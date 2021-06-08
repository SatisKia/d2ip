#import <Foundation/Foundation.h>

#import "_Canvas.h"

@class _Geolocation;

@interface MyCanvas : _Canvas
{
	_Geolocation* geolocation;
	int code;
	int elapse;
	NSDateFormatter* formatter;
}

- (void)_suspend;
- (void)_resume;

@end
