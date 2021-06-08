/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class _Graphics;

@interface _Image : NSObject
{
@private
	UIImage* _uiimage;
	BOOL _attach;

	CGImageRef _image;

	unsigned char* _pixels;
	CGContextRef _bitmap;

	int _width;
	int _height;
	int _length;

	_Graphics* _g;
}

- (void)attach:(UIImage*)image;
- (BOOL)load:(NSString*)name;
- (BOOL)create:(int)width :(int)height :(BOOL)use_g;
- (BOOL)create:(int)width :(int)height;
- (void)mutable:(BOOL)use_g;
- (void)mutable;
- (void)clear;
- (CGImageRef)_getImage;
- (void)_releaseImage;
- (CGContextRef)_getBitmap;
- (BOOL)_isFlip;
- (int)getWidth;
- (int)getHeight;
- (_Graphics*)getGraphics;
- (UIImage*)getImage;
- (UIImage*)allocImage;
- (unsigned char*)pixels;
- (int)length;
- (void)getPixels:(int)x :(int)y :(int)width :(int)height :(unsigned char*)pixels;

@end
