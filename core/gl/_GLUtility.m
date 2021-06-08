/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <OpenGLES/ES1/gl.h>

#import "_GLUtility.h"

#import "_GLModel.h"

#define TOLERANCE_M	-1.0f
#define TOLERANCE	1.0f

@implementation _GLUtility

- (id)init
{
	self = [super init];
	if( self != nil )
	{
		_rotate[ 3] = 0.0f;
		_rotate[ 7] = 0.0f;
		_rotate[11] = 0.0f;
		_rotate[12] = 0.0f;
		_rotate[13] = 0.0f;
		_rotate[14] = 0.0f;
		_rotate[15] = 1.0f;

		_scale[ 0] = 1.0f; _scale[ 1] = 0.0f; _scale[ 2] = 0.0f; _scale[ 3] = 0.0f;
		_scale[ 4] = 0.0f; _scale[ 5] = 1.0f; _scale[ 6] = 0.0f; _scale[ 7] = 0.0f;
		_scale[ 8] = 0.0f; _scale[ 9] = 0.0f; _scale[10] = 1.0f; _scale[11] = 0.0f;
		_scale[12] = 0.0f; _scale[13] = 0.0f; _scale[14] = 0.0f; _scale[15] = 1.0f;

		_translate[ 0] = 1.0f; _translate[ 1] = 0.0f; _translate[ 2] = 0.0f; _translate[ 3] = 0.0f;
		_translate[ 4] = 0.0f; _translate[ 5] = 1.0f; _translate[ 6] = 0.0f; _translate[ 7] = 0.0f;
		_translate[ 8] = 0.0f; _translate[ 9] = 0.0f; _translate[10] = 1.0f; _translate[11] = 0.0f;
		_translate[12] = 0.0f; _translate[13] = 0.0f; _translate[14] = 0.0f; _translate[15] = 1.0f;
	}
	return self;
}

- (float)deg2rad:(float)angle
{
	return (angle * M_PI) / 180.0f;
}
- (float)rad2deg:(float)angle
{
	return (angle * 180.0f) / M_PI;
}

/*
 * 各種行列演算後の、OpenGL 用行列の取得
 */
- (float*)matrix
{
	int i, j, k;
	for( j = 0; j < 4; j++ )
	{
		k = j * 4;
		for( i = 0; i < 4; i++ )
		{
			gl_mat[k + i] = util_mat[i * 4 + j];
		}
	}
	return gl_mat;
}

/*
 * 逆行列
 */
