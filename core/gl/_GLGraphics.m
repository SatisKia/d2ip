/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <OpenGLES/ES1/gl.h>

#import "_GLGraphics.h"

#import "_GLTexture.h"

@implementation _GLGraphics

- (id)initWithTexture:(_GLTexture*)glt
{
	self = [super init];
	if( self != nil )
	{
		_glt = glt;

		_coord[ 2] = 0.0f;
		_coord[ 5] = 0.0f;
		_coord[ 8] = 0.0f;
		_coord[11] = 0.0f;

		_color[ 3] = 1.0f;
		_color[ 7] = 1.0f;
		_color[11] = 1.0f;
		_color[15] = 1.0f;
		[self setColor:0];

		_alpha[ 0] = 1.0f; _alpha[ 1] = 1.0f; _alpha[ 2] = 1.0f;
		_alpha[ 4] = 1.0f; _alpha[ 5] = 1.0f; _alpha[ 6] = 1.0f;
		_alpha[ 8] = 1.0f; _alpha[ 9] = 1.0f; _alpha[10] = 1.0f;
		_alpha[12] = 1.0f; _alpha[13] = 1.0f; _alpha[14] = 1.0f;
		[self setAlpha:255];

		_strip[0] = 0;
		_strip[1] = 1;
		_strip[2] = 2;
		_strip[3] = 3;

		[self setROP:ROP_COPY];

		_flipmode = FLIP_NONE;

		_origin_x = 0;
		_origin_y = 0;

		_lock_tex_f = NO;
		_lock_tex = -1;
	}
	return self;
}

- (void)reset
{
	[self _setROP];
}

+ (int)getColorOfRGB:(int)r :(int)g :(int)b
{
	return (r << 16) + (g << 8) + b;
}

- (void)setSize:(int)width :(int)height
{
	_width  = width;
	_height = height;
}

- (int)getWidth
{
	return (int)((float)_width / _scale);
}
- (int)getHeight
{
	return (int)((float)_height / _scale);
}

- (void)setLineWidth:(float)width
{
	_line_width = width * _scale;
	if( _line_width > 1.0f )
	{
		_line_expand = (_line_width - 1.0f) / 2.0f;
	}
	else
	{
		_line_width  = 1.0f;
		_line_expand = 0.0f;
	}
}

- (void)setColor:(int)color
{
	_r = (float)((color >> 16) & 0xff) / 255.0f;
	_g = (float)((color >>  8) & 0xff) / 255.0f;
	_b = (float)( color        & 0xff) / 255.0f;

	_color[ 0] = _r; _color[ 1] = _g; _color[ 2] = _b;
	_color[ 4] = _r; _color[ 5] = _g; _color[ 6] = _b;
	_color[ 8] = _r; _color[ 9] = _g; _color[10] = _b;
	_color[12] = _r; _color[13] = _g; _color[14] = _b;
}
- (void)setAlpha:(int)a
{
	_a = (float)a / 255.0f;
	_a255 = (unsigned char)a;

	_color[ 3] = _a;
	_color[ 7] = _a;
	_color[11] = _a;
	_color[15] = _a;

	_alpha[ 3] = _a;
	_alpha[ 7] = _a;
	_alpha[11] = _a;
	_alpha[15] = _a;
}

- (void)_setROP
{
	switch( _rop )
	{
	case ROP_COPY:
		glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
		break;
	case ROP_ADD:
		glBlendFunc( GL_SRC_ALPHA, GL_ONE );
		break;
	}
}
- (void)setROP:(int)mode
{
	_rop = mode;
	[self _setROP];
}

- (void)setFlipMode:(int)flipmode
{
	_flipmode = flipmode;

	// _GLTexture にも通知
	[_glt setFlipMode:_flipmode];
}

- (void)setOrigin:(int)x :(int)y
{
	_origin_x = (int)((float)x * _scale);
	_origin_y = (int)((float)y * _scale);
}

