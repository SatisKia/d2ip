#import "Bar.h"

#import "MyCanvas.h"
#import "Speeder.h"

/*
 * バー
 */
@implementation Bar

- (id)initWithCanvas:(MyCanvas*)m :(int)x :(int)y :(int)col :(int)count :(BOOL)border
{
	self = [super init];
	if ( self ) {
		_m = m;

		_x      = x;
		_y      = y;
		_col    = col;
		_count  = count;
		_border = border;

		_hit[0] = NO;
		_hit[1] = NO;
		_hit[2] = NO;
	}
	return self;
}

#ifdef NO_OBJC_ARC
- (void)dealloc
{
	[super dealloc];
}
#endif // NO_OBJC_ARC

- (int)x { return _x; }
- (int)y { return _y; }
- (int)col { return _col; }
- (int)count { return _count; }
- (BOOL)update {
	_y += [_m->speeder[0] speed] / 10;

	int y;
	int dsp_x0, dsp_y0;
	int dsp_x1, dsp_y1;
	int dsp_x2, dsp_y2;
	for ( int i = 0; i < 3; i++ ) {
		y = [_m->speeder[i] dsp_y];
		if ( (y > -48) && (y < 320) && (_y > y) && !_hit[i] ) {
			_hit[i] = YES;

			if ( i != 0 ) {
				// 移動
				if ( [_m->speeder[i] x] <= (_x + 38) ) {
					[_m->speeder[i] right];
					[_m->speeder[i] auto:AUTO_MOVED_INERTIA];
				} else if ( [_m->speeder[i] x] >= (_x + 138) ) {
					[_m->speeder[i] left];
					[_m->speeder[i] auto:AUTO_MOVED_INERTIA];
				} else if ( [_m->speeder[i] x] != (_x + 88) ) {
					[_m->speeder[i] set_direction:((_x + 88) - [_m->speeder[i] x]) / 10];
					[_m->speeder[i] auto:AUTO_MOVED_NEUTRAL];
				} else {
					[_m->speeder[i] auto:AUTO_NEUTRAL];
				}

				// スライド
				dsp_x0 = [_m->speeder[0] dsp_x];
				dsp_y0 = [_m->speeder[0] dsp_y];
				dsp_x1 = [_m->speeder[1] dsp_x];
				dsp_y1 = [_m->speeder[1] dsp_y];
				dsp_x2 = [_m->speeder[2] dsp_x];
				dsp_y2 = [_m->speeder[2] dsp_y];
				switch ( i ) {
				case 1:
					if (
					( dsp_x1       <= (dsp_x0 + 24)) &&
					( dsp_y1       <= (dsp_y0 + 48)) &&
					((dsp_x1 + 24) >=  dsp_x0      ) &&
					((dsp_y1 + 48) >=  dsp_y0      )
					) {
						[_m->speeder[i] slide:(([_m->speeder[0] x] < (_x + 88)) ? 1 : -1)];
					} else if (
					( dsp_x1       <= (dsp_x2 + 24)) &&
					( dsp_y1       <= (dsp_y2 + 48)) &&
					((dsp_x1 + 24) >=  dsp_x2      ) &&
					((dsp_y1 + 48) >=  dsp_y2      )
					) {
						[_m->speeder[i] slide:(([_m->speeder[2] x] < (_x + 88)) ? 1 : -1)];
					}
					break;
				case 2:
					if (
					( dsp_x2       <= (dsp_x0 + 24)) &&
					( dsp_y2       <= (dsp_y0 + 48)) &&
					((dsp_x2 + 24) >=  dsp_x0      ) &&
					((dsp_y2 + 48) >=  dsp_y0      )
					) {
						[_m->speeder[i] slide:(([_m->speeder[0] x] < (_x + 88)) ? 1 : -1)];
					} else if (
					( dsp_x2       <= (dsp_x1 + 24)) &&
					( dsp_y2       <= (dsp_y1 + 48)) &&
					((dsp_x2 + 24) >=  dsp_x1      ) &&
					((dsp_y2 + 48) >=  dsp_y1      )
					) {
						[_m->speeder[i] slide:(([_m->speeder[1] x] < (_x + 88)) ? 1 : -1)];
					}
					break;
				}
			}

			// 移動
			if ( _m->level == 4 ) {
				if ( [_m->speeder[0] x] <= (_x + 38) ) {
					[_m->speeder[0] right];
					[_m->speeder[0] auto:AUTO_MOVED_INERTIA];
				} else if ( [_m->speeder[0] x] >= (_x + 138) ) {
					[_m->speeder[0] left];
					[_m->speeder[0] auto:AUTO_MOVED_INERTIA];
				} else if ( [_m->speeder[0] x] != (_x + 88) ) {
					[_m->speeder[0] set_direction:((_x + 88) - [_m->speeder[0] x]) / 10];
					[_m->speeder[0] auto:AUTO_MOVED_NEUTRAL];
				} else {
					[_m->speeder[0] auto:AUTO_NEUTRAL];
				}
			}

			// シールド変更
			if ( _m->level == 5 ) {
				if ( _col < 3 ) [_m->speeder[0] shield:_col];
			}

			// スピード変更
			BOOL in = YES;
			if ( (_m->level != 4) && ((_x > [_m->speeder[i] x]) || ((_x + 176) < [_m->speeder[i] x])) ) {
				in = NO;
			}
			if ( in && ((_col == 3) || (_col == [_m->speeder[i] shield])) ) {
				if ( _m->level != 6 ) {
					[_m->speeder[i] speed_up];
					if ( _col == 3 ) {
						[_m->speeder[i] speed_up];
					}
				}
			} else {
				if ( _m->level != 6 ) {
					[_m->speeder[i] speed_down];
				} else {
					[_m->speeder[i] speed_down:5];
				}
			}

			if ( i == 0 ) {
				// スピード変更
				if ( (_m->level < 2) || (_m->level == 7) ) {
					if ( [_m->speeder[1] out] ) {
						if ( ([_m->speeder[1] dsp_y] <= -48) && (_m->shield_wait[0] > 0) ) {
							[_m->speeder[1] speed_down];
						} else {
							[_m->speeder[1] speed_up];
						}
					}
					if ( [_m->speeder[2] out] ) {
						if ( ([_m->speeder[2] dsp_y] <= -48) && (_m->shield_wait[1] > 0) ) {
							[_m->speeder[2] speed_down];
						} else {
							[_m->speeder[2] speed_up];
						}
					}
				}

				// ラップタイム計測
				if ( _border ) {
					_m->_elapse_l = _m->_elapse;
					_m->lap = 9 - _count;
					_m->time[_m->lap] = _m->time[0];
					if ( _m->lap == 1 ) {
						_m->lap_time = _m->time[_m->lap] - _m->best_time[[_m index_b]][_m->lap];
					} else {
						_m->lap_time = (_m->time[_m->lap] - _m->time[_m->lap - 1]) - _m->best_time[[_m index_b]][_m->lap];
					}
					_m->dsp_lap = YES;
					if ( _m->lap == 9 ) {
						_m->finish = YES;
					}
				}
			}
		}
		if ( (_m->level >= 2) && (_m->level <= 6) ) break;
	}

	if ( _y >= 320 ) {
		return NO;
	}
	return YES;
}

@end