- (BOOL)invert
{
	float det;

	tmp_mat[ 0] =  util_mat[5] * util_mat[10] * util_mat[15] - util_mat[5] * util_mat[11] * util_mat[14] - util_mat[9] * util_mat[6] * util_mat[15] + util_mat[9] * util_mat[7] * util_mat[14] + util_mat[13] * util_mat[6] * util_mat[11] - util_mat[13] * util_mat[7] * util_mat[10];
	tmp_mat[ 4] = -util_mat[4] * util_mat[10] * util_mat[15] + util_mat[4] * util_mat[11] * util_mat[14] + util_mat[8] * util_mat[6] * util_mat[15] - util_mat[8] * util_mat[7] * util_mat[14] - util_mat[12] * util_mat[6] * util_mat[11] + util_mat[12] * util_mat[7] * util_mat[10];
	tmp_mat[ 8] =  util_mat[4] * util_mat[ 9] * util_mat[15] - util_mat[4] * util_mat[11] * util_mat[13] - util_mat[8] * util_mat[5] * util_mat[15] + util_mat[8] * util_mat[7] * util_mat[13] + util_mat[12] * util_mat[5] * util_mat[11] - util_mat[12] * util_mat[7] * util_mat[ 9];
	tmp_mat[12] = -util_mat[4] * util_mat[ 9] * util_mat[14] + util_mat[4] * util_mat[10] * util_mat[13] + util_mat[8] * util_mat[5] * util_mat[14] - util_mat[8] * util_mat[6] * util_mat[13] - util_mat[12] * util_mat[5] * util_mat[10] + util_mat[12] * util_mat[6] * util_mat[ 9];
	tmp_mat[ 1] = -util_mat[1] * util_mat[10] * util_mat[15] + util_mat[1] * util_mat[11] * util_mat[14] + util_mat[9] * util_mat[2] * util_mat[15] - util_mat[9] * util_mat[3] * util_mat[14] - util_mat[13] * util_mat[2] * util_mat[11] + util_mat[13] * util_mat[3] * util_mat[10];
	tmp_mat[ 5] =  util_mat[0] * util_mat[10] * util_mat[15] - util_mat[0] * util_mat[11] * util_mat[14] - util_mat[8] * util_mat[2] * util_mat[15] + util_mat[8] * util_mat[3] * util_mat[14] + util_mat[12] * util_mat[2] * util_mat[11] - util_mat[12] * util_mat[3] * util_mat[10];
	tmp_mat[ 9] = -util_mat[0] * util_mat[ 9] * util_mat[15] + util_mat[0] * util_mat[11] * util_mat[13] + util_mat[8] * util_mat[1] * util_mat[15] - util_mat[8] * util_mat[3] * util_mat[13] - util_mat[12] * util_mat[1] * util_mat[11] + util_mat[12] * util_mat[3] * util_mat[ 9];
	tmp_mat[13] =  util_mat[0] * util_mat[ 9] * util_mat[14] - util_mat[0] * util_mat[10] * util_mat[13] - util_mat[8] * util_mat[1] * util_mat[14] + util_mat[8] * util_mat[2] * util_mat[13] + util_mat[12] * util_mat[1] * util_mat[10] - util_mat[12] * util_mat[2] * util_mat[ 9];
	tmp_mat[ 2] =  util_mat[1] * util_mat[ 6] * util_mat[15] - util_mat[1] * util_mat[ 7] * util_mat[14] - util_mat[5] * util_mat[2] * util_mat[15] + util_mat[5] * util_mat[3] * util_mat[14] + util_mat[13] * util_mat[2] * util_mat[ 7] - util_mat[13] * util_mat[3] * util_mat[ 6];
	tmp_mat[ 6] = -util_mat[0] * util_mat[ 6] * util_mat[15] + util_mat[0] * util_mat[ 7] * util_mat[14] + util_mat[4] * util_mat[2] * util_mat[15] - util_mat[4] * util_mat[3] * util_mat[14] - util_mat[12] * util_mat[2] * util_mat[ 7] + util_mat[12] * util_mat[3] * util_mat[ 6];
	tmp_mat[10] =  util_mat[0] * util_mat[ 5] * util_mat[15] - util_mat[0] * util_mat[ 7] * util_mat[13] - util_mat[4] * util_mat[1] * util_mat[15] + util_mat[4] * util_mat[3] * util_mat[13] + util_mat[12] * util_mat[1] * util_mat[ 7] - util_mat[12] * util_mat[3] * util_mat[ 5];
	tmp_mat[14] = -util_mat[0] * util_mat[ 5] * util_mat[14] + util_mat[0] * util_mat[ 6] * util_mat[13] + util_mat[4] * util_mat[1] * util_mat[14] - util_mat[4] * util_mat[2] * util_mat[13] - util_mat[12] * util_mat[1] * util_mat[ 6] + util_mat[12] * util_mat[2] * util_mat[ 5];
	tmp_mat[ 3] = -util_mat[1] * util_mat[ 6] * util_mat[11] + util_mat[1] * util_mat[ 7] * util_mat[10] + util_mat[5] * util_mat[2] * util_mat[11] - util_mat[5] * util_mat[3] * util_mat[10] - util_mat[ 9] * util_mat[2] * util_mat[ 7] + util_mat[ 9] * util_mat[3] * util_mat[ 6];
	tmp_mat[ 7] =  util_mat[0] * util_mat[ 6] * util_mat[11] - util_mat[0] * util_mat[ 7] * util_mat[10] - util_mat[4] * util_mat[2] * util_mat[11] + util_mat[4] * util_mat[3] * util_mat[10] + util_mat[ 8] * util_mat[2] * util_mat[ 7] - util_mat[ 8] * util_mat[3] * util_mat[ 6];
	tmp_mat[11] = -util_mat[0] * util_mat[ 5] * util_mat[11] + util_mat[0] * util_mat[ 7] * util_mat[ 9] + util_mat[4] * util_mat[1] * util_mat[11] - util_mat[4] * util_mat[3] * util_mat[ 9] - util_mat[ 8] * util_mat[1] * util_mat[ 7] + util_mat[ 8] * util_mat[3] * util_mat[ 5];
	tmp_mat[15] =  util_mat[0] * util_mat[ 5] * util_mat[10] - util_mat[0] * util_mat[ 6] * util_mat[ 9] - util_mat[4] * util_mat[1] * util_mat[10] + util_mat[4] * util_mat[2] * util_mat[ 9] + util_mat[ 8] * util_mat[1] * util_mat[ 6] - util_mat[ 8] * util_mat[2] * util_mat[ 5];

	det = util_mat[0] * tmp_mat[0] + util_mat[1] * tmp_mat[4] + util_mat[2] * tmp_mat[8] + util_mat[3] * tmp_mat[12];
	if( det == 0.0f )
	{
		return NO;
	}
	det = 1.0f / det;

	for( int i = 0; i < 16; i++ )
	{
		util_mat[i] = tmp_mat[i] * det;
	}

	return YES;
}

