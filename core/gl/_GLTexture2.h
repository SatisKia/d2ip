/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "_GLTexture.h"

@class _Graphics;
@class _Image;

@interface _GLTexture2 : _GLTexture
{
@private
	// 2D描画用のテクスチャ・イメージ
	_Image* _img2D;
	unsigned char* _pixels2D;
	int _index2D;

	_Graphics* _g;
}

- (id)initWithNum:(int)index_num :(int)gen_num;
- (void)create2D:(int)width :(int)height;
- (_Image*)getImage2D;
- (_Graphics*)lock2D;
- (void)unlock2D:(BOOL)applyScale;
- (void)draw2D:(BOOL)applyScale;

@end
