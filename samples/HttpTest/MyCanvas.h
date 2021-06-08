#import <Foundation/Foundation.h>

#import "_Canvas.h"

@class _HttpRequest;

@interface MyCanvas : _Canvas
{
	_HttpRequest* http;

	NSString* server;

	NSMutableString* str1;
	NSMutableString* str2;

	int step;
	int elapse;
}
@end
