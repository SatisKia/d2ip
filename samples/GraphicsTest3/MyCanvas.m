#import "MyCanvas.h"

#import "_GLGraphics.h"
#import "_Main.h"
#import "_ScalableGraphics.h"
#import "_String.h"
#import "MyGLTexture.h"

@implementation MyCanvas

- (int)_frameTime { return 16/*1000 / 60*/; }

- (void)renderInit
{
//	glDisable( GL_DITHER );	// ディザ処理を無効化し、なめらかな表示に

//	glHint( GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST );	// GL_FASTEST or GL_NICEST

//	glShadeModel( GL_SMOOTH );	// GL_FLAT or GL_SMOOTH

	glViewport( 0, 0, [self getViewportWidth], [self getViewportHeight] );

	glMatrixMode( GL_PROJECTION );
	glLoadIdentity();
	glOrthof( 0, [self getWidth], 0, [self getHeight], -1, 1 );

	glMatrixMode( GL_MODELVIEW );
}

- (void)_init3D
{
	int width  = [self getWidth ];
	int height = [self getHeight];

	glt = [[MyGLTexture alloc] initWithNum:256 :1];
	if( [[self getMain] applyScale] )
	{
		float width2  = (float)width  * [UIScreen mainScreen].scale;
		float height2 = (float)height * [UIScreen mainScreen].scale;

		[glt setCanvasHeight:((int)height2)];
		[glt setScale:(width2 / 400.0f)];

		width2D  = (int)(width2  / [glt scale]);
		height2D = (int)(height2 / [glt scale]);
	}
	else
	{
		[glt setCanvasHeight:height];
		[glt setScale:((float)width / 400.0f)];

		width2D  = (int)((float)width  / [glt scale]);
		height2D = (int)((float)height / [glt scale]);
	}

	// 2D描画用のテクスチャ・イメージ
	[glt create2D:width2D :height2D];

	g = [[_GLGraphics alloc] initWithTexture:glt];
	[g setSize:width :height];
	[g setScale:((float)width / 400.0f)];

	g2 = [[_ScalableGraphics alloc] init];
	[g2 setScale:((float)width / 400.0f)];

	[self renderInit];

	step = 0;
	x = 0;
	y = 0;
	angle = 0;
}

- (void)_reset3D
{
	[glt reset];

	[self renderInit];
}

#ifdef NO_OBJC_ARC
- (void)_end3D
{
	[glt release];

	[g release];
}
#endif // NO_OBJC_ARC

- (void)_paint3D:(_Graphics*)_g
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

	[self lock3D];

	glClearColor( 0.5f, 0.5f, 1.0f, 1.0f );
	glClear( GL_COLOR_BUFFER_BIT );

	[glt lock:0];

	[glt draw:0 :0 :0 :75 :75 :x :y :120 :120];
	[glt setFlipMode:FLIP_HORIZONTAL];
	[glt draw:0 :90 :0 :75 :75 :x :y :120 :120];
	[glt setFlipMode:FLIP_VERTICAL];
	[glt draw:0 :180 :0 :75 :75 :x :y :120 :120];
	[glt setFlipMode:FLIP_ROTATE];
	[glt draw:0 :270 :0 :75 :75 :x :y :120 :120];
	[glt setFlipMode:FLIP_NONE];

	[glt unlock];

	// 描画の際の座標点指定のテスト
