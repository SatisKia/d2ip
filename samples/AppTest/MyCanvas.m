#import "MyCanvas.h"

#import "_Log.h"
#import "AppDelegate.h"

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }

- (void)_init
{
	m = (AppDelegate*)[self getMain];

	[m->log add:@"init"];

	_Graphics* g = [self getGraphics];
	[g setFontSize:[self getHeight] / LOG_NUM];
}

- (void)_end
{
}

- (void)_suspend
{
	[m->log add:@"suspend"];
}

- (void)_resume
{
	[m->log add:@"resume"];
}

- (void)_paint:(_Graphics*)g
{
	[g lock];

	[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
	[g fillRect:0 :0 :[self getWidth] :[self getHeight]];
	[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];

	NSString* str;
	[m->log beginGet];
	while( (str = [m->log get]) != nil )
	{
		[g drawString:str :0 :(([self getHeight] / LOG_NUM) * [m->log lineNum])];
	}

	[g unlock];
}

@end