- (void)_drawLineH:(int)y :(int)x1 :(int)x2
{
	if( _scale != 1.0f )
	{
		y  = (int)((float)y  * _scale);
		x1 = (int)((float)x1 * _scale);
		x2 = (int)((float)x2 * _scale);
	}

	x1 += _origin_x;
	x2 += _origin_x;
	y = _height - (y + _origin_y);

	float y2 = (float)y - _line_expand;
	float y3 = y2 + _line_width;
	_coord[0] = x1; _coord[ 1] = y2;
	_coord[3] = x2; _coord[ 4] = y2;
	_coord[6] = x1; _coord[ 7] = y3;
	_coord[9] = x2; _coord[10] = y3;

	glEnableClientState( GL_VERTEX_ARRAY );
	glVertexPointer( 3, GL_FLOAT, 0, _coord );

	glEnableClientState( GL_COLOR_ARRAY );
	glColorPointer( 4, GL_FLOAT, 0, _color );

	glDisable( GL_TEXTURE_2D );

	glEnable( GL_BLEND );
	glDepthMask( GL_FALSE );

	glLoadIdentity();
	glDrawElements( GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, _strip );

	glDisable( GL_BLEND );
	glDepthMask( GL_TRUE );

	glDisableClientState( GL_VERTEX_ARRAY );
	glDisableClientState( GL_COLOR_ARRAY );
}
- (void)_drawLineV:(int)x :(int)y1 :(int)y2
{
	if( _scale != 1.0f )
	{
		x  = (int)((float)x  * _scale);
		y1 = (int)((float)y1 * _scale);
		y2 = (int)((float)y2 * _scale);
	}

	x += _origin_x;
	y1 = _height - (y1 + _origin_y);
	y2 = _height - (y2 + _origin_y);

	float x2 = (float)x - _line_expand;
	float x3 = x2 + _line_width;
	_coord[0] = x2; _coord[ 1] = y1;
	_coord[3] = x3; _coord[ 4] = y1;
	_coord[6] = x2; _coord[ 7] = y2;
	_coord[9] = x3; _coord[10] = y2;

	glEnableClientState( GL_VERTEX_ARRAY );
	glVertexPointer( 3, GL_FLOAT, 0, _coord );

	glEnableClientState( GL_COLOR_ARRAY );
	glColorPointer( 4, GL_FLOAT, 0, _color );

	glDisable( GL_TEXTURE_2D );

	glEnable( GL_BLEND );
	glDepthMask( GL_FALSE );

	glLoadIdentity();
	glDrawElements( GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, _strip );

	glDisable( GL_BLEND );
	glDepthMask( GL_TRUE );

	glDisableClientState( GL_VERTEX_ARRAY );
	glDisableClientState( GL_COLOR_ARRAY );
}
- (void)drawLine:(int)x1 :(int)y1 :(int)x2 :(int)y2
{
	if( y1 == y2 )
	{
		[self _drawLineH:y1 :x1 :x2];
		return;
	}
	if( x1 == x2 )
	{
		[self _drawLineV:x1 :y1 :y2];
		return;
	}

	if( _scale != 1.0f )
	{
		x1 = (int)((float)x1 * _scale);
		y1 = (int)((float)y1 * _scale);
		x2 = (int)((float)x2 * _scale);
		y2 = (int)((float)y2 * _scale);
	}

	float width = sqrt( (float)((y2 - y1) * (y2 - y1) + (x2 - x1) * (x2 - x1)) );

	float x3 = -0.5f;
	float x4 = x3 + width;
	float y3 = -_line_width / 2.0f;
	float y4 = y3 + _line_width;
	_coord[0] = x3; _coord[ 1] = y3;
	_coord[3] = x4; _coord[ 4] = y3;
	_coord[6] = x3; _coord[ 7] = y4;
	_coord[9] = x4; _coord[10] = y4;

	glEnableClientState( GL_VERTEX_ARRAY );
	glVertexPointer( 3, GL_FLOAT, 0, _coord );

	glEnableClientState( GL_COLOR_ARRAY );
	glColorPointer( 4, GL_FLOAT, 0, _color );

	glDisable( GL_TEXTURE_2D );

	glEnable( GL_BLEND );
	glDepthMask( GL_FALSE );

	float r = (atan2( (float)(y2 - y1), (float)(x2 - x1) ) * 180.0f) / M_PI;

	x1 += _origin_x;
	y1 = _height - (y1 + _origin_y);

	glLoadIdentity();
	glTranslatef( (float)x1 + 0.5f, (float)y1 + 0.5f, 0.0f );
	glRotatef( -r, 0.0f, 0.0f, 1.0f );
	glDrawElements( GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, _strip );

	glDisable( GL_BLEND );
	glDepthMask( GL_TRUE );

	glDisableClientState( GL_VERTEX_ARRAY );
	glDisableClientState( GL_COLOR_ARRAY );
}

