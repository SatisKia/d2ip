/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef NO_CANVAS
@class _Canvas;
#endif // NO_CANVAS

// 画面の向き
#define ORIENTATION_NOSENSOR	0
#define ORIENTATION_LANDSCAPE	1
#define ORIENTATION_PORTRAIT	2

@interface _Main : UIResponder <UIApplicationDelegate>
{
@private
	BOOL _apply_scale;

	int _width;
	int _height;

	UIWindow* _window;
	UIViewController* _view_controller;
#ifndef NO_CANVAS
	_Canvas* _canvas;
#endif // NO_CANVAS
	UIView* _view;

	NSMutableDictionary* _params;

	BOOL _active;
}

- (void)_setApplyScale:(BOOL)flag;
- (void)setApplyScale:(BOOL)flag;
- (BOOL)applyScale;
- (int)getWidth;
- (int)getHeight;
- (BOOL)_isActive;
- (UIWindow*)getWindow;
- (UIViewController*)getViewController;
- (UIInterfaceOrientation)getOrientation;
#ifndef NO_CANVAS
- (void)setCurrent:(_Canvas*)canvas;
- (_Canvas*)getCurrent;
#endif // NO_CANVAS
- (void)setView:(UIView*)view;
- (UIView*)getView;
#ifndef NO_CANVAS
- (void)addCanvas:(_Canvas*)canvas;
#endif // NO_CANVAS
- (NSString*)getParameter:(NSString*)name;
- (NSString*)getParameter:(NSString*)name defString:(NSString*)defString;
- (int)getParameter:(NSString*)name defInteger:(int)defInteger;
- (NSURL*)resourceURL:(NSString*)name;
- (BOOL)launch:(NSString*)name :(NSArray*)args;
- (void)openBrowser:(NSString*)url;
- (NSString*)getUserAgentString;
- (void)setUserAgentString:(NSString*)ua;

- (UIColor*)_backgroundColor;
- (int)_orientation;
- (BOOL)_fullScreen;
- (BOOL)_applyScale;

- (void)_start;
- (void)_destroy;
- (void)_suspend;
- (void)_resume;

- (void)_onOrientationChange:(UIInterfaceOrientation)orientation;

// _AudioQueue クラス用
- (int)_volumeAudioQueue;

// _GameCenter クラス用
- (void)_gameCenterAuthOK;
- (void)_gameCenterAuthNG;
- (void)_gameCenterReportAchievementOK:(NSString*)identifier :(float)percent;
- (void)_gameCenterReportAchievementNG:(NSString*)identifier :(float)percent;
- (void)_gameCenterCloseAchievementView;
- (void)_gameCenterReportScoreOK:(NSString*)category :(int64_t)score;
- (void)_gameCenterReportScoreNG:(NSString*)category :(int64_t)score;
- (void)_gameCenterCloseLeaderboardView;

// _Geolocation クラス用
- (void)_onGeolocation:(int)code;

// _HttpRequest クラス用
- (void)_onHttpResponse:(NSData*)data;
- (void)_onHttpError:(int)status;

// _InAppPurchase クラス用
- (void)_inAppPurchaseInvalid:(NSString*)identifier;
- (void)_inAppPurchasePurchaseOK:(NSString*)identifier :(NSData*)receipt;
- (void)_inAppPurchasePurchaseNG:(NSString*)identifier;
- (void)_inAppPurchaseRestoreOK:(NSString*)identifier;
- (void)_inAppPurchaseRestoreNG;
- (void)_inAppPurchaseRestoreCompleted;
- (void)_inAppPurchaseCancelled:(NSString*)identifier;

// _Music クラス用
- (int)_volumeMusic;
- (void)_musicComplete:(id)music;

// _SafariView クラス用
- (void)_onSafariViewStart;
- (void)_onSafariViewFinish;

// _Sound クラス用
- (int)_volumeSound;

// _Twitter クラス用
- (void)_twitterAuthOK;
- (void)_twitterAuthNG;
- (void)_twitterTweetOK;
- (void)_twitterTweetNG:(int)status;
- (void)_twitterCloseTweetComposeView;

// _WebView クラス用
- (BOOL)_onWebViewShouldStartLoad:(NSString*)url :(NSString*)mainUrl;
- (void)_onWebViewStartLoad:(NSString*)url :(NSString*)mainUrl;
- (void)_onWebViewFinishLoad:(id)webView;
- (void)_onWebViewLoadError:(NSError*)error :(id)webView;

@end
