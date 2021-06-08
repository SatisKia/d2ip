#import <Foundation/Foundation.h>

@class MyCanvas;

/*
 * 星
 */
@interface Star : NSObject
{
	MyCanvas* _m;

	int _x, _y;
}

- (id)initWithCanvas:(MyCanvas*)m :(int)x :(int)y;
- (int)x;
- (int)y;
- (BOOL)update;

@end