- (void)drawRect:(int)x :(int)y :(int)width :(int)height
{
	if( _scale != 1.0f )
	{
		x      = (int)((float)x      * _scale);
		y      = (int)((float)y      * _scale);
		width  = (int)((float)width  * _scale);
		height = (int)((float)height * _scale);
	}

	x += _origin_x;
	y = _height - (y + _origin_y) - height - 1;

	glEnableClientState( GL_VERTEX_ARRAY );
	glVertexPointer( 3, GL_FLOAT, 0, _coord );

	glEnableClientState( GL_COLOR_ARRAY );
	glColorPointer( 4, GL_FLOAT, 0, _color );

	glDisable( GL_TEXTURE_2D );

	glEnable( GL_BLEND );
	glDepthMask( GL_FALSE );

	glLoadIdentity();

	float x2 = (float)x - _line_expand;
	float y2 = (float)y - _line_expand;
	float x3 = x2 + _line_width;
	float y3 = y2 + _line_width;
	float x4 = x2 + (float)width;
	float y4 = y2 + (float)height;
	float x5 = x4 + _line_width;
	float y5 = y4 + _line_width;

	_coord[0] = x2; _coord[ 1] = y2;
	_coord[3] = x5; _coord[ 4] = y2;
	_coord[6] = x2; _coord[ 7] = y3;
	_coord[9] = x5; _coord[10] = y3;
	glDrawElements( GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, _strip );

	_coord[0] = x2; _coord[ 1] = y3;
	_coord[3] = x3; _coord[ 4] = y3;
	_coord[6] = x2; _coord[ 7] = y5;
	_coord[9] = x3; _coord[10] = y5;
	glDrawElements( GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, _strip );

	_coord[0] = x4; _coord[ 1] = y3;
	_coord[3] = x5; _coord[ 4] = y3;
	_coord[6] = x4; _coord[ 7] = y5;
	_coord[9] = x5; _coord[10] = y5;
	glDrawElements( GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, _strip );

	_coord[0] = x3; _coord[ 1] = y4;
	_coord[3] = x4; _coord[ 4] = y4;
	_coord[6] = x3; _coord[ 7] = y5;
	_coord[9] = x4; _coord[10] = y5;
	glDrawElements( GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, _strip );

	glDisable( GL_BLEND );
	glDepthMask( GL_TRUE );

	glDisableClientState( GL_VERTEX_ARRAY );
	glDisableClientState( GL_COLOR_ARRAY );
}

- (void)fillRect:(int)x :(int)y :(int)width :(int)height
{
	if( _scale != 1.0f )
	{
		x      = (int)((float)x      * _scale);
		y      = (int)((float)y      * _scale);
		width  = (int)((float)width  * _scale);
		height = (int)((float)height * _scale);
	}

	x += _origin_x;
	y = _height - (y + _origin_y) - height;

	_coord[0] = x        ; _coord[ 1] = y         ;
	_coord[3] = x + width; _coord[ 4] = y         ;
	_coord[6] = x        ; _coord[ 7] = y + height;
	_coord[9] = x + width; _coord[10] = y + height;

	glEnableClientState( GL_VERTEX_ARRAY );
	glVertexPointer( 3, GL_FLOAT, 0, _coord );

	glEnableClientState( GL_COLOR_ARRAY );
	glColorPointer( 4, GL_FLOAT, 0, _color );

	glDisable( GL_TEXTURE_2D );

	glEnable( GL_BLEND );
	glDepthMask( GL_FALSE );

	glLoadIdentity();
	glDrawElements( GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, _strip );

	glDisable( GL_BLEND );
	glDepthMask( GL_TRUE );

	glDisableClientState( GL_VERTEX_ARRAY );
	glDisableClientState( GL_COLOR_ARRAY );
}

- (void)lockTexture:(int)tex_index
{
	_lock_tex_f = YES;
	_lock_tex = tex_index;

	if( _lock_tex >= 0 )
	{
		[_glt use:_lock_tex];
//		[_glt setTransparency:_lock_tex :_a255];

		_tex_width  = (float)[_glt width :_lock_tex];
		_tex_height = (float)[_glt height:_lock_tex];

		glEnable( GL_TEXTURE_2D );
		glBindTexture( GL_TEXTURE_2D, [_glt id:_lock_tex] );
		glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE/*GL_REPLACE*/ );
	}
	else
	{
		glDisable( GL_TEXTURE_2D );
	}

	glEnable( GL_BLEND );
	glDepthMask( GL_FALSE );
}

- (void)unlockTexture
{
	glDisable( GL_BLEND );
	glDepthMask( GL_TRUE );

	if( _lock_tex >= 0 )
	{
		glDisable( GL_TEXTURE_2D );
	}

	_lock_tex_f = NO;
	_lock_tex = -1;
}

