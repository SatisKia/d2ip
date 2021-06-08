#import "MyCanvas.h"

#import "_Image.h"
#import "_Layout.h"
#import "_Preference.h"
#import "_Random.h"
#import "_Sensor.h"

#import "Speeder.h"
#import "Stage.h"
#import "Wave.h"

const int _SPEEDER1_X[] = { 0, 17, 34, 51, 68, 85, 103, 121, 140, 160, 181, 202, 224, 247, 270, 294 };
const int _SPEEDER1_X_M[] = { 318, 301, 284, 267, 250, 232, 214, 195, 175, 154, 133, 111, 88, 65, 41, 17 };
const int _SPEEDER1_W[] = { 17, 17, 17, 17, 17, 18, 18, 19, 20, 21, 21, 22, 23, 23, 24, 24 };

const int _SPEEDER2_X[] = { 0, 17, 34, 51, 68, 86, 105, 124, 144, 164, 185, 206, 228, 250, 273, 296 };
const int _SPEEDER2_X_M[] = { 320, 303, 286, 269, 251, 232, 213, 193, 173, 152, 131, 109, 87, 64, 41, 17 };
const int _SPEEDER2_W[] = { 17, 17, 17, 17, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23, 23, 24 };

const int _SPEEDER3_X[] = { 0, 17, 34, 51, 68, 85, 103, 121, 140, 160, 181, 202, 224, 246, 269, 292 };
const int _SPEEDER3_X_M[] = { 315, 298, 281, 264, 247, 229, 211, 192, 172, 151, 130, 108, 86, 63, 40, 17 };
const int _SPEEDER3_W[] = { 17, 17, 17, 17, 17, 18, 18, 19, 20, 21, 21, 22, 22, 23, 23, 23 };

/*
 * キャンバス
 */
@implementation MyCanvas

- (int)_frameTime { return FRAME_TIME; }
- (int)_touchNum { return 2; }

/*
 * 設定の読み込み
 */
- (void)load_config
{
	int i, j;

	// デフォルト値
	sensor_f      = YES;
	neutral       = YES;
	level         = 0;
	player        = 0;
	shield_lag[0] = 10;
	shield_lag[1] = 10;
	shield_index  = 0;
	for ( i = 0; i < 7; i++ ) {
		for ( j = 0; j < 10; j++ ) {
			best_time[i][j] = 99999;
		}
	}
	for ( i = 0; i < 3; i++ ) {
		for ( j = 0; j < 3; j++ ) {
			win[i][j] = 0;
		}
	}
	best_distance = 0;

	// 既にデータがあるかどうかチェックする
	_Preference* pref = [[_Preference alloc] init];
	if ( [[pref getParameter:@"save" :@"0"] intValue] == 1 ) {
		// データがあるので読み出す
		[pref beginRead];
		NSString* str;
		str = [pref read:@""]; if ( [str length] > 0 ) neutral = ([str intValue] == 1) ? YES : NO;
		str = [pref read:@""]; if ( [str length] > 0 ) level = [str intValue];
		str = [pref read:@""]; if ( [str length] > 0 ) player = [str intValue];
		str = [pref read:@""]; if ( [str length] > 0 ) shield_lag[0] = [str intValue];
		str = [pref read:@""]; if ( [str length] > 0 ) shield_lag[1] = [str intValue];
		str = [pref read:@""]; if ( [str length] > 0 ) shield_index = [str intValue];
		for ( i = 0; i < 6; i++ ) {
			for ( j = 0; j < 10; j++ ) {
				str = [pref read:@""]; if ( [str length] > 0 ) best_time[i][j] = [str intValue];
			}
		}
		for ( i = 0; i < 2; i++ ) {
			for ( j = 0; j < 3; j++ ) {
				str = [pref read:@""]; if ( [str length] > 0 ) win[i][j] = [str intValue];
			}
		}
		str = [pref read:@""]; if ( [str length] > 0 ) best_distance = [str intValue];
		for ( j = 0; j < 10; j++ ) {
			str = [pref read:@""]; if ( [str length] > 0 ) best_time[6][j] = [str intValue];
		}
		for ( j = 0; j < 3; j++ ) {
			str = [pref read:@""]; if ( [str length] > 0 ) win[2][j] = [str intValue];
		}
		str = [pref read:@""]; if ( [str length] > 0 ) sensor_f = ([str intValue] == 1) ? YES : NO;
		[pref endRead];
	}
#ifdef NO_OBJC_ARC
	[pref release];
#endif // NO_OBJC_ARC
}

/*
 * 設定の書き出し
 */
- (void)save_config
{
	int i, j;
	_Preference* pref = [[_Preference alloc] init];
	[pref setParameter:@"save" :@"1"];
	[pref beginWrite];
	[pref write:(neutral ? @"1" : @"0")];
	[pref write:[NSString stringWithFormat:@"%d", level]];
	[pref write:[NSString stringWithFormat:@"%d", player]];
	[pref write:[NSString stringWithFormat:@"%d", shield_lag[0]]];
	[pref write:[NSString stringWithFormat:@"%d", shield_lag[1]]];
	[pref write:[NSString stringWithFormat:@"%d", shield_index]];
	for ( i = 0; i < 6; i++ ) {
		for ( j = 0; j < 10; j++ ) {
			[pref write:[NSString stringWithFormat:@"%d", best_time[i][j]]];
		}
	}
	for ( i = 0; i < 2; i++ ) {
		for ( j = 0; j < 3; j++ ) {
			[pref write:[NSString stringWithFormat:@"%d", win[i][j]]];
		}
	}
	[pref write:[NSString stringWithFormat:@"%d", best_distance]];
	for ( j = 0; j < 10; j++ ) {
		[pref write:[NSString stringWithFormat:@"%d", best_time[6][j]]];
	}
	for ( j = 0; j < 3; j++ ) {
		[pref write:[NSString stringWithFormat:@"%d", win[2][j]]];
	}
	[pref write:(sensor_f ? @"1" : @"0")];
	[pref endWrite];
#ifdef NO_OBJC_ARC
	[pref release];
#endif // NO_OBJC_ARC
}

/*
 * イメージ読み込み
 */
- (void)create_image:(int)id
{
	if ( main_img[id] == nil ) {
		NSString* id2;
		switch ( id ) {
		case IMAGE_BACK    : id2 = [NSString stringWithString:@"back.png"    ]; break;
		case IMAGE_BAR     : id2 = [NSString stringWithString:@"bar.png"     ]; break;
		case IMAGE_FORE1   : id2 = [NSString stringWithString:@"fore1.png"   ]; break;
		case IMAGE_FORE2   : id2 = [NSString stringWithString:@"fore2.png"   ]; break;
		case IMAGE_FORE3   : id2 = [NSString stringWithString:@"fore3.png"   ]; break;
		case IMAGE_FORE4   : id2 = [NSString stringWithString:@"fore4.png"   ]; break;
		case IMAGE_FORE5A  : id2 = [NSString stringWithString:@"fore5a.png"  ]; break;
		case IMAGE_FORE5B  : id2 = [NSString stringWithString:@"fore5b.png"  ]; break;
		case IMAGE_FORE6A  : id2 = [NSString stringWithString:@"fore6a.png"  ]; break;
		case IMAGE_FORE6B  : id2 = [NSString stringWithString:@"fore6b.png"  ]; break;
		case IMAGE_LOGO    : id2 = [NSString stringWithString:@"logo.png"    ]; break;
		case IMAGE_SHIELD  : id2 = [NSString stringWithString:@"shield.png"  ]; break;
		case IMAGE_SPEEDER1: id2 = [NSString stringWithString:@"speeder1.png"]; break;
		case IMAGE_SPEEDER2: id2 = [NSString stringWithString:@"speeder2.png"]; break;
		case IMAGE_SPEEDER3: id2 = [NSString stringWithString:@"speeder3.png"]; break;
		case IMAGE_STATUS  : id2 = [NSString stringWithString:@"status.png"  ]; break;
		case IMAGE_TITLE   : id2 = [NSString stringWithString:@"title.png"   ]; break;
		case IMAGE_RAY     : id2 = [NSString stringWithString:@"ray.png"     ]; break;
		case IMAGE_COM     : id2 = [NSString stringWithString:@"com.png"     ]; break;
		case IMAGE_RAX     : id2 = [NSString stringWithString:@"rax.png"     ]; break;
		}
		main_img[id] = [[_Image alloc] init];
		[main_img[id] load:id2];
		[main_img[id] mutable];
	}
}
- (void)dispose_image:(int)id
{
	if ( main_img[id] != nil ) {
#ifdef NO_OBJC_ARC
		[main_img[id] release];
#endif // NO_OBJC_ARC
		main_img[id] = nil;
	}
}
- (void)dispose_image
{
	for ( int i = 0; i < IMAGE_NUM; i++ ) {
		if ( main_img[i] != nil ) {
#ifdef NO_OBJC_ARC
			[main_img[i] release];
#endif // NO_OBJC_ARC
			main_img[i] = nil;
		}
	}
}
- (_Image*)use_image:(int)id
{
	[self create_image:id];
	return main_img[id];
}

