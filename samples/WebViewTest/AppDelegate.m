#import "AppDelegate.h"

#import "_Log.h"
#import "MyCanvas.h"

@implementation AppDelegate

- (int)_orientation { return ORIENTATION_PORTRAIT; }
- (BOOL)_fullScreen { return YES; }

- (void)_start
{
	log = [[_Log alloc] initWithLength:LOG_NUM];

	canvas = [[MyCanvas alloc] initWithMain:self];
	[self setCurrent:canvas];
}

#ifdef NO_OBJC_ARC
- (void)_destroy
{
	[log release];

	[canvas release];
}
#endif // NO_OBJC_ARC

@end
