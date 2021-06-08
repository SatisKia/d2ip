#import <Foundation/Foundation.h>

#import "_Canvas.h"

@class _Image;

@interface MyCanvas : _Canvas
{
	_Image* img;
	int step;
	int x, y;
	int angle;
}
@end