/*
 * 積
 */
- (void)multiply:(float*)matrix
{
	int i, j, k;
	for( j = 0; j < 4; j++ )
	{
		k = j * 4;
		for( i = 0; i < 4; i++ )
		{
			tmp_mat[k + i] =
				util_mat[k    ] * matrix[     i] +
				util_mat[k + 1] * matrix[ 4 + i] +
				util_mat[k + 2] * matrix[ 8 + i] +
				util_mat[k + 3] * matrix[12 + i];
		}
	}
	[self set:tmp_mat];
}

/*
 * 回転
 */
- (void)rotate:(float)angle :(float)x :(float)y :(float)z
{
	// 正規化
	float d = sqrt( x * x + y * y + z * z );
	if( d != 0.0f )
	{
		x /= d;
		y /= d;
		z /= d;
	}

	float a = [self deg2rad:angle];
	float c = cos( a );
	float s = sin( a );
	float c2 = 1.0f - c;
	_rotate[ 0] = x * x * c2 + c;
	_rotate[ 1] = x * y * c2 - z * s;
	_rotate[ 2] = x * z * c2 + y * s;
	_rotate[ 4] = y * x * c2 + z * s;
	_rotate[ 5] = y * y * c2 + c;
	_rotate[ 6] = y * z * c2 - x * s;
	_rotate[ 8] = x * z * c2 - y * s;
	_rotate[ 9] = y * z * c2 + x * s;
	_rotate[10] = z * z * c2 + c;
	[self multiply:_rotate];
}

/*
 * 拡大・縮小
 */
- (void)scale:(float)x :(float)y :(float)z
{
	_scale[ 0] = x;
	_scale[ 5] = y;
	_scale[10] = z;
	[self multiply:_scale];
}

/*
 * 値の設定
 */
- (void)set:(float*)matrix
{
	for( int i = 0; i < 16; i++ )
	{
		util_mat[i] = matrix[i];
	}
}
- (void)setVal:(int)index :(float)value
{
	util_mat[index] = value;
}

/*
 * 単位行列
 */
- (void)setIdentity
{
	util_mat[ 0] = 1.0f; util_mat[ 1] = 0.0f; util_mat[ 2] = 0.0f; util_mat[ 3] = 0.0f;
	util_mat[ 4] = 0.0f; util_mat[ 5] = 1.0f; util_mat[ 6] = 0.0f; util_mat[ 7] = 0.0f;
	util_mat[ 8] = 0.0f; util_mat[ 9] = 0.0f; util_mat[10] = 1.0f; util_mat[11] = 0.0f;
	util_mat[12] = 0.0f; util_mat[13] = 0.0f; util_mat[14] = 0.0f; util_mat[15] = 1.0f;
}

/*
 * 平行移動
 */
- (void)translate:(float)x :(float)y :(float)z
{
	_translate[ 3] = x;
	_translate[ 7] = y;
	_translate[11] = z;
	[self multiply:_translate];
}

/*
 * 転置行列
 */
- (void)transpose
{
	int i, j, k;
	for( j = 0; j < 4; j++ )
	{
		k = j * 4;
		for( i = 0; i < 4; i++ )
		{
			tmp_mat[k + i] = util_mat[i * 4 + j];
		}
	}
	[self set:tmp_mat];
}

/*
 * 点の座標を表すベクトルを変換行列で変換
 */
- (void)transVector:(float)x :(float)y :(float)z
{
	trans_x = util_mat[0] * x + util_mat[1] * y + util_mat[ 2] * z + util_mat[ 3] * 1.0f;
	trans_y = util_mat[4] * x + util_mat[5] * y + util_mat[ 6] * z + util_mat[ 7] * 1.0f;
	trans_z = util_mat[8] * x + util_mat[9] * y + util_mat[10] * z + util_mat[11] * 1.0f;
}

