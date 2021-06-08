/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <OpenGLES/ES1/gl.h>

#import "_GLPrimitive.h"

@class _GLTexture;

@interface _GLModel : _GLPrimitive
{
@public
	// マテリアル
	int _material_num;
	int* _material_texture;
	float* _material_diffuse;	// R、G、B、Aを各 0〜1
	float* _material_ambient;	// R、G、B、Aを各 0〜1
	float* _material_emission;	// R、G、B、Aを各 0〜1
	float* _material_specular;	// R、G、B、Aを各 0〜1
	float* _material_shininess;	// 0〜128

	// オブジェクト
	int _object_num;
	float** _coord;		// X、Y、Z
	float** _normal;	// X、Y、Z
	float** _color;		// R、G、B、Aを各 0〜1
	float** _map;		// U、V

	// 三角形ストリップ
	int _strip_num;
	int* _strip_material;
	int* _strip_coord;
	int* _strip_normal;
	int* _strip_color;
	int* _strip_map;
	int* _strip_len;
	unsigned short** _strip;

@private
	GLint _texture_env_mode;
}

- (id)initWithDepth:(BOOL)depth;
- (void)setMaterial:(int)num :(int*)texture :(float*)diffuse :(float*)ambient :(float*)emission :(float*)specular :(float*)shininess;
- (void)setObject:(int)num :(float**)coord :(float**)normal :(float**)color :(float**)map;
- (void)setStrip:(int)num :(int*)material :(int*)coord :(int*)normal :(int*)color :(int*)map :(int*)len :(unsigned short**)strip;
- (void)setTextureEnvMode:(GLint)mode;
- (int)stripNum;
- (int)textureIndex:(int)index;
- (BOOL)textureAlpha:(_GLTexture*)glt :(int)index :(int)tex_index;
- (void)draw:(_GLTexture*)glt :(int)index :(int)tex_index :(float*)mat :(BOOL)alpha;

- (BOOL)_setTexture:(_GLTexture*)glt :(int)index :(int)tex_index;
- (BOOL)_beginDraw:(_GLTexture*)glt :(int)index :(int)tex_index :(float*)mat;
- (void)_endDraw:(_GLTexture*)glt :(int)index :(int)tex_index;

@end
