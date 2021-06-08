#import <Foundation/Foundation.h>

#import "_Canvas.h"

@class _ScalableGraphics;
@class _Sound;
@class _String;
@class _WebView;
@class AppDelegate;

@interface MyCanvas : _Canvas
{
	AppDelegate* m;

	_ScalableGraphics* g;

	_WebView* webView;

	_String* userAgent1;
	_String* userAgent2;
	_String* url;
	int elapse;

	_Sound* sound;
}
@end
