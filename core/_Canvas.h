/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "_Graphics.h"

@class _Layout;
@class _Main;

// イベント
#define TOUCH_DOWN_EVENT	0
#define TOUCH_MOVE_EVENT	1
#define TOUCH_UP_EVENT		2
#define LAYOUT_DOWN_EVENT	3
#define LAYOUT_UP_EVENT		4

@interface _Canvas : UIView
{
@private
	BOOL _apply_scale;
	BOOL _apply_scale_f;

	NSTimer* _timer;

	_Main* _m;

	int _frame_width;
	int _frame_height;
	CGSize _size;

	UIImageView* _view;
	_Graphics* _g;

	// ウィンドウ設定
	int _win_left;
	int _win_top;
	int _win_right;
	int _win_bottom;
	int _win_width;
	int _win_height;

	// レイアウト
	_Layout* _layout;

	// タッチイベント用
	NSMutableArray* _touch;

	BOOL _init_f;
	BOOL _hide_f;
}

- (id)initWithMain:(_Main*)m;
- (void)_setApplyScale:(BOOL)flag;
- (void)_setApplyScale;
- (BOOL)_applyScaleFlag;
- (BOOL)_applyScale;
- (BOOL)_initFlag;
- (BOOL)_hideFlag;
- (void)_setHide:(BOOL)flag;
- (void)_setTimer:(_Main*)m;
- (void)_killTimer;
- (void)_prePaint;
- (void)_lock;
- (void)_unlock;
- (_Main*)getMain;
- (int)_getFrameWidth;
- (int)_getFrameHeight;
- (int)getWidth;
- (int)getHeight;
- (_Graphics*)getGraphics;
- (void)clearTouch;
- (int)getTouchNum;
- (int)getTouchX:(int)index;
- (int)getTouchY:(int)index;
- (void)setWindow:(int)left :(int)top :(int)right :(int)bottom :(int)width :(int)height;
- (void)setWindow:(int)width :(int)height;
- (int)getWindowLeft;
- (int)getWindowTop;
- (int)getWindowRight;
- (int)getWindowBottom;
- (int)windowX:(int)x;
- (int)windowY:(int)y;
- (int)screenX:(int)x;
- (int)screenY:(int)y;
- (int)screenWidth:(int)width;
- (int)screenHeight:(int)height;
- (void)setLayout:(_Layout*)layout;
- (BOOL)_setLayoutEvent:(int)type :(int)index;
- (int)getLayoutState;
- (void)drawLayout:(_Graphics*)g;
- (void)addView:(UIView*)view :(int)tag;
- (void)removeView:(int)tag;

- (int)_frameTime;
- (int)_touchNum;

- (void)_init;
- (void)_end;
- (void)_paint:(_Graphics*)g;
- (void)_suspend;
- (void)_resume;
- (void)_hide;
- (void)_show;
- (void)_processEvent:(int)type :(int)param;

- (void)_onOrientationChange:(UIInterfaceOrientation)orientation;

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
- (void)_musicComplete:(id)music;

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
