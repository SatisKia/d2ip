/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_GLModel.h"

#import "_GLTexture.h"

@implementation _GLModel

- (id)initWithDepth:(BOOL)depth
{
	self = [super init];
	if( self != nil )
	{
		[self _setType:_GLPRIMITIVE_TYPE_MODEL];
		[self _setDepth:depth];

		// マテリアル
		_material_num = 0;
		_material_texture = NULL;
		_material_diffuse = NULL;
		_material_ambient = NULL;
		_material_emission = NULL;
		_material_specular = NULL;
		_material_shininess = NULL;

		// オブジェクト
		_object_num = 0;
		_coord = NULL;
		_normal = NULL;
		_color = NULL;
		_map = NULL;

		// 三角形ストリップ
		_strip_num = 0;
		_strip_material = NULL;
		_strip_coord = NULL;
		_strip_normal = NULL;
		_strip_color = NULL;
		_strip_map = NULL;
		_strip_len = NULL;
		_strip = NULL;

		_texture_env_mode = GL_MODULATE;
	}
	return self;
}

- (void)dealloc
{
	int i, j;

	if( _material_texture != NULL )
	{
		free( _material_texture );
	}
	if( _material_diffuse != NULL )
	{
		free( _material_diffuse );
	}
	if( _material_ambient != NULL )
	{
		free( _material_ambient );
	}
	if( _material_emission != NULL )
	{
		free( _material_emission );
	}
	if( _material_specular != NULL )
	{
		free( _material_specular );
	}
	if( _material_shininess != NULL )
	{
		free( _material_shininess );
	}

	if( _coord != NULL )
	{
		for( i = 0; i < _object_num; i++ )
		{
			free( _coord[i] );
		}
		free( _coord );
	}
	if( _normal != NULL )
	{
		for( i = 0; i < _object_num; i++ )
		{
			free( _normal[i] );
		}
		free( _normal );
	}
	if( _color != NULL )
	{
		for( i = 0; i < _object_num; i++ )
		{
			free( _color[i] );
		}
		free( _color );
	}
	if( _map != NULL )
	{
		for( i = 0; i < _object_num; i++ )
		{
			free( _map[i] );
		}
		free( _map );
	}

	if( _strip_material != NULL )
	{
		free( _strip_material );
	}
	if( _strip_coord != NULL )
	{
		free( _strip_coord );
	}
	if( _strip_normal != NULL )
	{
		free( _strip_normal );
	}
	if( _strip_color != NULL )
	{
		free( _strip_color );
	}
	if( _strip_map != NULL )
	{
		free( _strip_map );
	}
	if( _strip_len != NULL )
	{
		free( _strip_len );
	}
	if( _strip != NULL )
	{
		for( j = 0; j < _strip_num; j++ )
		{
			free( _strip[j] );
		}
		free( _strip );
	}

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (void)setMaterial:(int)num :(int*)texture :(float*)diffuse :(float*)ambient :(float*)emission :(float*)specular :(float*)shininess
{
	_material_num = num;
	_material_texture = texture;
	_material_diffuse = diffuse;
	_material_ambient = ambient;
	_material_emission = emission;
	_material_specular = specular;
	_material_shininess = shininess;
}

- (void)setObject:(int)num :(float**)coord :(float**)normal :(float**)color :(float**)map
{
	_object_num = num;
	_coord = coord;
	_normal = normal;
	_color = color;
	_map = map;
}

- (void)setStrip:(int)num :(int*)material :(int*)coord :(int*)normal :(int*)color :(int*)map :(int*)len :(unsigned short**)strip
{
	_strip_num = num;
	_strip_material = material;
	_strip_coord = coord;
	_strip_normal = normal;
	_strip_color = color;
	_strip_map = map;
	_strip_len = len;
	_strip = strip;
}

- (void)setTextureEnvMode:(GLint)mode
{
	_texture_env_mode = mode;
}

- (int)stripNum
{
	return _strip_num;
}

- (int)textureIndex:(int)index
{
	if( _strip_material[index] < 0 )
	{
		return -1;
	}
	return _material_texture[_strip_material[index]];
}

- (BOOL)textureAlpha:(_GLTexture*)glt :(int)index :(int)tex_index
{
	BOOL alpha = NO;
	BOOL depth = [self depth];
	if( tex_index < 0 )
	{
		tex_index = [self textureIndex:index];
	}
	if( tex_index >= 0 )
	{
		[glt use:tex_index];
		[glt setTransparency:tex_index :[self transparency]];
		alpha = [glt alpha:tex_index];
		if( depth )
		{
			// モデル全体でデプスバッファ描き込みモードになっている場合のみ、
			// テクスチャ個別のモードを見る。
			depth = [glt depth:tex_index];
		}
	}
	return (alpha && !depth);
}

- (void)draw:(_GLTexture*)glt :(int)index :(int)tex_index :(float*)mat :(BOOL)alpha
{
	BOOL alpha2 = [self textureAlpha:glt :index :tex_index];
	if( [self transparency] != (unsigned char)255 )
	{
		alpha2 = YES;
	}
	if( alpha2 != alpha )
	{
		return;
	}

	if( _strip_coord[index] >= 0 )
	{
		glEnableClientState( GL_VERTEX_ARRAY );
		glVertexPointer( 3, GL_FLOAT, 0, _coord[_strip_coord[index]] );
	}
	else
	{
		glDisableClientState( GL_VERTEX_ARRAY );
	}

	if( (_normal != NULL) && (_strip_normal[index] >= 0) )
	{
		glEnableClientState( GL_NORMAL_ARRAY );
		glNormalPointer( GL_FLOAT, 0, _normal[_strip_normal[index]] );
	}
	else
	{
		glDisableClientState( GL_NORMAL_ARRAY );
	}

	if( (_color != NULL) && (_strip_color[index] >= 0) )
	{
		glEnableClientState( GL_COLOR_ARRAY );
		glColorPointer( 4, GL_FLOAT, 0, _color[_strip_color[index]] );
	}
	else
	{
		glDisableClientState( GL_COLOR_ARRAY );
	}

	if( tex_index < 0 )
	{
		tex_index = [self textureIndex:index];
	}
	if( ![self _setTexture:glt :index :tex_index] )
	{
		if( (_map != NULL) && (_strip_map[index] >= 0) && (tex_index >= 0) )
		{
			glEnableClientState( GL_TEXTURE_COORD_ARRAY );
			glEnable( GL_TEXTURE_2D );
			glBindTexture( GL_TEXTURE_2D, [glt id:tex_index] );
			glTexCoordPointer( 2, GL_FLOAT, 0, _map[_strip_map[index]] );
			glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, _texture_env_mode );
		}
		else
		{
			glDisableClientState( GL_TEXTURE_COORD_ARRAY );
			glDisable( GL_TEXTURE_2D );
		}
	}

	if( (_material_diffuse != NULL) && (_strip_material[index] >= 0) )
	{
		glMaterialfv( GL_FRONT_AND_BACK, GL_DIFFUSE, &_material_diffuse[_strip_material[index] * 4] );
	}
	if( (_material_ambient != NULL) && (_strip_material[index] >= 0) )
	{
		glMaterialfv( GL_FRONT_AND_BACK, GL_AMBIENT, &_material_ambient[_strip_material[index] * 4] );
	}
	if( (_material_emission != NULL) && (_strip_material[index] >= 0) )
	{
		glMaterialfv( GL_FRONT_AND_BACK, GL_EMISSION, &_material_emission[_strip_material[index] * 4] );
	}
	if( (_material_specular != NULL) && (_strip_material[index] >= 0) )
	{
		glMaterialfv( GL_FRONT_AND_BACK, GL_SPECULAR, &_material_specular[_strip_material[index] * 4] );
	}
	if( (_material_shininess != NULL) && (_strip_material[index] >= 0) )
	{
		glMaterialf( GL_FRONT_AND_BACK, GL_SHININESS, _material_shininess[_strip_material[index]] );
	}

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

	if( [self _beginDraw:glt :index :tex_index :mat] )
	{
		glDrawElements( GL_TRIANGLE_STRIP, _strip_len[index], GL_UNSIGNED_SHORT, _strip[index] );

		[self _endDraw:glt :index :tex_index];
	}

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

- (BOOL)_setTexture:(_GLTexture*)glt :(int)index :(int)tex_index { return NO; }
- (BOOL)_beginDraw:(_GLTexture*)glt :(int)index :(int)tex_index :(float*)mat
{
	glMultMatrixf( mat );
	return YES;
}
- (void)_endDraw:(_GLTexture*)glt :(int)index :(int)tex_index {}

@end
