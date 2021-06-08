/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <OpenGLES/ES1/gl.h>

#import "_GLTexture.h"

@implementation _GLTexture

- (id)initWithNum:(int)index_num :(int)gen_num
{
	self = [super init];
	if( self != nil )
	{
		int i;

		_num = index_num;
		_gen_num = gen_num;

		_id = malloc( sizeof(unsigned int) * _gen_num );
		glGenTextures( _gen_num, _id );
		_gen = YES;

		_use_id = malloc( sizeof(BOOL) * _gen_num );
		for( i = 0; i < _gen_num; i++ )
		{
			_use_id[i] = NO;
		}

		_index2id = malloc( sizeof(int) * _num );

		_width = malloc( sizeof(int) * _num );
		_height = malloc( sizeof(int) * _num );

		_t_rgba = malloc( sizeof(unsigned char*) * _num );
		_t_a = malloc( sizeof(unsigned char*) * _num );
		_t_trans = malloc( sizeof(unsigned char*) * _num );
		_t_alpha = malloc( sizeof(BOOL*) * _num );

		for( i = 0; i < _num; i++ )
		{
			_index2id[i] = -1;

			_t_rgba[i] = NULL;
			_t_a[i] = NULL;
		}

		_flipmode = FLIP_NONE;

		_lock_tex = -1;
	}
	return self;
}

- (void)dealloc
{
	for( int i = 0; i < _num; i++ )
	{
		[self unuse:i];
	}

	if( _gen )
	{
		glDeleteTextures( _gen_num, _id );
		_gen = NO;
	}

	free( _id );

	free( _use_id );

	free( _index2id );

	free( _width );
	free( _height );

	free( _t_rgba );
	free( _t_a );
	free( _t_trans );
	free( _t_alpha );

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (void)reset
{
//	if( _gen )
//	{
//		glDeleteTextures( _gen_num, _id );
//		glGenTextures( _gen_num, _id );
//	}

	for( int i = 0; i < _num; i++ )
	{
		if( _use_id[_index2id[i]] )
		{
			[self _useSub:i];
		}
	}
}

+ (int)getTextureSize:(int)size
{
	int tmp = 1;
	while( YES )
	{
		if( tmp >= size )
		{
			break;
		}
		tmp *= 2;
	}
	return tmp;
}

- (void)_useSub:(int)index
{
	// テクスチャを構築する
	glPixelStorei( GL_UNPACK_ALIGNMENT, 1 );
	glEnable( GL_TEXTURE_2D );
	glBindTexture( GL_TEXTURE_2D, _id[_index2id[index]] );
	glTexImage2D( GL_TEXTURE_2D,
		0,
		GL_RGBA,
		_width[index],
		_height[index],
		0,
		GL_RGBA,
		GL_UNSIGNED_BYTE,
		_t_rgba[index]
		);

	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, [self _filter:index] );
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, [self _filter:index] );
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, [self _wrap:index] );
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, [self _wrap:index] );
}
- (void)use:(int)index :(BOOL)use_trans
{
	if( _index2id[index] >= 0 )
	{
		return;
	}

	int i;

	_index2id[index] = 0;
	for( i = 0; i < _gen_num; i++ )
	{
		if( !_use_id[i] )
		{
			_use_id[i] = YES;
			_index2id[index] = i;
			break;
		}
	}

	// 画像ファイル読み込み
	UIImage* uiimage = [self _allocImage:index];
	CGImageRef cgimage = CGImageRetain( uiimage.CGImage );
	NSInteger order = CGImageGetBitmapInfo( cgimage ) & kCGBitmapByteOrderMask;
	CFDataRef data = CGDataProviderCopyData( CGImageGetDataProvider( cgimage ) );
	unsigned char* pixels = (unsigned char*)CFDataGetBytePtr( data );
	_width [index] = CGImageGetWidth ( cgimage );
	_height[index] = CGImageGetHeight( cgimage );
	int len = _width[index] * _height[index];
	_t_rgba[index] = malloc( len * 4 );
	if( CGImageGetBitsPerPixel( cgimage ) == 32 )
	{
		if( order == kCGBitmapByteOrder32Little )
		{
			for( i = 0; i < len; i++ )
			{
				_t_rgba[index][i * 4    ] = pixels[i * 4 + 2];
				_t_rgba[index][i * 4 + 1] = pixels[i * 4 + 1];
				_t_rgba[index][i * 4 + 2] = pixels[i * 4    ];

				_t_rgba[index][i * 4 + 3] = pixels[i * 4 + 3];
			}
		}
		else
		{
			for( i = 0; i < len; i++ )
			{
				_t_rgba[index][i * 4    ] = pixels[i * 4    ];
				_t_rgba[index][i * 4 + 1] = pixels[i * 4 + 1];
				_t_rgba[index][i * 4 + 2] = pixels[i * 4 + 2];

				_t_rgba[index][i * 4 + 3] = pixels[i * 4 + 3];
			}
		}
	}
	else
	{
		if( order == kCGBitmapByteOrder32Little )
		{
			for( i = 0; i < len; i++ )
			{
				_t_rgba[index][i * 4    ] = pixels[i * 3 + 2];
				_t_rgba[index][i * 4 + 1] = pixels[i * 3 + 1];
				_t_rgba[index][i * 4 + 2] = pixels[i * 3    ];

				_t_rgba[index][i * 4 + 3] = (unsigned char)255;
			}
		}
		else
		{
			for( i = 0; i < len; i++ )
			{
				_t_rgba[index][i * 4    ] = pixels[i * 3    ];
				_t_rgba[index][i * 4 + 1] = pixels[i * 3 + 1];
				_t_rgba[index][i * 4 + 2] = pixels[i * 3 + 2];

				_t_rgba[index][i * 4 + 3] = (unsigned char)255;
			}
		}
	}
	if( use_trans )
	{
		_t_a[index] = malloc( len );
		for( i = 0; i < len; i++ )
		{
			_t_a[index][i] = _t_rgba[index][i * 4 + 3];	// アルファ値を保持
		}
	}
	CFRelease( data );
	CGImageRelease( cgimage );
#ifdef NO_OBJC_ARC
	[uiimage release];
#endif // NO_OBJC_ARC

	_t_trans[index] = (unsigned char)255;
	_t_alpha[index] = [self _alphaFlag:index];

	[self _useSub:index];
}
- (void)use:(int)index
{
	[self use:index :NO];
}

