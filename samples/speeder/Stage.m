#import "Stage.h"

#import "_Random.h"
#import "_Vector.h"
#import "MyCanvas.h"
#import "Speeder.h"
#import "Star.h"
#import "Wave.h"

/*
 * ステージ
 */
@implementation Stage

- (id)initWithCanvas:(MyCanvas*)m
{
	self = [super init];
	if ( self ) {
		_m = m;

		_back = -1;

		star = [[_Vector alloc] init];
	}
	return self;
}

#ifdef NO_OBJC_ARC
- (void)dealloc
{
	[star release];

	[super dealloc];
}
#endif // NO_OBJC_ARC

/*
 * ステージデータ構築
 */
- (void)create
{
	int i;

	[star removeAllElements];

	int tmp;
	while ( YES ) {
		tmp = ([_m->rand nextInt] % 4) + 3;
		if ( tmp != _back ) {
			_back = tmp;
			break;
		}
	}

	_col = ([_m->rand nextInt] % 2) + 1;

	// シールド変更
	if ( _m->level == 5 ) {
		[_m->speeder[0] shield:_col];
	}
	if ( (_m->level < 2) || (_m->level == 7) ) {
		[_m->speeder[1] shield:_col];
		[_m->speeder[2] shield:_col];
	}

	for ( i = 0; i < _m->height; i += 3 ) {
#if !defined( NO_OBJC_ARC )
@autoreleasepool
{
#endif // !defined( NO_OBJC_ARC )
		Star* tmp = [[Star alloc] initWithCanvas:_m :120 + ([_m->rand nextInt] % 360) :i];
		[star addElement:tmp];
#ifdef NO_OBJC_ARC
		[tmp release];
#endif // NO_OBJC_ARC
#if !defined( NO_OBJC_ARC )
}
#endif // !defined( NO_OBJC_ARC )
	}

	[_m->wave add_bar:-100 :192 :3 :((_m->level != 6) ? 9 : 0) :NO];
	bar = 1;
	for ( i = 172; i > 0; i -= 20 ) {
		[_m->wave add_bar:-100 :i :_col];
		bar++;
	}

	old_distance = [_m->speeder[0] distance];
	x            = -100;
	_move_x      = 0;
	_offset_x    = 0;
	counter      = NO;
}

/*
 * ステージデータ更新
 */
- (void)update
{
	int i;

	for ( i = [star size] - 1; i >= 0; i-- ) {
		Star* tmp = (Star*)[star elementAt:i];
		if ( ![tmp update] ) {
			[star removeElementAt:i];
		}
	}

	if ( [_m->speeder[0] speed] > 0 ) {
		Star* tmp = [[Star alloc] initWithCanvas:_m :120 + ([_m->rand nextInt] % 360) :0];
		[star addElement:tmp];
#ifdef NO_OBJC_ARC
		[tmp release];
#endif // NO_OBJC_ARC
	}

	if ( _m->level != 6 ) {
		for ( i = 0; i < 3; i++ ) {
			if (
			((i == 0) && [_m->wave clear]) ||
			((i != 0) && ([_m->speeder[i] distance] > (DISTANCE + 2400)))
			) {
				[_m->speeder[i] speed_down:10];
			} else {
				[_m->speeder[i] speed_up:1];
			}
			[_m->speeder[i] add_distance:[_m->speeder[i] speed]];
			if ( (_m->level >= 2) && (_m->level <= 6) ) break;
		}
	} else {
		if ( [_m->speeder[0] speed] < 300 ) {
			[_m->speeder[0] speed_down:5];
		}
		[_m->speeder[0] add_distance:[_m->speeder[0] speed]];
	}

	if ( counter ) {
		if ( ([_m->speeder[0] distance] - old_distance) >= 240 ) {
			[_m->wave add_bar:x :0 :3 :9 - [_m->speeder[0] distance] / (DISTANCE / 9) :NO];
			bar++;
			if ( bar >= 12 ) {
				bar = 0;
				counter = NO;
			}
			old_distance = [_m->speeder[0] distance];
		}
	} else {
		if ( bar > 20 ) {
			bar = 0;

			_m->change_col = (_m->level == 7) ? 1 : 2;

			switch ( _m->level ) {
			case 0:
			case 2:
			case 4:
				_move_x += (12 * ([_m->rand nextInt] % 2));
				if ( _move_x < -12 ) _move_x = -12;
				if ( _move_x >  12 ) _move_x =  12;
				break;
			case 1:
			case 3:
			case 5:
			case 6:
				_move_x += (12 * ([_m->rand nextInt] % 3));
				if ( _move_x < -24 ) _move_x = -24;
				if ( _move_x >  24 ) _move_x =  24;
				break;
			case 7:
				_offset_x = (100 * ([_m->rand nextInt] % 2));
				break;
			}
		} else if ( (_m->level == 7) && (bar > 5) ) {
			if ( _m->change_col == 1 ) _m->change_col = 2;

			x += _offset_x;
			_offset_x = 0;
		}

		if ( _m->change_col == 2 ) {
			_m->change_col = 0;

			int old_col = _col;
			_col = ([_m->rand nextInt] % 2) + 1;
			if ( _col != old_col ) {
				if ( (_m->level < 2) || (_m->level == 7) ) {
					// シールド切り替え速度計測開始
					_m->_elapse_s = 1;

					// シールド変更
					for ( i = 0; i < 2; i++ ) {
						if ( _m->shield_wait[i] == 0 ) {
							_m->shield_wait[i] = _m->shield_lag[i];
							_m->shield_col [i] = _col;
						}
					}
				}
			}
		}

		if ( ([_m->speeder[0] distance] - old_distance) >= 500 ) {
			if ( _m->level != 6 ) {
				if ( ([_m->speeder[0] distance] / (DISTANCE / 9)) != (old_distance / (DISTANCE / 9)) ) {
					[_m->wave add_bar:x :0 :3 :9 - ([_m->speeder[0] distance] / (DISTANCE / 9)) :YES];
					if ( (9 - ([_m->speeder[0] distance] / (DISTANCE / 9))) > 0 ) {
						bar = 1;
						counter = YES;
						if ( (_m->level < 2) || (_m->level == 7) ) {
							_m->boost = YES;
						}
					}
				} else if ( [_m->speeder[0] distance] < DISTANCE ) {
					bar += ([_m->speeder[0] distance] - old_distance) / 500;
					x += _move_x;
					[_m->wave add_bar:x :0 :_col];
				}
			} else {
				bar += ([_m->speeder[0] distance] - old_distance) / 500;
				x += _move_x;
				[_m->wave add_bar:x :0 :_col];
			}
			old_distance = [_m->speeder[0] distance];
		}
	}
}

