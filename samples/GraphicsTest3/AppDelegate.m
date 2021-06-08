#import "AppDelegate.h"

#import "MyCanvas.h"

@implementation AppDelegate

- (int)_orientation { return ORIENTATION_PORTRAIT; }
- (BOOL)_fullScreen { return YES; }
- (BOOL)_applyScale { return YES; }

- (void)_start
{
	canvas = [[MyCanvas alloc] initWithMain:self];
	[self setCurrent:canvas];
}

#ifdef NO_OBJC_ARC
- (void)_destroy
{
	[canvas release];
}
#endif // NO_OBJC_ARC

@end