//	[g setOrigin:20 :50];

	[g setAlpha:192];

	[g setColor:[_GLGraphics getColorOfRGB:0 :255 :0]];
	[g fillRect:120 :120 :150 :150];
	[g setColor:[_GLGraphics getColorOfRGB:0 :0 :255]];
	[g fillRect:180 :180 :150 :150];
	[g setColor:[_GLGraphics getColorOfRGB:255 :0 :0]];
	[g fillRect:60 :60 :150 :150];

	[g setColor:[_GLGraphics getColorOfRGB:255 :255 :0]];
	[g setLineWidth:5];
	[g setAlpha:64];
	[g drawLine:60 :60 :209 :209];
	[g drawRect:61 :61 :150 :150];
	[g setLineWidth:1];
	[g setAlpha:255];
	[g drawLine:60 :60 :209 :209];
	[g drawRect:61 :61 :150 :150];
	[g setAlpha:192];

	[g lockTexture:0];

	[g setROP:ROP_COPY];

	[g drawScaledTexture:0 :0 :90 :75 :75 :x :y :120 :120];
	[g setFlipMode:FLIP_HORIZONTAL];
	[g drawScaledTexture:0 :90 :90 :75 :75 :x :y :120 :120];
	[g setFlipMode:FLIP_VERTICAL];
	[g drawScaledTexture:0 :180 :90 :75 :75 :x :y :120 :120];
	[g setFlipMode:FLIP_ROTATE];
	[g drawScaledTexture:0 :270 :90 :75 :75 :x :y :120 :120];
	[g setFlipMode:FLIP_NONE];

	[g setROP:ROP_ADD];

	[g drawTransTexture:0 :0 :240 :x :y :120 :120 :0 :120 :45.0f :100.0f :100.0f];
	[g setFlipMode:FLIP_HORIZONTAL];
	[g drawTransTexture:0 :90 :240 :x :y :120 :120 :0 :120 :45.0f :100.0f :100.0f];
	[g setFlipMode:FLIP_VERTICAL];
	[g drawTransTexture:0 :180 :240 :x :y :120 :120 :0 :120 :45.0f :100.0f :100.0f];
	[g setFlipMode:FLIP_ROTATE];
	[g drawTransTexture:0 :270 :240 :x :y :120 :120 :0 :120 :45.0f :100.0f :100.0f];
	[g setFlipMode:FLIP_NONE];

	[g setROP:ROP_COPY];

	// 拡大率をマイナス値にすることでも反転させることができます
	[g drawTransTexture:0 :45 :390 :x :y :120 :120 :60 :60 :(float)angle :150.0f :100.0f];
	[g drawTransTexture:0 :135 :390 :x :y :120 :120 :60 :60 :(float)angle :-100.0f :150.0f];
	[g drawTransTexture:0 :225 :390 :x :y :120 :120 :60 :60 :(float)angle :150.0f :-100.0f];
	[g drawTransTexture:0 :315 :390 :x :y :120 :120 :60 :60 :(float)angle :-100.0f :-150.0f];
	angle++;

	[g unlockTexture];

	[g drawLine:0 :240 :[g getWidth] :240];
	[g drawLine:0 :390 :[g getWidth] :390];

	[g setAlpha:255];

	// 2D描画（オフスクリーン→テクスチャ）
	_Graphics* g3 = [glt lock2D];
	{
		_String* tmp = [[_String alloc] init];
		[g3 setFontSize:24];
		[g3 setColor:[_Graphics getColorOfRGB:0 :0 :0]];
		[g3 setAlpha:160];
		[g3 fillRect:1 :1 :(width2D - 2) :(height2D - 2)];
		[g3 setAlpha:255];
		[g3 setColor:[_Graphics getColorOfRGB:255 :255 :255]];
		[g3 drawString:@"_GLTexture2" :5 :35];
		[g3 setColor:[_Graphics getColorOfRGB:255 :255 :0]];
		[[[tmp setInt:width2D] add:@" "] addInt:height2D];
		[g3 drawString:[tmp str] :5 :65];
		[g3 setColor:[_Graphics getColorOfRGB:255 :0 :255]];
		[[[tmp setInt:[[glt getImage2D] getWidth]] add:@" "] addInt:[[glt getImage2D] getHeight]];
		[g3 drawString:[tmp str] :5 :95];
		[g3 setColor:[_Graphics getColorOfRGB:0 :255 :255]];
		[tmp setInt:angle];
		[g3 drawString:[tmp str] :5 :125];
#ifdef NO_OBJC_ARC
		[tmp release];
#endif // NO_OBJC_ARC
	}
	[glt unlock2D:YES];

	[self unlock3D];

	// _Graphicsによる2D描画
	[_g lock];
	{
		[g2 setGraphics:_g];
		_String* tmp = [[_String alloc] init];
		[g2 setFontSize:24];
		[g2 setColor:[_Graphics getColorOfRGB:255 :255 :255]];
		[g2 drawString:@"_Graphics" :200 :35];
		[g2 setColor:[_Graphics getColorOfRGB:255 :255 :0]];
		[[[tmp setInt:width2D] add:@" "] addInt:height2D];
		[g2 drawString:[tmp str] :200 :65];
		[g2 setColor:[_Graphics getColorOfRGB:255 :0 :255]];
		[[[tmp setInt:[[glt getImage2D] getWidth]] add:@" "] addInt:[[glt getImage2D] getHeight]];
		[g2 drawString:[tmp str] :200 :95];
		[g2 setColor:[_Graphics getColorOfRGB:0 :255 :255]];
		[tmp setInt:angle];
		[g2 drawString:[tmp str] :200 :125];
#ifdef NO_OBJC_ARC
		[tmp release];
#endif // NO_OBJC_ARC
	}
	[_g unlock];
}

@end