// 経過時間を確認する
- (int)elapse { return pause ? _elapse_p : _elapse; }

// おまけモードがプレイできるか確認する
- (BOOL)omake1
{
	int i;
	for ( i = 0; i < 6; i++ ) {
		if ( best_time[i][0] == 99999 ) {
			return NO;
		}
	}
	return YES;
}
- (BOOL)omake2
{
	int i, j;
	for ( i = 0; i < 2; i++ ) {
		for ( j = 0; j < 3; j++ ) {
			if ( win[i][j] == 0 ) {
				return NO;
			}
		}
	}
	return YES;
}

- (int)level_max
{
	if ( [self omake1] ) {
		return [self omake2] ? 7 : 6;
	}
	return 5;
}

- (int)index_b { return (level == 7) ? 6 : level; }
- (int)index_w { return (level == 7) ? 2 : level; }

/*
 * アプリの状態を変更する
 */
- (void)set_state:(int)new_state
{
	int old_state = state;
	state = new_state;
	_elapse = 0;
	_elapse_l = 0;
	_elapse_b = 0 - WAIT_BOOST;

	switch ( old_state ) {
	case STATE_TITLE_LOADING:
	case STATE_SELECT_LOADING:
		[self dispose_image];

		if ( state == STATE_READY ) {
			change_col = 0;

			if ( level != 6 ) {
				shield_wait[0] = 0;
				shield_wait[1] = 0;

				first = (best_time[[self index_b]][0] == 99999) ? YES : NO;

				time[0] = 0;

				lap     = 0;
				dsp_lap = NO;
				finish  = NO;
			} else {
				old_distance = best_distance;
			}

			boost = NO;

			if ( (level < 2) || (level == 7) ) {
				BOOL tmp = ([rand nextInt] > 0) ? YES : NO;
				switch ( player ) {
				case 0:
					[speeder[0] _init:YES :SPEEDER1 :0 :0];
					[speeder[1] _init:NO :(tmp ? SPEEDER2 : SPEEDER3) :0 :-50];
					[speeder[2] _init:NO :(tmp ? SPEEDER3 : SPEEDER2) :0 : 50];
					break;
				case 1:
					[speeder[0] _init:YES :SPEEDER2 :0 :0];
					[speeder[1] _init:NO :(tmp ? SPEEDER1 : SPEEDER3) :0 :-50];
					[speeder[2] _init:NO :(tmp ? SPEEDER3 : SPEEDER1) :0 : 50];
					break;
				case 2:
					[speeder[0] _init:YES :SPEEDER3 :0 :0];
					[speeder[1] _init:NO :(tmp ? SPEEDER1 : SPEEDER2) :0 :-50];
					[speeder[2] _init:NO :(tmp ? SPEEDER2 : SPEEDER1) :0 : 50];
					break;
				}
			} else {
				switch ( [rand nextInt] % 2 ) {
				case -1: [speeder[0] _init:YES :SPEEDER1 :((level != 6) ? 0 : 495) :0]; break;
				case  0: [speeder[0] _init:YES :SPEEDER4 :((level != 6) ? 0 : 495) :0]; break;
				case  1: [speeder[0] _init:YES :SPEEDER5 :((level != 6) ? 0 : 495) :0]; break;
				}
			}
		}

		break;
	case STATE_CLEAR:
	case STATE_STOP:
		[self save_config];
		break;
	}

	switch ( state ) {
	case STATE_LAUNCH:
	case STATE_TITLE_LOADING:
	case STATE_SELECT_LOADING:
		[self setLayout:nil];
		break;
	case STATE_TITLE:
		{
//			int t = [self windowY:0];
//			int h = -t; if ( h > 40 ) h = 40;
			[layout clear];
//			[layout add:  0 :  t : 80 : h :MYLAYOUT_BACK  ];
			[layout add: 20 : 89 : 40 :27 :MYLAYOUT_LEFT1 ];
			[layout add:180 : 89 : 40 :27 :MYLAYOUT_RIGHT1];
			[layout add: 20 :116 : 40 :27 :MYLAYOUT_LEFT2 ];
			[layout add:180 :116 : 40 :27 :MYLAYOUT_RIGHT2];
			[layout add: 20 :143 : 40 :27 :MYLAYOUT_LEFT3 ];
			[layout add:180 :143 : 40 :27 :MYLAYOUT_RIGHT3];
			[layout add: 40 :217 :160 :27 :MYLAYOUT_SELECT];
			[self setLayout:layout];
		}
		break;
	case STATE_SELECT:
		{
			int t = [self windowY:0];
			int h = -t; if ( h > 40 ) h = 40;
			[layout clear];
			[layout add: 37 : 65 : 40 :40 :MYLAYOUT_LEFT  ];
			[layout add:165 : 65 : 40 :40 :MYLAYOUT_RIGHT ];
			[layout add: 40 :217 :160 :27 :MYLAYOUT_SELECT];
			[layout add:  0 :  t : 80 : h :MYLAYOUT_BACK  ];
			[self setLayout:layout];
		}
		break;
	default:
		{
			int t = [self windowY:0];
			int h = -t; if ( h > 40 ) h = 40;
			int b = [self windowY:[self getHeight]] - h;
			[layout clear];
			[layout add:160 :t : 80 :  h :MYLAYOUT_PAUSE   ];
			[layout add:  0 :t : 80 :  h :MYLAYOUT_BACK    ];
			[layout add:  0 :0 :120 :270 :MYLAYOUT_LEFT    ];
			[layout add:120 :0 :120 :270 :MYLAYOUT_RIGHT   ];
			[layout add:  0 :b : 80 :  h :MYLAYOUT_SHIELD_0];
			[layout add: 80 :b : 80 :  h :MYLAYOUT_SHIELD_1];
			[layout add:160 :b : 80 :  h :MYLAYOUT_SHIELD_2];
			[self setLayout:layout];
		}
		break;
	}
	
	switch ( state ) {
	case STATE_TITLE:
		if ( old_state != STATE_SELECT ) {
			pause = NO;
			[self save_config];
		}
		[self dispose_image];
		break;
	case STATE_SELECT:
		[self create_image:IMAGE_SPEEDER1];
		[self create_image:IMAGE_SPEEDER2];
		[self create_image:IMAGE_SPEEDER3];
		break;
	case STATE_READY:
		[wave create];
		[stage create];
		break;
	case STATE_CLEAR:
		new_time = NO;
		if ( time[0] < best_time[[self index_b]][0] ) {
			new_time = first ? NO : YES;
			best_time[[self index_b]][0] = time[0];
			best_time[[self index_b]][1] = time[1];
			for ( int i = 2; i < 10; i++ ) {
				best_time[[self index_b]][i] = time[i] - time[i - 1];
			}
		}
		ranking = 1;
		if ( (level < 2) || (level == 7) ) {
			if ( [speeder[0] distance] < [speeder[1] distance] ) ranking++;
			if ( [speeder[0] distance] < [speeder[2] distance] ) ranking++;
			if ( ranking == 1 ) {
				win[[self index_w]][player]++;
			}
		}
		break;
	case STATE_STOP:
		new_distance = NO;
		if ( [speeder[0] distance] > best_distance ) {
			new_distance = (best_distance == 0) ? NO : YES;
			best_distance = [speeder[0] distance];
		}
		break;
	}
}