/*
 * 外積
 */
- (void)cross:(float)x1 :(float)y1 :(float)z1 :(float)x2 :(float)y2 :(float)z2
{
	cross_x = y1 * z2 - z1 * y2;
	cross_y = z1 * x2 - x1 * z2;
	cross_z = x1 * y2 - y1 * x2;
}

/*
 * 内積
 */
- (float)dot:(float)x1 :(float)y1 :(float)z1 :(float)x2 :(float)y2 :(float)z2
{
	return x1 * x2 + y1 * y2 + z1 * z2;
}

/*
 * 距離
 */
- (float)distance:(float)x :(float)y :(float)z
{
	return sqrt( x * x + y * y + z * z );
}

/*
 * 正規化
 */
- (void)normalize:(float)x :(float)y :(float)z
{
	float d = sqrt( x * x + y * y + z * z );
	if( d != 0.0f )
	{
		normalize_x = x / d;
		normalize_y = y / d;
		normalize_z = z / d;
	}
	else
	{
		normalize_x = 0.0f;
		normalize_y = 0.0f;
		normalize_z = 0.0f;
	}
}

/*
 * 反射
 */
- (void)reflect:(float)vx :(float)vy :(float)vz :(float)nx :(float)ny :(float)nz
{
	float s = [self dot:-vx :-vy :-vz :nx :ny :nz];
	float px = nx * s;
	float py = ny * s;
	float pz = nz * s;
	reflect_x = vx + px + px;
	reflect_y = vy + py + py;
	reflect_z = vz + pz + pz;
}

/*
 * 三角形を検索
 */
- (void)beginGetTriangle
{
	seek_len = 2;
}
- (BOOL)getTriangle:(_GLModel*)model :(int)index :(BOOL)trans
{
	BOOL ret = NO;
	while( seek_len < model->_strip_len[index] )
	{
		for( int i = 0; i < 3; i++ )
		{
			seek_vertex[i] = model->_strip[index][seek_len - i];
		}
		seek_len++;
		if( (seek_vertex[0] != seek_vertex[1]) && (seek_vertex[0] != seek_vertex[2]) && (seek_vertex[1] != seek_vertex[2]) )
		{
			ret = YES;
			break;
		}
	}
	if( ret )
	{
		[self getTriangleCoord:model :index :trans];

		// 三角形の中心を求めておく
		center_x = (coord_x[0] + coord_x[1] + coord_x[2]) / 3.0f;
		center_y = (coord_y[0] + coord_y[1] + coord_y[2]) / 3.0f;
		center_z = (coord_z[0] + coord_z[1] + coord_z[2]) / 3.0f;
	}
	return ret;
}
- (void)getTriangleCoord:(_GLModel*)model :(int)index :(BOOL)trans
{
	int i;
	for( i = 0; i < 3; i++ )
	{
		coord_x[i] = model->_coord[model->_strip_coord[index]][seek_vertex[i] * 3    ];
		coord_y[i] = model->_coord[model->_strip_coord[index]][seek_vertex[i] * 3 + 1];
		coord_z[i] = model->_coord[model->_strip_coord[index]][seek_vertex[i] * 3 + 2];
	}
	if( trans )
	{
		for( i = 0; i < 3; i++ )
		{
			[self transVector:coord_x[i] :coord_y[i] :coord_z[i]];
			coord_x[i] = trans_x;
			coord_y[i] = trans_y;
			coord_z[i] = trans_z;
		}
	}
}
- (void)getTriangleNormal:(_GLModel*)model :(int)index :(BOOL)trans
{
	if( model->_strip_normal[index] >= 0 )
	{
		float x = 0.0f;
		float y = 0.0f;
		float z = 0.0f;
		for( int i = 0; i < 3; i++ )
		{
			x += model->_normal[model->_strip_normal[index]][seek_vertex[i] * 3    ];
			y += model->_normal[model->_strip_normal[index]][seek_vertex[i] * 3 + 1];
			z += model->_normal[model->_strip_normal[index]][seek_vertex[i] * 3 + 2];
		}
		if( trans )
		{
			[self transVector:x :y :z];
			x = trans_x;
			y = trans_y;
			z = trans_z;
		}

		// 水平または垂直な面は、三角形の座標から法線を求める
		[self cross
			:(coord_x[1] - coord_x[0])
			:(coord_y[1] - coord_y[0])
			:(coord_z[1] - coord_z[0])
			:(coord_x[2] - coord_x[0])
			:(coord_y[2] - coord_y[0])
			:(coord_z[2] - coord_z[0])
			];
		cross_x = abs( cross_x );
		cross_y = abs( cross_y );
		cross_z = abs( cross_z );

		// 誤差を考慮
		if( (cross_x < TOLERANCE) || (cross_y < TOLERANCE) || (cross_z < TOLERANCE) )
		{
			x = (x < 0.0f) ? -cross_x : cross_x;
			y = (y < 0.0f) ? -cross_y : cross_y;
			z = (z < 0.0f) ? -cross_z : cross_z;
		}

		// 正規化
		[self normalize:x :y :z];
		normal_x = normalize_x;
		normal_y = normalize_y;
		normal_z = normalize_z;
	}
}
- (BOOL)checkTriangle:(float)x_min :(float)x_max :(float)y_min :(float)y_max :(float)z_min :(float)z_max
{
	if(
		(center_x >= x_min) && (center_x <= x_max) &&
		(center_y >= y_min) && (center_y <= y_max) &&
		(center_z >= z_min) && (center_z <= z_max)
	){
		return YES;
	}
	return NO;
}

