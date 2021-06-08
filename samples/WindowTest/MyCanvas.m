#import "MyCanvas.h"

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }

- (void)_init
{
	_Graphics* g = [self getGraphics];
	[g setFontSize:20];

	if( [self getWidth] > [self getHeight] )
	{
		win_top    = 50;
		win_left   = ([self getWidth] - ([self getHeight] - 100)) / 2;
		win_bottom = [self getHeight] - 50;
		win_right  = win_left + ([self getHeight] - 100);
	}
	else
	{
		win_left   = 50;
		win_top    = ([self getHeight] - ([self getWidth] - 100)) / 2;
		win_right  = [self getWidth] - 50;
		win_bottom = win_top + ([self getWidth] - 100);
	}
	win_width  = 240;
	win_height = 240;
	[self setWindow:win_left :win_top :win_right :win_bottom :win_width :win_height];
}

- (void)_paint:(_Graphics*)g
{
	[g lock];

	[g setColor:[_Graphics getColorOfRGB:128 :128 :255]];
	[g fillRect:0 :0 :[self getWidth] :[self getHeight]];

	[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
	[g fillRect:[self getWindowLeft]
		:[self getWindowTop]
		:[self getWindowRight] - [self getWindowLeft]
		:[self getWindowBottom] - [self getWindowTop]
		];

	if( [self getTouchNum] > 0 )
	{
		[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
		[g drawString:[NSString stringWithFormat:@"%d", [self windowX:[self getTouchX:0]]] :0 :24];
		[g drawString:[NSString stringWithFormat:@"%d", [self windowY:[self getTouchY:0]]] :0 :48];
	}

	[g unlock];
}

@end
