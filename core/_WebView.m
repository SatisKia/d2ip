/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_WebView.h"

#ifndef NO_CANVAS
#import "_Canvas.h"
#endif // NO_CANVAS
#import "_Main.h"

@implementation _WebView

- (id)initWithMain:(_Main*)m
{
	self = [super init];
	if( self != nil )
	{
		_m = m;

		_web_view = [[UIWebView alloc] init];
		_web_view.delegate = self;

		_cache = YES;
		_timeout = 60.0f;

		_load_count = 0;
	}
	return self;
}

- (void)dealloc
{
	_web_view.delegate = nil;
	if( [_web_view isLoading] )
	{
		[_web_view stopLoading];
	}
#ifdef NO_OBJC_ARC
	[_web_view release];
#endif // NO_OBJC_ARC

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (UIWebView*)getView
{
	return _web_view;
}

- (void)addView:(UIView*)view :(int)tag
{
	view.tag = tag;
	[_web_view addSubview:view];
#ifdef NO_OBJC_ARC
	[view release];
#endif // NO_OBJC_ARC
}
- (void)removeView:(int)tag
{
	for( UIView* subview in _web_view.subviews )
	{
		if( subview.tag == tag )
		{
			[subview removeFromSuperview];
			break;
		}
	}
}

- (void)setCache:(BOOL)cache
{
	_cache = cache;
}

- (void)setTimeout:(float)timeout
{
	_timeout = timeout;
}

- (void)setAutoresizingMask:(UIViewAutoresizing)autoresizingMask
{
	_web_view.autoresizingMask = autoresizingMask;
}
- (void)setBackgroundColor:(UIColor*)color
{
	_web_view.backgroundColor = color;
}
- (void)setFrame:(CGRect)frame
{
	_web_view.frame = frame;
}
- (void)setOpaque:(BOOL)opaque
{
	_web_view.opaque = opaque;
}
- (void)setScalesPageToFit:(BOOL)scalesPageToFit
{
	_web_view.scalesPageToFit = scalesPageToFit;
}

- (NSString*)getUserAgentString
{
	return [_web_view stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
}

- (void)clearCache
{
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)loadURL:(NSString*)url
{
	[_web_view loadRequest:[NSURLRequest
		requestWithURL:[NSURL URLWithString:url]
		cachePolicy:(_cache ? NSURLRequestUseProtocolCachePolicy : NSURLRequestReloadIgnoringLocalCacheData)
		timeoutInterval:_timeout
		]];
}

- (void)loadResource:(NSString*)name
{
	NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
	if( path != nil )
	{
		[_web_view loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
	}
}

- (void)callScript:(NSString*)script
{
	[_web_view stringByEvaluatingJavaScriptFromString:script];
}

/*
 * 新しい URL が指定されたときの処理
 */
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSString* url     = [[request URL] absoluteString];
	NSString* mainUrl = [[request mainDocumentURL] absoluteString];

	if( [_m _onWebViewShouldStartLoad:url :mainUrl] )
	{
		return NO;
	}
#ifndef NO_CANVAS
	if( [_m getCurrent] != nil )
	{
		if( [[_m getCurrent] _onWebViewShouldStartLoad:url :mainUrl] )
		{
			return NO;
		}
	}
#endif // NO_CANVAS

	[_m _onWebViewStartLoad:url :mainUrl];
#ifndef NO_CANVAS
	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] _onWebViewStartLoad:url :mainUrl];
	}
#endif // NO_CANVAS

	return YES;
}

/*
 * ページ読み込み開始時の処理
 */
- (void)webViewDidStartLoad:(UIWebView*)webView
{
	_load_count++;
}

/*
 * ページ読み込み完了時の処理
 */
- (void)webViewDidFinishLoad:(UIWebView*)webView
{
	if( _load_count > 0 )
	{
		_load_count--;
		if( _load_count == 0 )
		{
			[_m _onWebViewFinishLoad:self];
#ifndef NO_CANVAS
			if( [_m getCurrent] != nil )
			{
				[[_m getCurrent] _onWebViewFinishLoad:self];
			}
#endif // NO_CANVAS
		}
	}
}

/*
 * ページ読み込みエラー時の処理
 */
- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
	if( _load_count > 0 )
	{
		_load_count--;
	}

	[_m _onWebViewLoadError:error :self];
#ifndef NO_CANVAS
	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] _onWebViewLoadError:error :self];
	}
#endif // NO_CANVAS
}

- (NSString*)getTitle
{
	return [_web_view stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (NSString*)getURL
{
	return [_web_view stringByEvaluatingJavaScriptFromString:@"document.URL"];
}

- (BOOL)canGoBack
{
	return [_web_view canGoBack];
}

- (void)goBack
{
	[_web_view goBack];
}

- (BOOL)canGoForward
{
	return [_web_view canGoForward];
}

- (void)goForward
{
	[_web_view goForward];
}

- (void)loadCookie:(NSString*)key
{
	NSData* cookiesData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	if( cookiesData != nil )
	{
		NSArray* cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesData];
		for( NSHTTPCookie* cookie in cookies )
		{
			[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
		}
	}
}

- (void)saveCookie:(NSString*)key
{
	NSData* cookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
	NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
	[pref setObject:cookiesData forKey:key];
	[pref synchronize];
}

@end
