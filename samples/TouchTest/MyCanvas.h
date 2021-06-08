#import <Foundation/Foundation.h>

#import "_Canvas.h"

@class _EventStep;

#define TOUCH_NUM	4

@interface MyCanvas : _Canvas
{
	int touch_down;
	BOOL touch_down_f;
	int touch_move;
	BOOL touch_move_f;
	int touch_up;
	BOOL touch_up_f;

	_EventStep* touchStep;
}

@end