/*
 * 描画に使用する色を設定
 */
- (void)setCMYColor:(int)col
{
	switch ( col ) {
	case 0: [g setColor:COLOR_C]; break;
	case 1: [g setColor:COLOR_M]; break;
	case 2: [g setColor:COLOR_Y]; break;
	}
}

- (int)drawImage:(_Image*)img :(int)x0 :(int)y0 :(int)x :(int)y :(int)w :(int)h
{
	if ( (x0 + w) <= 0 ) {
		return -1;
	} else if ( x0 >= 240 ) {
		return 1;
	}
	[g drawImage:img :x0 :y0 :x :y :w :h];
	return 0;
}

- (void)drawButton:(_Graphics*)_g :(int)id
{
	[_g setAlpha:64];
	[_g fillRoundRect:[layout getLeft:id] :[layout getTop:id] :[layout getWidth:id] :[layout getHeight:id] :5];
	[_g setAlpha:255];
	[_g drawRoundRect:[layout getLeft:id] :[layout getTop:id] :[layout getWidth:id] - 1 :[layout getHeight:id] - 1 :5];
}
- (void)drawScreenButton:(_Graphics*)_g :(int)id :(NSString*)str
{
	int left   = [self screenX:[layout getLeft  :id]];
	int top    = [self screenY:[layout getTop   :id]];
	int right  = [self screenX:[layout getRight :id]];
	int bottom = [self screenY:[layout getBottom:id]];
	[_g drawRoundRect:left :top :right - left - 1 :bottom - top - 1 :16];
	[_g drawString:str :left + ((right - left) - [_g stringWidth:str]) / 2 :top + ((bottom - top) - [_g fontHeight]) / 2 + [_g fontHeight]];
}
- (void)drawScreenButton2:(_Graphics*)_g :(int)id
{
	int left   = [self screenX:[layout getLeft  :id]];
	int top    = [self screenY:[layout getTop   :id]];
	int right  = [self screenX:[layout getRight :id]];
	int bottom = [self screenY:[layout getBottom:id]];
	[_g fillRoundRect:left :top :right - left :bottom - top :16];
}

/*
 * 文字列センタリング描画
 */
- (void)centerDrawString:(NSString*)str :(int)y
{
	int x;
	x = (240 - [g stringWidth:str]) / 2;
	y = y + [g fontHeight] / 2;

	[g drawString:str :x + 1 :y];
	[g drawString:str :x     :y];
}

/*
 * ステータス描画
 */
- (void)drawStatus:(BOOL)ready
{
	int i, x, y;
	int tmp;

	if ( level != 6 ) {
		[g drawImage:[self use_image:IMAGE_STATUS] :10 :0 :0 :26 :92 :24];
		x = 15 + 12 * 3;
		tmp = time[0];
		for ( i = 0; i < 4; i++ ) {
			[g drawImage:[self use_image:IMAGE_STATUS] :x :6 :(tmp % 10) * 12 :0 :12 :13];
			tmp /= 10;
			x -= 12;
		}

		if ( !first && dsp_lap ) {
			if ( (lap > 0) && ((_elapse - _elapse_l) < WAIT_2) ) {
				[g drawImage:[self use_image:IMAGE_STATUS] :10 :24 :0 :26 :59 :24];
				x = 15 + 12 * 3;
				y = 0;
				tmp = lap_time;
				if ( tmp < 0 ) {
					tmp = 0 - tmp;
					[g drawImage:[self use_image:IMAGE_STATUS] :15 :30 :120 :13 :12 :13];
					y = 13;
				} else {
					[g drawImage:[self use_image:IMAGE_STATUS] :15 :30 :120 :((tmp == 0) ? 26 : 0) :12 :13];
				}
				for ( i = 0; i < 3; i++ ) {
					[g drawImage:[self use_image:IMAGE_STATUS] :x :30 :(tmp % 10) * 12 :y :12 :13];
					tmp /= 10;
					x -= 12;
				}
			} else {
				dsp_lap = NO;
			}
		}
	}

	[g drawImage:[self use_image:IMAGE_STATUS] :148 :0 :0 :50 :82 :24];
	x = 190 + 12 * 2;
	tmp = ready ? 0 : [speeder[0] speed];
	for ( i = 0; i < 3; i++ ) {
		[g drawImage:[self use_image:IMAGE_STATUS] :x :6 :(tmp % 10) * 12 :0 :12 :13];
		tmp /= 10;
		x -= 12;
	}

	[g drawImage:[self use_image:IMAGE_STATUS] :0 :0 :132 :0 :10 :height];
	[g drawImage:[self use_image:IMAGE_STATUS] :230 :0 :132 :0 :10 :height];

	if ( (level < 2) || (level == 7) ) {
		for ( i = 1; i < 3; i++ ) {
			[g drawImage:[self use_image:IMAGE_STATUS] :1 :height - (height * [speeder[i] distance] / DISTANCE) - 4 :92 :34 :8 :8];
		}
		[g drawImage:[self use_image:IMAGE_STATUS] :1 :height - (height * [speeder[0] distance] / DISTANCE) - 4 :92 :26 :8 :8];

		for ( i = 1; i < 3; i++ ) {
			[g drawImage:[self use_image:IMAGE_STATUS] :231 :(height / 2 - 4) - (([speeder[i] distance] - [speeder[0] distance]) / 100) :92 :34 :8 :8];
		}
		[g drawImage:[self use_image:IMAGE_STATUS] :231 :height / 2 - 4 :92 :26 :8 :8];
	} else if ( (level != 6) || (old_distance == 0) ) {
		y = height - (height * [speeder[0] distance] / DISTANCE);
		[g drawImage:[self use_image:IMAGE_STATUS] :1 :y - 4 :92 :26 :8 :8];
		[g drawImage:[self use_image:IMAGE_STATUS] :231 :y - 4 :92 :26 :8 :8];
	} else {
		y = height - (height * old_distance / (old_distance * 2));
		[g drawImage:[self use_image:IMAGE_STATUS] :1 :y - 4 :92 :34 :8 :8];
		[g drawImage:[self use_image:IMAGE_STATUS] :231 :y - 4 :92 :34 :8 :8];
		y = height - (height * [speeder[0] distance] / (old_distance * 2));
		[g drawImage:[self use_image:IMAGE_STATUS] :1 :y - 4 :92 :26 :8 :8];
		[g drawImage:[self use_image:IMAGE_STATUS] :231 :y - 4 :92 :26 :8 :8];
	}

	if ( boost ) {
		[g drawImage:[self use_image:IMAGE_STATUS] :184 :24 :((([self elapse] % 4) < 2) ? 0 : 46) :264 :46 :23];
	}
}

