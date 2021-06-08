/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_LockonMove.h"

@implementation _LockonMove

- (double)_deg2rad:(double)angle
{
	return (angle * 3.14159265358979323846264) / 180.0;
}

- (id)initWithPos:(int)x0 :(int)y0 :(int)x1 :(int)y1 :(int)step :(BOOL)clockwise
{
	self = [super init];
	if( self != nil )
	{
		_step = step;
		_move_x = malloc( sizeof(int) * _step );
		_move_y = malloc( sizeof(int) * _step );
		for( int i = 0; i < _step; i++ )
		{
			double deg = (double)(360 * i) / (double)_step;
			_move_x[i] = (int)(sin( [self _deg2rad: deg         ] ) * 120.0);
			_move_y[i] = (int)(cos( [self _deg2rad:(deg + 180.0)] ) * 120.0);
		}

		_x = (double)x0;
		_y = (double)y0;
		_tx = x1;
		_ty = y1;
		_direction = [self direction:(int)_x :(int)_y :_tx :_ty];
		_clockwise = clockwise;
		_clockwise2 = NO;
	}
	return self;
}

- (void)dealloc
{
	free( _move_x );
	free( _move_y );

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (int)direction:(int)x0 :(int)y0 :(int)x1 :(int)y1
{
	x1 -= x0;
	y1 -= y0;
	int dx = 0;
	int dy = 0;
	int tmp_d = 0;
	int d = 0;
	int j = 0;
	for( int i = 0; i < _step; i++ )
	{
		dx = x1 - _move_x[i];
		dy = y1 - _move_y[i];
		tmp_d = dx * dx + dy * dy;
		if( (i == 0) || (tmp_d < d) )
		{
			d = tmp_d;
			j = i;
		}
	}
	return j;
}
- (double)normalizeX:(int)direction
{
	if( direction < 0 )
	{
		direction += _step;
	}
	else if( direction >= _step )
	{
		direction -= _step;
	}
	return (double)_move_x[direction] / 120.0;
}
- (double)normalizeY:(int)direction
{
	if( direction < 0 )
	{
		direction += _step;
	}
	else if( direction >= _step )
	{
		direction -= _step;
	}
	return (double)_move_y[direction] / 120.0;
}

- (void)addDirection:(int)add
{
	_direction += add;
	if( _direction < 0 )
	{
		_direction += _step;
	}
	else if( _direction >= _step )
	{
		_direction -= _step;
	}
}

- (void)setTarget:(int)tx :(int)ty
{
	_tx = tx;
	_ty = ty;
}

- (void)update:(int)dist :(int)step
{
	_x += (double)_move_x[_direction] * (double)dist / 120.0;
	_y += (double)_move_y[_direction] * (double)dist / 120.0;
	int tmp = [self direction:(int)_x :(int)_y :_tx :_ty];
	if( abs( _direction - tmp ) == _step / 2 )
	{
		if( !_clockwise2 )
		{
			_clockwise = _clockwise ? NO : YES;
			_clockwise2 = YES;
		}
		if( _clockwise )
		{
			step = 0 - step;
		}
	}
	else
	{
		_clockwise2 = NO;
		if(
			((tmp >  _direction) && ((tmp - _direction) >= _step / 2)) ||
			((tmp <= _direction) && ((_direction - tmp) <  _step / 2))
		){
			step = 0 - step;
		}
	}
	_direction = ((_direction + step) + _step) % _step;
}

- (int)getX
{
	return (int)_x;
}
- (int)getY
{
	return (int)_y;
}
- (int)getDirection
{
	return _direction;
}

@end
