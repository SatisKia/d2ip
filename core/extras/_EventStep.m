/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_EventStep.h"

@implementation _EventStep

- (void)start:(int)eventOn :(int)eventOff
{
	_event_on = eventOn;
	_event_off = eventOff;
	_step = 0;
	_time = (double)[[NSDate date] timeIntervalSince1970] * 1000.0;
}

- (void)handleEvent:(int)type :(int)param
{
	if( (type == _event_on) && [self _checkParam:param] )
	{
		double now_time = (double)[[NSDate date] timeIntervalSince1970] * 1000.0;
		if( [self isTimeout:now_time] )
		{
			_step = 1;
		}
		else
		{
			if( (_step % 2) == 0 )
			{
				_step++;
			}
		}
		_time = now_time;
	}
	else if( (type == _event_off) && [self _checkParam:param] )
	{
		double now_time = (double)[[NSDate date] timeIntervalSince1970] * 1000.0;
		if( [self isTimeout:now_time] )
		{
			_step = 0;
		}
		else
		{
			if( (_step % 2) == 1 )
			{
				_step++;
			}
		}
		_time = now_time;
	}
}

- (int)step
{
	return _step;
}

- (void)reset
{
	_step = 0;
}

- (BOOL)isTimeout:(double)nowTime
{
	if( _step == 0 )
	{
		return NO;
	}
	return ((int)(nowTime - _time) > [self _checkTime]);
}
- (BOOL)isTimeout
{
	return [self isTimeout:((double)[[NSDate date] timeIntervalSince1970] * 1000.0)];
}

- (BOOL)_checkParam:(int)param { return YES; }
- (int)_checkTime { return 200/*1000 / 5*/; }

@end