/*
 * 辺と三角形ポリゴンとの当たり判定
 */
- (BOOL)hitCheck:(float)px :(float)py :(float)pz :(float)qx :(float)qy :(float)qz :(float*)cx :(float*)cy :(float*)cz
{
	// 平面の方程式より法線ベクトルを求める
	[self cross
		:(cx[1] - cx[0])
		:(cy[1] - cy[0])
		:(cz[1] - cz[0])
		:(cx[2] - cx[0])
		:(cy[2] - cy[0])
		:(cz[2] - cz[0])
		];
	float nx = cross_x;
	float ny = cross_y;
	float nz = cross_z;

	// 直線の方程式より u を求める
	float ux = qx - px;
	float uy = qy - py;
	float uz = qz - pz;

	// 交点を求める
	float top = nx * (cx[0] - px) + ny * (cy[0] - py) + nz * (cz[0] - pz);
	float bottom = [self dot:nx :ny :nz :ux :uy :uz];

	// 平行である場合、抜ける
	if( bottom == 0.0f )
	{
		return NO;
	}

	// t を求める
	float t = top / bottom;

	// 0 <= t <= 1 以外の場合、交差していないので抜ける
	if( (t < 0.0f) || (t > 1.0f) )
	{
		return NO;
	}

	// 面と線の交点を求める
	hit_x = px + t * ux;
	hit_y = py + t * uy;
	hit_z = pz + t * uz;

	// 三角形内外判定
	for( int i = 0; i < 3; i++ )
	{
		// 外積を利用して内外判定
		[self cross
			:(cx[(i == 2) ? 0 : i + 1] - cx[i])
			:(cy[(i == 2) ? 0 : i + 1] - cy[i])
			:(cz[(i == 2) ? 0 : i + 1] - cz[i])
			:(hit_x - cx[i])
			:(hit_y - cy[i])
			:(hit_z - cz[i])
			];

		// すべての場合の法線が同一方向ならば、三角ポリゴン内に存在する（誤差を考慮）
		if( ((cross_x * nx) < TOLERANCE_M) || ((cross_y * ny) < TOLERANCE_M) || ((cross_z * nz) < TOLERANCE_M) )
		{
			return NO;
		}
	}

	return YES;	// 交点有り
}

/*
 * gluLookAt
 */