- (void)_init
{
	rand = [[_Random alloc] init];
	stage = [[Stage alloc] initWithCanvas:self];
	wave = [[Wave alloc] initWithCanvas:self];

	speeder[0] = [[Speeder alloc] initWithCanvas:self];
	speeder[1] = [[Speeder alloc] initWithCanvas:self];
	speeder[2] = [[Speeder alloc] initWithCanvas:self];

	COLOR_C = [_Graphics getColorOfRGB:0   :255 :255];
	COLOR_M = [_Graphics getColorOfRGB:255 :0   :255];
	COLOR_Y = [_Graphics getColorOfRGB:255 :255 :0  ];
	COLOR_K = [_Graphics getColorOfRGB:0   :0   :0  ];
	COLOR_W = [_Graphics getColorOfRGB:255 :255 :255];

	SPEEDER1_X   = _SPEEDER1_X;
	SPEEDER1_X_M = _SPEEDER1_X_M;
	SPEEDER1_W   = _SPEEDER1_W;

	SPEEDER2_X   = _SPEEDER2_X;
	SPEEDER2_X_M = _SPEEDER2_X_M;
	SPEEDER2_W   = _SPEEDER2_W;

	SPEEDER3_X   = _SPEEDER3_X;
	SPEEDER3_X_M = _SPEEDER3_X_M;
	SPEEDER3_W   = _SPEEDER3_W;

	state = STATE_LAUNCH;
	help_back = -1;
	pause = NO;

	for ( int i = 0; i < IMAGE_NUM; i++ ) {
		main_img[i] = nil;
	}

	layout = [[_Layout alloc] init];
	[layout setWindow:YES];
	layoutState = 0;

	sensor = [[_Sensor alloc] init];
	[sensor start:0.1f];

	processingEvent = NO;

	[self load_config];

	height = 270;

	window = [[_Image alloc] init];
	[window create:240 :height];
	g = [window getGraphics];

	[self setWindow:240 :height];

	[self set_state:STATE_TITLE];
}

#ifdef NO_OBJC_ARC
- (void)_end
{
	[rand release];
	[stage release];
	[wave release];

	[speeder[0] release];
	[speeder[1] release];
	[speeder[2] release];

	for ( int i = 0; i < IMAGE_NUM; i++ ) {
		if ( main_img[i] != nil ) {
			[main_img[i] release];
		}
	}

	[layout release];

	[sensor release];

	[window release];
}
#endif // NO_OBJC_ARC

- (void)_suspend
{
	[sensor stop];
}

- (void)_resume
{
	[sensor start:0.1f];
}

