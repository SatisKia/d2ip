#import "MyCanvas.h"

#import "_Image.h"

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }

- (void)_init
{
	// リソースから作成する
	img = [[_Image alloc] init];
	[img load:@"sample.png"];
	[img mutable];

	step = 0;
	x = 0;
	y = 0;
	angle = 0;
}

#ifdef NO_OBJC_ARC
- (void)_end
{
	[img release];
}
#endif // NO_OBJC_ARC

- (void)_paint:(_Graphics*)g
{
	switch( step )
	{
	case 0:
		x++; if( x >= 60 ) step++;
		break;
	case 1:
		y++; if( y >= 60 ) step++;
		break;
	case 2:
		x--; if( x <= 0 ) step++;
		break;
	case 3:
		y--; if( y <= 0 ) step = 0;
		break;
	}

	[g lock];

	[g setColor:[_Graphics getColorOfRGB:128 :128 :255]];
	[g fillRect:0 :0 :[self getWidth] :[self getHeight]];

	[g setAlpha:192];

	[g setColor:[_Graphics getColorOfRGB:255 :0 :0]];
	[g fillRect:60 :60 :150 :150];
	[g setColor:[_Graphics getColorOfRGB:0 :255 :0]];
	[g fillRect:120 :120 :150 :150];
	[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
	[g fillRect:180 :180 :150 :150];

	[g drawScaledImage:img :0 :0 :75 :75 :x :y :120 :120];
	[g setFlipMode:FLIP_HORIZONTAL];
	[g drawScaledImage:img :90 :0 :75 :75 :x :y :120 :120];
	[g setFlipMode:FLIP_VERTICAL];
	[g drawScaledImage:img :180 :0 :75 :75 :x :y :120 :120];
	[g setFlipMode:FLIP_ROTATE];
	[g drawScaledImage:img :270 :0 :75 :75 :x :y :120 :120];
	[g setFlipMode:FLIP_NONE];

	[g drawTransImage:img :0 :150 :x :y :120 :120 :0 :120 :45.0f :100.0f :100.0f];
	[g setFlipMode:FLIP_HORIZONTAL];
	[g drawTransImage:img :90 :150 :x :y :120 :120 :0 :120 :45.0f :100.0f :100.0f];
	[g setFlipMode:FLIP_VERTICAL];
	[g drawTransImage:img :180 :150 :x :y :120 :120 :0 :120 :45.0f :100.0f :100.0f];
	[g setFlipMode:FLIP_ROTATE];
	[g drawTransImage:img :270 :150 :x :y :120 :120 :0 :120 :45.0f :100.0f :100.0f];
	[g setFlipMode:FLIP_NONE];

	[g drawLine:0 :150 :[self getWidth] :150];

	// 拡大率をマイナス値にすることでも反転させることができます
	[g drawTransImage:img :45 :300 :x :y :120 :120 :60 :60 :(float)angle :150.0f :100.0f];
	[g drawTransImage:img :135 :300 :x :y :120 :120 :60 :60 :(float)angle :-100.0f :150.0f];
	[g drawTransImage:img :225 :300 :x :y :120 :120 :60 :60 :(float)angle :150.0f :-100.0f];
	[g drawTransImage:img :315 :300 :x :y :120 :120 :60 :60 :(float)angle :-100.0f :-150.0f];
	angle++;

	[g drawLine:0 :300 :[self getWidth] :300];

	[g setAlpha:255];

	[g unlock];
}

@end
