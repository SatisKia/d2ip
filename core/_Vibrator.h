/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface _Vibrator : NSObject
{
@public
	BOOL _vibrate;
}

- (void)startVibrate;
- (void)stopVibrate;
- (void)vibrate:(int)level;

@end
