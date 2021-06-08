#import "MyCanvas.h"

#import "_Main.h"

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }

- (void)_init
{
	_Graphics* g = [self getGraphics];
	[g setFontSize:20];

	step_s = 0;
	step_r = 0;
	elapse = 0;

	args = nil;

	error = [[NSMutableString alloc] initWithString:@""];
}

#ifdef NO_OBJC_ARC
- (void)_end
{
	if( args != nil )
	{
		[args release];
	}
	[error release];
}
#endif // NO_OBJC_ARC

- (void)_suspend
{
	step_s++;
}

- (void)_resume
{
	step_r++;
}

- (void)_paint:(_Graphics*)g
{
	elapse++;

	[g lock];

	[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
	[g fillRect:0 :0 :[self getWidth] :[self getHeight]];

	[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
	[g drawString:[NSString stringWithFormat:@"suspend : %d", step_s] :0 :24];
	[g drawString:[NSString stringWithFormat:@"resume : %d", step_r] :0 :48];
	[g drawString:[NSString stringWithFormat:@"elapse : %d", elapse] :0 :72];
	[g drawString:error :0 :96];

	[g unlock];
}

- (void)_processEvent:(int)type :(int)param
{
	if( type == TOUCH_UP_EVENT )
	{
#ifdef NO_OBJC_ARC
		if( args != nil )
		{
			[args release];
		}
#endif // NO_OBJC_ARC
		args = [[NSMutableArray alloc] init];
		[args addObject:@"user"];
		[args addObject:@"てすと"];
		[args addObject:@"elapse"];
		[args addObject:[NSString stringWithFormat:@"%d", elapse]];
		if( [[self getMain] launch:@"LaunchSub" :args] == NO )
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
