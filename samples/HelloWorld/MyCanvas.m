#import "MyCanvas.h"

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }

- (void)_init
{
	_Graphics* g = [self getGraphics];
	[g setFontSize:20];

#ifdef NO_OBJC_ARC
	str = [[NSString stringWithString:@"Hello World !!"] retain];
#else
	str = [NSString stringWithString:@"Hello World !!"];
#endif // NO_OBJC_ARC
	w = [g stringWidth:str];
	h = [g fontHeight];
	x = 0;
	y = h;
	dx = 5;
	dy = 5;

	elapse = 0;
}

#ifdef NO_OBJC_ARC
- (void)_end
{
	[str release];
}
#endif // NO_OBJC_ARC

- (void)_paint:(_Graphics*)g
{
	elapse++;

	x += dx;
	if( (x <= 0) || (x >= [self getWidth] - w) )
	{
		dx = -dx;
	}
	y += dy;
	if( (y <= h) || (y >= [self getHeight]) )
	{
		dy = -dy;
	}

	[g lock];

	[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
	[g fillRect:0 :0 :[self getWidth] :[self getHeight]];

	[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
	[g drawString:[NSString stringWithFormat:@"%d", elapse] :0 :24];
	[g drawString:str :x :y];

	[g unlock];
}

@end
