/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class _GLPrimitive;
@class _GLTexture;
@class _GLUtility;

@interface _GLDraw : NSObject
{
@private
	NSMutableArray* _draw;
}

- (void)clear;
- (void)add:(_GLPrimitive*)p :(int)index :(int)tex_index :(float*)mat :(int)trans;
- (void)addSprite:(_GLUtility*)glu :(_GLPrimitive*)p :(int)tex_index :(float)x :(float)y :(float)z :(int)trans;
- (void)draw:(_GLTexture*)glt;

@end
