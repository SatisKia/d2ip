/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <AudioToolbox/AudioFile.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>

@class _Main;

#define NUM_BUFFERS	3
#define BUFFER_SIZE	0x10000

@interface _AudioQueue : NSObject
{
@private
	_Main* _m;

	BOOL _init;

	AudioFileID _file;
	BOOL _file_f;

	AudioQueueRef _queue;

	UInt32 _packetNum;
	AudioStreamPacketDescription* _packetDescs;
	SInt64 _packetIndex;
	AudioQueueBufferRef _buffers[NUM_BUFFERS];

	int _volume;

	BOOL _isInput;
	BOOL _isOutput;
	BOOL _isEnd;
}

- (id)initWithMain:(_Main*)m;
- (UInt32)_readPackets:(AudioQueueBufferRef)buffer;
- (void)_writePackets:(AudioQueueBufferRef)buffer :(UInt32)numPackets :(const AudioStreamPacketDescription*)packetDescs;
- (void)setVolume:(int)volume;
- (int)volume;
- (float)getLevelAverage;
- (float)getLevelPeak;
- (BOOL)startInput:(CFURLRef)path :(AudioStreamBasicDescription*)format;
- (BOOL)startOutput:(CFURLRef)path;
- (void)pause;
- (void)restart;
- (void)stop;
- (BOOL)isInput;
- (BOOL)isOutput;
- (BOOL)isEnd;

@end
