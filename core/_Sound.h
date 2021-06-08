/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@class _Main;

@interface _Sound : NSObject
{
@private
	_Main* _m;
	AVAudioPlayer* _player;
	int _volume;
}

- (id)initWithMain:(_Main*)m;
- (void)load:(NSURL*)url;
- (void)play:(BOOL)loop;
- (void)play;
- (void)stop;
- (void)setVolume:(int)volume;
- (int)volume;
- (BOOL)isPlaying;

@end
