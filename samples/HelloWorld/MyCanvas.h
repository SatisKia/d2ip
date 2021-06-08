#import <Foundation/Foundation.h>

#import "_Canvas.h"

@interface MyCanvas : _Canvas
{
	NSString* str;
	int w, h;
	int x, y;
	int dx, dy;

	int elapse;
}
@end
