#import <Foundation/Foundation.h>

#import "_Canvas.h"

@interface MyCanvas : _Canvas
{
	int step_s, step_r;
	int elapse;
	NSMutableArray* args;
	NSMutableString* error;
}
@end
