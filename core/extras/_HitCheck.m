/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_HitCheck.h"

@implementation _HitCheck

- (void)initCircle:(int)r0 :(int)r1
{
	_r = r0 + r1;
	_d = _r * _r;
}
- (BOOL)circle:(int)cx0 :(int)cy0 :(int)cx1 :(int)cy1
{
	int w = cx0 - cx1;
	int h = cy0 - cy1;
	return (w * w + h * h <= _d);
}
- (BOOL)circle:(int)cx0 :(int)cy0 :(int)r0 :(int)cx1 :(int)cy1 :(int)r1
{
	[self initCircle:r0 :r1];
	return [self circle:cx0 :cy0 :cx1 :cy1];
}

- (void)initCircleAndRect:(int)r
{
	_r = r;
	_d = _r * _r;
}
- (BOOL)circleAndRect:(int)cx :(int)cy :(int)left :(int)top :(int)right :(int)bottom
{
	if( (cx >= left) && (cx <= right) )
	{
		return ((cy >= top - _r) && (cy <= bottom + _r));
	}
	if( (cy >= top) && (cy <= bottom) )
	{
		return ((cx >= left - _r) && (cx <= right + _r));
	}
	if( (cx < left) && (cy < top) )
	{
		int w = cx - left;
		int h = cy - top;
		return (w * w + h * h <= _d);
	}
	if( (cx < left) && (cy > bottom) )
	{
		int w = cx - left;
		int h = cy - bottom;
		return (w * w + h * h <= _d);
	}
	if( (cx > right) && (cy < top) )
	{
		int w = cx - right;
		int h = cy - top;
		return (w * w + h * h <= _d);
	}
	if( (cx > right) && (cy > bottom) )
	{
		int w = cx - right;
		int h = cy - bottom;
		return (w * w + h * h <= _d);
	}
	return NO;
}
- (BOOL)circleAndRect:(int)cx :(int)cy :(int)r :(int)left :(int)top :(int)right :(int)bottom
{
	[self initCircleAndRect:r];
	return [self circleAndRect:cx :cy :left :top :right :bottom];
}

- (BOOL)rect:(int)left0 :(int)top0 :(int)right0 :(int)bottom0 :(int)left1 :(int)top1 :(int)right1 :(int)bottom1
{
	return ((left0 <= right1) && (top0 <= bottom1) && (right0 >= left1) && (bottom0 >= top1));
}

@end
