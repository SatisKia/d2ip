/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

#define _GLPRIMITIVE_TYPE_MODEL		0
#define _GLPRIMITIVE_TYPE_SPRITE	1

@interface _GLPrimitive : NSObject
{
@private
	int _type;
	BOOL _depth;
	unsigned char _trans;
}

- (void)_setType:(int)type;
- (void)_setDepth:(BOOL)depth;
- (void)setTransparency:(unsigned char)trans;
- (int)type;
- (BOOL)depth;
- (unsigned char)transparency;

@end
