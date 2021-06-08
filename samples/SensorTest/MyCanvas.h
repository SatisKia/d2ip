#import <Foundation/Foundation.h>

#import "_Canvas.h"

@class _Sensor;

@interface MyCanvas : _Canvas
{
	_Sensor* sensor;
}

- (void)_suspend;
- (void)_resume;

@end
