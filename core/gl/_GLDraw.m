/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_GLDraw.h"

#import "_GLModel.h"
#import "_GLPrimitive.h"
#import "_GLSprite.h"
#import "_GLTexture.h"
#import "_GLUtility.h"

@interface _GLDrawPrimitive : NSObject
{
@private
	_GLPrimitive* _p;
	int _index;
	int _tex_index;
	float _mat[16];

	unsigned char _trans;
}

- (id)initWithPrimitive:(_GLPrimitive*)p :(int)index :(int)tex_index :(float*)mat :(int)trans;
- (int)textureIndex;
- (void)draw:(_GLTexture*)glt :(BOOL)alpha;

@end

@implementation _GLDrawPrimitive

- (id)initWithPrimitive:(_GLPrimitive*)p :(int)index :(int)tex_index :(float*)mat :(int)trans
{
	self = [super init];
	if( self != nil )
	{
		_p = p;
		_index = index;
		_tex_index = tex_index;
		for( int i = 0; i < 16; i++ )
		{
			_mat[i] = mat[i];
		}
		_trans = (trans >= 0) ? (unsigned char)trans : [p transparency];
	}
	return self;
}

- (int)textureIndex
{
	switch( [_p type] )
	{
	case _GLPRIMITIVE_TYPE_MODEL:
		if( _tex_index < 0 )
		{
			return [(_GLModel*)_p textureIndex:_index];
		}
		break;
	case _GLPRIMITIVE_TYPE_SPRITE:
		break;
	}
	return _tex_index;
}

- (void)draw:(_GLTexture*)glt :(BOOL)alpha
{
	switch( [_p type] )
	{
	case _GLPRIMITIVE_TYPE_MODEL:
		[(_GLModel*)_p setTransparency:_trans];
		[(_GLModel*)_p draw:glt :_index :_tex_index :_mat :alpha];
		break;
	case _GLPRIMITIVE_TYPE_SPRITE:
		[(_GLSprite*)_p setTransparency:_trans];
		[(_GLSprite*)_p draw:glt :_tex_index :_mat :alpha];
		break;
	}
}

@end

@implementation _GLDraw

- (id)init
{
	self = [super init];
	if( self != nil )
	{
#ifdef NO_OBJC_ARC
		_draw = [[NSMutableArray array] retain];
#else
		_draw = [NSMutableArray array];
#endif // NO_OBJC_ARC
	}
	return self;
}

#ifdef NO_OBJC_ARC
- (void)dealloc
{
	[_draw release];

	[super dealloc];
}
#endif // NO_OBJC_ARC

- (void)clear
{
	[_draw removeAllObjects];
}

- (void)add:(_GLPrimitive*)p :(int)index :(int)tex_index :(float*)mat :(int)trans
{
	_GLDrawPrimitive* tmp = [[_GLDrawPrimitive alloc] initWithPrimitive:p :index :tex_index :mat :trans];
	[_draw addObject:tmp];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
}

- (void)addSprite:(_GLUtility*)glu :(_GLPrimitive*)p :(int)tex_index :(float)x :(float)y :(float)z :(int)trans
{
	_GLDrawPrimitive* tmp = [[_GLDrawPrimitive alloc] initWithPrimitive:p :-1 :tex_index :[glu spriteMatrix:x :y :z] :trans];
	[_draw addObject:tmp];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
}

- (void)draw:(_GLTexture*)glt
{
	int i;
	_GLDrawPrimitive* tmp;

	int count = [_draw count];

	// まず、アルファ情報のない物体を描画する
	for( i = 0; i < count; i++ )
	{
		tmp = (_GLDrawPrimitive*)[_draw objectAtIndex:i];
		[tmp draw:glt :NO];
	}

	// 次に、アルファ情報のある物体を描画する
	for( i = 0; i < count; i++ )
	{
		tmp = (_GLDrawPrimitive*)[_draw objectAtIndex:i];
		[tmp draw:glt :YES];
	}
}

@end
