/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface _EventStep : NSObject
{
@private
	int _event_on;
	int _event_off;
	int _step;
	double _time;
}

- (void)start:(int)eventOn :(int)eventOff;
- (void)handleEvent:(int)type :(int)param;
- (int)step;
- (void)reset;
- (BOOL)isTimeout:(double)nowTime;
- (BOOL)isTimeout;

- (BOOL)_checkParam:(int)param;
- (int)_checkTime;

@end
