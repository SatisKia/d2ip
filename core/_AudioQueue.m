/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_AudioQueue.h"

#import "_Main.h"

static void _inputCallback( void* userData, AudioQueueRef queue, AudioQueueBufferRef buffer, const AudioTimeStamp* startTime, UInt32 numPackets, const AudioStreamPacketDescription* packetDescs )
{
	_AudioQueue* recorder = (_AudioQueue*)userData;
	[recorder _writePackets:buffer :numPackets :packetDescs];
}

static void _outputCallback( void* userData, AudioQueueRef queue, AudioQueueBufferRef buffer )
{
	_AudioQueue* player = (_AudioQueue*)userData;
	[player _readPackets:buffer];
}

@implementation _AudioQueue

- (id)initWithMain:(_Main*)m;
{
	self = [super init];
	if( self != nil )
	{
		_m = m;

		_init = NO;

		_queue = NULL;

		_packetDescs = NULL;

		_volume = 100;

		_isInput = NO;
		_isOutput = NO;
	}
	return self;
}

- (void)dealloc
{
	[self stop];

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (UInt32)_readPackets:(AudioQueueBufferRef)buffer
{
	UInt32 numBytes;
	UInt32 numPackets = _packetNum;
	AudioFileReadPackets( _file, NO, &numBytes, _packetDescs, _packetIndex, &numPackets, buffer->mAudioData );
	if( numPackets > 0 )
	{
		// バッファの大きさを、読み込んだパケットデータのサイズに設定する
		buffer->mAudioDataByteSize = numBytes;

		// バッファをキューに追加する
		AudioQueueEnqueueBuffer( _queue, buffer, numPackets, _packetDescs );
		_packetIndex += numPackets;
	}
	else
	{
		_isEnd = YES;
	}
	return numPackets;
}

- (void)_writePackets:(AudioQueueBufferRef)buffer :(UInt32)numPackets :(const AudioStreamPacketDescription*)packetDescs
{
	OSStatus status = noErr;
	if( _file_f )
	{
		status = AudioFileWritePackets( _file, NO, buffer->mAudioDataByteSize, packetDescs, _packetIndex, &numPackets, buffer->mAudioData );
	}
	if( status == noErr )
	{
		// バッファをキューに追加する
		AudioQueueEnqueueBuffer( _queue, buffer, 0, NULL );
		_packetIndex += numPackets;
	}
}

- (void)setVolume:(int)volume
{
	_volume = volume;
	if( _queue != NULL )
	{
		float tmp = (float)(_volume * [_m _volumeAudioQueue] / 100) / 100.0f;
		AudioQueueSetParameter( _queue, kAudioQueueParam_Volume, tmp );
	}
}

- (int)volume
{
	return _volume;
}

- (float)getLevelAverage
{
	if( _queue == NULL )
	{
		return -120.0f;
	}
	AudioQueueLevelMeterState level;
	UInt32 size = sizeof(AudioQueueLevelMeterState);
	AudioQueueGetProperty( _queue, kAudioQueueProperty_CurrentLevelMeterDB, &level, &size );
	return level.mAveragePower;
}

- (float)getLevelPeak
{
	if( _queue == NULL )
	{
		return -120.0f;
	}
	AudioQueueLevelMeterState level;
	UInt32 size = sizeof(AudioQueueLevelMeterState);
	AudioQueueGetProperty( _queue, kAudioQueueProperty_CurrentLevelMeterDB, &level, &size );
	return level.mPeakPower;
}

- (void)_setActive:(BOOL)isInput
{
	if( !_init )
	{
		AudioSessionInitialize( NULL, NULL, NULL, (void*)self );
		_init = YES;
	}
	UInt32 category = isInput ? kAudioSessionCategory_RecordAudio : kAudioSessionCategory_SoloAmbientSound;
	AudioSessionSetProperty( kAudioSessionProperty_AudioCategory, sizeof(category), &category );
	AudioSessionSetActive( YES );
}

- (BOOL)startInput:(CFURLRef)path :(AudioStreamBasicDescription*)format
{
	if( _isInput || _isOutput )
	{
		return NO;
	}

	OSStatus status;
	UInt32 size;

	// オーディオファイルを作成する
	if( path == NULL )
	{
		_file_f = NO;
	}
	else
	{
		status = AudioFileCreateWithURL( path, kAudioFileAIFFType, format, kAudioFileFlags_EraseFile, &_file );
		if( status != noErr )
		{
			return NO;
		}
		_file_f = YES;
	}

	// 録音モードにする
	[self _setActive:YES];

	// 録音用の AudioQueue を作成する
	AudioQueueNewInput( format, _inputCallback, self, CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &_queue );

	// レベルメーターの有効化
	UInt32 enable = true;
	AudioQueueSetProperty( _queue, kAudioQueueProperty_EnableLevelMetering, &enable, sizeof(UInt32) );

	if( AudioQueueGetPropertySize( _queue, kAudioQueueProperty_MagicCookie, &size ) == noErr )
	{
		char* cookie = malloc( sizeof(char) * size );
		free( cookie );
	}

	// バッファを作成する
	_packetIndex = 0;
	for( int i = 0; i < NUM_BUFFERS; i++ )
	{
		AudioQueueAllocateBuffer( _queue, (format->mSampleRate / 10.0f) * format->mBytesPerFrame, &_buffers[i] );
		AudioQueueEnqueueBuffer( _queue, _buffers[i], 0, NULL );
	}

	// 録音を開始する
	_isInput = YES;
	AudioQueueStart( _queue, NULL );

	return YES;
}

- (BOOL)startOutput:(CFURLRef)path
{
	if( _isInput || _isOutput )
	{
		return NO;
	}

	OSStatus status;
	UInt32 size;

	// オーディオファイルを開く
	status = AudioFileOpenURL( path, kAudioFileReadPermission, 0, &_file );
	if( status != noErr )
	{
		return NO;
	}
	_file_f = YES;

	// 再生モードにする
	[self _setActive:NO];

	// オーディオデータフォーマットを取得する
	AudioStreamBasicDescription format;
	size = sizeof(format);
	AudioFileGetProperty( _file, kAudioFilePropertyDataFormat, &size, &format );

	// 再生用の AudioQueue を作成する
	AudioQueueNewOutput( &format, _outputCallback, self, NULL, NULL, 0, &_queue );

	// レベルメーターの有効化
	UInt32 enable = true;
	AudioQueueSetProperty( _queue, kAudioQueueProperty_EnableLevelMetering, &enable, sizeof(UInt32) );

	// パケットの見積りをする
	if( (format.mBytesPerPacket == 0) || (format.mFramesPerPacket == 0) )
	{
		UInt32 maxSize;
		size = sizeof(maxSize);
		AudioFileGetProperty( _file, kAudioFilePropertyPacketSizeUpperBound, &size, &maxSize );
		if( maxSize > BUFFER_SIZE )
		{
			maxSize = BUFFER_SIZE;
		}
		_packetNum = BUFFER_SIZE / maxSize;
	}
	else
	{
		_packetNum = BUFFER_SIZE / format.mBytesPerPacket;
	}
	_packetDescs = malloc( sizeof(AudioStreamPacketDescription) * _packetNum );

	AudioFileGetPropertyInfo( _file, kAudioFilePropertyMagicCookieData, &size, NULL );
	if( size > 0 )
	{
		char* cookie = malloc( sizeof(char) * size );
		AudioFileGetProperty( _file, kAudioFilePropertyMagicCookieData, &size, cookie );
		AudioQueueSetProperty( _queue, kAudioQueueProperty_MagicCookie, cookie, size );
		free( cookie );
	}

	// バッファを作成する
	_packetIndex = 0;
	for( int i = 0; i < NUM_BUFFERS; i++ )
	{
		AudioQueueAllocateBuffer( _queue, BUFFER_SIZE, &_buffers[i] );
		if( [self _readPackets:_buffers[i]] == 0 )
		{
			break;
		}
	}

	float volume = (float)(_volume * [_m _volumeAudioQueue] / 100) / 100.0f;
	AudioQueueSetParameter( _queue, kAudioQueueParam_Volume, volume );

	// 再生を開始する
	_isOutput = YES;
	_isEnd = NO;
	AudioQueueStart( _queue, NULL );

	return YES;
}

- (void)pause
{
	if( _isInput || _isOutput )
	{
		AudioQueuePause( _queue );
	}
}

- (void)restart
{
	if( _isInput || _isOutput )
	{
		AudioQueueStart( _queue, NULL );
	}
}

- (void)stop
{
	if( _isInput || _isOutput )
	{
		BOOL isInput = _isInput;
		_isInput = NO;
		_isOutput = NO;
		_isEnd = NO;

		AudioQueueFlush( _queue );
		AudioQueueStop( _queue, NO );
		for( int i = 0; i < NUM_BUFFERS; i++ )
		{
			AudioQueueFreeBuffer( _queue, _buffers[i] );
		}
		AudioQueueDispose( _queue, YES );
		_queue = NULL;

		if( _packetDescs != NULL )
		{
			free( _packetDescs );
			_packetDescs = NULL;
		}

		// ファイルを閉じる
		if( _file_f )
		{
			AudioFileClose( _file );
		}

		if( isInput )
		{
			// 録音モードの場合、再生モードにする
			UInt32 audioCategory = kAudioSessionCategory_SoloAmbientSound;
			AudioSessionSetProperty( kAudioSessionProperty_AudioCategory,
				sizeof(audioCategory),
				&audioCategory
				);
		}
		AudioSessionSetActive( NO );
	}
}

- (BOOL)isInput
{
	return _isInput;
}

- (BOOL)isOutput
{
	return _isOutput;
}

- (BOOL)isEnd
{
	return _isEnd;
}

@end
