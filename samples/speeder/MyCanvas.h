#import "_Canvas.h"

// ゴールまでの距離
#define DISTANCE				1000000

// アプリの状態
#define STATE_LAUNCH			-1
#define STATE_TITLE				0
#define STATE_TITLE_LOADING		1
#define STATE_SELECT			3
#define STATE_SELECT_LOADING	4
#define STATE_READY				5
#define STATE_PLAY				6
#define STATE_CLEAR				7
#define STATE_STOP				8

// 1フレームの時間(ミリ秒)
#define FRAME_TIME				65

// 待ちフレーム数
#define WAIT_BOOST				15
#define WAIT_1					30
#define WAIT_2					60
#define WAIT_3					90

// 画像の種類
#define IMAGE_BACK				0
#define IMAGE_BAR				1
#define IMAGE_FORE1				2
#define IMAGE_FORE2				3
#define IMAGE_FORE3				4
#define IMAGE_FORE4				5
#define IMAGE_FORE5A			6
#define IMAGE_FORE5B			7
#define IMAGE_FORE6A			8
#define IMAGE_FORE6B			9
#define IMAGE_LOGO				10
#define IMAGE_SHIELD			11
#define IMAGE_SPEEDER1			12
#define IMAGE_SPEEDER2			13
#define IMAGE_SPEEDER3			14
#define IMAGE_STATUS			15
#define IMAGE_TITLE				16
#define IMAGE_RAY				17
#define IMAGE_COM				18
#define IMAGE_RAX				19
#define IMAGE_NUM				20	// 画像の数

// タイトル画面テキスト情報
#define TEXT_NEUTRAL_X			0
#define TEXT_NEUTRAL_Y			12
#define TEXT_NEUTRAL_W			74
#define TEXT_NEUTRAL_H			10
#define TEXT_ON_X				0
#define TEXT_ON_Y				22
#define TEXT_ON_W				20
#define TEXT_ON_H				10
#define TEXT_OFF_X				22
#define TEXT_OFF_Y				22
#define TEXT_OFF_W				28
#define TEXT_OFF_H				10
#define TEXT_RACE_X				0
#define TEXT_RACE_Y				32
#define TEXT_RACE_W				38
#define TEXT_RACE_H				10
#define TEXT_FREE_X				40
#define TEXT_FREE_Y				32
#define TEXT_FREE_W				38
#define TEXT_FREE_H				10
#define TEXT_TRAINING_X			80
#define TEXT_TRAINING_Y			32
#define TEXT_TRAINING_W			80
#define TEXT_TRAINING_H			10
#define TEXT_EASY_X				0
#define TEXT_EASY_Y				42
#define TEXT_EASY_W				40
#define TEXT_EASY_H				10
#define TEXT_HARD_X				42
#define TEXT_HARD_Y				42
#define TEXT_HARD_W				40
#define TEXT_HARD_H				10
#define TEXT_1_X				84
#define TEXT_1_Y				42
#define TEXT_1_W				8
#define TEXT_1_H				10
#define TEXT_2_X				94
#define TEXT_2_Y				42
#define TEXT_2_W				8
#define TEXT_2_H				10
#define TEXT_OMAKE_X			104
#define TEXT_OMAKE_Y			42
#define TEXT_OMAKE_W			52
#define TEXT_OMAKE_H			10
#define TEXT_BESTTIME_X			0
#define TEXT_BESTTIME_Y			52
#define TEXT_BESTTIME_W			90
#define TEXT_BESTTIME_H			10
#define TEXT_DISTANCE_X			0
#define TEXT_DISTANCE_Y			62
#define TEXT_DISTANCE_W			80
#define TEXT_DISTANCE_H			10
#define TEXT_PRESS_X			0
#define TEXT_PRESS_Y			72
#define TEXT_PRESS_W			48
#define TEXT_PRESS_H			10
#define TEXT_KEY_X				50
#define TEXT_KEY_Y				72
#define TEXT_KEY_W				30
#define TEXT_KEY_H				10
#define TEXT_ENTER_X			0
#define TEXT_ENTER_Y			82
#define TEXT_ENTER_W			52
#define TEXT_ENTER_H			10
#define TEXT_SELECT_X			54
#define TEXT_SELECT_Y			82
#define TEXT_SELECT_W			60
#define TEXT_SELECT_H			10
#define TEXT_LOADING_X			0
#define TEXT_LOADING_Y			92
#define TEXT_LOADING_W			86
#define TEXT_LOADING_H			10
#define TEXT_COPYRIGHT_X		0
#define TEXT_COPYRIGHT_Y		102
#define TEXT_COPYRIGHT_W		92
#define TEXT_COPYRIGHT_H		10
#define TEXT_COPYRIGHT2_X		0
#define TEXT_COPYRIGHT2_Y		112
#define TEXT_COPYRIGHT2_W		94
#define TEXT_COPYRIGHT2_H		10
#define TEXT_SELECTCHAR_X		0
#define TEXT_SELECTCHAR_Y		122
#define TEXT_SELECTCHAR_W		160
#define TEXT_SELECTCHAR_H		10
#define TEXT_RAY_X				0
#define TEXT_RAY_Y				132
#define TEXT_RAY_W				30
#define TEXT_RAY_H				10
#define TEXT_RAX_X				32
#define TEXT_RAX_Y				132
#define TEXT_RAX_W				30
#define TEXT_RAX_H				10
#define TEXT_COM_X				64
#define TEXT_COM_Y				132
#define TEXT_COM_W				32
#define TEXT_COM_H				10
#define TEXT_ACCELERATION_X		0
#define TEXT_ACCELERATION_Y		142
#define TEXT_ACCELERATION_W		120
#define TEXT_ACCELERATION_H		10
#define TEXT_FAST_X				0
#define TEXT_FAST_Y				152
#define TEXT_FAST_W				40
#define TEXT_FAST_H				10
#define TEXT_MIDDLE_X			42
#define TEXT_MIDDLE_Y			152
#define TEXT_MIDDLE_W			60
#define TEXT_MIDDLE_H			10
#define TEXT_SLOW_X				104
#define TEXT_SLOW_Y				152
#define TEXT_SLOW_W				42
#define TEXT_SLOW_H				10
#define TEXT_SLOWDOWN_X			0
#define TEXT_SLOWDOWN_Y			162
#define TEXT_SLOWDOWN_W			88
#define TEXT_SLOWDOWN_H			10
#define TEXT_NORMAL_X			0
#define TEXT_NORMAL_Y			172
#define TEXT_NORMAL_W			64
#define TEXT_NORMAL_H			10
#define TEXT_SLIGHT_X			66
#define TEXT_SLIGHT_Y			172
#define TEXT_SLIGHT_W			60
#define TEXT_SLIGHT_H			10
#define TEXT_STEERING_X			0
#define TEXT_STEERING_Y			182
#define TEXT_STEERING_W			80
#define TEXT_STEERING_H			10
#define TEXT_QUICK_X			0
#define TEXT_QUICK_Y			192
#define TEXT_QUICK_W			50
#define TEXT_QUICK_H			10
#define TEXT_SENSOR_X			0
#define TEXT_SENSOR_Y			202
#define TEXT_SENSOR_W			60
#define TEXT_SENSOR_H			10
#define TEXT_BUTTON_X			82
#define TEXT_BUTTON_Y			72
#define TEXT_BUTTON_W			66
#define TEXT_BUTTON_H			10