// ウェーブの色を確認
- (int)col { return _col; }

- (int)move_x { return _move_x; }

- (int)offset_x { return _offset_x; }

/*
 * 描画
 */
- (void)draw:(BOOL)ready
{
	if ( _back < 5 ) {
		[_m->g drawImage:[_m use_image:IMAGE_BACK] :0 :  0];
		[_m->g drawImage:[_m use_image:IMAGE_BACK] :0 :135];
	}

	int distance;
	distance = [_m->speeder[0] distance]; if ( distance > DISTANCE ) distance = DISTANCE;
	switch ( _back ) {
	case 0:
		[_m->g drawImage:[_m use_image:IMAGE_FORE1] :10 :(120 * distance / DISTANCE) - 120];
		break;
	case 1:
		[_m->g drawImage:[_m use_image:IMAGE_FORE2] :(120 * distance / DISTANCE) - 120 :0];
		break;
	case 2:
		[_m->g drawImage:[_m use_image:IMAGE_FORE3] :0 - (80 * distance / DISTANCE) :_m->height - 188];
		break;
	case 3:
		[_m->g drawImage:[_m use_image:IMAGE_FORE4] :120 - (240 * distance / DISTANCE) :0];
		break;
	case 4:
		[_m->g drawImage:[_m use_image:IMAGE_FORE4] :0 :(240 * distance / DISTANCE) - 120];
		break;
	case 5:
		[_m->g drawImage:[_m use_image:IMAGE_FORE5A] :0 :((480 - _m->height) * distance / DISTANCE) - (480 - _m->height)      ];
		[_m->g drawImage:[_m use_image:IMAGE_FORE5B] :0 :((480 - _m->height) * distance / DISTANCE) - (480 - _m->height) + 240];
		break;
	case 6:
		[_m->g drawImage:[_m use_image:IMAGE_FORE6A] :0 - (140 * distance / DISTANCE)       :0];
		[_m->g drawImage:[_m use_image:IMAGE_FORE6B] :0 - (140 * distance / DISTANCE) + 190 :0];
		break;
	}

	[_m->g setColor:_m->COLOR_W];
	int h = ready ? 0 : ([_m->speeder[0] speed] / 50);
	for ( int i = [star size] - 1; i >= 0; i-- ) {
		Star* tmp = (Star*)[star elementAt:i];
		if ( ([tmp x] >= 0) && ([tmp x] < 240) ) {
			[_m->g drawLine:[tmp x] :[tmp y] :[tmp x] :[tmp y] + h];
		}
	}
}

@end
