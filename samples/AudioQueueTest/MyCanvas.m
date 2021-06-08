#import "MyCanvas.h"

#import "_AudioQueue.h"

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }

- (void)_init
{
	// ファイル
	NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString* documentDirectory = [paths objectAtIndex:0];
	NSString* filePath = [NSString stringWithFormat:@"%@/test.aiff", documentDirectory];
	url = CFURLCreateFromFileSystemRepresentation(
		NULL,
		(const UInt8*)[filePath UTF8String],
		[filePath length],
		NO
		);

	// 録音するデータフォーマット
	format.mSampleRate = 44100.0f;
	format.mFormatID = kAudioFormatLinearPCM;
	format.mFormatFlags =
		kLinearPCMFormatFlagIsBigEndian |
		kLinearPCMFormatFlagIsSignedInteger |
		kLinearPCMFormatFlagIsPacked;
	format.mBitsPerChannel = 16;
	format.mChannelsPerFrame = 1;
	format.mFramesPerPacket = 1;
	format.mBytesPerFrame = 2;
	format.mBytesPerPacket = 2;
	format.mReserved = 0;

	a = [[_AudioQueue alloc] init];

	step = 0;
	elapse = 0;
}

- (void)_end
{
	CFRelease( url );

#ifdef NO_OBJC_ARC
	[a release];
#endif // NO_OBJC_ARC
}

- (void)_suspend
{
	[a pause];
}

- (void)_resume
{
	[a restart];
}

- (void)_paint:(_Graphics*)g
{
	int i;
	int y;

	elapse++;

	[g lock];

	[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
	[g fillRect:0 :0 :[self getWidth] :[self getHeight]];

	[g setColor:[_Graphics getColorOfRGB:0 :255 :0]];
	y = [self getHeight] * -[a getLevelAverage] / 120;
	[g fillRect:0 :y :[self getWidth] :([self getHeight] - y)];

	[g setColor:[_Graphics getColorOfRGB:128 :128 :128]];
	[g setFontSize:15];
	NSString* tmp;
	for( i = 1; i <= 12; i++ )
	{
		y = [self getHeight] * i / 12;
		[g drawLine:0 :y :[self getWidth] :y];
		tmp = [NSString stringWithFormat:@"-%d", i * 10];
		[g drawString:tmp :([self getWidth] - [g stringWidth:tmp]) :y];
	}

	[g setColor:[_Graphics getColorOfRGB:255 :0 :0]];
	y = [self getHeight] * -[a getLevelPeak] / 120;
	[g fillRect:0 :y :[self getWidth] :2];

	[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
	[g setFontSize:20];
	[g drawString:[NSString stringWithFormat:@"Peak %f", [a getLevelPeak]] :0 :24];
	[g drawString:[NSString stringWithFormat:@"Average %f", [a getLevelAverage]] :0 :48];
	if( [a isInput] )
	{
		[g drawString:@"タッチすると録音終了します" :0 :72];
		switch( elapse % 3 )
		{
		case 0: [g drawString:@"録音中."   :0 :96]; break;
		case 1: [g drawString:@"録音中.."  :0 :96]; break;
		case 2: [g drawString:@"録音中..." :0 :96]; break;
		}
		[g drawString:[NSString stringWithFormat:@"%f", (float)(elapse * [self _frameTime]) / 1000.0f] :0 :[self getHeight]];
	}
	else if( [a isOutput] )
	{
		[g drawString:@"タッチすると再生終了します" :0 :72];
		switch( elapse % 3 )
		{
		case 0: [g drawString:@"再生中."   :0 :96]; break;
		case 1: [g drawString:@"再生中.."  :0 :96]; break;
		case 2: [g drawString:@"再生中..." :0 :96]; break;
		}
		[g drawString:[NSString stringWithFormat:@"%f", (float)(elapse * [self _frameTime]) / 1000.0f] :0 :[self getHeight]];
		if( [a isEnd] && ([a getLevelPeak] <= -120.0f) )
		{
			[a stop];
			step++;
		}
	}
	else
	{
		if( (step % 2) == 0 )
		{
			[g drawString:@"タッチすると録音開始します" :0 :72];
		}
		else
		{
			[g drawString:@"タッチすると再生開始します" :0 :72];
		}
	}

	[g unlock];
}

- (void)_processEvent:(int)type :(int)param
{
	if( type == TOUCH_DOWN_EVENT )
	{
		if( [a isInput] || [a isOutput] )
		{
			[a stop];
			step++;
		}
		else
		{
			if( (step % 2) == 0 )
			{
				[a startInput:url :&format];
			}
			else
			{
				[a startOutput:url];
			}
			elapse = 0;
		}
	}
}

@end