- (void)_paint:(_Graphics*)_g
{
	layoutState = [self getLayoutState];

	switch ( state ) {
//	case STATE_LAUNCH:
//		g.lock();
//		g.setColor(COLOR_K);
//		g.fillRect(0, 0, 240, height);
//		setCMYColor(_elapse % 3);
//		centerDrawString("起動中...", 120);
//		g.unlock();
//		break;
	case STATE_TITLE:
	case STATE_TITLE_LOADING:
		// 描画
		[g lock];
		{
			int x;

			[g setColor:COLOR_K];
			[g fillRect:0 :0 :240 :height];

			[g setColor:COLOR_W];
			[g setStrokeWidth:1];
			[self drawButton:g :MYLAYOUT_LEFT1];
			[self drawButton:g :MYLAYOUT_RIGHT1];
			[self drawButton:g :MYLAYOUT_LEFT2];
			[self drawButton:g :MYLAYOUT_RIGHT2];
			[self drawButton:g :MYLAYOUT_LEFT3];
			[self drawButton:g :MYLAYOUT_RIGHT3];
			if ( state == STATE_TITLE ) {
				[self drawButton:g :MYLAYOUT_SELECT];
			}

			[g drawImage:[self use_image:IMAGE_LOGO] :0 :5];

			[g drawImage:[self use_image:IMAGE_TITLE] : 36 :98 :150 :0 :5 :9];
			[g drawImage:[self use_image:IMAGE_TITLE] :200 :98 :155 :0 :5 :9];
			x = (240 - (TEXT_SENSOR_W + 8 + TEXT_OFF_W)) / 2;
			[g drawImage:[self use_image:IMAGE_TITLE] :x :98 :TEXT_SENSOR_X :TEXT_SENSOR_Y :TEXT_SENSOR_W :TEXT_SENSOR_H]; x += (TEXT_SENSOR_W + 8);
			if ( sensor_f ) {
				[g drawImage:[self use_image:IMAGE_TITLE] :x :98 :TEXT_ON_X :TEXT_ON_Y :TEXT_ON_W :TEXT_ON_H];
			} else {
				[g drawImage:[self use_image:IMAGE_TITLE] :x :98 :TEXT_OFF_X :TEXT_OFF_Y :TEXT_OFF_W :TEXT_OFF_H];
			}

			[g drawImage:[self use_image:IMAGE_TITLE] : 36 :125 :150 :0 :5 :9];
			[g drawImage:[self use_image:IMAGE_TITLE] :200 :125 :155 :0 :5 :9];
			x = (240 - (TEXT_NEUTRAL_W + 8 + TEXT_OFF_W)) / 2;
			[g drawImage:[self use_image:IMAGE_TITLE] :x :125 :TEXT_NEUTRAL_X :TEXT_NEUTRAL_Y :TEXT_NEUTRAL_W :TEXT_NEUTRAL_H]; x += (TEXT_NEUTRAL_W + 8);
			if ( neutral ) {
				[g drawImage:[self use_image:IMAGE_TITLE] :x :125 :TEXT_ON_X :TEXT_ON_Y :TEXT_ON_W :TEXT_ON_H];
			} else {
				[g drawImage:[self use_image:IMAGE_TITLE] :x :125 :TEXT_OFF_X :TEXT_OFF_Y :TEXT_OFF_W :TEXT_OFF_H];
			}

			[g drawImage:[self use_image:IMAGE_TITLE] : 36 :152 :150 :0 :5 :9];
			[g drawImage:[self use_image:IMAGE_TITLE] :200 :152 :155 :0 :5 :9];
			switch ( level ) {
			case 0:
				x = (240 - (TEXT_RACE_W + 8 + TEXT_EASY_W)) / 2;
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_RACE_X :TEXT_RACE_Y :TEXT_RACE_W :TEXT_RACE_H]; x += (TEXT_RACE_W + 8);
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_EASY_X :TEXT_EASY_Y :TEXT_EASY_W :TEXT_EASY_H];
				break;
			case 1:
				x = (240 - (TEXT_RACE_W + 8 + TEXT_HARD_W)) / 2;
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_RACE_X :TEXT_RACE_Y :TEXT_RACE_W :TEXT_RACE_H]; x += (TEXT_RACE_W + 8);
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_HARD_X :TEXT_HARD_Y :TEXT_HARD_W :TEXT_HARD_H];
				break;
			case 2:
				x = (240 - (TEXT_FREE_W + 8 + TEXT_EASY_W)) / 2;
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_FREE_X :TEXT_FREE_Y :TEXT_FREE_W :TEXT_FREE_H]; x += (TEXT_FREE_W + 8);
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_EASY_X :TEXT_EASY_Y :TEXT_EASY_W :TEXT_EASY_H];
				break;
			case 3:
				x = (240 - (TEXT_FREE_W + 8 + TEXT_HARD_W)) / 2;
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_FREE_X :TEXT_FREE_Y :TEXT_FREE_W :TEXT_FREE_H]; x += (TEXT_FREE_W + 8);
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_HARD_X :TEXT_HARD_Y :TEXT_HARD_W :TEXT_HARD_H];
				break;
			case 4:
				x = (240 - (TEXT_TRAINING_W + 8 + TEXT_1_W)) / 2;
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_TRAINING_X :TEXT_TRAINING_Y :TEXT_TRAINING_W :TEXT_TRAINING_H]; x += (TEXT_TRAINING_W + 8);
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_1_X :TEXT_1_Y :TEXT_1_W :TEXT_1_H];
				break;
			case 5:
				x = (240 - (TEXT_TRAINING_W + 8 + TEXT_2_W)) / 2;
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_TRAINING_X :TEXT_TRAINING_Y :TEXT_TRAINING_W :TEXT_TRAINING_H]; x += (TEXT_TRAINING_W + 8);
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_2_X :TEXT_2_Y :TEXT_2_W :TEXT_2_H];
				break;
			case 6:
				x = (240 - (TEXT_OMAKE_W + 8 + TEXT_1_W)) / 2;
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_OMAKE_X :TEXT_OMAKE_Y :TEXT_OMAKE_W :TEXT_OMAKE_H]; x += (TEXT_OMAKE_W + 8);
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_1_X :TEXT_1_Y :TEXT_1_W :TEXT_1_H];
				break;
			case 7:
				x = (240 - (TEXT_OMAKE_W + 8 + TEXT_2_W)) / 2;
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_OMAKE_X :TEXT_OMAKE_Y :TEXT_OMAKE_W :TEXT_OMAKE_H]; x += (TEXT_OMAKE_W + 8);
				[g drawImage:[self use_image:IMAGE_TITLE] :x :152 :TEXT_2_X :TEXT_2_Y :TEXT_2_W :TEXT_2_H];
				break;
			}

			if ( level != 6 ) {
				[g drawImage:[self use_image:IMAGE_TITLE] :(240 - TEXT_BESTTIME_W) / 2 :179 :TEXT_BESTTIME_X :TEXT_BESTTIME_Y :TEXT_BESTTIME_W :TEXT_BESTTIME_H];
				if ( best_time[[self index_b]][0] == 99999 ) {
					[g drawImage:[self use_image:IMAGE_TITLE] :96 :195 :120 :0 :12 :12];
					[g drawImage:[self use_image:IMAGE_TITLE] :108 :195 :120 :0 :12 :12];
					[g drawImage:[self use_image:IMAGE_TITLE] :120 :195 :120 :0 :12 :12];
					[g drawImage:[self use_image:IMAGE_TITLE] :132 :195 :120 :0 :12 :12];
				} else {
					x = 96 + 12 * 3;
					int tmp = best_time[[self index_b]][0];
					for ( int i = 0; i < 4; i++ ) {
						[g drawImage:[self use_image:IMAGE_TITLE] :x :195 :(tmp % 10) * 12 :0 :12 :12];
						tmp /= 10;
						x -= 12;
					}
				}
			} else {
				[g drawImage:[self use_image:IMAGE_TITLE] :(240 - TEXT_DISTANCE_W) / 2 :179 :TEXT_DISTANCE_X :TEXT_DISTANCE_Y :TEXT_DISTANCE_W :TEXT_DISTANCE_H];
				int i = 0;
				int tmp = best_distance / 5;
				while ( YES ) {
					i++;
					tmp /= 10;
					if ( tmp == 0 ) {
						break;
					}
				}
				x = 240 - ((240 - (12 * i)) / 2);
				tmp = best_distance / 5;
				while ( YES ) {
					x -= 12;
					[g drawImage:[self use_image:IMAGE_TITLE] :x :195 :(tmp % 10) * 12 :0 :12 :12];
					tmp /= 10;
					if ( tmp == 0 ) {
						break;
					}
				}
			}

			if ( state == STATE_TITLE ) {
				if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
					x = (240 - (TEXT_PRESS_W + 8 + TEXT_BUTTON_W)) / 2;
					[g drawImage:[self use_image:IMAGE_TITLE] :x :225 :TEXT_PRESS_X :TEXT_PRESS_Y :TEXT_PRESS_W :TEXT_PRESS_H]; x += (TEXT_PRESS_W + 8);
					[g drawImage:[self use_image:IMAGE_TITLE] :x :225 :TEXT_BUTTON_X :TEXT_BUTTON_Y :TEXT_BUTTON_W :TEXT_BUTTON_H];
				}
			} else {
				[g drawImage:[self use_image:IMAGE_TITLE] :(240 - TEXT_LOADING_W) / 2 :225 :TEXT_LOADING_X :TEXT_LOADING_Y :TEXT_LOADING_W :TEXT_LOADING_H];
			}

			x = (240 - (TEXT_COPYRIGHT_W + 8 + TEXT_COPYRIGHT2_W)) / 2;
			[g drawImage:[self use_image:IMAGE_TITLE] :x :255 :TEXT_COPYRIGHT_X :TEXT_COPYRIGHT_Y :TEXT_COPYRIGHT_W :TEXT_COPYRIGHT_H]; x += (TEXT_COPYRIGHT_W + 8);
			[g drawImage:[self use_image:IMAGE_TITLE] :x :255 :TEXT_COPYRIGHT2_X :TEXT_COPYRIGHT2_Y :TEXT_COPYRIGHT2_W :TEXT_COPYRIGHT2_H];
		}
		[g unlock];

		if ( state == STATE_TITLE_LOADING ) {
			if ( (level < 2) || (level == 7) ) {
				[self set_state:STATE_SELECT];
			} else {
				[self set_state:STATE_READY];
			}
		}

		break;
	case STATE_SELECT:
	case STATE_SELECT_LOADING:
		// 描画
		[g lock];
		{
			int i;
			int x = 0;
			int tmp = 0;

			[g setColor:COLOR_K];
			[g fillRect:0 :0 :240 :height];

			switch ( player ) {
			case 0: [g drawScaledImage:[self use_image:IMAGE_RAY] :0 :0 :240 :height :0 :0 :240 :240]; break;
			case 1: [g drawScaledImage:[self use_image:IMAGE_RAX] :0 :0 :240 :height :0 :0 :240 :240]; break;
			case 2: [g drawScaledImage:[self use_image:IMAGE_COM] :0 :0 :240 :height :0 :0 :240 :240]; break;
			}
			[g setColor:COLOR_K];
			[g setAlpha:128];
			[g fillRect:0 :0 :240 :height];
			[g setAlpha:255];

//			[g setColor:COLOR_Y];
//			[g setFontSize:16];
//			[self centerDrawString:@"キャラクタを選んでね" :20];
			[g drawImage:[self use_image:IMAGE_TITLE] :(240 - TEXT_SELECTCHAR_W) / 2 :15 :TEXT_SELECTCHAR_X :TEXT_SELECTCHAR_Y :TEXT_SELECTCHAR_W :TEXT_SELECTCHAR_H];

			[g drawImage:[self use_image:IMAGE_TITLE] :140 - TEXT_ACCELERATION_W :140 :TEXT_ACCELERATION_X :TEXT_ACCELERATION_Y :TEXT_ACCELERATION_W :TEXT_ACCELERATION_H];
			[g drawImage:[self use_image:IMAGE_TITLE] :140 - TEXT_SLOWDOWN_W :160 :TEXT_SLOWDOWN_X :TEXT_SLOWDOWN_Y :TEXT_SLOWDOWN_W :TEXT_SLOWDOWN_H];
			[g drawImage:[self use_image:IMAGE_TITLE] :140 - TEXT_STEERING_W :180 :TEXT_STEERING_X :TEXT_STEERING_Y :TEXT_STEERING_W :TEXT_STEERING_H];

			switch ( player ) {
			case 0:
				for ( i = 0; i < 3; i++ ) {
					switch ( i ) {
					case 0: x =  65; tmp = win[[self index_w]][2]; break;
					case 1: x = 145; tmp = win[[self index_w]][0]; break;
					case 2: x = 225; tmp = win[[self index_w]][1]; break;
					}
					while ( tmp != 0 ) {
						[g drawImage:[self use_image:IMAGE_TITLE] :x :50 :(tmp % 10) * 12 :0 :12 :12];
						tmp /= 10;
						x -= 12;
					}
				}

				[g drawImage:[self use_image:IMAGE_SPEEDER3] : 40 - (SPEEDER3_W[0] / 2) :55 :SPEEDER3_X[0] :0 :SPEEDER3_W[0] :43];
				[g drawImage:[self use_image:IMAGE_SPEEDER1] :120 - (SPEEDER1_W[0] / 2) :55 :SPEEDER1_X[0] :0 :SPEEDER1_W[0] :43];
				[g drawImage:[self use_image:IMAGE_SPEEDER2] :200 - (SPEEDER2_W[0] / 2) :57 :SPEEDER2_X[0] :0 :SPEEDER2_W[0] :41];

				[g drawImage:[self use_image:IMAGE_TITLE] :(240 - TEXT_RAY_W) / 2 :105 :TEXT_RAY_X :TEXT_RAY_Y :TEXT_RAY_W :TEXT_RAY_H];

				[g drawImage:[self use_image:IMAGE_TITLE] :150 :140 :TEXT_FAST_X :TEXT_FAST_Y :TEXT_FAST_W :TEXT_FAST_H];
				[g drawImage:[self use_image:IMAGE_TITLE] :150 :160 :TEXT_NORMAL_X :TEXT_NORMAL_Y :TEXT_NORMAL_W :TEXT_NORMAL_H];
				[g drawImage:[self use_image:IMAGE_TITLE] :150 :180 :TEXT_NORMAL_X :TEXT_NORMAL_Y :TEXT_NORMAL_W :TEXT_NORMAL_H];

				break;
			case 1:
				for ( i = 0; i < 3; i++ ) {
					switch ( i ) {
					case 0: x =  65; tmp = win[[self index_w]][0]; break;
					case 1: x = 145; tmp = win[[self index_w]][1]; break;
					case 2: x = 225; tmp = win[[self index_w]][2]; break;
					}
					while ( tmp != 0 ) {
						[g drawImage:[self use_image:IMAGE_TITLE] :x :50 :(tmp % 10) * 12 :0 :12 :12];
						tmp /= 10;
						x -= 12;
					}
				}

				[g drawImage:[self use_image:IMAGE_SPEEDER1] : 40 - (SPEEDER1_W[0] / 2) :55 :SPEEDER1_X[0] :0 :SPEEDER1_W[0] :43];
				[g drawImage:[self use_image:IMAGE_SPEEDER2] :120 - (SPEEDER2_W[0] / 2) :57 :SPEEDER2_X[0] :0 :SPEEDER2_W[0] :41];
				[g drawImage:[self use_image:IMAGE_SPEEDER3] :200 - (SPEEDER3_W[0] / 2) :55 :SPEEDER3_X[0] :0 :SPEEDER3_W[0] :43];

				[g drawImage:[self use_image:IMAGE_TITLE] :(240 - TEXT_RAX_W) / 2 :105 :TEXT_RAX_X :TEXT_RAX_Y :TEXT_RAX_W :TEXT_RAX_H];

				[g drawImage:[self use_image:IMAGE_TITLE] :150 :140 :TEXT_MIDDLE_X :TEXT_MIDDLE_Y :TEXT_MIDDLE_W :TEXT_MIDDLE_H];
				[g drawImage:[self use_image:IMAGE_TITLE] :150 :160 :TEXT_SLIGHT_X :TEXT_SLIGHT_Y :TEXT_SLIGHT_W :TEXT_SLIGHT_H];
				[g drawImage:[self use_image:IMAGE_TITLE] :150 :180 :TEXT_NORMAL_X :TEXT_NORMAL_Y :TEXT_NORMAL_W :TEXT_NORMAL_H];

				break;
			case 2:
				for ( i = 0; i < 3; i++ ) {
					switch ( i ) {
					case 0: x =  65; tmp = win[[self index_w]][1]; break;
					case 1: x = 145; tmp = win[[self index_w]][2]; break;
					case 2: x = 225; tmp = win[[self index_w]][0]; break;
					}
					while ( tmp != 0 ) {
						[g drawImage:[self use_image:IMAGE_TITLE] :x :50 :(tmp % 10) * 12 :0 :12 :12];
						tmp /= 10;
						x -= 12;
					}
				}

				[g drawImage:[self use_image:IMAGE_SPEEDER2] : 40 - (SPEEDER2_W[0] / 2) :57 :SPEEDER2_X[0] :0 :SPEEDER2_W[0] :41];
				[g drawImage:[self use_image:IMAGE_SPEEDER3] :120 - (SPEEDER3_W[0] / 2) :55 :SPEEDER3_X[0] :0 :SPEEDER3_W[0] :43];
				[g drawImage:[self use_image:IMAGE_SPEEDER1] :200 - (SPEEDER1_W[0] / 2) :55 :SPEEDER1_X[0] :0 :SPEEDER1_W[0] :43];

				[g drawImage:[self use_image:IMAGE_TITLE] :(240 - TEXT_COM_W) / 2 :105 :TEXT_COM_X :TEXT_COM_Y :TEXT_COM_W :TEXT_COM_H];

				[g drawImage:[self use_image:IMAGE_TITLE] :150 :140 :TEXT_SLOW_X :TEXT_SLOW_Y :TEXT_SLOW_W :TEXT_SLOW_H];
				[g drawImage:[self use_image:IMAGE_TITLE] :150 :160 :TEXT_NORMAL_X :TEXT_NORMAL_Y :TEXT_NORMAL_W :TEXT_NORMAL_H];
				[g drawImage:[self use_image:IMAGE_TITLE] :150 :180 :TEXT_QUICK_X :TEXT_QUICK_Y :TEXT_QUICK_W :TEXT_QUICK_H];

				break;
			}

			[g setColor:COLOR_W];
			[g setStrokeWidth:1];
			[self drawButton:g :MYLAYOUT_LEFT];
			[self drawButton:g :MYLAYOUT_RIGHT];
			if ( state == STATE_SELECT ) {
				[self drawButton:g :MYLAYOUT_SELECT];
			}

			[self setCMYColor:_elapse % 3];
			[g drawRect:80 :45 :80 :80];
			[g drawImage:[self use_image:IMAGE_TITLE] : 56 :81 :150 :0 :5 :9];
			[g drawImage:[self use_image:IMAGE_TITLE] :180 :81 :155 :0 :5 :9];

			if ( state == STATE_SELECT ) {
				if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
					x = (240 - (TEXT_PRESS_W + 8 + TEXT_BUTTON_W)) / 2;
					[g drawImage:[self use_image:IMAGE_TITLE] :x :225 :TEXT_PRESS_X :TEXT_PRESS_Y :TEXT_PRESS_W :TEXT_PRESS_H]; x += (TEXT_PRESS_W + 8);
					[g drawImage:[self use_image:IMAGE_TITLE] :x :225 :TEXT_BUTTON_X :TEXT_BUTTON_Y :TEXT_BUTTON_W :TEXT_BUTTON_H];
				}
			} else {
				[g drawImage:[self use_image:IMAGE_TITLE] :(240 - TEXT_LOADING_W) / 2 :225 :TEXT_LOADING_X :TEXT_LOADING_Y :TEXT_LOADING_W :TEXT_LOADING_H];
			}
		}
		[g unlock];

		if ( state == STATE_SELECT_LOADING ) {
			[self set_state:STATE_READY];
		}

		break;
	case STATE_READY:
		// 描画
		[g lock];
		[stage draw:YES];
		[wave draw];
		[speeder[0] draw:YES];
		if ( (level < 2) || (level == 7) ) {
			[speeder[1] draw:YES];
			[speeder[2] draw:YES];
		}
		switch ( level ) {
		case 4:
			[g drawImage:[self use_image:IMAGE_STATUS] :(240 - TEXT_AUTOSTEERING_W) / 2 :80 :TEXT_AUTOSTEERING_X :TEXT_AUTOSTEERING_Y :TEXT_AUTOSTEERING_W :TEXT_AUTOSTEERING_H];
			break;
		case 5:
			[g drawImage:[self use_image:IMAGE_STATUS] :(240 - TEXT_AUTOSHIELD_W) / 2 :80 :TEXT_AUTOSHIELD_X :TEXT_AUTOSHIELD_Y :TEXT_AUTOSHIELD_W :TEXT_AUTOSHIELD_H];
			break;
		}
		[g drawImage:[self use_image:IMAGE_STATUS] :(240 - TEXT_READY_W) / 2 :(240 - TEXT_READY_H) / 2 :TEXT_READY_X :TEXT_READY_Y :TEXT_READY_W :TEXT_READY_H];
		[self drawStatus:YES];
		[g unlock];

		// 一定時間過ぎたらゲーム開始
		if ( _elapse > WAIT_2 ) {
			[self set_state:STATE_PLAY];
		}

		break;
	case STATE_PLAY:
		if ( !pause ) {
			int i;

			time[0]++;

			// 更新前の座標を保持
			if ( (level < 2) || (level == 7) ) {
				old_y[0] = [speeder[1] dsp_y];
				old_y[1] = [speeder[2] dsp_y];
			}

			// 更新
			[stage update];
			[wave update];

			if ( (level < 2) || (level == 7) ) {
				for ( i = 0; i < 2; i++ ) {
					if ( shield_wait[i] > 0 ) {
						shield_wait[i]--;
						if ( shield_wait[i] == 0 ) {
							[speeder[i + 1] shield:shield_col[i]];
						}
					}

					new_y[i] = [speeder[i + 1] dsp_y];
					if ( (old_y[i] > -48) && (new_y[i] <= -48) ) {
						[speeder[i + 1] out:[wave top_x]];
					} else if ( (old_y[i] <= -48) && (new_y[i] > -48) ) {
						[speeder[i + 1] in:[wave top_x]];
					} else if ( (old_y[i] < 320) && (new_y[i] >= 320) ) {
						[speeder[i + 1] out:[wave bottom_x]];
					} else if ( (old_y[i] >= 320) && (new_y[i] < 320) ) {
						[speeder[i + 1] in:[wave bottom_x]];
					}

					if ( new_y[i] <= -48 ) {
						if ( [speeder[0] speed] < 310 ) {
							[speeder[i + 1] speed_limit:300];
						} else {
							[speeder[i + 1] speed_limit:[speeder[0] speed] - 10];
						}
					}
				}
			}

			// スピーダーの移動
			if ( level == 4 ) {
				switch ( [speeder[0] auto] ) {
				case AUTO_MOVED_INERTIA: [speeder[0] auto:AUTO_INERTIA]; break;
				case AUTO_MOVED_NEUTRAL: [speeder[0] auto:AUTO_NEUTRAL]; break;
				case AUTO_INERTIA: [speeder[0] inertia:NO]; break;
				case AUTO_NEUTRAL: [speeder[0] inertia:YES]; break;
				}
			} else {
				if      ( (layoutState & (1 << MYLAYOUT_LEFT )) != 0 ) [speeder[0] left];
				else if ( (layoutState & (1 << MYLAYOUT_RIGHT)) != 0 ) [speeder[0] right];
				else if ( sensor_f && ((int)[sensor getRoll] / 6 > 0) ) [speeder[0] left];
				else if ( sensor_f && ((int)[sensor getRoll] / 6 < 0) ) [speeder[0] right];
				else [speeder[0] inertia:neutral];
				if ( (level < 2) || (level == 7) ) {
					for ( i = 1; i < 3; i++ ) {
						switch ( [speeder[i] auto] ) {
						case AUTO_MOVED_INERTIA: [speeder[i] auto:AUTO_INERTIA]; break;
						case AUTO_MOVED_NEUTRAL: [speeder[i] auto:AUTO_NEUTRAL]; break;
						case AUTO_INERTIA: [speeder[i] inertia:NO]; break;
						case AUTO_NEUTRAL: [speeder[i] inertia:YES]; break;
						}
					}
				}
			}
		}

		// 描画
		[g lock];
		[stage draw:NO];
		{
			int cnt = [wave draw];
			if ( (cnt < 0) || ([stage offset_x] < 0) ) {
				if ( ([self elapse] % 2) == 0 ) {
					[g drawImage:[self use_image:IMAGE_BAR] :10 :102 :200 :0 :40 :36];
				}
			} else if ( (cnt > 0) || ([stage offset_x] > 0) ) {
				if ( ([self elapse] % 2) == 0 ) {
					[g drawImage:[self use_image:IMAGE_BAR] :190 :102 :200 :36 :40 :36];
				}
			}
		}
		[speeder[0] draw:NO];
		if ( (level < 2) || (level == 7) ) {
			[speeder[1] draw:NO];
			[speeder[2] draw:NO];
		}
		if ( level != 6 ) {
			if ( _elapse < WAIT_2 ) {
				[g drawImage:[self use_image:IMAGE_STATUS] :(240 - TEXT_START_W) / 2 :(240 - TEXT_START_H) / 2 :TEXT_START_X :TEXT_START_Y :TEXT_START_W :TEXT_START_H];
			}
		}
		if ( pause ) {
			if ( (_elapse_p % WAIT_1) <= (WAIT_1 / 2) ) {
				[g drawImage:[self use_image:IMAGE_STATUS] :(240 - TEXT_PAUSE_W) / 2 :125 :TEXT_PAUSE_X :TEXT_PAUSE_Y :TEXT_PAUSE_W :TEXT_PAUSE_H];
			}
		}
		[self drawStatus:NO];
		[g unlock];

		if ( level != 6 ) {
			if ( finish ) {
				// ステージクリア
				[self set_state:STATE_CLEAR];
			}
		} else {
			if ( [speeder[0] speed] == 0 ) {
				// ゲーム終了
				[self set_state:STATE_STOP];
			}
		}

		break;
	case STATE_CLEAR:
		{
			int i;

			// 更新前の座標を保持
			if ( (level < 2) || (level == 7) ) {
				old_y[0] = [speeder[1] dsp_y];
				old_y[1] = [speeder[2] dsp_y];
			}

			// 更新
			[stage update];
			[wave update];

			if ( (level < 2) || (level == 7) ) {
				for ( i = 0; i < 2; i++ ) {
					new_y[i] = [speeder[i + 1] dsp_y];
					if ( (old_y[i] <= -48) && (new_y[i] > -48) ) {
						[speeder[i + 1] in:[speeder[0] x] - 88];
					} else if ( (old_y[i] >= 320) && (new_y[i] < 320) ) {
						[speeder[i + 1] in:[speeder[0] x] - 88];
					}
				}
			}

			// スピーダーの移動
			[speeder[0] inertia:YES];
			if ( (level < 2) || (level == 7) ) {
				[speeder[1] inertia:YES];
				[speeder[2] inertia:YES];
			}
		}

		// 描画
		[g lock];
		[stage draw:NO];
		[wave draw];
		[speeder[0] draw:NO];
		if ( (level < 2) || (level == 7) ) {
			[speeder[1] draw:NO];
			[speeder[2] draw:NO];
		}
		if ( (level < 2) || (level == 7) ) {
			int y = (240 - (TEXT_FINISH_H + 10 + TEXT_1ST_H + 10 + TEXT_NEWRECORD_H)) / 2;
			[g drawImage:[self use_image:IMAGE_STATUS] :(240 - TEXT_FINISH_W) / 2 :y :TEXT_FINISH_X :TEXT_FINISH_Y :TEXT_FINISH_W :TEXT_FINISH_H];
			y += (TEXT_FINISH_H + 10);
			switch ( ranking ) {
			case 1:
				[g drawImage:[self use_image:IMAGE_STATUS] :(240 - TEXT_1ST_W) / 2 :y :TEXT_1ST_X :TEXT_1ST_Y :TEXT_1ST_W :TEXT_1ST_H];
				break;
			case 2:
				[g drawImage:[self use_image:IMAGE_STATUS] :(240 - TEXT_2ND_W) / 2 :y :TEXT_2ND_X :TEXT_2ND_Y :TEXT_2ND_W :TEXT_2ND_H];
				break;
			case 3:
				[g drawImage:[self use_image:IMAGE_STATUS] :(240 - TEXT_3RD_W) / 2 :y :TEXT_3RD_X :TEXT_3RD_Y :TEXT_3RD_W :TEXT_3RD_H];
				break;
			}
			y += (TEXT_1ST_H + 10);
			if ( new_time ) {
				[g drawImage:[self use_image:IMAGE_STATUS] :(240 - TEXT_NEWRECORD_W) / 2 :y :TEXT_NEWRECORD_X :TEXT_NEWRECORD_Y :TEXT_NEWRECORD_W :TEXT_NEWRECORD_H];
			}
		} else {
			[g drawImage:[self use_image:IMAGE_STATUS] :(240 - TEXT_FINISH_W) / 2 :(240 - TEXT_FINISH_H) / 2 :TEXT_FINISH_X :TEXT_FINISH_Y :TEXT_FINISH_W :TEXT_FINISH_H];
			if ( new_time ) {
				[g drawImage:[self use_image:IMAGE_STATUS] :(240 - TEXT_NEWRECORD_W) / 2 :140 :TEXT_NEWRECORD_X :TEXT_NEWRECORD_Y :TEXT_NEWRECORD_W :TEXT_NEWRECORD_H];
			}
		}
		[self drawStatus:NO];
		[g unlock];

		// 一定時間過ぎたらタイトル画面へ
		if ( _elapse > WAIT_3 ) {
			[self set_state:STATE_TITLE];
		}

		break;
	case STATE_STOP:
		// スピーダーの移動
		[speeder[0] inertia:YES];

		// 描画
		[g lock];
		[stage draw:NO];
		[wave draw];
		[speeder[0] draw:NO];
		{
			int x = (240 - (TEXT_STOP_W + 3 + TEXT_PED_W)) / 2;
			int y = (240 - TEXT_STOP_H) / 2;
			[g drawImage:[self use_image:IMAGE_STATUS] :x :y :TEXT_STOP_X :TEXT_STOP_Y :TEXT_STOP_W :TEXT_STOP_H]; x += (TEXT_STOP_W + 3);
			[g drawImage:[self use_image:IMAGE_STATUS] :x :y :TEXT_PED_X :TEXT_PED_Y :TEXT_PED_W :TEXT_PED_H];
		}
		if ( new_distance ) {
			[g drawImage:[self use_image:IMAGE_STATUS] :(240 - TEXT_NEWRECORD_W) / 2 :140 :TEXT_NEWRECORD_X :TEXT_NEWRECORD_Y :TEXT_NEWRECORD_W :TEXT_NEWRECORD_H];
		}
		[self drawStatus:NO];
		[g unlock];

		// 一定時間過ぎたらタイトル画面へ
		if ( _elapse > WAIT_3 ) {
			[self set_state:STATE_TITLE];
		}

		break;
	}

	if ( (state != STATE_PLAY) || !pause ) {
		_elapse++;
	}
	if ( pause ) {
		_elapse_p++;
	} else if ( _elapse_s > 0 ) {
		_elapse_s++;
	}

	[_g lock];

	[_g setColor:[_Graphics getColorOfRGB:64 :64 :64]];
	[_g fillRect:0 :0 :[self getWidth] :[self getHeight]];

	[_g drawScaledImage:window :[self getWindowLeft] :[self getWindowTop] :[self getWindowRight] - [self getWindowLeft] :[self getWindowBottom] - [self getWindowTop]];

	[_g setColor:COLOR_W];
	[_g setStrokeWidth:3];
	[_g setFontSize:24];
	switch ( state ) {
	case STATE_LAUNCH:
	case STATE_TITLE_LOADING:
	case STATE_SELECT_LOADING:
		break;
	case STATE_TITLE:
//		[self drawScreenButton:_g :MYLAYOUT_BACK :@"終了"];
		break;
	case STATE_SELECT:
		[self drawScreenButton:_g :MYLAYOUT_BACK :@"戻る"];
		break;
	default:
		[self drawScreenButton:_g :MYLAYOUT_PAUSE :@"中断"];
		[self drawScreenButton:_g :MYLAYOUT_BACK :@"戻る"];
		[_g setColor:COLOR_C];
		[self drawScreenButton2:_g :MYLAYOUT_SHIELD_0];
		[_g setColor:COLOR_M];
		[self drawScreenButton2:_g :MYLAYOUT_SHIELD_1];
		[_g setColor:COLOR_Y];
		[self drawScreenButton2:_g :MYLAYOUT_SHIELD_2];
		break;
	}

