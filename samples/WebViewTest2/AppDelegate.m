#import "AppDelegate.h"

#import "_Sound.h"
#import "_String.h"
#import "_WebView.h"

@implementation AppDelegate

- (int)_orientation { return ORIENTATION_PORTRAIT; }
- (BOOL)_fullScreen { return YES; }

- (void)_start
{
	webView = [[_WebView alloc] initWithMain:self];
//	[webView setCache:NO];
	[webView setTimeout:60.0f];
//	[webView setAutoresizingMask:UIViewAutoresizingNone];
//	[webView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	[webView setAutoresizingMask:(
		UIViewAutoresizingFlexibleWidth |
		UIViewAutoresizingFlexibleHeight |
		UIViewAutoresizingFlexibleLeftMargin |
		UIViewAutoresizingFlexibleRightMargin |
		UIViewAutoresizingFlexibleTopMargin |
		UIViewAutoresizingFlexibleBottomMargin
		)];
	[webView setBackgroundColor:[UIColor clearColor]];
	[webView setFrame:CGRectMake( 0, 0, [self getWidth], [self getHeight] )];
	[webView setOpaque:NO];
//	[webView setScalesPageToFit:YES];
	[webView setScalesPageToFit:NO];

	[self setView:[webView getView]];

	url = [[_String alloc] init];

	sound = [[_Sound alloc] init];
	[sound load:[self resourceURL:@"hit.mp3"]];

//	[webView clearCache];
//	[webView loadURL:@"http://www5d.biglobe.ne.jp/~satis/s/"];
	[webView loadResource:@"index.html"];
}

#ifdef NO_OBJC_ARC
- (void)_destroy
{
	[webView release];

	[url release];

	[sound release];
}
#endif // NO_OBJC_ARC

- (BOOL)_onWebViewShouldStartLoad:(NSString*)_url :(NSString*)mainUrl
{
	[url set:_url];

	if( [url startsWith:@"native://"] )
	{
		_String* command = [[_String alloc] init];
		[command set:[url str] :9 :[url length]];
		if( [command equals:@"se_hit"] )
		{
			[sound play:NO];
		}
#ifdef NO_OBJC_ARC
		[command release];
#endif // NO_OBJC_ARC
		return YES;
	}

	return NO;
}

- (void)_onWebViewStartLoad:(NSString*)_url :(NSString*)mainUrl
{
	[url set:_url];
}

- (void)_onWebViewFinishLoad:(id)_webView
{
}

- (void)_onWebViewLoadError:(NSError*)error :(id)_webView
{
}

@end
