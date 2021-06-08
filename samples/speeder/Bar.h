#import <Foundation/Foundation.h>

@class MyCanvas;

/*
 * バー
 */
@interface Bar : NSObject
{
	MyCanvas* _m;

	int _x, _y;
	int _col;
	int _count;
	BOOL _border;
	BOOL _hit[3];
}

- (id)initWithCanvas:(MyCanvas*)m :(int)x :(int)y :(int)col :(int)count :(BOOL)border;
- (int)x;
- (int)y;
- (int)col;
- (int)count;
- (BOOL)update;

@end