- (void)unuse:(int)index
{
	if( _index2id[index] >= 0 )
	{
		_use_id[_index2id[index]] = NO;

		free( _t_rgba[index] );
		_t_rgba[index] = NULL;

		if( _t_a[index] != NULL )
		{
			free( _t_a[index] );
			_t_a[index] = NULL;
		}

		_index2id[index] = -1;
	}
}

- (void)unuse
{
	for( int i = 0; i < _num; i++ )
	{
		[self unuse:i];
	}

	glDeleteTextures( _gen_num, _id );
	glGenTextures( _gen_num, _id );
}

- (void)update:(int)index :(unsigned char*)pixels :(int)length
{
	if( _index2id[index] >= 0 )
	{
		int len = _width[index] * _height[index];
		if( length == len * 4 )
		{
			memcpy( _t_rgba[index], pixels, len * 4 );
			if( _t_a[index] != NULL )
			{
				for( int i = 0; i < len; i++ )
				{
					_t_a[index][i] = _t_rgba[index][i * 4 + 3];	// アルファ値を保持
				}
			}

			_t_trans[index] = (unsigned char)255;
			_t_alpha[index] = [self _alphaFlag:index];

			// テクスチャを再構築する
			glPixelStorei( GL_UNPACK_ALIGNMENT, 1 );
			glEnable( GL_TEXTURE_2D );
			glBindTexture( GL_TEXTURE_2D, _id[_index2id[index]] );
			glTexImage2D( GL_TEXTURE_2D,
				0,
				GL_RGBA,
				_width[index],
				_height[index],
				0,
				GL_RGBA,
				GL_UNSIGNED_BYTE,
				_t_rgba[index]
				);
		}
	}
}

- (void)setTransparency:(int)index :(unsigned char)trans
{
	if( _t_a[index] == NULL )
	{
		return;
	}

	[self use:index];

	if( trans == _t_trans[index] )
	{
		return;
	}
	_t_trans[index] = trans;

	// アルファ値を操作する
	int len = _width[index] * _height[index];
	int j = 3;
	for( int i = 0; i < len; i++ )
	{
		_t_rgba[index][j] = (unsigned char)((int)_t_a[index][i] * (int)_t_trans[index] / 255);
		j += 4;
	}

	_t_alpha[index] = (_t_trans[index] == (unsigned char)255) ? [self _alphaFlag:index] : YES;

	// テクスチャを再構築する
	glPixelStorei( GL_UNPACK_ALIGNMENT, 1 );
	glEnable( GL_TEXTURE_2D );
	glBindTexture( GL_TEXTURE_2D, _id[_index2id[index]] );
	glTexImage2D( GL_TEXTURE_2D,
		0,
		GL_RGBA,
		_width[index],
		_height[index],
		0,
		GL_RGBA,
		GL_UNSIGNED_BYTE,
		_t_rgba[index]
		);
}

- (int)id:(int)index
{
	return _id[_index2id[index]];
}

- (int)width:(int)index
{
	return _width[index];
}

