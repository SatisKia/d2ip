#import <AudioToolbox/AudioFile.h>

#import "_Canvas.h"

@class _AudioQueue;

@interface MyCanvas : _Canvas
{
	CFURLRef url;
	AudioStreamBasicDescription format;

	_AudioQueue* a;

	int step;
	int elapse;
}
@end
