/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_ScalableGraphics.h"

#import "_Graphics.h"
#import "_Image.h"

@implementation _ScalableGraphics

- (void)setGraphics:(_Graphics*)g
{
	_g = g;
}

- (int)getWidth
{
	return (int)((float)[_g getWidth] / _scale);
}
- (int)getHeight
{
	return (int)((float)[_g getHeight] / _scale);
}

- (void)setStrokeWidth:(float)width
{
	[_g setStrokeWidth:(width * _scale)];
}
- (void)setColor:(int)col
{
	[_g setColor:col];
}
- (void)setAlpha:(int)a
{
	[_g setAlpha:a];
}
- (void)setROP:(int)mode
{
	[_g setROP:mode];
}
- (void)setFlipMode:(int)flipmode
{
	[_g setFlipMode:flipmode];
}
- (void)setOrigin:(int)x :(int)y
{
	[_g setOrigin:(int)((float)x * _scale) :(int)((float)y * _scale)];
}
- (void)setFont:(NSString*)name :(int)size
{
	[_g setFont:name :(int)((float)size * _scale)];
}
- (void)setFontName:(NSString*)name
{
	[_g setFontName:name];
}
- (void)setFontSize:(int)size
{
	[_g setFontSize:(int)((float)size * _scale)];
}
- (int)stringWidth:(NSString*)str
{
	if( _scale == 0.0f )
	{
		return 0;
	}
	return (int)((float)[_g stringWidth:str] / _scale);
}
- (int)fontHeight
{
	if( _scale == 0.0f )
	{
		return 0;
	}
	return (int)((float)[_g fontHeight] / _scale);
}
- (void)lock
{
	[_g lock];
}
- (void)unlock
{
	[_g unlock];
}
- (void)drawLine:(int)x1 :(int)y1 :(int)x2 :(int)y2
{
	[_g drawLine:(int)((float)x1 * _scale) :(int)((float)y1 * _scale) :(int)((float)x2 * _scale) :(int)((float)y2 * _scale)];
}
- (void)drawRect:(int)x :(int)y :(int)width :(int)height
{
	[_g drawRect:(int)((float)x * _scale) :(int)((float)y * _scale) :(int)((float)width * _scale) :(int)((float)height * _scale)];
}
- (void)fillRect:(int)x :(int)y :(int)width :(int)height
{
	[_g fillRect:(int)((float)x * _scale) :(int)((float)y * _scale) :(int)((float)width * _scale) :(int)((float)height * _scale)];
}
- (void)drawRoundRect:(int)x :(int)y :(int)width :(int)height :(int)r
{
	[_g drawRoundRect:(int)((float)x * _scale) :(int)((float)y * _scale) :(int)((float)width * _scale) :(int)((float)height * _scale) :(int)((float)r * _scale)];
}
- (void)fillRoundRect:(int)x :(int)y :(int)width :(int)height :(int)r
{
	[_g fillRoundRect:(int)((float)x * _scale) :(int)((float)y * _scale) :(int)((float)width * _scale) :(int)((float)height * _scale) :(int)((float)r * _scale)];
}
- (void)drawOval:(int)x :(int)y :(int)width :(int)height
{
	[_g drawOval:(int)((float)x * _scale) :(int)((float)y * _scale) :(int)((float)width * _scale) :(int)((float)height * _scale)];
}
- (void)fillOval:(int)x :(int)y :(int)width :(int)height
{
	[_g fillOval:(int)((float)x * _scale) :(int)((float)y * _scale) :(int)((float)width * _scale) :(int)((float)height * _scale)];
}
- (void)drawCircle:(int)x :(int)y :(int)r
{
	[_g drawCircle:(int)((float)x * _scale) :(int)((float)y * _scale) :(int)((float)r * _scale)];
}
- (void)fillCircle:(int)x :(int)y :(int)r
{
	[_g fillCircle:(int)((float)x * _scale) :(int)((float)y * _scale) :(int)((float)r * _scale)];
}
- (void)drawString:(NSString*)str :(int)x :(int)y
{
	[_g drawString:str :(int)((float)x * _scale) :(int)((float)y * _scale)];
}
- (void)drawImage:(_Image*)image :(int)x :(int)y
{
	int width  = [image getWidth];
	int height = [image getHeight];
	[_g drawScaledImage:image :(int)((float)x * _scale) :(int)((float)y * _scale) :(int)((float)width * _scale) :(int)((float)height * _scale) :0 :0 :width :height];
}
- (void)drawImage:(_Image*)image :(int)dx :(int)dy :(int)sx :(int)sy :(int)width :(int)height
{
	[_g drawScaledImage:image :(int)((float)dx * _scale) :(int)((float)dy * _scale) :(int)((float)width * _scale) :(int)((float)height * _scale) :sx :sy :width :height];
}
- (void)drawScaledImage:(_Image*)image :(int)dx :(int)dy :(int)width :(int)height :(int)sx :(int)sy :(int)swidth :(int)sheight
{
	[_g drawScaledImage:image :(int)((float)dx * _scale) :(int)((float)dy * _scale) :(int)((float)width * _scale) :(int)((float)height * _scale) :sx :sy :swidth :sheight];
}
- (void)drawScaledImage:(_Image*)image :(int)dx :(int)dy :(int)width :(int)height
{
	[_g drawScaledImage:image :(int)((float)dx * _scale) :(int)((float)dy * _scale) :(int)((float)width * _scale) :(int)((float)height * _scale)];
}
- (void)drawTransImage:(_Image*)image :(float)dx :(float)dy :(int)sx :(int)sy :(int)width :(int)height :(float)cx :(float)cy :(float)r360 :(float)z128x :(float)z128y
{
	[_g drawTransImage:image :(dx * _scale) :(dy * _scale) :sx :sy :width :height :cx :cy :r360 :(z128x * _scale) :(z128y * _scale)];
}
- (void)drawTransImage:(_Image*)image :(float)dx :(float)dy :(float)cx :(float)cy :(float)r360 :(float)z128x :(float)z128y
{
	[_g drawTransImage:image :(dx * _scale) :(dy * _scale) :cx :cy :r360 :(z128x * _scale) :(z128y * _scale)];
}

@end
