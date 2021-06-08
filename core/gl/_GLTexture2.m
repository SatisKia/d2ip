/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_GLTexture2.h"

#import "_Graphics.h"
#import "_Image.h"

@implementation _GLTexture2

- (id)initWithNum:(int)index_num :(int)gen_num
{
	self = [super initWithNum:index_num :(gen_num + 1)];
	if( self != nil )
	{
		// 2D描画用のテクスチャ・イメージ
		_img2D = nil;
		_pixels2D = NULL;
		_index2D = gen_num;
	}
	return self;
}

- (void)dealloc
{
#ifdef NO_OBJC_ARC
	if( _img2D != nil )
	{
		[_img2D release];
	}
#endif // NO_OBJC_ARC
	if( _pixels2D != NULL )
	{
		free( _pixels2D );
	}

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (void)create2D:(int)width :(int)height
{
	// 2D描画用のテクスチャ・イメージ
	_img2D = [[_Image alloc] init];
	[_img2D create:[_GLTexture getTextureSize:width] :[_GLTexture getTextureSize:height]];
	_pixels2D = malloc( [_img2D getWidth] * [_img2D getHeight] * 4 );
}

- (_Image*)getImage2D
{
	return _img2D;
}

- (_Graphics*)lock2D
{
	[_img2D clear];

	_g = [_img2D getGraphics];
	[_g lock];
	return _g;
}

- (void)unlock2D:(BOOL)applyScale
{
	[_g unlock];

	// テクスチャ更新
	int width  = [_img2D getWidth ];
	int height = [_img2D getHeight];
	[_img2D getPixels:0 :0 :width :height :_pixels2D];
	[self update:_index2D :_pixels2D :(width * height * 4)];

	// 画面に表示
	[self draw2D:applyScale];
}

- (void)draw2D:(BOOL)applyScale
{
	float scale = _scale;
	int flipmode = _flipmode;

	if( !applyScale )
	{
		[self setScale:1.0f];
	}
	[self setFlipMode:FLIP_NONE];

	[self draw:_index2D :0 :0];

	if( !applyScale )
	{
		[self setScale:scale];
	}
	[self setFlipMode:flipmode];
}

- (UIImage*)_allocImage:(int)index
{
	if( index == _index2D )
	{
		return [_img2D allocImage];
	}
	return [super _allocImage:index];
}

@end
