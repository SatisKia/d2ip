/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "_Scalable.h"

@class _Graphics;
@class _Image;

@interface _ScalableGraphics : _Scalable
{
@private
	_Graphics* _g;
}

- (void)setGraphics:(_Graphics*)g;
- (int)getWidth;
- (int)getHeight;
- (void)setStrokeWidth:(float)width;
- (void)setColor:(int)col;
- (void)setAlpha:(int)a;
- (void)setROP:(int)mode;
- (void)setFlipMode:(int)flipmode;
- (void)setOrigin:(int)x :(int)y;
- (void)setFont:(NSString*)name :(int)size;
- (void)setFontName:(NSString*)name;
- (void)setFontSize:(int)size;
- (int)stringWidth:(NSString*)str;
- (int)fontHeight;
- (void)lock;
- (void)unlock;
- (void)drawLine:(int)x1 :(int)y1 :(int)x2 :(int)y2;
- (void)drawRect:(int)x :(int)y :(int)width :(int)height;
- (void)fillRect:(int)x :(int)y :(int)width :(int)height;
- (void)drawRoundRect:(int)x :(int)y :(int)width :(int)height :(int)r;
- (void)fillRoundRect:(int)x :(int)y :(int)width :(int)height :(int)r;
- (void)drawOval:(int)x :(int)y :(int)width :(int)height;
- (void)fillOval:(int)x :(int)y :(int)width :(int)height;
- (void)drawCircle:(int)x :(int)y :(int)r;
- (void)fillCircle:(int)x :(int)y :(int)r;
- (void)drawString:(NSString*)str :(int)x :(int)y;
- (void)drawImage:(_Image*)image :(int)x :(int)y;
- (void)drawImage:(_Image*)image :(int)dx :(int)dy :(int)sx :(int)sy :(int)width :(int)height;
- (void)drawScaledImage:(_Image*)image :(int)dx :(int)dy :(int)width :(int)height :(int)sx :(int)sy :(int)swidth :(int)sheight;
- (void)drawScaledImage:(_Image*)image :(int)dx :(int)dy :(int)width :(int)height;
- (void)drawTransImage:(_Image*)image :(float)dx :(float)dy :(int)sx :(int)sy :(int)width :(int)height :(float)cx :(float)cy :(float)r360 :(float)z128x :(float)z128y;
- (void)drawTransImage:(_Image*)image :(float)dx :(float)dy :(float)cx :(float)cy :(float)r360 :(float)z128x :(float)z128y;

@end