- (void)_draw
{
	if( _lock_tex >= 0 )
	{
		for( int i = 0; i < 4; i++ )
		{
			_uv[i * 2    ] = _map[i * 2    ] / _tex_width;
			_uv[i * 2 + 1] = _map[i * 2 + 1] / _tex_height;
		}
	}

	glEnableClientState( GL_VERTEX_ARRAY );
	glVertexPointer( 3, GL_FLOAT, 0, _coord );

	if( _lock_tex >= 0 )
	{
		glEnableClientState( GL_COLOR_ARRAY );
		glColorPointer( 4, GL_FLOAT, 0, _alpha );

		glEnableClientState( GL_TEXTURE_COORD_ARRAY );
		glTexCoordPointer( 2, GL_FLOAT, 0, _uv );
	}
	else
	{
		glEnableClientState( GL_COLOR_ARRAY );
		glColorPointer( 4, GL_FLOAT, 0, _color );
	}

	glDrawElements( GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, _strip );

	glDisableClientState( GL_VERTEX_ARRAY );
	glDisableClientState( GL_COLOR_ARRAY );
	if( _lock_tex >= 0 )
	{
		glDisableClientState( GL_TEXTURE_COORD_ARRAY );
	}
}
- (void)_draw:(int)tex_index
{
	if( tex_index >= 0 )
	{
		[_glt use:tex_index];
//		[_glt setTransparency:tex_index :_a255];

		float width  = (float)[_glt width :tex_index];
		float height = (float)[_glt height:tex_index];
		for( int i = 0; i < 4; i++ )
		{
			_uv[i * 2    ] = _map[i * 2    ] / width;
			_uv[i * 2 + 1] = _map[i * 2 + 1] / height;
		}
	}

	glEnableClientState( GL_VERTEX_ARRAY );
	glVertexPointer( 3, GL_FLOAT, 0, _coord );

	if( tex_index >= 0 )
	{
		glEnableClientState( GL_COLOR_ARRAY );
		glColorPointer( 4, GL_FLOAT, 0, _alpha );

		glEnable( GL_TEXTURE_2D );
		glBindTexture( GL_TEXTURE_2D, [_glt id:tex_index] );
		glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE/*GL_REPLACE*/ );

		glEnableClientState( GL_TEXTURE_COORD_ARRAY );
		glTexCoordPointer( 2, GL_FLOAT, 0, _uv );
	}
	else
	{
		glEnableClientState( GL_COLOR_ARRAY );
		glColorPointer( 4, GL_FLOAT, 0, _color );

		glDisable( GL_TEXTURE_2D );
	}

	glEnable( GL_BLEND );
	glDepthMask( GL_FALSE );

	glDrawElements( GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, _strip );

	glDisable( GL_BLEND );
	glDepthMask( GL_TRUE );

	glDisableClientState( GL_VERTEX_ARRAY );
	glDisableClientState( GL_COLOR_ARRAY );
	if( tex_index >= 0 )
	{
		glDisable( GL_TEXTURE_2D );
		glDisableClientState( GL_TEXTURE_COORD_ARRAY );
	}
}

- (void)drawScaledTexture:(int)tex_index :(int)dx :(int)dy :(int)width :(int)height :(int)sx :(int)sy :(int)swidth :(int)sheight
{
	if( _lock_tex_f )
	{
		tex_index = _lock_tex;
	}

	if( _scale != 1.0f )
	{
		dx     = (int)((float)dx     * _scale);
		dy     = (int)((float)dy     * _scale);
		width  = (int)((float)width  * _scale);
		height = (int)((float)height * _scale);
	}

	dx += _origin_x;
	dy = _height - (dy + _origin_y) - height;

	float sx2 = (float)sx + 0.5f;
	float sy2 = (float)sy + 0.5f;
	float sx3 = sx2 + (float)swidth  - 1.0f;
	float sy3 = sy2 + (float)sheight - 1.0f;

	_coord[0] = 0.0f ; _coord[ 1] = 0.0f  ;
	_coord[3] = width; _coord[ 4] = 0.0f  ;
	_coord[6] = 0.0f ; _coord[ 7] = height;
	_coord[9] = width; _coord[10] = height;

	if( tex_index >= 0 )
	{
		switch( _flipmode )
		{
		case FLIP_NONE:
			_map[0] = sx2; _map[1] = sy3;
			_map[2] = sx3; _map[3] = sy3;
			_map[4] = sx2; _map[5] = sy2;
			_map[6] = sx3; _map[7] = sy2;
			break;
		case FLIP_HORIZONTAL:
			_map[0] = sx3; _map[1] = sy3;
			_map[2] = sx2; _map[3] = sy3;
			_map[4] = sx3; _map[5] = sy2;
			_map[6] = sx2; _map[7] = sy2;
			break;
		case FLIP_VERTICAL:
			_map[0] = sx2; _map[1] = sy2;
			_map[2] = sx3; _map[3] = sy2;
			_map[4] = sx2; _map[5] = sy3;
			_map[6] = sx3; _map[7] = sy3;
			break;
		case FLIP_ROTATE:
			_map[0] = sx3; _map[1] = sy2;
			_map[2] = sx2; _map[3] = sy2;
			_map[4] = sx3; _map[5] = sy3;
			_map[6] = sx2; _map[7] = sy3;
			break;
		}
	}

	glLoadIdentity();
	glTranslatef( dx, dy, 0.0f );
	if( _lock_tex_f )
	{
		[self _draw];
	}
	else
	{
		[self _draw:tex_index];
	}
}