- (int)height:(int)index
{
	return _height[index];
}

- (BOOL)alpha:(int)index
{
	return _t_alpha[index];
}

- (BOOL)depth:(int)index
{
	return [self _depthFlag:index];
}

- (void)setCanvasHeight:(int)height
{
	_canvas_height = height;
}

- (void)setFlipMode:(int)flipmode
{
	_flipmode = flipmode;
}

- (void)lock:(int)index
{
	_lock_tex = index;

	[self use:_lock_tex];

	glEnable( GL_TEXTURE_2D );
	glBindTexture( GL_TEXTURE_2D, _id[_index2id[_lock_tex]] );

	glEnable( GL_BLEND );
	glDepthMask( GL_FALSE );
}

- (void)unlock
{
	glDisable( GL_BLEND );
	glDepthMask( GL_TRUE );

	glDisable( GL_TEXTURE_2D );

	_lock_tex = -1;
}

- (void)_draw:(int)dx :(int)dy
{
	dy = _canvas_height - _height[_lock_tex] - dy;

	switch( _flipmode )
	{
	case FLIP_NONE:
		_draw_rect[0] = 0;
		_draw_rect[1] = _height[_lock_tex];
		_draw_rect[2] = _width[_lock_tex];
		_draw_rect[3] = -_height[_lock_tex];
		break;
	case FLIP_HORIZONTAL:
		_draw_rect[0] = _width[_lock_tex];
		_draw_rect[1] = _height[_lock_tex];
		_draw_rect[2] = -_width[_lock_tex];
		_draw_rect[3] = -_height[_lock_tex];
		break;
	case FLIP_VERTICAL:
		_draw_rect[0] = 0;
		_draw_rect[1] = 0;
		_draw_rect[2] = _width[_lock_tex];
		_draw_rect[3] = _height[_lock_tex];
		break;
	case FLIP_ROTATE:
		_draw_rect[0] = _width[_lock_tex];
		_draw_rect[1] = 0;
		_draw_rect[2] = -_width[_lock_tex];
		_draw_rect[3] = _height[_lock_tex];
		break;
	}
	glTexParameteriv( GL_TEXTURE_2D, GL_TEXTURE_CROP_RECT_OES, _draw_rect );

	glDrawTexfOES( dx, dy, 0.0f, _width[_lock_tex], _height[_lock_tex] );
}
- (void)draw:(int)index :(int)dx :(int)dy
{
	if( _lock_tex >= 0 )
	{
		if( _scale != 1.0f )
		{
			[self _draw:dx :dy :_width[_lock_tex] :_height[_lock_tex] :0 :0 :_width[_lock_tex] :_height[_lock_tex]];
		}
		else
		{
			[self _draw:dx :dy];
		}
		return;
	}

	if( _scale != 1.0f )
	{
		[self draw:index :dx :dy :_width[index] :_height[index] :0 :0 :_width[index] :_height[index]];
		return;
	}

	[self use:index];

	dy = _canvas_height - _height[index] - dy;

	glEnable( GL_TEXTURE_2D );
	glBindTexture( GL_TEXTURE_2D, _id[_index2id[index]] );

	switch( _flipmode )
	{
	case FLIP_NONE:
		_draw_rect[0] = 0;
		_draw_rect[1] = _height[index];
		_draw_rect[2] = _width[index];
		_draw_rect[3] = -_height[index];
		break;
	case FLIP_HORIZONTAL:
		_draw_rect[0] = _width[index];
		_draw_rect[1] = _height[index];
		_draw_rect[2] = -_width[index];
		_draw_rect[3] = -_height[index];
		break;
	case FLIP_VERTICAL:
		_draw_rect[0] = 0;
		_draw_rect[1] = 0;
		_draw_rect[2] = _width[index];
		_draw_rect[3] = _height[index];
		break;
	case FLIP_ROTATE:
		_draw_rect[0] = _width[index];
		_draw_rect[1] = 0;
		_draw_rect[2] = -_width[index];
		_draw_rect[3] = _height[index];
		break;
	}
	glTexParameteriv( GL_TEXTURE_2D, GL_TEXTURE_CROP_RECT_OES, _draw_rect );

	glEnable( GL_BLEND );
	glDepthMask( GL_FALSE );

	glDrawTexfOES( dx, dy, 0.0f, _width[index], _height[index] );

	glDisable( GL_BLEND );
	glDepthMask( GL_TRUE );

	glDisable( GL_TEXTURE_2D );
}

