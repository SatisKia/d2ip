#import "MyCanvas.h"

#import "_Log.h"
#import "_Main.h"
#import "_ScalableGraphics.h"
#import "_Sound.h"
#import "_String.h"
#import "_WebView.h"
#import "AppDelegate.h"

@implementation MyCanvas

- (int)_frameTime { return 100/*1000 / 10*/; }

- (void)_init
{
	m = (AppDelegate*)[self getMain];

	g = [[_ScalableGraphics alloc] init];
	[g setScale:((float)[self getWidth] / 480.0f)];

	[g setGraphics:[self getGraphics]];
	[g setFontSize:FONT_SIZE];
	[g setStrokeWidth:1.0f];

	userAgent1 = [[_String alloc] init];
	[userAgent1 set:[[self getMain] getUserAgentString]];
//	[[self getMain] setUserAgentString:@"..."];

	webView = [[_WebView alloc] initWithMain:[self getMain]];
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
	[webView setFrame:CGRectMake( 0, 0, [self getWidth], [self getHeight] - [g scaledValue:(LOG_HEIGHT + (FONT_SIZE + 3) * 3)] )];
	[webView setOpaque:NO];
//	[webView setScalesPageToFit:YES];
	[webView setScalesPageToFit:NO];

	[self addView:[webView getView] :123];

	userAgent2 = [[_String alloc] init];
	[userAgent2 set:[webView getUserAgentString]];
	url = [[_String alloc] init];
	elapse = 0;

	sound = [[_Sound alloc] init];
	[sound load:[[self getMain] resourceURL:@"hit.mp3"]];

//	[webView clearCache];
//	[webView loadURL:@"http://www5d.biglobe.ne.jp/~satis/s/"];
	[webView loadResource:@"index.html"];
}

#ifdef NO_OBJC_ARC
- (void)_end
{
	[g release];

	[webView release];

	[userAgent1 release];
	[userAgent2 release];
	[url release];

	[sound release];
}
#endif // NO_OBJC_ARC

- (void)_paint:(_Graphics*)_g
{
	[g setGraphics:_g];

	[g lock];

	[g setColor:[_Graphics getColorOfRGB:128 :128 :255]];
	[g fillRect:0 :0 :[g getWidth] :[g getHeight]];
	[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];

	[g drawLine:0 :([g getHeight] - (LOG_HEIGHT + (FONT_SIZE + 3) * 3)) :[g getWidth] :([g getHeight] - (LOG_HEIGHT + (FONT_SIZE + 3) * 3))];

	int w = 0;

	w = [g stringWidth:[userAgent1 str]];
	if( (w - [g getWidth]) > 0 )
	{
		[g drawString:[userAgent1 str] :(0 - ((elapse * 3) % w)) :([g getHeight] - (LOG_HEIGHT + (FONT_SIZE + 3) * 2))];
	}
	else
	{
		[g drawString:[userAgent1 str] :0 :([g getHeight] - (LOG_HEIGHT + (FONT_SIZE + 3) * 2))];
	}

	w = [g stringWidth:[userAgent2 str]];
	if( (w - [g getWidth]) > 0 )
	{
		[g drawString:[userAgent2 str] :(0 - ((elapse * 3) % w)) :([g getHeight] - (LOG_HEIGHT + FONT_SIZE + 3))];
	}
	else
	{
		[g drawString:[userAgent2 str] :0 :([g getHeight] - (LOG_HEIGHT + FONT_SIZE + 3))];
	}

	w = [g stringWidth:[url str]];
	if( (w - [g getWidth]) > 0 )
	{
		[g drawString:[url str] :(0 - ((elapse * 3) % w)) :([g getHeight] - (LOG_HEIGHT + 3))];
	}
	else
	{
		[g drawString:[url str] :0 :([g getHeight] - (LOG_HEIGHT + 3))];
	}

	[g drawLine:0 :([g getHeight] - (LOG_HEIGHT + 3)) :[g getWidth] :([g getHeight] - (LOG_HEIGHT + 3))];

	NSString* str;
	[m->log beginGet];
	while( (str = [m->log get]) != nil )
	{
		[g drawString:str :0 :([g getHeight] - LOG_HEIGHT + (FONT_SIZE * [m->log lineNum]))];
	}

	[g unlock];

	elapse++;
}

- (BOOL)_onWebViewShouldStartLoad:(NSString*)_url :(NSString*)mainUrl
{
	[url set:_url];
	elapse = 0;

	_String* tmp = [[_String alloc] init];
	[m->log add:[[[tmp set:@"H "] add:[url str]] str]];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC

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
	elapse = 0;

	_String* tmp = [[_String alloc] init];
	[m->log add:[[[tmp set:@"S "] add:[url str]] str]];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
}

- (void)_onWebViewFinishLoad:(id)_webView
{
	_String* tmp = [[_String alloc] init];
	[m->log add:[[[tmp set:@"F "] add:[url str]] str]];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
}

- (void)_onWebViewLoadError:(NSError*)error :(id)_webView
{
	_String* tmp = [[_String alloc] init];
	[m->log add:[[[tmp set:@"E "] add:[url str]] str]];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
}

@end
