#import <Foundation/Foundation.h>

@class _Vector;
@class MyCanvas;

/*
 * ステージ
 */
@interface Stage : NSObject
{
	MyCanvas* _m;

	int _back;// = -1;		// 背景の種類
	int _col;			// ウェーブの色
	int old_distance;
	int x, _move_x, _offset_x;
	BOOL counter;
	int bar;
	_Vector* star;		// 星情報
}

- (id)initWithCanvas:(MyCanvas*)m;
- (void)create;
- (void)update;
- (int)col;
- (int)move_x;
- (int)offset_x;
- (void)draw:(BOOL)ready;

@end
