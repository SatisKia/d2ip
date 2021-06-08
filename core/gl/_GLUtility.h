/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class _GLModel;

@interface _GLUtility : NSObject
{
@private
	// 各種行列演算用
	float util_mat[16];
	float tmp_mat[16];

	// 各種行列演算後の、OpenGL 用行列の取得
	float gl_mat[16];

	// 回転
	float _rotate[16];

	// 拡大・縮小
	float _scale[16];

	// 平行移動
	float _translate[16];

	// 点の座標を表すベクトルを変換行列で変換
	float trans_x;
	float trans_y;
	float trans_z;

	// 外積
	float cross_x;
	float cross_y;
	float cross_z;

	// 正規化
	float normalize_x;
	float normalize_y;
	float normalize_z;

	// 反射
	float reflect_x;
	float reflect_y;
	float reflect_z;

	// 三角形を検索
	int seek_len;
	unsigned short seek_vertex[3];
	float coord_x[3];
	float coord_y[3];
	float coord_z[3];
	float normal_x;
	float normal_y;
	float normal_z;
	float center_x;
	float center_y;
	float center_z;

	// 辺と三角形ポリゴンとの当たり判定
	float hit_x;
	float hit_y;
	float hit_z;

	// gluLookAt
	float look_side[3];
	float look_mat[16];
	float model_mat[16];

	// glFrustum
	float proj_mat[16];

	// glViewport
	float view_mat[4];

	// gluProject
	float project_in[4];
	float project_out[4];
	float project_x;
	float project_y;
	float project_z;
}

- (float)deg2rad:(float)angle;
- (float)rad2deg:(float)angle;
- (float*)matrix;
- (BOOL)invert;
- (void)multiply:(float*)matrix;
- (void)rotate:(float)angle :(float)x :(float)y :(float)z;
- (void)scale:(float)x :(float)y :(float)z;
- (void)set:(float*)matrix;
- (void)setVal:(int)index :(float)value;
- (void)setIdentity;
- (void)translate:(float)x :(float)y :(float)z;
- (void)transpose;
- (void)transVector:(float)x :(float)y :(float)z;
- (void)cross:(float)x1 :(float)y1 :(float)z1 :(float)x2 :(float)y2 :(float)z2;
- (float)dot:(float)x1 :(float)y1 :(float)z1 :(float)x2 :(float)y2 :(float)z2;
- (float)distance:(float)x :(float)y :(float)z;
- (void)normalize:(float)x :(float)y :(float)z;
- (void)reflect:(float)vx :(float)vy :(float)vz :(float)nx :(float)ny :(float)nz;
- (void)beginGetTriangle;
- (BOOL)getTriangle:(_GLModel*)model :(int)index :(BOOL)trans;
- (void)getTriangleCoord:(_GLModel*)model :(int)index :(BOOL)trans;
- (void)getTriangleNormal:(_GLModel*)model :(int)index :(BOOL)trans;
- (BOOL)checkTriangle:(float)x_min :(float)x_max :(float)y_min :(float)y_max :(float)z_min :(float)z_max;
- (BOOL)hitCheck:(float)px :(float)py :(float)pz :(float)qx :(float)qy :(float)qz :(float*)cx :(float*)cy :(float*)cz;
- (void)lookAt:(float)position_x :(float)position_y :(float)position_z :(float)look_x :(float)look_y :(float)look_z :(float)up_x :(float)up_y :(float)up_z;
- (float*)lookMatrix;
- (float*)spriteMatrix:(float)x :(float)y :(float)z;
- (void)frustum:(float)l :(float)r :(float)b :(float)t :(float)n :(float)f;
- (void)viewport:(int)x :(int)y :(int)width :(int)height;
- (BOOL)project:(float)obj_x :(float)obj_y :(float)obj_z;
- (BOOL)unProject:(float)win_x :(float)win_y :(float)win_z;
- (float)transX;
- (float)transY;
- (float)transZ;
- (float)crossX;
- (float)crossY;
- (float)crossZ;
- (float)normalizeX;
- (float)normalizeY;
- (float)normalizeZ;
- (float)reflectX;
- (float)reflectY;
- (float)reflectZ;
- (float)coordX:(int)i;
- (float)coordY:(int)i;
- (float)coordZ:(int)i;
- (float)normalX;
- (float)normalY;
- (float)normalZ;
- (float)centerX;
- (float)centerY;
- (float)centerZ;
- (float)hitX;
- (float)hitY;
- (float)hitZ;
- (float)projectX;
- (float)projectY;
- (float)projectZ;

@end