//	[_g setColor:COLOR_W];
//	[_g setStrokeWidth:1];
//	[_g setFontSize:16];
//	[self drawLayout:_g];

	[_g unlock];
}

- (void)_processEvent:(int)type :(int)param
{
	if ( processingEvent ) return;
	processingEvent = YES;

	if( type == LAYOUT_DOWN_EVENT ) {
		switch ( state ) {
		case STATE_LAUNCH:
			break;
		case STATE_TITLE:
			switch ( param ) {
			case MYLAYOUT_LEFT1:
			case MYLAYOUT_RIGHT1:
				sensor_f = sensor_f ? NO : YES;
				break;
			case MYLAYOUT_LEFT2:
			case MYLAYOUT_RIGHT2:
				neutral = neutral ? NO : YES;
				break;
			case MYLAYOUT_LEFT3:
				level--; if ( level < 0 ) level = [self level_max];
				break;
			case MYLAYOUT_RIGHT3:
				level++; if ( level > [self level_max] ) level = 0;
				break;
			case MYLAYOUT_SELECT:
				[self set_state:STATE_TITLE_LOADING];
				break;
			}
			break;
		case STATE_TITLE_LOADING:
			break;
		case STATE_SELECT:
			switch ( param ) {
			case MYLAYOUT_LEFT:
				player--; if ( player < 0 ) player = 2;
				break;
			case MYLAYOUT_RIGHT:
				player++; if ( player > 2 ) player = 0;
				break;
			case MYLAYOUT_SELECT:
				[self set_state:STATE_SELECT_LOADING];
				break;
			case MYLAYOUT_BACK:
				[self set_state:STATE_TITLE];
				break;
			}
			break;
		case STATE_SELECT_LOADING:
			break;
		default:
			switch ( param ) {
			case MYLAYOUT_PAUSE:
				pause = pause ? NO : YES; if ( pause ) _elapse_p = 0;
				break;
			case MYLAYOUT_BACK:
				[self set_state:STATE_TITLE];
				break;
			case MYLAYOUT_SHIELD_0:
				if ( level != 5 ) {
					if ( !pause ) {
						if ( boost && ([speeder[0] shield] == 0) ) {
							_elapse_b = _elapse;
							boost = NO;
							[speeder[0] speed_up:400];
						} else {
							[speeder[0] shield:0];
						}
					}
				}
				break;
			case MYLAYOUT_SHIELD_1:
				if ( level != 5 ) {
					if ( !pause ) {
						if ( boost && ([speeder[0] shield] == 1) ) {
							_elapse_b = _elapse;
							boost = NO;
							[speeder[0] speed_up:400];
						} else {
							[speeder[0] shield:1];
						}
					}
				}
				break;
			case MYLAYOUT_SHIELD_2:
				if ( level != 5 ) {
					if ( !pause ) {
						if ( boost && ([speeder[0] shield] == 2) ) {
							_elapse_b = _elapse;
							boost = NO;
							[speeder[0] speed_up:400];
						} else {
							[speeder[0] shield:2];
						}
					}
				}
				break;
			}
			break;
		}
	}

	processingEvent = NO;
}

@end
