/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "_Scalable.h"

// イメージ描画時の反転方法
#define FLIP_NONE		0
#define FLIP_HORIZONTAL	1
#define FLIP_VERTICAL	2
#define FLIP_ROTATE		3

@interface _GLTexture : _Scalable
{
@private
	int _num;
	unsigned int* _id;
	BOOL* _use_id;
	int* _index2id;
	int* _width;
	int* _height;

	unsigned char** _t_rgba;
	unsigned char** _t_a;
	unsigned char* _t_trans;
	BOOL* _t_alpha;

	int _gen_num;
	BOOL _gen;

	int _canvas_height;

	// イメージ描画時の反転方法
@protected
	int _flipmode;
@private

	GLint _draw_rect[4];

	int _lock_tex;
}

- (id)initWithNum:(int)index_num :(int)gen_num;
- (void)reset;
+ (int)getTextureSize:(int)size;
- (void)use:(int)index :(BOOL)use_trans;
- (void)use:(int)index;
- (void)unuse:(int)index;
- (void)unuse;
- (void)update:(int)index :(unsigned char*)pixels :(int)length;
- (void)setTransparency:(int)index :(unsigned char)trans;
- (int)id:(int)index;
- (int)width:(int)index;
- (int)height:(int)index;
- (BOOL)alpha:(int)index;
- (BOOL)depth:(int)index;
- (void)setCanvasHeight:(int)height;
- (void)setFlipMode:(int)flipmode;
- (void)lock:(int)index;
- (void)unlock;
- (void)draw:(int)index :(int)dx :(int)dy;
- (void)draw:(int)index :(int)dx :(int)dy :(int)sx :(int)sy :(int)swidth :(int)sheight;
- (void)draw:(int)index :(int)dx :(int)dy :(int)dwidth :(int)dheight :(int)sx :(int)sy :(int)swidth :(int)sheight;

- (NSString*)_resourceName:(int)index;
- (UIImage*)_allocImage:(int)index;
- (BOOL)_alphaFlag:(int)index;
- (BOOL)_depthFlag:(int)index;
- (GLint)_filter:(int)index;
- (GLint)_wrap:(int)index;

@end
