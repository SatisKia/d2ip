#import "AppDelegate.h"

#import "MyCanvas.h"

/*
 * メイン
 */
@implementation AppDelegate

- (UIColor*)_backgroundColor { return [UIColor blackColor]; }
- (int)_orientation { return ORIENTATION_PORTRAIT; }
- (BOOL)_fullScreen { return YES; }
//- (BOOL)_applyScale { return YES; }

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
