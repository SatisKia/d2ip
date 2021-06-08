/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Graphics.h"

#import "_Canvas.h"
#import "_Image.h"

@implementation _Graphics

- (id)init
{
	self = [super init];
	if( self != nil )
	{
		_canvas = nil;
		_image = nil;
		_context = NULL;

		_scale = 1.0f;

		_stroke_width = 1.0f;

		_r = 0.0f;
		_g = 0.0f;
		_b = 0.0f;

		_a = 1.0f;

		_font_name = nil;
		_font = nil;

		_rop = ROP_COPY;

		_flipmode = FLIP_NONE;

		_origin_x = 0;
		_origin_y = 0;

		_bitmap_pixels = NULL;
	}
	return self;
}

- (void)dealloc
{
#ifdef NO_OBJC_ARC
	if( _font_name != nil )
	{
		[_font_name release];
	}
	if( _font != nil )
	{
		[_font release];
	}
#endif // NO_OBJC_ARC

	if( _bitmap_pixels != NULL )
	{
		free( _bitmap_pixels );
	}

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (void)_setCanvas:(_Canvas*)canvas
{
	_canvas = canvas;

	NSString* tmp = @"";
#ifdef NO_OBJC_ARC
	_font_name = [[NSString stringWithString:tmp] retain];
#else
	_font_name = [NSString stringWithString:tmp];
#endif // NO_OBJC_ARC
	_font_size = 16;
#ifdef NO_OBJC_ARC
	_font = [[UIFont systemFontOfSize:_font_size] retain];
#else
	_font = [UIFont systemFontOfSize:_font_size];
#endif // NO_OBJC_ARC
}

- (void)_setImage:(_Image*)image
{
	_image = image;
	_context = [_image _getBitmap];
}

- (void)_setScale:(float)scale
{
	_scale = scale;
}

- (int)getWidth
{
	if( _canvas != nil )
	{
		return [_canvas getWidth];
	}
	if( _image != nil )
	{
		return [_image getWidth];
	}
	return 0;
}
- (int)getHeight
{
	if( _canvas != nil )
	{
		return [_canvas getHeight];
	}
	if( _image != nil )
	{
		return [_image getHeight];
	}
	return 0;
}

+ (int)getColorOfRGB:(int)r :(int)g :(int)b
{
	return (r << 16) + (g << 8) + b;
}

- (void)_setStrokeWidth
{
	if( _context != NULL )
	{
		CGContextSetLineWidth( _context, _stroke_width );
	}
}
- (void)setStrokeWidth:(float)width
{
	_stroke_width = width;
	[self _setStrokeWidth];
}

- (void)_setColor
{
	if( _context != NULL )
	{
		// Core Graphics 用
		CGContextSetRGBFillColor  ( _context, _r, _g, _b, _a );
		CGContextSetRGBStrokeColor( _context, _r, _g, _b, _a );
	}

	if( _canvas != nil )
	{
		// UIKit 用
		[[UIColor colorWithRed:_r green:_g blue:_b alpha:_a] set];
	}
}
- (void)setColor:(int)color
{
	_r = (float)((color >> 16) & 0xff) / 255.0f;
	_g = (float)((color >>  8) & 0xff) / 255.0f;
	_b = (float)( color        & 0xff) / 255.0f;
	[self _setColor];
}
- (void)setAlpha:(int)a
{
	_a = (float)a / 255.0f;
	[self _setColor];
}

- (void)_setROP
{
	if( _context != NULL )
	{
		switch( _rop )
		{
		case ROP_COPY:
			CGContextSetBlendMode( _context, kCGBlendModeNormal );
			break;
		case ROP_ADD:
			CGContextSetBlendMode( _context, kCGBlendModeScreen );
			break;
		}
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
}

- (void)setOrigin:(int)x :(int)y
{
	_origin_x = x;
	_origin_y = y;
}

- (void)_setFontName:(NSString*)name
{
//	if( _canvas == nil )
//	{
//		return;
//	}
#ifdef NO_OBJC_ARC
	[_font_name release];
#endif // NO_OBJC_ARC
	if( name == nil )
	{
		NSString* tmp = @"";
#ifdef NO_OBJC_ARC
		_font_name = [[NSString stringWithString:tmp] retain];
#else
		_font_name = [NSString stringWithString:tmp];
#endif // NO_OBJC_ARC
	}
	else
	{
#ifdef NO_OBJC_ARC
		_font_name = [[NSString stringWithString:name] retain];
#else
		_font_name = [NSString stringWithString:name];
#endif // NO_OBJC_ARC
	}
}
- (void)_setFontSize:(int)size
{
	_font_size = size;
}
- (void)_setFont
{
//	if( _canvas == nil )
//	{
//		return;
//	}
#ifdef NO_OBJC_ARC
	[_font release];
#endif // NO_OBJC_ARC
	if( _font_name.length == 0 )
	{
#ifdef NO_OBJC_ARC
		_font = [[UIFont systemFontOfSize:_font_size] retain];
#else
		_font = [UIFont systemFontOfSize:_font_size];
#endif // NO_OBJC_ARC
	}
	else
	{
#ifdef NO_OBJC_ARC
		_font = [[UIFont fontWithName:_font_name size:_font_size] retain];
#else
		_font = [UIFont fontWithName:_font_name size:_font_size];
#endif // NO_OBJC_ARC
	}
}
- (void)setFont:(NSString*)name :(int)size
{
	[self _setFontName:name];
	[self _setFontSize:size];
	[self _setFont];
}
- (void)setFontName:(NSString*)name
{
	[self _setFontName:name];
	[self _setFont];
}
- (void)setFontSize:(int)size
{
	[self _setFontSize:size];
	[self _setFont];
}

- (int)stringWidth:(NSString*)str
{
	return [str sizeWithFont:_font].width;
}

- (int)fontHeight
{
	return _font.lineHeight;
}

- (void)lock
{
	if( _canvas != nil )
	{
		[_canvas _lock];
	}

	if( _image == nil )
	{
		_context = UIGraphicsGetCurrentContext();
	}

	[self _setStrokeWidth];
	[self _setColor];
	[self _setROP];
}

- (void)unlock
{
	if( _image == nil )
	{
		_context = NULL;
	}

	if( _canvas != nil )
	{
		[_canvas _unlock];
	}
}

- (void)drawLine:(int)x1 :(int)y1 :(int)x2 :(int)y2
{
	CGContextMoveToPoint( _context,
		(float)x1 + (float)_origin_x + 0.5f,
		(float)y1 + (float)_origin_y + 0.5f
		);
	CGContextAddLineToPoint( _context,
		(float)x2 + (float)_origin_x + 0.5f,
		(float)y2 + (float)_origin_y + 0.5f
		);
	CGContextStrokePath( _context );
}

- (void)drawRect:(int)x :(int)y :(int)width :(int)height
{
	float x2 = (float)x + (float)_origin_x + 0.5f;
	float y2 = (float)y + (float)_origin_y + 0.5f;
	float x3 = x2 + (float)width;
	float y3 = y2 + (float)height;
	CGContextMoveToPoint   ( _context, x2, y2 );
	CGContextAddLineToPoint( _context, x3, y2 );
	CGContextAddLineToPoint( _context, x3, y3 );
	CGContextAddLineToPoint( _context, x2, y3 );
	CGContextAddLineToPoint( _context, x2, y2 );
	CGContextAddLineToPoint( _context, x3, y2 );
	CGContextStrokePath( _context );
}

- (void)fillRect:(int)x :(int)y :(int)width :(int)height
{
	_rect.origin.x    = x + _origin_x;
	_rect.origin.y    = y + _origin_y;
	_rect.size.width  = width;
	_rect.size.height = height;
	CGContextFillRect( _context, _rect );
}

- (void)drawRoundRect:(int)x :(int)y :(int)width :(int)height :(int)r
{
	_rect.origin.x    = (float)x + (float)_origin_x + 0.5f;
	_rect.origin.y    = (float)y + (float)_origin_y + 0.5f;
	_rect.size.width  = width;
	_rect.size.height = height;
	float min_x = CGRectGetMinX( _rect );
	float mid_x = CGRectGetMidX( _rect );
	float max_x = CGRectGetMaxX( _rect );
	float min_y = CGRectGetMinY( _rect );
	float mid_y = CGRectGetMidY( _rect );
	float max_y = CGRectGetMaxY( _rect );
	CGContextMoveToPoint( _context, min_x, mid_y );
	CGContextAddArcToPoint( _context, min_x, min_y, mid_x, min_y, r );
	CGContextAddArcToPoint( _context, max_x, min_y, max_x, mid_y, r );
	CGContextAddArcToPoint( _context, max_x, max_y, mid_x, max_y, r );
	CGContextAddArcToPoint( _context, min_x, max_y, min_x, mid_y, r );
	CGContextClosePath( _context );
	CGContextStrokePath( _context );
}

- (void)fillRoundRect:(int)x :(int)y :(int)width :(int)height :(int)r
{
	_rect.origin.x    = x + _origin_x;
	_rect.origin.y    = y + _origin_y;
	_rect.size.width  = width;
	_rect.size.height = height;
	float min_x = CGRectGetMinX( _rect );
	float mid_x = CGRectGetMidX( _rect );
	float max_x = CGRectGetMaxX( _rect );
	float min_y = CGRectGetMinY( _rect );
	float mid_y = CGRectGetMidY( _rect );
	float max_y = CGRectGetMaxY( _rect );
	CGContextMoveToPoint( _context, min_x, mid_y );
	CGContextAddArcToPoint( _context, min_x, min_y, mid_x, min_y, r );
	CGContextAddArcToPoint( _context, max_x, min_y, max_x, mid_y, r );
	CGContextAddArcToPoint( _context, max_x, max_y, mid_x, max_y, r );
	CGContextAddArcToPoint( _context, min_x, max_y, min_x, mid_y, r );
	CGContextClosePath( _context );
	CGContextFillPath( _context );
}

- (void)drawOval:(int)x :(int)y :(int)width :(int)height
{
	_rect.origin.x    = (float)x + (float)_origin_x + 0.5f;
	_rect.origin.y    = (float)y + (float)_origin_y + 0.5f;
	_rect.size.width  = width;
	_rect.size.height = height;
	CGContextAddEllipseInRect( _context, _rect );
	CGContextStrokePath( _context );
}

- (void)fillOval:(int)x :(int)y :(int)width :(int)height
{
	_rect.origin.x    = x + _origin_x;
	_rect.origin.y    = y + _origin_y;
	_rect.size.width  = width;
	_rect.size.height = height;
	CGContextFillEllipseInRect( _context, _rect );
}

- (void)drawCircle:(int)x :(int)y :(int)r
{
	[self drawOval:(x - r) :(y - r) :(r * 2) :(r * 2)];
}

- (void)fillCircle:(int)x :(int)y :(int)r
{
	[self fillOval:(x - r) :(y - r) :(r * 2) :(r * 2)];
}

- (void)drawString:(NSString*)str :(int)x :(int)y
{
	if( _canvas == nil )
	{
		if( _context == NULL )
		{
			return;
		}
		UIGraphicsPushContext( _context );
		[[UIColor colorWithRed:_r green:_g blue:_b alpha:_a] set];
	}

	x += _origin_x;
	y += _origin_y;
	_point.x = x;
	_point.y = y - _font.lineHeight;
	[str drawAtPoint:_point withFont:_font];

	if( _canvas == nil )
	{
		UIGraphicsPopContext();
	}
}

- (int)getFlipMode:(BOOL)flip
{
	if( flip )
	{
		switch( _flipmode )
		{
		case FLIP_NONE      : return FLIP_VERTICAL  ;
		case FLIP_HORIZONTAL: return FLIP_ROTATE    ;
		case FLIP_VERTICAL  : return FLIP_NONE      ;
		case FLIP_ROTATE    : return FLIP_HORIZONTAL;
		}
	}
	return _flipmode;
}

- (void)_allocBitmapPixels:(int)len
{
	if( _bitmap_pixels != NULL )
	{
		if( _bitmap_len >= len )
		{
			return;
		}
		free( _bitmap_pixels );
	}
	_bitmap_len = len;
	_bitmap_pixels = malloc( _bitmap_len );
}
- (BOOL)createAlphaImage:(int)width :(int)height
{
	_bitmap_image = NULL;
	if( _bitmap_pixels != NULL )
	{
		int len = width * height * 4;
		for( int i = 3; i < len; i += 4 )
		{
			_bitmap_pixels[i] = (unsigned char)((float)_bitmap_pixels[i] * _a);
		}
		CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
		CGDataProviderRef provider = CGDataProviderCreateWithData( NULL, _bitmap_pixels, len, NULL );
		_bitmap_image = CGImageCreate(
			width, height, 8, 32, width * 4,
			colorspace,
			(CGBitmapInfo)kCGImageAlphaLast,
			provider, NULL, NO,
			kCGRenderingIntentDefault
			);
		CGDataProviderRelease( provider );
		CGColorSpaceRelease( colorspace );
	}
	return (_bitmap_image != NULL);
}
- (BOOL)createAlphaImage:(CGImageRef)image :(int)width :(int)height
{
	_bitmap_image = NULL;
	int len = width * height * 4;
	[self _allocBitmapPixels:len];
	if( _bitmap_pixels != NULL )
	{
		memset( _bitmap_pixels, 0, len );
		CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
		CGContextRef bitmap = CGBitmapContextCreate(
			_bitmap_pixels,
			width, height, 8, width * 4,
			colorspace,
			(CGBitmapInfo)kCGImageAlphaPremultipliedLast
			);
		if( bitmap != NULL )
		{
			_rect.origin.x    = 0;
			_rect.origin.y    = 0;
			_rect.size.width  = width;
			_rect.size.height = height;
			CGContextDrawImage( bitmap, _rect, image );
			CGContextRelease( bitmap );
			for( int i = 3; i < len; i += 4 )
			{
				_bitmap_pixels[i] = (unsigned char)((float)_bitmap_pixels[i] * _a);
			}
			CGDataProviderRef provider = CGDataProviderCreateWithData( NULL, _bitmap_pixels, len, NULL );
			_bitmap_image = CGImageCreate(
				width, height, 8, 32, width * 4,
				colorspace,
				(CGBitmapInfo)kCGImageAlphaLast,
				provider, NULL, NO,
				kCGRenderingIntentDefault
				);
			CGDataProviderRelease( provider );
		}
		CGColorSpaceRelease( colorspace );
	}
	return (_bitmap_image != NULL);
}
- (void)releaseAlphaImage
{
	CGImageRelease( _bitmap_image );
}

- (void)drawImageSub:(CGImageRef)image :(int)x :(int)y :(float)width :(float)height :(BOOL)flip
{
	width  /= _scale;
	height /= _scale;
	x += _origin_x;
	y += _origin_y;
	int flipmode = [self getFlipMode:flip];
	if( flipmode == FLIP_NONE )
	{
		_rect.origin.x    = x;
		_rect.origin.y    = y;
		_rect.size.width  = width;
		_rect.size.height = height;
		CGContextDrawImage( _context, _rect, image );
	}
	else
	{
		CGContextSaveGState( _context );
		switch( flipmode )
		{
		case FLIP_HORIZONTAL:
			CGContextTranslateCTM( _context, width, 0.0f );
			CGContextScaleCTM( _context, -1.0f, 1.0f );
			_rect.origin.x = -x;
			_rect.origin.y = y;
			break;
		case FLIP_VERTICAL:
			CGContextTranslateCTM( _context, 0.0f, height );
			CGContextScaleCTM( _context, 1.0f, -1.0f );
			_rect.origin.x = x;
			_rect.origin.y = -y;
			break;
		case FLIP_ROTATE:
			CGContextTranslateCTM( _context, width, height );
			CGContextScaleCTM( _context, -1.0f, -1.0f );
			_rect.origin.x = -x;
			_rect.origin.y = -y;
			break;
		}
		_rect.size.width  = width;
		_rect.size.height = height;
		CGContextDrawImage( _context, _rect, image );
		CGContextRestoreGState( _context );
	}
}
- (void)drawImage:(_Image*)image :(int)x :(int)y
{
	if( _a < 1.0f )
	{
		unsigned char* pixels = [image pixels];
		int width  = [image getWidth];
		int height = [image getHeight];
		if( pixels != NULL )
		{
			int len = width * height * 4;
			[self _allocBitmapPixels:len];
			if( _bitmap_pixels != NULL )
			{
				memcpy( _bitmap_pixels, pixels, len );
				if( [self createAlphaImage:width :height] )
				{
					[self drawImageSub:_bitmap_image :x :y :width :height :[image _isFlip]];
					[self releaseAlphaImage];
				}
			}
		}
		else
		{
			if( [self createAlphaImage:[image _getImage] :width :height] )
			{
				[self drawImageSub:_bitmap_image :x :y :width :height :[image _isFlip]];
				[self releaseAlphaImage];
			}
			[image _releaseImage];
		}
	}
	else
	{
		[self drawImageSub:[image _getImage] :x :y :[image getWidth] :[image getHeight] :[image _isFlip]];
		[image _releaseImage];
	}
}
- (void)drawImage:(_Image*)image :(int)dx :(int)dy :(int)sx :(int)sy :(int)width :(int)height
{
	unsigned char* pixels = [image pixels];
	if( (pixels != NULL) && (_a < 1.0f) )
	{
		int len = width * height * 4;
		[self _allocBitmapPixels:len];
		if( _bitmap_pixels != NULL )
		{
			[image getPixels:sx :sy :width :height :_bitmap_pixels];
			if( [self createAlphaImage:width :height] )
			{
				[self drawImageSub:_bitmap_image :dx :dy :width :height :[image _isFlip]];
				[self releaseAlphaImage];
			}
		}
	}
	else
	{
		_rect.origin.x    = sx;
		_rect.origin.y    = [image _isFlip] ? sy : (([image getHeight] - height) - sy);
		_rect.size.width  = width;
		_rect.size.height = height;
		CGImageRef tmp = CGImageCreateWithImageInRect( [image _getImage], _rect );
		[image _releaseImage];
		if( _a < 1.0f )
		{
			if( [self createAlphaImage:tmp :width :height] )
			{
				[self drawImageSub:_bitmap_image :dx :dy :width :height :[image _isFlip]];
				[self releaseAlphaImage];
			}
		}
		else
		{
			[self drawImageSub:tmp :dx :dy :width :height :[image _isFlip]];
		}
		CGImageRelease( tmp );
	}
}

- (void)drawScaledImageSub:(CGImageRef)image :(float)dx :(float)dy :(int)width :(int)height :(float)swidth :(float)sheight :(BOOL)flip
{
	swidth  /= _scale;
	sheight /= _scale;
	dx = (dx + (float)_origin_x) * swidth  / (float)width ;
	dy = (dy + (float)_origin_y) * sheight / (float)height;
	float scale_x = (float)width  / swidth;
	float scale_y = (float)height / sheight;
	CGContextSaveGState( _context );
	switch( [self getFlipMode:flip] )
	{
	case FLIP_NONE:
		CGContextScaleCTM( _context, scale_x, scale_y );
		_rect.origin.x = dx;
		_rect.origin.y = dy;
		break;
	case FLIP_HORIZONTAL:
		CGContextScaleCTM( _context, -scale_x, scale_y );
		CGContextTranslateCTM( _context, -swidth, 0.0f );
		_rect.origin.x = -dx;
		_rect.origin.y = dy;
		break;
	case FLIP_VERTICAL:
		CGContextScaleCTM( _context, scale_x, -scale_y );
		CGContextTranslateCTM( _context, 0.0f, -sheight );
		_rect.origin.x = dx;
		_rect.origin.y = -dy;
		break;
	case FLIP_ROTATE:
		CGContextScaleCTM( _context, -scale_x, -scale_y );
		CGContextTranslateCTM( _context, -swidth, -sheight );
		_rect.origin.x = -dx;
		_rect.origin.y = -dy;
		break;
	}
	_rect.size.width  = swidth;
	_rect.size.height = sheight;
	CGContextDrawImage( _context, _rect, image );
	CGContextRestoreGState( _context );
}
- (void)drawScaledImage:(_Image*)image :(int)dx :(int)dy :(int)width :(int)height :(int)sx :(int)sy :(int)swidth :(int)sheight
{
	unsigned char* pixels = [image pixels];
	if( (pixels != NULL) && (_a < 1.0f) )
	{
		int len = swidth * sheight * 4;
		[self _allocBitmapPixels:len];
		if( _bitmap_pixels != NULL )
		{
			[image getPixels:sx :sy :swidth :sheight :_bitmap_pixels];
			if( [self createAlphaImage:swidth :sheight] )
			{
				[self drawScaledImageSub:_bitmap_image :dx :dy :width :height :swidth :sheight :[image _isFlip]];
				[self releaseAlphaImage];
			}
		}
	}
	else
	{
		_rect.origin.x    = sx;
		_rect.origin.y    = [image _isFlip] ? sy : (([image getHeight] - sheight) - sy);
		_rect.size.width  = swidth;
		_rect.size.height = sheight;
		CGImageRef tmp = CGImageCreateWithImageInRect( [image _getImage], _rect );
		[image _releaseImage];
		if( _a < 1.0f )
		{
			if( [self createAlphaImage:tmp :swidth :sheight] )
			{
				[self drawScaledImageSub:_bitmap_image :dx :dy :width :height :swidth :sheight :[image _isFlip]];
				[self releaseAlphaImage];
			}
		}
		else
		{
			[self drawScaledImageSub:tmp :dx :dy :width :height :swidth :sheight :[image _isFlip]];
		}
		CGImageRelease( tmp );
	}
}
- (void)drawScaledImage:(_Image*)image :(int)dx :(int)dy :(int)width :(int)height
{
	if( _a < 1.0f )
	{
		unsigned char* pixels = [image pixels];
		int swidth  = [image getWidth];
		int sheight = [image getHeight];
		if( pixels != NULL )
		{
			int len = swidth * sheight * 4;
			[self _allocBitmapPixels:len];
			if( _bitmap_pixels != NULL )
			{
				memcpy( _bitmap_pixels, pixels, len );
				if( [self createAlphaImage:swidth :sheight] )
				{
					[self drawScaledImageSub:_bitmap_image :dx :dy :width :height :swidth :sheight :[image _isFlip]];
					[self releaseAlphaImage];
				}
			}
		}
		else
		{
			if( [self createAlphaImage:[image _getImage] :swidth :sheight] )
			{
				[self drawScaledImageSub:_bitmap_image :dx :dy :width :height :swidth :sheight :[image _isFlip]];
				[self releaseAlphaImage];
			}
			[image _releaseImage];
		}
	}
	else
	{
		[self drawScaledImageSub:[image _getImage] :dx :dy :width :height :[image getWidth] :[image getHeight] :[image _isFlip]];
		[image _releaseImage];
	}
}

- (void)drawTransImageSub:(CGImageRef)image :(float)dx :(float)dy :(float)width :(float)height :(float)cx :(float)cy :(float)r360 :(float)z128x :(float)z128y :(BOOL)flip
{
	width  /= _scale;
	height /= _scale;
	cx /= _scale;
	cy /= _scale;
	float scale_x = z128x / 128.0f;
	float scale_y = z128y / 128.0f;
	CGContextSaveGState( _context );
	CGContextTranslateCTM( _context, dx, dy );
	CGContextRotateCTM( _context, (r360 * M_PI) / 180.0f );
	CGContextTranslateCTM( _context, -dx, -dy );
	dx = (dx + (float)_origin_x) * 128.0f / z128x;
	dy = (dy + (float)_origin_y) * 128.0f / z128y;
	dx -= cx;
	dy -= cy;
	switch( [self getFlipMode:flip] )
	{
	case FLIP_NONE:
		CGContextScaleCTM( _context, scale_x, scale_y );
		_rect.origin.x = dx;
		_rect.origin.y = dy;
		break;
	case FLIP_HORIZONTAL:
		CGContextScaleCTM( _context, -scale_x, scale_y );
		CGContextTranslateCTM( _context, -width, 0.0f );
		_rect.origin.x = -dx;
		_rect.origin.y = dy;
		break;
	case FLIP_VERTICAL:
		CGContextScaleCTM( _context, scale_x, -scale_y );
		CGContextTranslateCTM( _context, 0.0f, -height );
		_rect.origin.x = dx;
		_rect.origin.y = -dy;
		break;
	case FLIP_ROTATE:
		CGContextScaleCTM( _context, -scale_x, -scale_y );
		CGContextTranslateCTM( _context, -width, -height );
		_rect.origin.x = -dx;
		_rect.origin.y = -dy;
		break;
	}
	_rect.size.width  = width;
	_rect.size.height = height;
	CGContextDrawImage( _context, _rect, image );
	CGContextRestoreGState( _context );
}
- (void)drawTransImage:(_Image*)image :(float)dx :(float)dy :(int)sx :(int)sy :(int)width :(int)height :(float)cx :(float)cy :(float)r360 :(float)z128x :(float)z128y
{
	unsigned char* pixels = [image pixels];
	if( (pixels != NULL) && (_a < 1.0f) )
	{
		int len = width * height * 4;
		[self _allocBitmapPixels:len];
		if( _bitmap_pixels != NULL )
		{
			[image getPixels:sx :sy :width :height :_bitmap_pixels];
			if( [self createAlphaImage:width :height] )
			{
				[self drawTransImageSub:_bitmap_image :dx :dy :width :height :cx :cy :r360 :z128x :z128y :[image _isFlip]];
				[self releaseAlphaImage];
			}
		}
	}
	else
	{
		_rect.origin.x    = sx;
		_rect.origin.y    = [image _isFlip] ? sy : (([image getHeight] - height) - sy);
		_rect.size.width  = width;
		_rect.size.height = height;
		CGImageRef tmp = CGImageCreateWithImageInRect( [image _getImage], _rect );
		[image _releaseImage];
		if( _a < 1.0f )
		{
			if( [self createAlphaImage:tmp :width :height] )
			{
				[self drawTransImageSub:_bitmap_image :dx :dy :width :height :cx :cy :r360 :z128x :z128y :[image _isFlip]];
				[self releaseAlphaImage];
			}
		}
		else
		{
			[self drawTransImageSub:tmp :dx :dy :width :height :cx :cy :r360 :z128x :z128y :[image _isFlip]];
		}
		CGImageRelease( tmp );
	}
}
- (void)drawTransImage:(_Image*)image :(float)dx :(float)dy :(float)cx :(float)cy :(float)r360 :(float)z128x :(float)z128y
{
	if( _a < 1.0f )
	{
		unsigned char* pixels = [image pixels];
		int width  = [image getWidth];
		int height = [image getHeight];
		if( pixels != NULL )
		{
			int len = width * height * 4;
			[self _allocBitmapPixels:len];
			if( _bitmap_pixels != NULL )
			{
				memcpy( _bitmap_pixels, pixels, len );
				if( [self createAlphaImage:width :height] )
				{
					[self drawTransImageSub:_bitmap_image :dx :dy :width :height :cx :cy :r360 :z128x :z128y :[image _isFlip]];
					[self releaseAlphaImage];
				}
			}
		}
		else
		{
			if( [self createAlphaImage:[image _getImage] :width :height] )
			{
				[self drawTransImageSub:_bitmap_image :dx :dy :width :height :cx :cy :r360 :z128x :z128y :[image _isFlip]];
				[self releaseAlphaImage];
			}
			[image _releaseImage];
		}
	}
	else
	{
		[self drawTransImageSub:[image _getImage] :dx :dy :[image getWidth] :[image getHeight] :cx :cy :r360 :z128x :z128y :[image _isFlip]];
		[image _releaseImage];
	}
}

@end
