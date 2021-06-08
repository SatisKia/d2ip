/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface _HitCheck : NSObject
{
@private
	int _r;
	int _d;
}

- (void)initCircle:(int)r0 :(int)r1;
- (BOOL)circle:(int)cx0 :(int)cy0 :(int)cx1 :(int)cy1;
- (BOOL)circle:(int)cx0 :(int)cy0 :(int)r0 :(int)cx1 :(int)cy1 :(int)r1;
- (void)initCircleAndRect:(int)r;
- (BOOL)circleAndRect:(int)cx :(int)cy :(int)left :(int)top :(int)right :(int)bottom;
- (BOOL)circleAndRect:(int)cx :(int)cy :(int)r :(int)left :(int)top :(int)right :(int)bottom;
- (BOOL)rect:(int)left0 :(int)top0 :(int)right0 :(int)bottom0 :(int)left1 :(int)top1 :(int)right1 :(int)bottom1;

@end
