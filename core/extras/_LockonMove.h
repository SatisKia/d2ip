/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface _LockonMove : NSObject
{
@private
	int* _move_x;
	int* _move_y;
	int _step;

	double _x, _y;		// 現在位置
	int _tx, _ty;		// 目的位置
	int _direction;		// 方向
	BOOL _clockwise;	// 180度反対方向だった場合に時計回りに回すかどうか
	BOOL _clockwise2;
}

- (id)initWithPos:(int)x0 :(int)y0 :(int)x1 :(int)y1 :(int)step :(BOOL)clockwise;
- (int)direction:(int)x0 :(int)y0 :(int)x1 :(int)y1;
- (double)normalizeX:(int)direction;
- (double)normalizeY:(int)direction;
- (void)addDirection:(int)add;
- (void)setTarget:(int)tx :(int)ty;
- (void)update:(int)dist :(int)step;
- (int)getX;
- (int)getY;
- (int)getDirection;

@end
