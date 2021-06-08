#import <Foundation/Foundation.h>

#import "_Main.h"

#define LOG_NUM	20

@class _Log;
@class MyCanvas;

@interface AppDelegate : _Main
{
@public
	_Log* log;

	MyCanvas* canvas;
}
@end