- (void)_draw:(int)dx :(int)dy :(int)dwidth :(int)dheight :(int)sx :(int)sy :(int)swidth :(int)sheight
{
	if( _scale != 1.0f )
	{
		dx      = (int)((float)dx      * _scale);
		dy      = (int)((float)dy      * _scale);
		dwidth  = (int)((float)dwidth  * _scale);
		dheight = (int)((float)dheight * _scale);
	}

	dy = _canvas_height - dheight - dy;
	sy = _height[_lock_tex] - sy - sheight;

	switch( _flipmode )
	{
	case FLIP_NONE:
		_draw_rect[0] = sx;
		_draw_rect[1] = _height[_lock_tex] - sy;
		_draw_rect[2] = swidth;
		_draw_rect[3] = -sheight;
		break;
	case FLIP_HORIZONTAL:
		_draw_rect[0] = sx + swidth;
		_draw_rect[1] = _height[_lock_tex] - sy;
		_draw_rect[2] = -swidth;
		_draw_rect[3] = -sheight;
		break;
	case FLIP_VERTICAL:
		_draw_rect[0] = sx;
		_draw_rect[1] = _height[_lock_tex] - sy - sheight;
		_draw_rect[2] = swidth;
		_draw_rect[3] = sheight;
		break;
	case FLIP_ROTATE:
		_draw_rect[0] = sx + swidth;
		_draw_rect[1] = _height[_lock_tex] - sy - sheight;
		_draw_rect[2] = -swidth;
		_draw_rect[3] = sheight;
		break;
	}
	glTexParameteriv( GL_TEXTURE_2D, GL_TEXTURE_CROP_RECT_OES, _draw_rect );

	glDrawTexfOES( dx, dy, 0.0f, dwidth, dheight );
}
- (void)draw:(int)index :(int)dx :(int)dy :(int)dwidth :(int)dheight :(int)sx :(int)sy :(int)swidth :(int)sheight
{
	if( _lock_tex >= 0 )
	{
		[self _draw:dx :dy :dwidth :dheight :sx :sy :swidth :sheight];
		return;
	}

	if( _scale != 1.0f )
	{
		dx      = (int)((float)dx      * _scale);
		dy      = (int)((float)dy      * _scale);
		dwidth  = (int)((float)dwidth  * _scale);
		dheight = (int)((float)dheight * _scale);
	}

	[self use:index];

	dy = _canvas_height - dheight - dy;
	sy = _height[index] - sy - sheight;

	glEnable( GL_TEXTURE_2D );
	glBindTexture( GL_TEXTURE_2D, _id[_index2id[index]] );

	switch( _flipmode )
	{
	case FLIP_NONE:
		_draw_rect[0] = sx;
		_draw_rect[1] = _height[index] - sy;
		_draw_rect[2] = swidth;
		_draw_rect[3] = -sheight;
		break;
	case FLIP_HORIZONTAL:
		_draw_rect[0] = sx + swidth;
		_draw_rect[1] = _height[index] - sy;
		_draw_rect[2] = -swidth;
		_draw_rect[3] = -sheight;
		break;
	case FLIP_VERTICAL:
		_draw_rect[0] = sx;
		_draw_rect[1] = _height[index] - sy - sheight;
		_draw_rect[2] = swidth;
		_draw_rect[3] = sheight;
		break;
	case FLIP_ROTATE:
		_draw_rect[0] = sx + swidth;
		_draw_rect[1] = _height[index] - sy - sheight;
		_draw_rect[2] = -swidth;
		_draw_rect[3] = sheight;
		break;
	}
	glTexParameteriv( GL_TEXTURE_2D, GL_TEXTURE_CROP_RECT_OES, _draw_rect );

	glEnable( GL_BLEND );
	glDepthMask( GL_FALSE );

	glDrawTexfOES( dx, dy, 0.0f, dwidth, dheight );

	glDisable( GL_BLEND );
	glDepthMask( GL_TRUE );

	glDisable( GL_TEXTURE_2D );
}
- (void)draw:(int)index :(int)dx :(int)dy :(int)sx :(int)sy :(int)swidth :(int)sheight
{
	if( _lock_tex >= 0 )
	{
		[self _draw:dx :dy :swidth :sheight :sx :sy :swidth :sheight];
	}
	else
	{
		[self draw:index :dx :dy :swidth :sheight :sx :sy :swidth :sheight];
	}
}

- (NSString*)_resourceName:(int)index { return @""; }
- (UIImage*)_allocImage:(int)index
{
	NSString* path = [[NSBundle mainBundle] pathForResource:[self _resourceName:index] ofType:@""];
	return [[UIImage alloc] initWithContentsOfFile:path];
}
- (BOOL)_alphaFlag:(int)index { return YES; }
- (BOOL)_depthFlag:(int)index { return YES; }
- (GLint)_filter:(int)index { return GL_LINEAR; }
- (GLint)_wrap:(int)index { return GL_CLAMP_TO_EDGE; }

@end
