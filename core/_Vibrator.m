/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <AudioToolbox/AudioServices.h>

#import "_Vibrator.h"

static void vibrateComplete( SystemSoundID soundID, void* client )
{
	if( ((__bridge _Vibrator*)client)->_vibrate )
	{
		AudioServicesPlaySystemSound( kSystemSoundID_Vibrate );
	}
	else
	{
		AudioServicesRemoveSystemSoundCompletion( kSystemSoundID_Vibrate );
	}
}

@implementation _Vibrator

- (void)startVibrate
{
	_vibrate = YES;
	AudioServicesAddSystemSoundCompletion( kSystemSoundID_Vibrate, NULL, NULL, vibrateComplete, (__bridge void*)self );
	AudioServicesPlaySystemSound( kSystemSoundID_Vibrate );
}

- (void)stopVibrate
{
	_vibrate = NO;
}

- (void)vibrate:(int)level
{
	switch( level )
	{
	case 1:
		AudioServicesPlaySystemSound( 1519 );
		break;
	case 2:
		AudioServicesPlaySystemSound( 1520 );
		break;
	case 3:
		AudioServicesPlaySystemSound( 1521 );
		break;
	case 4:
		AudioServicesPlaySystemSound( 1003 );
		AudioServicesDisposeSystemSoundID( 1003 );
		break;
	case 5:
		AudioServicesPlaySystemSound( kSystemSoundID_Vibrate );
		break;
	}
}

@end
