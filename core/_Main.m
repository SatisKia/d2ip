/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Main.h"

#ifndef NO_CANVAS
#import "_Canvas.h"
#endif // NO_CANVAS

@interface _MainViewController : UIViewController
{
@private
	_Main* _m;
}

- (id)initWithMain:(_Main*)m;

@end

@implementation _MainViewController

- (id)initWithMain:(_Main*)m
{
	self = [super init];
	if( self != nil )
	{
		_m = m;
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	if( [_m _orientation] == ORIENTATION_LANDSCAPE )
	{
		return ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight));
	}
	else if( [_m _orientation] == ORIENTATION_PORTRAIT )
	{
		return ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown));
	}
	return NO;
}

- (BOOL)shouldAutorotate
{
	return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
	if( [_m _orientation] == ORIENTATION_LANDSCAPE )
	{
		return ((1 << UIInterfaceOrientationLandscapeLeft) | (1 << UIInterfaceOrientationLandscapeRight));
	}
	else if( [_m _orientation] == ORIENTATION_PORTRAIT )
	{
		return ((1 << UIInterfaceOrientationPortrait) | (1 << UIInterfaceOrientationPortraitUpsideDown));
	}
	return 0;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toOrientation duration:(NSTimeInterval)duration
{
	[_m _onOrientationChange:toOrientation];
#ifndef NO_CANVAS
	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] _onOrientationChange:toOrientation];
	}
#endif // NO_CANVAS
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromOrientation
{
}

@end

