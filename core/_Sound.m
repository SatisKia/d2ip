/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Sound.h"

#import "_Main.h"

@implementation _Sound

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
	if( _player != nil )
	{
		[_player stop];
#ifdef NO_OBJC_ARC
		[_player release];
#endif // NO_OBJC_ARC
	}

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (void)load:(NSURL*)url
{
	if( url != nil )
	{
		_player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		if( _player != nil )
		{
			[_player prepareToPlay];
		}
	}
}

- (void)play:(BOOL)loop
{
	if( _player != nil )
	{
//		if( _player.playing )
//		{
//			[_player pause];
			_player.currentTime = 0.0f;
//		}
		_player.numberOfLoops = loop ? -1 : 0;
		_player.volume = (float)(_volume * [_m _volumeSound] / 100) / 100.0f;
		[_player play];
	}
}
- (void)play
{
	[self play:NO];
}

- (void)stop
{
	if( _player != nil )
	{
		if( _player.playing )
		{
			[_player pause];
			_player.currentTime = 0.0f;
		}
	}
}

- (void)setVolume:(int)volume
{
	_volume = volume;
	if( _player != nil )
	{
		_player.volume = (float)(_volume * [_m _volumeSound] / 100) / 100.0f;
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

@end
