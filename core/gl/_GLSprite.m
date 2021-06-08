/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <OpenGLES/ES1/gl.h>

#import "_GLSprite.h"

#import "_GLTexture.h"

@implementation _GLSprite

- (id)initWithDepth:(BOOL)depth
{
	self = [super init];
	if( self != nil )
	{
		[self _setType:_GLPRIMITIVE_TYPE_SPRITE];
		[self _setDepth:depth];

		_coord[0] = -1.0f; _coord[ 1] = -1.0f; _coord[ 2] = 0.0f;
		_coord[3] =  1.0f; _coord[ 4] = -1.0f; _coord[ 5] = 0.0f;
		_coord[6] = -1.0f; _coord[ 7] =  1.0f; _coord[ 8] = 0.0f;
		_coord[9] =  1.0f; _coord[10] =  1.0f; _coord[11] = 0.0f;

		_uv_f = YES;
		_uv[0] = 0.0f; _uv[1] = 1.0f;
		_uv[2] = 1.0f; _uv[3] = 1.0f;
		_uv[4] = 0.0f; _uv[5] = 0.0f;
		_uv[6] = 1.0f; _uv[7] = 0.0f;

		_strip[0] = 0;
		_strip[1] = 1;
		_strip[2] = 2;
		_strip[3] = 3;
	}
	return self;
}

- (void)setCoord:(float*)coord
{
	for( int i = 0; i < 12; i++ )
	{
		_coord[i] = coord[i];
	}
}

- (void)setMap:(float*)map :(BOOL)uv
{
	_uv_f = uv;
	if( _uv_f )
	{
		for( int i = 0; i < 8; i++ )
		{
			_uv[i] = map[i];
		}
	}
	else
	{
		for( int i = 0; i < 8; i++ )
		{
			_map[i] = map[i];
		}
	}
}

- (void)setStrip:(unsigned short*)strip
{
	for( int i = 0; i < 4; i++ )
	{
		_strip[i] = strip[i];
	}
}

- (BOOL)textureAlpha:(_GLTexture*)glt :(int)tex_index
{
	[glt use:tex_index];
	[glt setTransparency:tex_index :[self transparency]];
	return ([glt alpha:tex_index] && ![self depth]);
}

- (void)draw:(_GLTexture*)glt :(int)tex_index :(float*)mat :(BOOL)alpha
{
	BOOL alpha2 = [self textureAlpha:glt :tex_index];
	if( [self transparency] != (unsigned char)255 )
	{
		alpha2 = YES;
	}
	if( alpha2 != alpha )
	{
		return;
	}

	glEnableClientState( GL_VERTEX_ARRAY );
	glVertexPointer( 3, GL_FLOAT, 0, _coord );

	if( !_uv_f )
	{
		int width  = [glt width :tex_index];
		int height = [glt height:tex_index];
		for( int i = 0; i < 4; i++ )
		{
			_uv[i * 2    ] = _map[i * 2    ] / (float)width;
			_uv[i * 2 + 1] = _map[i * 2 + 1] / (float)height;
		}
	}

	glEnableClientState( GL_TEXTURE_COORD_ARRAY );
	glEnable( GL_TEXTURE_2D );
	glBindTexture( GL_TEXTURE_2D, [glt id:tex_index] );
	glTexCoordPointer( 2, GL_FLOAT, 0, _uv );
	glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE );

	if( [glt alpha:tex_index] )
	{
		glEnable( GL_ALPHA_TEST );
	}
	if( alpha2 )
	{
		glEnable( GL_BLEND );
		glDepthMask( GL_FALSE );
	}

	glPushMatrix();
	glMultMatrixf( mat );
	glDrawElements( GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, _strip );
	glPopMatrix();

	if( [glt alpha:tex_index] )
	{
		glDisable( GL_ALPHA_TEST );
	}
	if( alpha2 )
	{
		glDisable( GL_BLEND );
		glDepthMask( GL_TRUE );
	}
}

@end
