/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class _Main;

@interface _WebView : NSObject <UIWebViewDelegate>
{
@private
	_Main* _m;

	UIWebView* _web_view;

	BOOL _cache;
	float _timeout;

	int _load_count;
}

- (id)initWithMain:(_Main*)m;
- (UIWebView*)getView;
- (void)addView:(UIView*)view :(int)tag;
- (void)removeView:(int)tag;
- (void)setCache:(BOOL)cache;
- (void)setTimeout:(float)timeout;
- (void)setAutoresizingMask:(UIViewAutoresizing)autoresizingMask;
- (void)setBackgroundColor:(UIColor*)color;
- (void)setFrame:(CGRect)frame;
- (void)setOpaque:(BOOL)opaque;
- (void)setScalesPageToFit:(BOOL)scalesPageToFit;
- (NSString*)getUserAgentString;
- (void)clearCache;
- (void)loadURL:(NSString*)url;
- (void)loadResource:(NSString*)name;
- (void)callScript:(NSString*)script;
- (NSString*)getTitle;
- (NSString*)getURL;
- (BOOL)canGoBack;
- (void)goBack;
- (BOOL)canGoForward;
- (void)goForward;
- (void)loadCookie:(NSString*)key;
- (void)saveCookie:(NSString*)key;

@end
