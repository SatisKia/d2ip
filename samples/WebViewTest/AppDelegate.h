#import <Foundation/Foundation.h>

#import "_Main.h"

#define LOG_NUM		5
#define FONT_SIZE	20
#define LOG_HEIGHT	(LOG_NUM * FONT_SIZE)

@class _Log;
@class MyCanvas;

@interface AppDelegate : _Main
{
@public
	_Log* log;

	MyCanvas* canvas;
}
@end
