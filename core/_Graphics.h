/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class _Canvas;
@class _Image;

// ラスターオペレーション
#define ROP_COPY	0
#define ROP_ADD		1

// イメージ描画時の反転方法
#define FLIP_NONE		0
#define FLIP_HORIZONTAL	1
#define FLIP_VERTICAL	2
#define FLIP_ROTATE		3

@interface _Graphics : NSObject
{
@private
	_Canvas* _canvas;
	_Image* _image;
	CGContextRef _context;

	float _scale;

	CGPoint _point;
	CGRect _rect;

	// 線幅
	float _stroke_width;

	// 色
	float _r;
	float _g;
	float _b;

	// 透明度
	float _a;

	// フォント
	NSString* _font_name;
	int _font_size;
	UIFont* _font;

	// ラスターオペレーション
	int _rop;

	// イメージ描画時の反転方法
	int _flipmode;

	// 描画の際の座標原点
	int _origin_x;
	int _origin_y;

	// 半透明イメージ用
	unsigned char* _bitmap_pixels;
	int _bitmap_len;
	CGImageRef _bitmap_image;
}

- (void)_setCanvas:(_Canvas*)canvas;
- (void)_setImage:(_Image*)image;
- (void)_setScale:(float)scale;
- (int)getWidth;
- (int)getHeight;
+ (int)getColorOfRGB:(int)r :(int)g :(int)b;
- (void)setStrokeWidth:(float)width;
- (void)setColor:(int)color;
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
