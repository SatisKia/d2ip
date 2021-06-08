/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_LinearMove.h"

@implementation _LinearMove

- (void)setPos:(int)x0 :(int)y0 :(int)x1 :(int)y1
{
	_x0 = x0;
	_y0 = y0;
	_x1 = x1;
	_y1 = y1;
	_dist = 0.0;
	_x = _x0;
	_y = _y0;
}

- (void)update:(double)dist
{
	_dist += dist;
	int i;
	int e;
	int dx, dy, sx, sy;
	int w, h;
	int d = (int)_dist;
	int d2 = (int)(_dist * _dist);
	sx = (_x1 > _x0) ? 1 : -1;
	dx = (_x1 > _x0) ? _x1 - _x0 : _x0 - _x1;
	sy = (_y1 > _y0) ? 1 : -1;
	dy = (_y1 > _y0) ? _y1 - _y0 : _y0 - _y1;
	_x = _x0;
	_y = _y0;
	if( dx >= dy )
	{
		e = -dx;
		for( i = 0; i <= d; i++ )
		{
			_x += sx;
			e += 2 * dy;
			if( e >= 0 )
			{
				_y += sy;
				e -= 2 * dx;
			}
			w = _x - _x0;
			h = _y - _y0;
			if( (w * w + h * h) >= d2 )
			{
				// 目標距離に達すると抜ける
				break;
			}
		}
	}
	else
	{
		e = -dy;
		for( i = 0; i <= d; i++ )
		{
			_y += sy;
			e += 2 * dx;
			if( e >= 0 )
			{
				_x += sx;
				e -= 2 * dy;
			}
			w = _x - _x0;
			h = _y - _y0;
			if( (w * w + h * h) >= d2 )
			{
				// 目標距離に達すると抜ける
				break;
			}
		}
	}
}

- (int)getX
{
	return _x;
}
- (int)getY
{
	return _y;
}

@end