@implementation _Main

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url
{
#ifdef NO_OBJC_ARC
	if( _params != nil )
	{
		[_params release];
	}
#endif // NO_OBJC_ARC

	NSArray* params = [[url query] componentsSeparatedByString:@"&"];
	_params = [[NSMutableDictionary alloc] init];
	for( NSString* param in params )
	{
		NSArray* tmp = [param componentsSeparatedByString:@"="];
		if( ([tmp count] == 2) && ([(NSString*)[tmp objectAtIndex:0] length] > 0) )
		{
			[_params
				setObject:[(NSString*)[tmp objectAtIndex:1]
				stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
				forKey:(NSString*)[tmp objectAtIndex:0]
				];
		}
	}

	return NO;
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)options
{
	if( [self _fullScreen] )
	{
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
	}

	if( options != nil )
	{
		NSURL* url = [options objectForKey:UIApplicationLaunchOptionsURLKey];
		if( url != nil )
		{
			[self application:application handleOpenURL:url];
		}
	}

	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_window.backgroundColor = [self _backgroundColor];
	[_window makeKeyAndVisible];

	_view_controller = [[_MainViewController alloc] initWithMain:self];
	if( [self _applyScale] )
	{
		_view_controller.view.contentScaleFactor = [UIScreen mainScreen].scale;
	}
	[_window addSubview:_view_controller.view];

#ifndef NO_CANVAS
	_canvas = nil;
#endif // NO_CANVAS
	_view = nil;

	[self _start];

	return NO;
}

- (id)init
{
	self = [super init];
	if( self != nil )
	{
		_apply_scale = [self _applyScale];

		CGRect frame;
		if( [self _fullScreen] )
		{
			frame = [[UIScreen mainScreen] bounds];
		}
		else
		{
			frame = [[UIScreen mainScreen] applicationFrame];
		}
		float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
		if( (iOSVersion < 8.0) && ([self _orientation] == ORIENTATION_LANDSCAPE) )
		{
			_width  = frame.size.height;
			_height = frame.size.width;
		}
		else
		{
			_width  = frame.size.width;
			_height = frame.size.height;
		}

		_params = nil;

		_active = YES;
	}
	return self;
}

- (void)dealloc
{
	[self _destroy];

#ifdef NO_OBJC_ARC
	if( _params != nil )
	{
		[_params release];
	}
#endif // NO_OBJC_ARC

#ifdef NO_OBJC_ARC
	[_window release];
	[_view_controller release];
#endif // NO_OBJC_ARC

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (void)applicationWillResignActive:(UIApplication*)application
{
	if( _active )
	{
		_active = NO;

		[self _suspend];

#ifndef NO_CANVAS
		if( _canvas != nil )
		{
			[_canvas _suspend];

			[_canvas clearTouch];
		}
#endif // NO_CANVAS
	}
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
	if( !_active )
	{
		[self _resume];

#ifndef NO_CANVAS
		if( _canvas != nil )
		{
			[_canvas _resume];
		}
#endif // NO_CANVAS

		_active = YES;
	}
}

- (void)_setApplyScale:(BOOL)flag
{
	if( flag != _apply_scale )
	{
		_apply_scale = flag;

		_view_controller.view.contentScaleFactor = _apply_scale ? [UIScreen mainScreen].scale : 1.0f;
	}
}

- (void)setApplyScale:(BOOL)flag
{
#ifndef NO_CANVAS
	if( _canvas != nil )
	{
		[_canvas _setApplyScale:flag];
	}
	else
	{
#endif // NO_CANVAS
		[self _setApplyScale:flag];
#ifndef NO_CANVAS
	}
#endif // NO_CANVAS
}

- (BOOL)applyScale
{
	return _apply_scale;
}

- (int)getWidth
{
	return _width;
}
- (int)getHeight
{
	return _height;
}

- (BOOL)_isActive
{
	return _active;
}

- (UIWindow*)getWindow
{
	return _window;
}

- (UIViewController*)getViewController
{
	return _view_controller;
}

- (UIInterfaceOrientation)getOrientation
{
	return [[UIApplication sharedApplication] statusBarOrientation];
}

#ifndef NO_CANVAS
- (void)setCurrent:(_Canvas*)canvas
{
	if( _view != nil )
	{
		return;
	}

	if( _canvas != nil )
	{
		[_canvas _setHide:YES];
		[_canvas clearTouch];
		[_canvas _killTimer];
	}

	_canvas = canvas;
	_view_controller.view = _canvas;
	for( UIView* subview in _window.subviews )
	{
		[subview removeFromSuperview];
	}
	[_window setRootViewController:_view_controller];

	[_canvas _setApplyScale:_apply_scale];
	if( [_canvas _hideFlag] )
	{
		[_canvas _setHide:NO];
	}
	[_canvas _setTimer:self];
}

- (_Canvas*)getCurrent
{
	return _canvas;
}
#endif // NO_CANVAS

- (void)setView:(UIView*)view
{
#ifndef NO_CANVAS
	if( _canvas != nil )
	{
		return;
	}
#endif // NO_CANVAS
	_view = view;
	_view_controller.view = _view;
	[_window setRootViewController:_view_controller];
}

- (UIView*)getView
{
	return _view;
}

#ifndef NO_CANVAS
- (void)addCanvas:(_Canvas*)canvas
{
	if( _view == nil )
	{
		return;
	}

	if( _canvas != nil )
	{
		return;
	}

	_canvas = canvas;
	[_view addSubview:_canvas];
#ifdef NO_OBJC_ARC
	[_canvas release];
#endif // NO_OBJC_ARC

	[_canvas _setApplyScale:_apply_scale];
	[_canvas _setTimer:self];
}
#endif // NO_CANVAS

- (NSString*)getParameter:(NSString*)name
{
	if( _params != nil )
	{
		return [_params objectForKey:name];
	}
	return nil;
}
- (NSString*)getParameter:(NSString*)name defString:(NSString*)defString
{
	NSString* string = [self getParameter:name];
	if( string != nil )
	{
		return string;
	}
	return defString;
}
- (int)getParameter:(NSString*)name defInteger:(int)defInteger
{
	NSString* string = [self getParameter:name];
	if( string != nil )
	{
		return [string intValue];
	}
	return defInteger;
}

- (NSURL*)resourceURL:(NSString*)name
{
	NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
	if( path != nil )
	{
		return [NSURL fileURLWithPath:path];
	}
	return nil;
}

- (BOOL)launch:(NSString*)name :(NSArray*)args
{
	NSMutableString* url = [[NSMutableString alloc] initWithString:name];
	[url appendString:@"://localhost/"];
	if( args != nil )
	{
		for( int i = 0; i < [args count] / 2; i++ )
		{
			[url appendString:((i == 0) ? @"?" : @"&")];
			[url appendString:[args objectAtIndex:i * 2]];
			[url appendString:@"="];
#if !defined( NO_OBJC_ARC )
@autoreleasepool
{
#endif // !defined( NO_OBJC_ARC )
#ifdef NO_OBJC_ARC
			NSString* tmp = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(
#else
			NSString* tmp = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(
#endif // NO_OBJC_ARC
				kCFAllocatorDefault,
				(__bridge CFStringRef)[args objectAtIndex:i * 2 + 1],
				NULL,
				CFSTR( "!*'();:@&=+$,/?%#[]" ),
				kCFStringEncodingUTF8
				);
			[url appendString:tmp];
#ifdef NO_OBJC_ARC
			[tmp release];
#endif // NO_OBJC_ARC
#if !defined( NO_OBJC_ARC )
}
#endif // !defined( NO_OBJC_ARC )
		}
	}
	NSURL* url2 = [NSURL URLWithString:url];
#ifdef NO_OBJC_ARC
	[url release];
#endif // NO_OBJC_ARC
	if( [[UIApplication sharedApplication] canOpenURL:url2] )
	{
		[[UIApplication sharedApplication] openURL:url2];
		return YES;
	}
	return NO;
}

- (void)openBrowser:(NSString*)url
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (NSString*)getUserAgentString
{
	UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
	NSString* string = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
#ifdef NO_OBJC_ARC
	[webView release];
#endif // NO_OBJC_ARC
	return string;
}

- (void)setUserAgentString:(NSString*)ua
{
	NSDictionary* dictionary = [NSDictionary dictionaryWithObject:ua forKey:@"UserAgent"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (UIColor*)_backgroundColor { return [UIColor whiteColor]; }
- (int)_orientation { return ORIENTATION_NOSENSOR; }
- (BOOL)_fullScreen { return NO; }
- (BOOL)_applyScale { return NO; }

- (void)_start {}
- (void)_destroy {}
- (void)_suspend {}
- (void)_resume {}

- (void)_onOrientationChange:(UIInterfaceOrientation)orientation {}

- (int)_volumeAudioQueue { return 100; }

- (void)_gameCenterAuthOK {}
- (void)_gameCenterAuthNG {}
- (void)_gameCenterReportAchievementOK:(NSString*)identifier :(float)percent {}
- (void)_gameCenterReportAchievementNG:(NSString*)identifier :(float)percent {}
- (void)_gameCenterCloseAchievementView {}
- (void)_gameCenterReportScoreOK:(NSString*)category :(int64_t)score {}
- (void)_gameCenterReportScoreNG:(NSString*)category :(int64_t)score {}
- (void)_gameCenterCloseLeaderboardView {}

- (void)_onGeolocation:(int)code {}

- (void)_onHttpResponse:(NSData*)data {}
- (void)_onHttpError:(int)status {}

- (void)_inAppPurchaseInvalid:(NSString*)identifier {}
- (void)_inAppPurchasePurchaseOK:(NSString*)identifier :(NSData*)receipt {}
- (void)_inAppPurchasePurchaseNG:(NSString*)identifier {}
- (void)_inAppPurchaseRestoreOK:(NSString*)identifier {}
- (void)_inAppPurchaseRestoreNG {}
- (void)_inAppPurchaseRestoreCompleted {}
- (void)_inAppPurchaseCancelled:(NSString*)identifier {}

- (int)_volumeMusic { return 100; }
- (void)_musicComplete:(id)music {}

- (int)_volumeSound { return 100; }

- (void)_twitterAuthOK {}
- (void)_twitterAuthNG {}
- (void)_twitterTweetOK {}
- (void)_twitterTweetNG:(int)status {}
- (void)_twitterCloseTweetComposeView {}

- (BOOL)_onWebViewShouldStartLoad:(NSString*)url :(NSString*)mainUrl { return NO; }
- (void)_onWebViewStartLoad:(NSString*)url :(NSString*)mainUrl {}
- (void)_onWebViewFinishLoad:(id)webView {}
- (void)_onWebViewLoadError:(NSError*)error :(id)webView {}

@end
