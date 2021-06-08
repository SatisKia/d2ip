#import <Foundation/Foundation.h>

#import "_Main.h"

@class _Sound;
@class _String;
@class _WebView;

@interface AppDelegate : _Main
{
@private
	_WebView* webView;

	_String* url;

	_Sound* sound;
}
@end
