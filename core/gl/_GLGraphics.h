/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "_Scalable.h"

@class _GLTexture;

// ラスターオペレーション
#define ROP_COPY	0
#define ROP_ADD		1

// イメージ描画時の反転方法
#define FLIP_NONE		0
#define FLIP_HORIZONTAL	1
#define FLIP_VERTICAL	2
#define FLIP_ROTATE		3

@interface _GLGraphics : _Scalable
{
@private
	_GLTexture* _glt;

	int _width;
	int _height;

	// 線幅
	float _line_width;
	float _line_expand;

	// 色
	float _r;
	float _g;
	float _b;

	// 透明度
	unsigned char _a255;
	float _a;

	// ラスターオペレーション
	int _rop;

	// イメージ描画時の反転方法
	int _flipmode;

	// 描画の際の座標原点
	int _origin_x;
	int _origin_y;

	float _coord[12];
	float _color[16];
	float _alpha[16];
	float _map[8];
	unsigned short _strip[4];
	float _uv[8];

	BOOL _lock_tex_f;
	int _lock_tex;
	float _tex_width;
	float _tex_height;
}

- (id)initWithTexture:(_GLTexture*)glt;
- (void)reset;
+ (int)getColorOfRGB:(int)r :(int)g :(int)b;
- (void)setSize:(int)width :(int)height;
- (int)getWidth;
- (int)getHeight;
- (void)setLineWidth:(float)width;
- (void)setColor:(int)color;
- (void)setAlpha:(int)a;
- (void)setROP:(int)mode;
- (void)setFlipMode:(int)flipmode;
- (void)setOrigin:(int)x :(int)y;
- (void)drawLine:(int)x1 :(int)y1 :(int)x2 :(int)y2;
- (void)drawRect:(int)x :(int)y :(int)width :(int)height;
- (void)fillRect:(int)x :(int)y :(int)width :(int)height;
- (void)lockTexture:(int)tex_index;
- (void)unlockTexture;
- (void)drawTexture:(int)tex_index :(int)x :(int)y;
- (void)drawTexture:(int)tex_index :(int)dx :(int)dy :(int)sx :(int)sy :(int)width :(int)height;
- (void)drawScaledTexture:(int)tex_index :(int)dx :(int)dy :(int)width :(int)height :(int)sx :(int)sy :(int)swidth :(int)sheight;
- (void)drawTransTexture:(int)tex_index :(float)dx :(float)dy :(int)sx :(int)sy :(int)width :(int)height :(float)cx :(float)cy :(float)r360 :(float)z128x :(float)z128y;

@end
