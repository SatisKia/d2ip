/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class _GLModel;
@class _GLUtility;

@interface _GLTriangle : NSObject
{
@private
	int _num;
	float** _coord_x;
	float** _coord_y;
	float** _coord_z;
	float* _normal_x;
	float* _normal_y;
	float* _normal_z;
	float* _center_x;
	float* _center_y;
	float* _center_z;
}

- (id)initWithModel:(_GLUtility*)glu :(_GLModel*)model :(int)index;
- (int)num;
- (float*)coord_x:(int)i;
- (float*)coord_y:(int)i;
- (float*)coord_z:(int)i;
- (float)normal_x:(int)i;
- (float)normal_y:(int)i;
- (float)normal_z:(int)i;
- (float)center_x:(int)i;
- (float)center_y:(int)i;
- (float)center_z:(int)i;
- (BOOL)check:(int)i :(float)x_min :(float)x_max :(float)y_min :(float)y_max :(float)z_min :(float)z_max;
- (int)hitCheck:(_GLUtility*)glu :(float)px :(float)py :(float)pz :(float)qx :(float)qy :(float)qz :(float)r;

@end
