#import "Speeder.h"

#import "MyCanvas.h"
#import "Speeder.h"
#import "Stage.h"

/*
 * スピーダー
 */
@implementation Speeder

- (id)initWithCanvas:(MyCanvas*)m
{
	self = [super init];
	if ( self ) {
		_m = m;
	}
	return self;
}

#ifdef NO_OBJC_ARC
- (void)dealloc
{
	[super dealloc];
}
#endif // NO_OBJC_ARC

/*
 * 初期化
 */
- (void)_init:(BOOL)jiki :(int)type :(int)speed :(int)x
{
	_jiki      = jiki;
	_type      = type;
	_auto      = AUTO_INERTIA;
	_distance  = 0;
	_speed     = speed;
	_x         = x - 12;
	_out       = NO;
	_direction = 0;
	_shield    = 0;
}

/*
 * 左移動
 */
- (void)left
{
	switch ( _type ) {
	case SPEEDER1: _direction -= 1; break;
	case SPEEDER2: _direction -= 1; break;
	case SPEEDER3: _direction -= 2; break;
	case SPEEDER4: _direction -= 1; break;
	case SPEEDER5: _direction -= 1; break;
	}
	if ( _direction < -15 ) _direction = -15;
	_x += _direction;
}

/*
 * 右移動
 */
- (void)right
{
	switch ( _type ) {
	case SPEEDER1: _direction += 1; break;
	case SPEEDER2: _direction += 1; break;
	case SPEEDER3: _direction += 2; break;
	case SPEEDER4: _direction += 1; break;
	case SPEEDER5: _direction += 1; break;
	}
	if ( _direction > 15 ) _direction = 15;
	_x += _direction;
}

/*
 * 慣性移動
 */
- (void)inertia:(BOOL)neutral
{
	if ( neutral ) {
		if ( _direction > 0 ) {
			_direction--;
		} else if ( _direction < 0 ) {
			_direction++;
		}
	}
	_x += _direction;
}

/*
 *
 */
- (void)set_direction:(int)target
{
	if ( _direction < target ) {
		[self right];
	} else if ( _direction > target ) {
		[self left];
	}
}

- (void)slide:(int)val { _x += val; }

- (void)out:(int)bar_x
{
	off_x = _x - bar_x;
	_out = YES;
}
- (void)in:(int)bar_x
{
	if      ( off_x <   0 ) off_x =   0;
	else if ( off_x > 176 ) off_x = 176;
	_x = bar_x + off_x;
	_out = NO;
	if ( !_jiki ) {
		_direction = ([_m->stage move_x] * 15) / 24;
	}
}
- (BOOL)out { return _out; }

- (int)type { return _type; }

// 自動移動の種類を変更
- (void)auto:(int)type { _auto = type; }

// 自動移動の種類を確認
- (int)auto { return _auto; }

// 走行距離を変更
- (void)add_distance:(int)val { _distance += val; }

// 走行距離を確認
- (int)distance { return _distance; }

/*
 * スピードを上げる
 */
- (void)speed_up:(int)val
{
	_speed += val;
	if ( _speed > 505 ) _speed = 495;
}
- (void)speed_up
{
	switch ( _type ) {
	case SPEEDER1:
	case SPEEDER4:
	case SPEEDER5:
		[self speed_up:5];
		break;
	case SPEEDER2:
		[self speed_up:4];
		break;
	case SPEEDER3:
		[self speed_up:3];
		break;
	}
}

/*
 * スピードを落とす
 */
- (void)speed_down:(int)val
{
	_speed -= val;
	if ( _speed < 0 ) _speed = 0;
}
- (void)speed_down
{
	switch ( _type ) {
	case SPEEDER1:
	case SPEEDER4:
	case SPEEDER5:
		[self speed_down:25];
		break;
	case SPEEDER2:
		[self speed_down:20];
		break;
	case SPEEDER3:
		[self speed_down:25];
		break;
	}
}

/*
 * スピードを制限する
 */
- (void)speed_limit:(int)val
{
	if ( _speed > val ) _speed = val;
}

// スピードを確認
- (int)speed { return _speed; }

