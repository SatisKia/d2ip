/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Image.h"

#import "_Graphics.h"

@implementation _Image

- (id)init
{
	self = [super init];
	if( self != nil )
	{
		_uiimage = nil;

		_pixels = NULL;
		_bitmap = NULL;

		_g = nil;
	}
	return self;
}

- (void)dealloc
{
	if( _uiimage != nil )
	{
		CGImageRelease( _image );
#ifdef NO_OBJC_ARC
		if( !_attach )
		{
			[_uiimage release];
		}
#endif // NO_OBJC_ARC
	}
	if( _pixels != NULL )
	{
		if( _bitmap != NULL )
		{
			CGContextRelease( _bitmap );
		}
		free( _pixels );
	}
#ifdef NO_OBJC_ARC
	if( _g != nil )
	{
		[_g release];
	}
#endif // NO_OBJC_ARC

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (void)attach:(UIImage*)image
{
	_uiimage = image;
	_attach = YES;
	_image = CGImageRetain( _uiimage.CGImage );
	_width  = CGImageGetWidth ( _image );
	_height = CGImageGetHeight( _image );
}

- (BOOL)load:(NSString*)name
{
	NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
	_uiimage = [[UIImage alloc] initWithContentsOfFile:path];
	if( _uiimage != nil )
	{
		_attach = NO;
		_image = CGImageRetain( _uiimage.CGImage );
		_width  = CGImageGetWidth ( _image );
		_height = CGImageGetHeight( _image );
		return YES;
	}
	return NO;
}

- (BOOL)create:(int)width :(int)height :(BOOL)use_g
{
	_width  = width;
	_height = height;
	_length = _width * _height * 4;
	_pixels = malloc( _length );
	memset( _pixels, 0, _length );
	if( _pixels != NULL )
	{
		CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
		_bitmap = CGBitmapContextCreate(
			_pixels,
			_width, _height, 8, _width * 4,
			colorspace,
			(CGBitmapInfo)kCGImageAlphaPremultipliedLast
			);
		CGColorSpaceRelease( colorspace );
		if( _bitmap == NULL )
		{
			free( _pixels );
			_pixels = NULL;
		}
		else
		{
			if( use_g )
			{
				_g = [[_Graphics alloc] init];
			}
			return YES;
		}
	}
	return NO;
}
- (BOOL)create:(int)width :(int)height
{
	return [self create:width :height :YES];
}

- (void)mutable:(BOOL)use_g
{
	if( _uiimage != nil )
	{
		if( [self create:_width :_height :use_g] )
		{
			CGContextTranslateCTM( _bitmap, 0.0f, _height );
			CGContextScaleCTM( _bitmap, 1.0f, -1.0f );
			CGContextDrawImage( _bitmap, CGRectMake( 0, 0, _width, _height ), _image );
			CGImageRelease( _image );
#ifdef NO_OBJC_ARC
			if( !_attach )
			{
				[_uiimage release];
			}
#endif // NO_OBJC_ARC
			_uiimage = nil;
		}
	}
}
- (void)mutable
{
	[self mutable:YES];
}

- (void)clear
{
	if( _bitmap != NULL )
	{
		CGContextSaveGState( _bitmap );
		CGContextSetBlendMode( _bitmap, kCGBlendModeClear );
		CGContextFillRect( _bitmap, CGRectMake( 0, 0, _width, _height ) );
		CGContextRestoreGState( _bitmap );
	}
}

- (CGImageRef)_getImage
{
	if( _uiimage == nil )
	{
		_image = CGBitmapContextCreateImage( _bitmap );
	}
	return _image;
}

- (void)_releaseImage
{
	if( _uiimage == nil )
	{
		CGImageRelease( _image );
	}
}

- (CGContextRef)_getBitmap
{
	return _bitmap;
}

- (BOOL)_isFlip
{
	return (_uiimage != nil);
}

- (int)getWidth
{
	return _width;
}

- (int)getHeight
{
	return _height;
}

- (_Graphics*)getGraphics
{
	if( _g != nil )
	{
		[_g _setImage:self];
	}
	return _g;
}

- (UIImage*)getImage
{
	if( _uiimage != nil )
	{
		return _uiimage;
	}
	UIGraphicsBeginImageContext( CGSizeMake( _width, _height ) );
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawImage( context, CGRectMake( 0, 0, _width, _height ), [self _getImage] );
	[self _releaseImage];
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (UIImage*)allocImage
{
	return [[UIImage alloc] initWithCGImage:[self getImage].CGImage];
}

- (unsigned char*)pixels
{
	return _pixels;
}

- (int)length
{
	return _length;
}

- (void)getPixels:(int)x :(int)y :(int)width :(int)height :(unsigned char*)pixels
{
	if( _pixels == NULL )
	{
		return;
	}
	unsigned char* src = &_pixels[(_height - y - 1) * _width * 4 + x * 4];
	unsigned char* dst = pixels;
	for( int y2 = 0; y2 < height; y2++ )
	{
		memcpy( dst, src, width * 4 );
		src -= _width * 4;
		dst +=  width * 4;
	}
}

@end
