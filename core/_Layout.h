/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class _Canvas;
@class _Graphics;

@interface _Layout : NSObject
{
@private
	NSMutableArray* _layout;
	BOOL _window;
}

- (void)setWindow:(BOOL)window;
- (void)clear;
- (void)add:(int)left :(int)top :(int)width :(int)height :(int)id;
- (int)getLeft:(int)id;
- (int)getTop:(int)id;
- (int)getRight:(int)id;
- (int)getBottom:(int)id;
- (int)getWidth:(int)id;
- (int)getHeight:(int)id;
- (BOOL)_isWindow;
- (int)_check:(int)x :(int)y;
- (void)_draw:(_Canvas*)canvas :(_Graphics*)g;

@end