- (void)lookAt:(float)position_x :(float)position_y :(float)position_z :(float)look_x :(float)look_y :(float)look_z :(float)up_x :(float)up_y :(float)up_z
{
	float d;

	look_x -= position_x;
	look_y -= position_y;
	look_z -= position_z;
	d = sqrt( look_x * look_x + look_y * look_y + look_z * look_z );
	if( d != 0.0f )
	{
		look_x /= d;
		look_y /= d;
		look_z /= d;
	}

	look_side[0] = look_y * up_z - look_z * up_y;
	look_side[1] = look_z * up_x - look_x * up_z;
	look_side[2] = look_x * up_y - look_y * up_x;
	d = sqrt( look_side[0] * look_side[0] + look_side[1] * look_side[1] + look_side[2] * look_side[2] );
	if( d != 0.0f )
	{
		look_side[0] /= d;
		look_side[1] /= d;
		look_side[2] /= d;
	}

	up_x = look_side[1] * look_z - look_side[2] * look_y;
	up_y = look_side[2] * look_x - look_side[0] * look_z;
	up_z = look_side[0] * look_y - look_side[1] * look_x;

	look_mat[ 0] = look_side[0]; look_mat[ 1] = up_x; look_mat[ 2] = -look_x; look_mat[ 3] = 0.0f;
	look_mat[ 4] = look_side[1]; look_mat[ 5] = up_y; look_mat[ 6] = -look_y; look_mat[ 7] = 0.0f;
	look_mat[ 8] = look_side[2]; look_mat[ 9] = up_z; look_mat[10] = -look_z; look_mat[11] = 0.0f;
	look_mat[12] = 0.0f        ; look_mat[13] = 0.0f; look_mat[14] = 0.0f   ; look_mat[15] = 1.0f;

	glLoadMatrixf( look_mat );
	glTranslatef( -position_x, -position_y, -position_z );

	// モデルビュー行列を取得
	// （OpenGL 形式の行列を _GLUtility 形式の行列に変換）
	int i, j, k;
	for( j = 0; j < 4; j++ )
	{
		k = j * 4;
		for( i = 0; i < 4; i++ )
		{
			model_mat[k + i] = look_mat[i * 4 + j];
		}
	}
	[self set:model_mat];
	[self translate:-position_x :-position_y :-position_z];
	for( i = 0; i < 16; i++ )
	{
		model_mat[i] = util_mat[i];
	}
}
- (float*)lookMatrix
{
	return look_mat;
}
- (float*)spriteMatrix:(float)x :(float)y :(float)z
{
	[self setIdentity];
	[self translate:x :y :z];
	[self multiply:look_mat];
	return [self matrix];
}

/*
 * glFrustum
 */
- (void)frustum:(float)l :(float)r :(float)b :(float)t :(float)n :(float)f
{
	glMatrixMode( GL_PROJECTION );
	glLoadIdentity();
	glFrustumf( l, r, b, t, n, f );

	// 射影行列を取得
	/******************************************
	 *   2 n                r + l             *
	 * -------     0       -------       0    *
	 *  r - l               r - l             *
	 *                                        *
	 *            2 n       t + b             *
	 *    0     -------    -------       0    *
	 *           t - b      t - b             *
	 *                                        *
	 *                      f + n      2 f n  *
	 *    0        0     - -------  - ------- *
	 *                      f - n      f - n  *
	 *                                        *
	 *    0        0         -1          0    *
	 ******************************************/
	proj_mat[ 0] = (2.0f * n) / (r - l);
	proj_mat[ 1] = 0.0f;
	proj_mat[ 2] = (r + l) / (r - l);
	proj_mat[ 3] = 0.0f;
	proj_mat[ 4] = 0.0f;
	proj_mat[ 5] = (2.0f * n) / (t - b);
	proj_mat[ 6] = (t + b) / (t - b);
	proj_mat[ 7] = 0.0f;
	proj_mat[ 8] = 0.0f;
	proj_mat[ 9] = 0.0f;
	proj_mat[10] = -(f + n) / (f - n);
	proj_mat[11] = -(2.0f * f * n) / (f - n);
	proj_mat[12] = 0.0f;
	proj_mat[13] = 0.0f;
	proj_mat[14] = -1.0f;
	proj_mat[15] = 0.0f;
	[self setIdentity];
	[self multiply:proj_mat];
	for( int i = 0; i < 16; i++ )
	{
		proj_mat[i] = util_mat[i];
	}
}

/*
 * glViewport
 */
- (void)viewport:(int)x :(int)y :(int)width :(int)height
{
	glViewport( x, y, width, height );

	// ビューポート行列を取得
	view_mat[0] = (float)x;
	view_mat[1] = (float)y;
	view_mat[2] = (float)width;
	view_mat[3] = (float)height;
}

/*
 * gluProject
 */
