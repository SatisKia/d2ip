#import <Foundation/Foundation.h>

@class MyCanvas;

/*
 * スピーダー
 */
@interface Speeder : NSObject
{
	MyCanvas* _m;

	BOOL _jiki;	// 自機かどうか
	int _type;		// 種類
	int _auto;		// 自動移動の種類
	int _distance;	// 走行距離
	int _speed;		// スピード
	int _x, off_x;	// 位置
	BOOL _out;	// 画面外かどうか
	int _direction;	// 移動の状態
	int _shield;	// シールドの状態
}

- (id)initWithCanvas:(MyCanvas*)m;
- (void)_init:(BOOL)jiki :(int)type :(int)speed :(int)x;
- (void)left;
- (void)right;
- (void)inertia:(BOOL)neutral;
- (void)set_direction:(int)target;
- (void)slide:(int)val;
- (void)out:(int)bar_x;
- (void)in:(int)bar_x;
- (BOOL)out;
- (int)type;
- (void)auto:(int)type;
- (int)auto;
- (void)add_distance:(int)val;
- (int)distance;
- (void)speed_up:(int)val;
- (void)speed_up;
- (void)speed_down:(int)val;
- (void)speed_down;
- (void)speed_limit:(int)val;
- (int)speed;
- (void)shield:(int)col;
- (int)shield;
- (int)x;
- (int)dsp_x;
- (int)dsp_y;
- (int)direction;
- (void)draw:(BOOL)ready;

@end