// ステータステキスト情報
#define TEXT_READY_X			0
#define TEXT_READY_Y			74
#define TEXT_READY_W			101
#define TEXT_READY_H			21
#define TEXT_START_X			0
#define TEXT_START_Y			95
#define TEXT_START_W			119
#define TEXT_START_H			21
#define TEXT_FINISH_X			0
#define TEXT_FINISH_Y			116
#define TEXT_FINISH_W			131
#define TEXT_FINISH_H			21
#define TEXT_STOP_X				0
#define TEXT_STOP_Y				137
#define TEXT_STOP_W				81
#define TEXT_STOP_H				21
#define TEXT_PED_X				0
#define TEXT_PED_Y				158
#define TEXT_PED_W				71
#define TEXT_PED_H				21
#define TEXT_1ST_X				71
#define TEXT_1ST_Y				158
#define TEXT_1ST_W				52
#define TEXT_1ST_H				31
#define TEXT_2ND_X				0
#define TEXT_2ND_Y				189
#define TEXT_2ND_W				58
#define TEXT_2ND_H				31
#define TEXT_3RD_X				58
#define TEXT_3RD_Y				189
#define TEXT_3RD_W				55
#define TEXT_3RD_H				31
#define TEXT_PAUSE_X			0
#define TEXT_PAUSE_Y			220
#define TEXT_PAUSE_W			51
#define TEXT_PAUSE_H			11
#define TEXT_NEWRECORD_X		0
#define TEXT_NEWRECORD_Y		231
#define TEXT_NEWRECORD_W		109
#define TEXT_NEWRECORD_H		11
#define TEXT_AUTOSTEERING_X		0
#define TEXT_AUTOSTEERING_Y		242
#define TEXT_AUTOSTEERING_W		131
#define TEXT_AUTOSTEERING_H		11
#define TEXT_AUTOSHIELD_X		0
#define TEXT_AUTOSHIELD_Y		253
#define TEXT_AUTOSHIELD_W		109
#define TEXT_AUTOSHIELD_H		11

