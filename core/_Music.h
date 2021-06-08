/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@class _Main;

@interface _Music : NSObject <AVAudioPlayerDelegate>
{
@private
	_Main* _m;
	AVAudioPlayer* _player;
	int _volume;
}

- (id)initWithMain:(_Main*)m;
- (void)play:(NSURL*)url :(int)time :(BOOL)loop;
- (void)play:(NSURL*)url :(BOOL)loop;
- (void)stop;
- (void)setVolume:(int)volume;
- (int)volume;
- (BOOL)isPlaying;
- (void)setCurrentTime:(int)time;
- (int)getCurrentTime;
- (int)getTotalTime;

@end
