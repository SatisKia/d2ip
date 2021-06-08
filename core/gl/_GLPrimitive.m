/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_GLPrimitive.h"

@implementation _GLPrimitive

- (id)init
{
	self = [super init];
	if( self != nil )
	{
		_trans = (unsigned char)255;
	}
	return self;
}

- (void)_setType:(int)type
{
	_type = type;
}

- (void)_setDepth:(BOOL)depth
{
	_depth = depth;
}

- (void)setTransparency:(unsigned char)trans
{
	_trans = trans;
}

- (int)type
{
	return _type;
}

- (BOOL)depth
{
	return _depth;
}

- (unsigned char)transparency
{
	return _trans;
}

@end