// スピーダーの種類
#define SPEEDER1				0
#define SPEEDER2				1
#define SPEEDER3				2
#define SPEEDER4				3
#define SPEEDER5				4

// 自動移動の種類
#define AUTO_INERTIA			0
#define AUTO_NEUTRAL			1
#define AUTO_MOVED_INERTIA		2
#define AUTO_MOVED_NEUTRAL		3

#define MYLAYOUT_LEFT			0
#define MYLAYOUT_RIGHT			1
#define MYLAYOUT_UP				2
#define MYLAYOUT_DOWN			3
#define MYLAYOUT_SELECT			4
#define MYLAYOUT_BACK			5
#define MYLAYOUT_PAUSE			6
#define MYLAYOUT_SHIELD_0		7
#define MYLAYOUT_SHIELD_1		8
#define MYLAYOUT_SHIELD_2		9
#define MYLAYOUT_LEFT1			10
#define MYLAYOUT_RIGHT1			11
#define MYLAYOUT_LEFT2			12
#define MYLAYOUT_RIGHT2			13
#define MYLAYOUT_LEFT3			14
#define MYLAYOUT_RIGHT3			15

@class _Random;
@class _Sensor;
@class Speeder;
@class Stage;
@class Wave;

/*
 * キャンバス
 */
@interface MyCanvas : _Canvas
{
@public
	_Image* window;
	_Graphics* g;

	_Random* rand;
	Stage* stage;
	Wave* wave;
	Speeder* speeder[3];

	// よく使う色
	int COLOR_C;
	int COLOR_M;
	int COLOR_Y;
	int COLOR_K;
	int COLOR_W;

	const int* SPEEDER1_X;
	const int* SPEEDER1_X_M;
	const int* SPEEDER1_W;

	const int* SPEEDER2_X;
	const int* SPEEDER2_X_M;
	const int* SPEEDER2_W;

	const int* SPEEDER3_X;
	const int* SPEEDER3_X_M;
	const int* SPEEDER3_W;

	int load_cnt;				// ロード済みデータ数
	int load_num;				// ロード数

	int state;// = STATE_LAUNCH;	// アプリの状態
	int help;					// ヘルプの種類
	int help_back;// = -1;			// ヘルプ背景の種類
	int _elapse;				// 経過時間
	int _elapse_p;				// ポーズ中の経過時間
	int _elapse_s;				// シールド切り替え速度
	BOOL pause;// = NO;		// ポーズ中かどうか
	int shield_lag[2];
	int shield_index;
	int shield_wait[2];
	int shield_col[2];

	int change_col;

	int height;

	BOOL sensor_f;			// モーションセンサーを使用するかどうか
	BOOL neutral;			// キー解放でニュートラルにするかどうか
	int level;					// レベル
	int player;					// 使用キャラクタ

	BOOL first;				// 初挑戦かどうか

	int time[10];					// 今回のタイム
	int best_time[7][10];			// ベストタイム
	int win[3][3];				// １位になった回数
	int ranking;				// 順位
	BOOL new_time;			// 記録更新かどうか

	int best_distance;			// ベスト走行距離
	int old_distance;			//
	BOOL new_distance;		// 記録更新かどうか

	int _elapse_l;				// 計測ポイント通過時の時間
	int lap;					// ラップ
	int lap_time;				// ラップタイムの差
	BOOL dsp_lap;			// ラップタイムの差を表示するかどうか
	BOOL finish;				// フィニッシュラインかどうか

	BOOL boost;				// ブースト可能かどうか
	int _elapse_b;				// ブースト使用時の時間

	int old_y[2];
	int new_y[2];

	_Image* main_img[IMAGE_NUM];

	_Layout* layout;
	int layoutState;// = 0;

	_Sensor* sensor;

	// キー入力時処理のコンフリクト抑制用
	BOOL processingEvent;// = NO;
}

- (void)load_config;
- (void)save_config;
- (void)create_image:(int)id;
- (void)dispose_image:(int)id;
- (void)dispose_image;
- (_Image*)use_image:(int)id;
- (int)elapse;
- (BOOL)omake1;
- (BOOL)omake2;
- (int)level_max;
- (int)index_b;
- (int)index_w;
- (void)set_state:(int)new_state;
- (void)setCMYColor:(int)col;
- (int)drawImage:(_Image*)img :(int)x0 :(int)y0 :(int)x :(int)y :(int)w :(int)h;
- (void)drawButton:(_Graphics*)g :(int)id;
- (void)drawScreenButton:(_Graphics*)g :(int)id :(NSString*)str;
- (void)drawScreenButton2:(_Graphics*)g :(int)id;
- (void)centerDrawString:(NSString*)str :(int)y;
- (void)drawStatus:(BOOL)ready;

@end
