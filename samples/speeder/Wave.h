#import <Foundation/Foundation.h>

@class _Vector;
@class MyCanvas;

/*
 * ウェーブ
 */
@interface Wave : NSObject
{
	MyCanvas* _m;

	_Vector* bar;	// バー情報
}

- (id)initWithCanvas:(MyCanvas*)m;
- (void)create;
- (void)add_bar:(int)x :(int)y :(int)col :(int)count :(BOOL)border;
- (void)add_bar:(int)x :(int)y :(int)col;
- (BOOL)clear;
- (int)top_x;
- (int)bottom_x;
- (void)update;
- (int)draw;

@end
