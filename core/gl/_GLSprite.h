/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_GLPrimitive.h"

@class _GLTexture;

@interface _GLSprite : _GLPrimitive
{
@private
	float _coord[12];
	float _map[8];
	float _uv[8];
	BOOL _uv_f;
	unsigned short _strip[4];
}

- (id)initWithDepth:(BOOL)depth;
- (void)setCoord:(float*)coord;
- (void)setMap:(float*)map :(BOOL)uv;
- (void)setStrip:(unsigned short*)strip;
- (BOOL)textureAlpha:(_GLTexture*)glt :(int)tex_index;
- (void)draw:(_GLTexture*)glt :(int)tex_index :(float*)mat :(BOOL)alpha;

@end
