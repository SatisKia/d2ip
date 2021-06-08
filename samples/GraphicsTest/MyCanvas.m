#import "MyCanvas.h"

#import "_Image.h"

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }

- (void)_init
{
	// リソースから作成する
	img1 = [[_Image alloc] init];
	[img1 load:@"sample.png"];
	img2 = [[_Image alloc] init];
	[img2 load:@"sample.png"];
	[img2 mutable];

	// オフスクリーンを作成する
	img3 = [[_Image alloc] init];
	[img3 create:[img1 getWidth] :[img1 getHeight]];

	str = @"Graphics Test";
}

#ifdef NO_OBJC_ARC
- (void)_end
{
	[img1 release];
	[img2 release];
	[img3 release];
}
#endif // NO_OBJC_ARC

- (void)_paint:(_Graphics*)g
{
	// オフスクリーンに描画
	_Graphics* g2;
	g2 = [img2 getGraphics];
	[g2 setColor:[_Graphics getColorOfRGB:255 :0 :0]];
	[g2 setStrokeWidth:5];
	[g2 drawRect:2 :2 :150 :150];
	g2 = [img3 getGraphics];
	[g2 drawImage:img1 :-50 :-50];

	[g lock];

	[g setColor:[_Graphics getColorOfRGB:128 :128 :255]];
	[g fillRect:0 :0 :[self getWidth] :[self getHeight]];

	// 描画の際の座標点指定のテスト
	[g setOrigin:10 :20];

	[g drawImage:img1 :30 :50];
	[g setAlpha:128];
	[g drawImage:img1 :80 :100];
	[g setAlpha:255];
	[g drawImage:img1 :0 :300 :120 :120 :50 :50];
	[g drawScaledImage:img1 :0 :360 :100 :50 :120 :120 :50 :50];
	[g drawImage:img2 :110 :300 :120 :120 :50 :50];
	[g drawScaledImage:img2 :110 :360 :100 :50 :120 :120 :50 :50];
	[g drawImage:img3 :220 :300 :70 :70 :50 :50];
	[g drawScaledImage:img3 :220 :360 :100 :50 :70 :70 :50 :50];

	[g setColor:[_Graphics getColorOfRGB:255 :0 :0]];
	[g setStrokeWidth:1.0f];
	[g drawLine:10 :100 :110 :200];
	[g setStrokeWidth:1.5f];
	[g drawLine:110 :100 :210 :200];
	[g setStrokeWidth:2.0f];
	[g drawLine:210 :100 :310 :200];
	[g setStrokeWidth:1.0f];

	[g setColor:[_Graphics getColorOfRGB:255 :255 :0]];
	[g drawRect:10 :220 :50 :50];
	[g drawRoundRect:10 :290 :50 :50 :8];
	[g fillRoundRect:80 :290 :50 :50 :8];

	[g setColor:[_Graphics getColorOfRGB:0 :255 :0]];
	[g setAlpha:128];
	[g fillRect:100 :220 :50 :50];
	[g setAlpha:64];
	[g fillRect:150 :220 :50 :50];
	[g setAlpha:255];

	[g setFont:@"Verdana-Italic" :24];
	[g setColor:[_Graphics getColorOfRGB:255 :0 :255]];
	[g drawRect:0 :0 :[g stringWidth:str] :[g fontHeight]];
	[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
	[g drawString:str :0 :[g fontHeight]];

	[g setFontSize:36];
	[g setColor:[_Graphics getColorOfRGB:255 :0 :255]];
	[g drawRect:0 :35 :[g stringWidth:str] :[g fontHeight]];
	[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
	[g drawString:str :0 :35 + [g fontHeight]];

	[g setColor:[_Graphics getColorOfRGB:255 :0 :255]];
	[g drawOval:10 :10 :50 :50];
	[g fillOval:70 :10 :50 :50];
	[g setColor:[_Graphics getColorOfRGB:0 :255 :255]];
	[g drawCircle:35 :95 :25];
	[g fillCircle:95 :95 :25];

	[g setOrigin:0 :0];

	[g unlock];
}

@end