- (void)drawTexture:(int)tex_index :(int)x :(int)y
{
	if( _lock_tex_f )
	{
		int width  = (int)_tex_width;
		int height = (int)_tex_height;
		[self drawScaledTexture:_lock_tex :x :y :width :height :0 :0 :width :height];
	}
	else
	{
		int width  = [_glt width :tex_index];
		int height = [_glt height:tex_index];
		[self drawScaledTexture:tex_index :x :y :width :height :0 :0 :width :height];
	}
}

- (void)drawTexture:(int)tex_index :(int)dx :(int)dy :(int)sx :(int)sy :(int)width :(int)height
{
	[self drawScaledTexture:tex_index :dx :dy :width :height :sx :sy :width :height];
}

- (void)drawTransTexture:(int)tex_index :(float)dx :(float)dy :(int)sx :(int)sy :(int)width :(int)height :(float)cx :(float)cy :(float)r360 :(float)z128x :(float)z128y
{
	if( _lock_tex_f )
	{
		tex_index = _lock_tex;
	}

	if( _scale != 1.0f )
	{
		dx    *= _scale;
		dy    *= _scale;
		z128x *= _scale;
		z128y *= _scale;
	}

	dx += (float)_origin_x;
	dy = (float)_height - (dy + (float)_origin_y);

	float sx2 = (float)sx + 0.5f;
	float sy2 = (float)sy + 0.5f;
	float sx3 = sx2 + (float)width  - 1.0f;
	float sy3 = sy2 + (float)height - 1.0f;

	_coord[0] = -cx               ; _coord[ 1] = cy - (float)height;
	_coord[3] = -cx + (float)width; _coord[ 4] = cy - (float)height;
	_coord[6] = -cx               ; _coord[ 7] = cy                ;
	_coord[9] = -cx + (float)width; _coord[10] = cy                ;

	if( tex_index >= 0 )
	{
		switch( _flipmode )
		{
		case FLIP_NONE:
			_map[0] = sx2; _map[1] = sy3;
			_map[2] = sx3; _map[3] = sy3;
			_map[4] = sx2; _map[5] = sy2;
			_map[6] = sx3; _map[7] = sy2;
			break;
		case FLIP_HORIZONTAL:
			_map[0] = sx3; _map[1] = sy3;
			_map[2] = sx2; _map[3] = sy3;
			_map[4] = sx3; _map[5] = sy2;
			_map[6] = sx2; _map[7] = sy2;
			break;
		case FLIP_VERTICAL:
			_map[0] = sx2; _map[1] = sy2;
			_map[2] = sx3; _map[3] = sy2;
			_map[4] = sx2; _map[5] = sy3;
			_map[6] = sx3; _map[7] = sy3;
			break;
		case FLIP_ROTATE:
			_map[0] = sx3; _map[1] = sy2;
			_map[2] = sx2; _map[3] = sy2;
			_map[4] = sx3; _map[5] = sy3;
			_map[6] = sx2; _map[7] = sy3;
			break;
		}
	}

	glLoadIdentity();
	glTranslatef( dx, dy, 0.0f );
	glRotatef( -r360, 0.0f, 0.0f, 1.0f );
	glScalef( z128x / 128.0f, z128y / 128.0f, 1.0f );
	if( _lock_tex_f )
	{
		[self _draw];
	}
	else
	{
		[self _draw:tex_index];
	}
}

@end
