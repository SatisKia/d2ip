/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Scalable.h"

@implementation _Scalable

- (id)init
{
	self = [super init];
	if( self != nil )
	{
		_scale = 1.0f;
	}
	return self;
}

- (void)setScale:(float)scale
{
	_scale = scale;
}

- (float)scale
{
	return _scale;
}

- (int)scaledValue:(int)val
{
	return (int)((float)val * _scale);
}

@end
