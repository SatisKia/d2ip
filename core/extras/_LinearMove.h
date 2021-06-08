/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface _LinearMove : NSObject
{
@private
	int _x, _y;
	int _x0, _y0;
	int _x1, _y1;
	double _dist;
}

- (void)setPos:(int)x0 :(int)y0 :(int)x1 :(int)y1;
- (void)update:(double)dist;
- (int)getX;
- (int)getY;

@end