- (BOOL)project:(float)obj_x :(float)obj_y :(float)obj_z
{
	project_in[0] = obj_x * model_mat[ 0] + obj_y * model_mat[ 1] + obj_z * model_mat[ 2] + model_mat[ 3];
	project_in[1] = obj_x * model_mat[ 4] + obj_y * model_mat[ 5] + obj_z * model_mat[ 6] + model_mat[ 7];
	project_in[2] = obj_x * model_mat[ 8] + obj_y * model_mat[ 9] + obj_z * model_mat[10] + model_mat[11];
	project_in[3] = obj_x * model_mat[12] + obj_y * model_mat[13] + obj_z * model_mat[14] + model_mat[15];

	project_out[0] = project_in[0] * proj_mat[ 0] + project_in[1] * proj_mat[ 1] + project_in[2] * proj_mat[ 2] + project_in[3] * proj_mat[ 3];
	project_out[1] = project_in[0] * proj_mat[ 4] + project_in[1] * proj_mat[ 5] + project_in[2] * proj_mat[ 6] + project_in[3] * proj_mat[ 7];
	project_out[2] = project_in[0] * proj_mat[ 8] + project_in[1] * proj_mat[ 9] + project_in[2] * proj_mat[10] + project_in[3] * proj_mat[11];
	project_out[3] = project_in[0] * proj_mat[12] + project_in[1] * proj_mat[13] + project_in[2] * proj_mat[14] + project_in[3] * proj_mat[15];
	if( project_out[3] == 0.0f )
	{
		return NO;
	}

	project_x = ((project_out[0] / project_out[3] + 1.0f) / 2.0f) * view_mat[2] + view_mat[0];
	project_y = ((project_out[1] / project_out[3] + 1.0f) / 2.0f) * view_mat[3] + view_mat[1];
	project_z =  (project_out[2] / project_out[3] + 1.0f) / 2.0f;

	return YES;
}

/*
 * gluUnProject
 */
- (BOOL)unProject:(float)win_x :(float)win_y :(float)win_z
{
	[self set:model_mat];
	[self multiply:proj_mat];
	[self invert];

	project_in[0] = (win_x - view_mat[0]) * 2.0f / view_mat[2] - 1.0f;
	project_in[1] = (win_y - view_mat[1]) * 2.0f / view_mat[3] - 1.0f;
	project_in[2] = win_z * 2.0f - 1.0f;

	project_out[0] = project_in[0] * util_mat[ 0] + project_in[1] * util_mat[ 1] + project_in[2] * util_mat[ 2] + util_mat[ 3];
	project_out[1] = project_in[0] * util_mat[ 4] + project_in[1] * util_mat[ 5] + project_in[2] * util_mat[ 6] + util_mat[ 7];
	project_out[2] = project_in[0] * util_mat[ 8] + project_in[1] * util_mat[ 9] + project_in[2] * util_mat[10] + util_mat[11];
	project_out[3] = project_in[0] * util_mat[12] + project_in[1] * util_mat[13] + project_in[2] * util_mat[14] + util_mat[15];
	if( project_out[3] == 0.0f )
	{
		return NO;
	}

	project_x = project_out[0] / project_out[3];
	project_y = project_out[1] / project_out[3];
	project_z = project_out[2] / project_out[3];

	return YES;
}

- (float)transX
{
	return trans_x;
}
- (float)transY
{
	return trans_y;
}
- (float)transZ
{
	return trans_z;
}
- (float)crossX
{
	return cross_x;
}
- (float)crossY
{
	return cross_y;
}
- (float)crossZ
{
	return cross_z;
}
- (float)normalizeX
{
	return normalize_x;
}
- (float)normalizeY
{
	return normalize_y;
}
- (float)normalizeZ
{
	return normalize_z;
}
- (float)reflectX
{
	return reflect_x;
}
- (float)reflectY
{
	return reflect_y;
}
- (float)reflectZ
{
	return reflect_z;
}
- (float)coordX:(int)i
{
	return coord_x[i];
}
- (float)coordY:(int)i
{
	return coord_y[i];
}
- (float)coordZ:(int)i
{
	return coord_z[i];
}
- (float)normalX
{
	return normal_x;
}
- (float)normalY
{
	return normal_y;
}
- (float)normalZ
{
	return normal_z;
}
- (float)centerX
{
	return center_x;
}
- (float)centerY
{
	return center_y;
}
- (float)centerZ
{
	return center_z;
}
- (float)hitX
{
	return hit_x;
}
- (float)hitY
{
	return hit_y;
}
- (float)hitZ
{
	return hit_z;
}
- (float)projectX
{
	return project_x;
}
- (float)projectY
{
	return project_y;
}
- (float)projectZ
{
	return project_z;
}

@end
