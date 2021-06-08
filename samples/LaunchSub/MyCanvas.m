#import "MyCanvas.h"

#import "_Main.h"

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }

- (void)_init
{
	_Graphics* g = [self getGraphics];
	[g setFontSize:20];

	NSString* tmp = [[self getMain] getParameter:@"user" defString:@"-"];
	user = [[NSMutableString alloc] initWithString:tmp];

	elapse = [[self getMain] getParameter:@"elapse" defInteger:0];

	error = [[NSMutableString alloc] initWithString:@""];
}

#ifdef NO_OBJC_ARC
- (void)_end
{
	[user release];
	[error release];
}
#endif // NO_OBJC_ARC

- (void)_resume
{
	NSString* tmp = [[self getMain] getParameter:@"user" defString:@"-"];
	[user setString:tmp];

	elapse = [[self getMain] getParameter:@"elapse" defInteger:0];
}

- (void)_paint:(_Graphics*)g
{
	[g lock];

	[g setColor:[_Graphics getColorOfRGB:255 :128 :255]];
	[g fillRect:0 :0 :[self getWidth] :[self getHeight]];

	[g setColor:[_Graphics getColorOfRGB:255 :0 :0]];
	[g drawString:[NSString stringWithFormat:@"user : %@", user] :0 :24];
	[g drawString:[NSString stringWithFormat:@"elapse : %d", elapse] :0 :48];
	[g drawString:error :0 :72];

	[g unlock];
}

- (void)_processEvent:(int)type :(int)param
{
	if( type == TOUCH_UP_EVENT )
	{
		if( [[self getMain] launch:@"LaunchTest" :nil] == NO )
		{
			[error setString:@"起動に失敗しました"];
		}
		else
		{
			[error setString:@""];
		}
	}
}

@end
