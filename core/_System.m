/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_System.h"

@implementation _System

+ (double)currentTimeMillis
{
	return (double)[[NSDate date] timeIntervalSince1970] * 1000.0;
}

@end