// シールドの状態を変更
- (void)shield:(int)col
{
	_shield = col;
	if ( _jiki && (_m->_elapse_s > 0) && (_shield == [_m->stage col]) ) {
		if ( _m->_elapse_s <= 20 ) {
			_m->shield_lag[_m->shield_index] = (_m->shield_lag[_m->shield_index] + _m->_elapse_s) / 2;
			_m->shield_index++; if ( _m->shield_index > 1 ) _m->shield_index = 0;
		}
		_m->_elapse_s = 0;
	}
}

// シールドの状態を確認
- (int)shield { return _shield; }

// 位置を確認
- (int)x { return _x; }
- (int)dsp_x { return _jiki ? 108 : (108 + (_x - [_m->speeder[0] x])); }
- (int)dsp_y { return _jiki ? 192 : (192 - (_distance - [_m->speeder[0] distance]) / 10); }

// 移動の状態を確認
- (int)direction { return _direction; }

/*
 * 描画
 */
- (void)draw:(BOOL)ready
{
	int x = [self dsp_x];
	int y = [self dsp_y];
	if ( y <= -48 ) {
		return;
	}
	if ( _jiki && ((_m->_elapse - _m->_elapse_b) < WAIT_BOOST) ) {
		for ( int i = 1; i < 10; i++ ) {
			[_m->g drawImage:[_m use_image:IMAGE_SHIELD] :x - _direction * i / 10 :y + _speed * i / 50 :24 * _shield :0 :24 :24];
		}
	} else if ( !ready && (([_m elapse] % 2) == 0) ) {
		[_m->g drawImage:[_m use_image:IMAGE_SHIELD] :x -  _direction      :y + (_speed / 10) :24 * _shield :96 :24 :48];
		[_m->g drawImage:[_m use_image:IMAGE_SHIELD] :x - (_direction / 2) :y + (_speed / 20) :24 * _shield :48 :24 :48];
	}
	[_m->g drawImage:[_m use_image:IMAGE_SHIELD] :x :y :24 * _shield :0 :24 :48];
	if ( _direction < 0 ) {
		int d = 0 - _direction;
		switch ( _type ) {
		case SPEEDER1:
			[_m->g drawImage:[_m use_image:IMAGE_SPEEDER1]
				:x + 12 - (_m->SPEEDER1_W[d] / 2) :y + 3
				:_m->SPEEDER1_X_M[d] :43
				:_m->SPEEDER1_W[d] :43
				];
			break;
		case SPEEDER2:
		case SPEEDER4:
			[_m->g drawImage:[_m use_image:IMAGE_SPEEDER2]
				:x + 12 - (_m->SPEEDER2_W[d] / 2) :y + 3
				:_m->SPEEDER2_X_M[d] :41
				:_m->SPEEDER2_W[d] :41
				];
			break;
		case SPEEDER3:
		case SPEEDER5:
			[_m->g drawImage:[_m use_image:IMAGE_SPEEDER3]
				:x + 12 - (_m->SPEEDER3_W[d] / 2) :y + 3
				:_m->SPEEDER3_X_M[d] :43
				:_m->SPEEDER3_W[d] :43
				];
			break;
		}
	} else {
		int d = _direction;
		switch ( _type ) {
		case SPEEDER1:
			[_m->g drawImage:[_m use_image:IMAGE_SPEEDER1]
				:x + 12 - (_m->SPEEDER1_W[d] / 2) :y + 3
				:_m->SPEEDER1_X[d] :0
				:_m->SPEEDER1_W[d] :43
				];
			break;
		case SPEEDER2:
		case SPEEDER4:
			[_m->g drawImage:[_m use_image:IMAGE_SPEEDER2]
				:x + 12 - (_m->SPEEDER2_W[d] / 2) :y + 3
				:_m->SPEEDER2_X[d] :0
				:_m->SPEEDER2_W[d] :41
				];
			break;
		case SPEEDER3:
		case SPEEDER5:
			[_m->g drawImage:[_m use_image:IMAGE_SPEEDER3]
				:x + 12 - (_m->SPEEDER3_W[d] / 2) :y + 3
				:_m->SPEEDER3_X[d] :0
				:_m->SPEEDER3_W[d] :43
				];
			break;
		}
	}
}

@end
