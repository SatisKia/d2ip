/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Music.h"

#import "_Canvas.h"
#import "_Main.h"

@implementation _Music

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
	[_m _musicComplete:self];
	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] _musicComplete:self];
	}
}

- (id)initWithMain:(_Main*)m
{
	self = [super init];
	if( self != nil )
	{
		_m = m;
		_player = nil;
		_volume = 100;
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

- (void)play:(NSURL*)url :(int)time :(BOOL)loop
{
	[self stop];
	if( url != nil )
	{
		_player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		if( _player != nil )
		{
			_player.delegate = self;
			_player.currentTime = (float)time / 1000.0f;
			_player.numberOfLoops = loop ? -1 : 0;
			_player.volume = (float)(_volume * [_m _volumeMusic] / 100) / 100.0f;
			[_player prepareToPlay];
			[_player play];
		}
	}
}
- (void)play:(NSURL*)url :(BOOL)loop
{
	[self play:url :0 :loop];
}

- (void)stop
{
	if( _player != nil )
	{
		[_player stop];
#ifdef NO_OBJC_ARC
		[_player release];
#endif // NO_OBJC_ARC
		_player = nil;
	}
}

- (void)setVolume:(int)volume
{
	_volume = volume;
	if( _player != nil )
	{
		_player.volume = (float)(_volume * [_m _volumeMusic] / 100) / 100.0f;
	}
}

- (int)volume
{
	return _volume;
}

- (BOOL)isPlaying
{
	if( _player != nil )
	{
		return _player.playing;
	}
	return NO;
}

- (void)setCurrentTime:(int)time
{
	if( _player != nil )
	{
		[_player pause];
		_player.currentTime = (float)time / 1000.0f;
		[_player play];
	}
}

- (int)getCurrentTime
{
	if( _player != nil )
	{
		return (int)(_player.currentTime * 1000.0f);
	}
	return 0;
}

- (int)getTotalTime
{
	if( _player != nil )
	{
		return (int)(_player.duration * 1000.0f);
	}
	return 0;
}

@end
