/************************************************
 * R a y  S p e e d e r                         *
 * Copyright (C) SatisKia. All rights reserved. *
 ************************************************
 * ADF設定                                      *
 * AppClass  ：Main                             *
 * AppName   ：Ray Speeder                      *
 * SPsize    ：505i:204800 900i:301056          *
 * UseNetwork：http                             *
 ************************************************/

import com.nttdocomo.io.*;
import com.nttdocomo.ui.*;
import com.nttdocomo.util.*;
import javax.microedition.io.*;
import java.io.*;
import java.util.*;

#ifdef _505i
#define RESOURCE_NAME		"data_505i."
#endif // _505i
#ifdef _900i
#define RESOURCE_NAME		"data_900i."
#endif // _900i
#define RESOURCE_TOP		512

// ストリーム読み込みブロックサイズ
#define DATA_SIZE			256

// フォントの種類
#define FONT_TINY			0
#define FONT_SMALL			1
#define FONT_MEDIUM			2

// ゴールまでの距離
#define DISTANCE			1000000

// アプリの状態
#define STATE_DOWNLOAD			-5
#define STATE_DOWNLOADERROR		-4
#define STATE_RELOAD			-3
#define STATE_RELOADCONFIRM		-2
#define STATE_LAUNCH			-1
#define STATE_TITLE				0
#define STATE_TITLE_LOADING		1
#define STATE_HELP				2
#define STATE_SELECT			3
#define STATE_SELECT_LOADING	4
#define STATE_READY				5
#define STATE_PLAY				6
#define STATE_CLEAR				7
#define STATE_STOP				8

// 1フレームの時間(ミリ秒)
#define FRAME_TIME			65

// 待ちフレーム数
#define WAIT_BOOST			15
#define WAIT_1				30
#define WAIT_2				60
#define WAIT_3				90

// 画像の種類
#ifdef _505i
#define IMAGE_BACK1			0
#define IMAGE_BACK2			1
#define IMAGE_BACK3			2
#define IMAGE_BACK4			3
#define IMAGE_BACK5			4
#define IMAGE_BAR			5
#define IMAGE_LOGO			6
#define IMAGE_SHIELD		7
#define IMAGE_SPEEDER1		8
#define IMAGE_SPEEDER2		9
#define IMAGE_SPEEDER3		10
#define IMAGE_STATUS		11
#define IMAGE_TITLE			12
#define IMAGE_MASK			13
#define IMAGE_RAY			14
#define IMAGE_COM			15
#define IMAGE_RAX			16
#define IMAGE_NUM			17	// 画像の数
#endif // _505i
#ifdef _900i
#define IMAGE_BACK			0
#define IMAGE_BAR			1
#define IMAGE_FORE1			2
#define IMAGE_FORE2			3
#define IMAGE_FORE3			4
#define IMAGE_FORE4			5
#define IMAGE_FORE5A		6
#define IMAGE_FORE5B		7
#define IMAGE_FORE6A		8
#define IMAGE_FORE6B		9
#define IMAGE_LOGO			10
#define IMAGE_SHIELD		11
#define IMAGE_SPEEDER1		12
#define IMAGE_SPEEDER2		13
#define IMAGE_SPEEDER3		14
#define IMAGE_STATUS		15
#define IMAGE_TITLE			16
#define IMAGE_MASK			17
#define IMAGE_RAY			18
#define IMAGE_COM			19
#define IMAGE_RAX			20
#define IMAGE_NUM			21	// 画像の数
#endif // _900i

// タイトル画面テキスト情報
#define TEXT_NEUTRAL_X		0
#define TEXT_NEUTRAL_Y		12
#define TEXT_NEUTRAL_W		74
#define TEXT_NEUTRAL_H		10
#define TEXT_ON_X			0
#define TEXT_ON_Y			22
#define TEXT_ON_W			20
#define TEXT_ON_H			10
#define TEXT_OFF_X			22
#define TEXT_OFF_Y			22
#define TEXT_OFF_W			28
#define TEXT_OFF_H			10
#define TEXT_RACE_X			0
#define TEXT_RACE_Y			32
#define TEXT_RACE_W			38
#define TEXT_RACE_H			10
#define TEXT_FREE_X			40
#define TEXT_FREE_Y			32
#define TEXT_FREE_W			38
#define TEXT_FREE_H			10
#define TEXT_TRAINING_X		80
#define TEXT_TRAINING_Y		32
#define TEXT_TRAINING_W		80
#define TEXT_TRAINING_H		10
#define TEXT_EASY_X			0
#define TEXT_EASY_Y			42
#define TEXT_EASY_W			40
#define TEXT_EASY_H			10
#define TEXT_HARD_X			42
#define TEXT_HARD_Y			42
#define TEXT_HARD_W			40
#define TEXT_HARD_H			10
#define TEXT_1_X			84
#define TEXT_1_Y			42
#define TEXT_1_W			8
#define TEXT_1_H			10
#define TEXT_2_X			94
#define TEXT_2_Y			42
#define TEXT_2_W			8
#define TEXT_2_H			10
#define TEXT_OMAKE_X		104
#define TEXT_OMAKE_Y		42
#define TEXT_OMAKE_W		52
#define TEXT_OMAKE_H		10
#define TEXT_BESTTIME_X		0
#define TEXT_BESTTIME_Y		52
#define TEXT_BESTTIME_W		90
#define TEXT_BESTTIME_H		10
#define TEXT_DISTANCE_X		0
#define TEXT_DISTANCE_Y		62
#define TEXT_DISTANCE_W		80
#define TEXT_DISTANCE_H		10
#define TEXT_PRESS_X		0
#define TEXT_PRESS_Y		72
#define TEXT_PRESS_W		48
#define TEXT_PRESS_H		10
#define TEXT_KEY_X			50
#define TEXT_KEY_Y			72
#define TEXT_KEY_W			30
#define TEXT_KEY_H			10
#define TEXT_ENTER_X		0
#define TEXT_ENTER_Y		82
#define TEXT_ENTER_W		52
#define TEXT_ENTER_H		10
#define TEXT_SELECT_X		54
#define TEXT_SELECT_Y		82
#define TEXT_SELECT_W		60
#define TEXT_SELECT_H		10
#define TEXT_LOADING_X		0
#define TEXT_LOADING_Y		92
#define TEXT_LOADING_W		86
#define TEXT_LOADING_H		10
#define TEXT_COPYRIGHT_X	0
#define TEXT_COPYRIGHT_Y	102
#define TEXT_COPYRIGHT_W	92
#define TEXT_COPYRIGHT_H	10
#define TEXT_COPYRIGHT2_X	0
#define TEXT_COPYRIGHT2_Y	112
#define TEXT_COPYRIGHT2_W	94
#define TEXT_COPYRIGHT2_H	10
#define TEXT_SELECTCHAR_X	0
#define TEXT_SELECTCHAR_Y	122
#define TEXT_SELECTCHAR_W	160
#define TEXT_SELECTCHAR_H	10
#define TEXT_RAY_X			0
#define TEXT_RAY_Y			132
#define TEXT_RAY_W			30
#define TEXT_RAY_H			10
#define TEXT_RAX_X			32
#define TEXT_RAX_Y			132
#define TEXT_RAX_W			30
#define TEXT_RAX_H			10
#define TEXT_COM_X			64
#define TEXT_COM_Y			132
#define TEXT_COM_W			32
#define TEXT_COM_H			10
#define TEXT_ACCELERATION_X	0
#define TEXT_ACCELERATION_Y	142
#define TEXT_ACCELERATION_W	120
#define TEXT_ACCELERATION_H	10
#define TEXT_FAST_X			0
#define TEXT_FAST_Y			152
#define TEXT_FAST_W			40
#define TEXT_FAST_H			10
#define TEXT_MIDDLE_X		42
#define TEXT_MIDDLE_Y		152
#define TEXT_MIDDLE_W		60
#define TEXT_MIDDLE_H		10
#define TEXT_SLOW_X			104
#define TEXT_SLOW_Y			152
#define TEXT_SLOW_W			42
#define TEXT_SLOW_H			10
#define TEXT_SLOWDOWN_X		0
#define TEXT_SLOWDOWN_Y		162
#define TEXT_SLOWDOWN_W		88
#define TEXT_SLOWDOWN_H		10
#define TEXT_NORMAL_X		0
#define TEXT_NORMAL_Y		172
#define TEXT_NORMAL_W		64
#define TEXT_NORMAL_H		10
#define TEXT_SLIGHT_X		66
#define TEXT_SLIGHT_Y		172
#define TEXT_SLIGHT_W		60
#define TEXT_SLIGHT_H		10
#define TEXT_STEERING_X		0
#define TEXT_STEERING_Y		182
#define TEXT_STEERING_W		80
#define TEXT_STEERING_H		10
#define TEXT_QUICK_X		0
#define TEXT_QUICK_Y		192
#define TEXT_QUICK_W		50
#define TEXT_QUICK_H		10

// ステータステキスト情報
#define TEXT_READY_X		0
#define TEXT_READY_Y		74
#define TEXT_READY_W		101
#define TEXT_READY_H		21
#define TEXT_START_X		0
#define TEXT_START_Y		95
#define TEXT_START_W		119
#define TEXT_START_H		21
#define TEXT_FINISH_X		0
#define TEXT_FINISH_Y		116
#define TEXT_FINISH_W		131
#define TEXT_FINISH_H		21
#define TEXT_STOP_X			0
#define TEXT_STOP_Y			137
#define TEXT_STOP_W			81
#define TEXT_STOP_H			21
#define TEXT_PED_X			0
#define TEXT_PED_Y			158
#define TEXT_PED_W			71
#define TEXT_PED_H			21
#define TEXT_1ST_X			71
#define TEXT_1ST_Y			158
#define TEXT_1ST_W			52
#define TEXT_1ST_H			31
#define TEXT_2ND_X			0
#define TEXT_2ND_Y			189
#define TEXT_2ND_W			58
#define TEXT_2ND_H			31
#define TEXT_3RD_X			58
#define TEXT_3RD_Y			189
#define TEXT_3RD_W			55
#define TEXT_3RD_H			31
#define TEXT_PAUSE_X		0
#define TEXT_PAUSE_Y		220
#define TEXT_PAUSE_W		51
#define TEXT_PAUSE_H		11
#define TEXT_NEWRECORD_X	0
#define TEXT_NEWRECORD_Y	231
#define TEXT_NEWRECORD_W	109
#define TEXT_NEWRECORD_H	11
#define TEXT_AUTOSTEERING_X	0
#define TEXT_AUTOSTEERING_Y	242
#define TEXT_AUTOSTEERING_W	131
#define TEXT_AUTOSTEERING_H	11
#define TEXT_AUTOSHIELD_X	0
#define TEXT_AUTOSHIELD_Y	253
#define TEXT_AUTOSHIELD_W	109
#define TEXT_AUTOSHIELD_H	11

// スピーダーの種類
#define SPEEDER1			0
#define SPEEDER2			1
#define SPEEDER3			2
#define SPEEDER4			3
#define SPEEDER5			4

// 自動移動の種類
#define AUTO_INERTIA		0
#define AUTO_NEUTRAL		1
#define AUTO_MOVED_INERTIA	2
#define AUTO_MOVED_NEUTRAL	3

/**
 * メイン
 */
public class Main extends IApplication {
	public static MainCanvas canvas;
	public static Graphics g;

	public static Random rand;
	public static Stage stage;
	public static Wave wave;
	public static Speeder[] speeder;

	// よく使う色
	public static final int COLOR_C = Graphics.getColorOfRGB(  0, 255, 255);
	public static final int COLOR_M = Graphics.getColorOfRGB(255,   0, 255);
	public static final int COLOR_Y = Graphics.getColorOfRGB(255, 255,   0);
	public static final int COLOR_K = Graphics.getColorOfRGB(  0,   0,   0);
	public static final int COLOR_W = Graphics.getColorOfRGB(255, 255, 255);

	// よく使うフォント
	public static Font[] font;

#ifdef _505i
	public static final int[] SPEEDER1_X = { 0, 17, 34, 51, 69, 88, 109, 131, 154 };
	public static final int[] SPEEDER1_X_M = { 178, 161, 144, 126, 107, 86, 64, 41, 17 };
	public static final int[] SPEEDER1_W = { 17, 17, 17, 18, 19, 21, 22, 23, 24 };

	public static final int[] SPEEDER2_X = { 0, 17, 34, 51, 70, 90, 111, 133, 156 };
	public static final int[] SPEEDER2_X_M = { 180, 163, 146, 127, 107, 86, 64, 41, 17 };
	public static final int[] SPEEDER2_W = { 17, 17, 17, 19, 20, 21, 22, 23, 24 };

	public static final int[] SPEEDER3_X = { 0, 17, 34, 51, 69, 88, 109, 131, 154 };
	public static final int[] SPEEDER3_X_M = { 177, 160, 143, 125, 106, 85, 63, 40, 17 };
	public static final int[] SPEEDER3_W = { 17, 17, 17, 18, 19, 21, 22, 23, 23 };
#endif // _505i
#ifdef _900i
	public static final int[] SPEEDER1_X = { 0, 17, 34, 51, 68, 85, 103, 121, 140, 160, 181, 202, 224, 247, 270, 294 };
	public static final int[] SPEEDER1_X_M = { 318, 301, 284, 267, 250, 232, 214, 195, 175, 154, 133, 111, 88, 65, 41, 17 };
	public static final int[] SPEEDER1_W = { 17, 17, 17, 17, 17, 18, 18, 19, 20, 21, 21, 22, 23, 23, 24, 24 };

	public static final int[] SPEEDER2_X = { 0, 17, 34, 51, 68, 86, 105, 124, 144, 164, 185, 206, 228, 250, 273, 296 };
	public static final int[] SPEEDER2_X_M = { 320, 303, 286, 269, 251, 232, 213, 193, 173, 152, 131, 109, 87, 64, 41, 17 };
	public static final int[] SPEEDER2_W = { 17, 17, 17, 17, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23, 23, 24 };

	public static final int[] SPEEDER3_X = { 0, 17, 34, 51, 68, 85, 103, 121, 140, 160, 181, 202, 224, 246, 269, 292 };
	public static final int[] SPEEDER3_X_M = { 315, 298, 281, 264, 247, 229, 211, 192, 172, 151, 130, 108, 86, 63, 40, 17 };
	public static final int[] SPEEDER3_W = { 17, 17, 17, 17, 17, 18, 18, 19, 20, 21, 21, 22, 22, 23, 23, 23 };
#endif // _900i

	int load_cnt;				// ロード済みデータ数
	int load_num;				// ロード数

	int state = STATE_LAUNCH;	// アプリの状態
	int help;					// ヘルプの種類
	int help_back = -1;			// ヘルプ背景の種類
	int _elapse;				// 経過時間
	int _elapse_p;				// ポーズ中の経過時間
	int _elapse_s;				// シールド切り替え速度
	boolean pause = false;		// ポーズ中かどうか
	int[] shield_lag;
	int shield_index;
	int[] shield_wait;
	int[] shield_col;

	int change_col;

	int height;

	boolean neutral;			// キー解放でニュートラルにするかどうか
	int level;					// レベル
	int player;					// 使用キャラクタ

	boolean first;				// 初挑戦かどうか

	int[] time;					// 今回のタイム
	int[][] best_time;			// ベストタイム
	int[][] win;				// １位になった回数
	int ranking;				// 順位
	boolean new_time;			// 記録更新かどうか

	int best_distance;			// ベスト走行距離
	int old_distance;			//
	boolean new_distance;		// 記録更新かどうか

	int _elapse_l;				// 計測ポイント通過時の時間
	int lap;					// ラップ
	int lap_time;				// ラップタイムの差
	boolean dsp_lap;			// ラップタイムの差を表示するかどうか
	boolean finish;				// フィニッシュラインかどうか

	boolean boost;				// ブースト可能かどうか
	int _elapse_b;				// ブースト使用時の時間

	int[] old_y;
	int[] new_y;

	MediaImage c_mimg;			// カウンタイメージ
	Image c_img;				// カウンタイメージ

	MediaImage[] main_mimg;
	Image[] main_img;

	int key = 0;

	// キー入力と描画との排他処理用
	boolean _lock_state = false;
	boolean _wait_state = false;
	public void lock_state() {
		_wait_state = true;
		while ( _lock_state ) {
			try {
				Thread.sleep(FRAME_TIME);
			} catch ( Exception e ) {
			}
		}
		_lock_state = true;
		_wait_state = false;
	}
	public void unlock_state() {
		_lock_state = false;
		while ( _wait_state ) {
			try {
				Thread.sleep(FRAME_TIME);
			} catch ( Exception e ) {
			}
		}
	}

	// キー入力時処理のコンフリクト抑制用
	boolean processingEvent = false;

	public int read_int(int pos) {
		int val = -1;
		try {
			DataInputStream in = Connector.openDataInputStream("scratchpad:///0;pos=" + pos);
			try {
				val = in.readInt();
			} catch ( Exception e ) {
			}
			in.close();
		} catch ( Exception e ) {
		}
		return val;
	}
	public void write_int(int pos, int val) {
		try {
			DataOutputStream out = Connector.openDataOutputStream("scratchpad:///0;pos=" + pos);
			try {
				out.writeInt(val);
			} catch ( Exception e ) {
			}
			out.close();
		} catch ( Exception e ) {
		}
	}

	/**
	 * ゲームデータがダウンロード済みかどうかチェックする
	 */
	public boolean download_check() {
		int cnt = read_int(RESOURCE_TOP);
		if ( cnt >= 0 ) {
			load_cnt = cnt;
			if ( load_cnt != IMAGE_NUM ) {
				return false;
			}
		} else {
			return false;
		}
		return true;
	}

	/**
	 * ゲームデータをダウンロードする
	 */
	public boolean download() {
		HttpConnection con = null;
		try {
			byte buff[];
			buff = new byte[1024];
			int pos = 0;
			if ( load_cnt > 0 ) {
				pos = read_int(RESOURCE_TOP + 4 + (4 * (load_cnt - 1)));
			} else {
				pos = RESOURCE_TOP + 4 + (4 * (IMAGE_NUM + 1));
				write_int(RESOURCE_TOP + 4, pos);
			}
			while ( true ) {
				String file = new String("");
				file = IApplication.getCurrentApp().getSourceURL() + RESOURCE_NAME + load_cnt;
System.out.println(file);
				con = (HttpConnection)Connector.open(
					file,
					Connector.READ,
					true
					);
				con.setRequestMethod(HttpConnection.GET);
				con.connect();
				int    rCode = con.getResponseCode();
				String rMsg  = con.getResponseMessage();
				if ( rMsg.equals("OK") == false ) {
					break;
				}
				long len = con.getLength();
				write_int(RESOURCE_TOP + 4 + (4 * (load_cnt + 1)), pos + (int)len);
				InputStream  in  = con.openInputStream();
				OutputStream out = Connector.openOutputStream("scratchpad:///0;pos=" + pos);
				pos += len;
				while ( (len = in.read(buff)) > 0 ) {
					out.write(buff, 0, (int)len);
				}
				out.close();
				in.close();
				con.close();
				con = null;
				load_cnt++;
				write_int(RESOURCE_TOP, load_cnt);
				if ( load_cnt >= IMAGE_NUM ) {
					break;
				}
			}
		} catch ( Exception e ) {
		}
		try {
			if ( con != null ) {
				con.close();
			}
		} catch ( Exception e ) {
		}
		if ( load_cnt < IMAGE_NUM ) {
			return false;
		}
		return true;
	}

	/**
	 * リソースを取り出す
	 */
	byte[] resource_data = null;
	public byte[] resource(int id) {
		free_resource();
		try {
			int pos = read_int(RESOURCE_TOP + 4 + (4 * id));
			int size = read_int(RESOURCE_TOP + 4 + (4 * (id + 1))) - pos;
			InputStream in = Connector.openInputStream("scratchpad:///0;pos=" + pos);
			resource_data = new byte[size];
			in.read(resource_data);
			in.close();
		} catch ( Exception e ) {
		}
		return resource_data;
	}
	public void free_resource() {
		if ( resource_data != null ) {
			resource_data = null;
			System.gc();
		}
	}

	/**
	 * 設定の読み込み
	 */
	public void load_config() {
		int i, j;

		// デフォルト値
		neutral       = true;
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

		try {
			InputStream tmp;

			// スクラッチパッドに既にデータがあるかどうかチェックする
			int size = -1;
			tmp = Connector.openInputStream("scratchpad:///0;pos=0");
			try {
				size = tmp.read();
			} catch ( Exception e ) {
			}
			tmp.close();

			// データがあるので読み出す
			if ( size > 0 ) {
				tmp = Connector.openInputStream("scratchpad:///0;pos=0");
				StreamReader reader = new StreamReader();
				reader.begin(tmp);
				String str = new String("");
				str = reader.read(); if ( str.length() > 0 ) neutral = (Integer.parseInt(str) == 1) ? true : false;
				str = reader.read(); if ( str.length() > 0 ) level = Integer.parseInt(str);
				str = reader.read(); if ( str.length() > 0 ) player = Integer.parseInt(str);
				str = reader.read(); if ( str.length() > 0 ) shield_lag[0] = Integer.parseInt(str);
				str = reader.read(); if ( str.length() > 0 ) shield_lag[1] = Integer.parseInt(str);
				str = reader.read(); if ( str.length() > 0 ) shield_index = Integer.parseInt(str);
				for ( i = 0; i < 6; i++ ) {
					for ( j = 0; j < 10; j++ ) {
						str = reader.read(); if ( str.length() > 0 ) best_time[i][j] = Integer.parseInt(str);
					}
				}
				for ( i = 0; i < 2; i++ ) {
					for ( j = 0; j < 3; j++ ) {
						str = reader.read(); if ( str.length() > 0 ) win[i][j] = Integer.parseInt(str);
					}
				}
				str = reader.read(); if ( str.length() > 0 ) best_distance = Integer.parseInt(str);
				for ( j = 0; j < 10; j++ ) {
					str = reader.read(); if ( str.length() > 0 ) best_time[6][j] = Integer.parseInt(str);
				}
				for ( j = 0; j < 3; j++ ) {
					str = reader.read(); if ( str.length() > 0 ) win[2][j] = Integer.parseInt(str);
				}
				reader.end();
				tmp.close();
			}
		} catch ( Exception e ) {
e.printStackTrace();
		}
	}

	/**
	 * 設定の書き出し
	 */
	public void save_config() {
		int i, j;
		String str = new String("");
		str = str + (neutral ? "1" : "0") + ",";
		str = str + level + ",";
		str = str + player + ",";
		str = str + shield_lag[0] + ",";
		str = str + shield_lag[1] + ",";
		str = str + shield_index + ",";
		for ( i = 0; i < 6; i++ ) {
			for ( j = 0; j < 10; j++ ) {
				str = str + best_time[i][j] + ",";
			}
		}
		for ( i = 0; i < 2; i++ ) {
			for ( j = 0; j < 3; j++ ) {
				str = str + win[i][j] + ",";
			}
		}
		str = str + best_distance + ",";
		for ( j = 0; j < 10; j++ ) {
			str = str + best_time[6][j] + ",";
		}
		for ( j = 0; j < 3; j++ ) {
			str = str + win[2][j] + ",";
		}
		byte[] data = str.getBytes();
		try {
			DataOutputStream out = Connector.openDataOutputStream("scratchpad:///0;pos=0");
			out.write(data, 0, data.length);
			out.close();
		} catch ( Exception e ) {
		}
	}

	/**
	 * イメージ読み込み
	 */
	public void create_image(int id) {
		if ( main_img[id] == null ) {
			try {
				main_mimg[id] = MediaManager.getImage(resource(id)); free_resource();
				main_mimg[id].use();
				main_img[id] = main_mimg[id].getImage();
			} catch ( Exception e ) {
			}
		}
	}
	public void dispose_image(int id) {
		if ( main_img[id] != null ) {
			main_img[id].dispose();
			main_mimg[id].dispose();
			main_img[id] = null;
			System.gc();
		}
	}
	public void dispose_image() {
		for ( int i = 0; i < IMAGE_NUM; i++ ) {
			if ( main_img[i] != null ) {
				main_img[i].dispose();
				main_mimg[i].dispose();
				main_img[i] = null;
			}
		}
		System.gc();
	}
	public Image use_image(int id) {
		create_image(id);
		return main_img[id];
	}

	// 経過時間を確認する
	public int elapse() { return pause ? _elapse_p : _elapse; }

	// おまけモードがプレイできるか確認する
	public boolean omake1() {
		int i;
		for ( i = 0; i < 6; i++ ) {
			if ( best_time[i][0] == 99999 ) {
				return false;
			}
		}
		return true;
	}
	public boolean omake2() {
		int i, j;
		for ( i = 0; i < 2; i++ ) {
			for ( j = 0; j < 3; j++ ) {
				if ( win[i][j] == 0 ) {
					return false;
				}
			}
		}
		return true;
	}

	public int level_max() {
		if ( omake1() ) {
			return omake2() ? 7 : 6;
		}
		return 5;
	}

	public int index_b() { return (level == 7) ? 6 : level; }
	public int index_w() { return (level == 7) ? 2 : level; }

	/**
	 * アプリの状態を変更する
	 */
	public void set_state(int new_state) {
		int old_state = state;
		state = new_state;
		_elapse = 0;
		_elapse_l = 0;
		_elapse_b = 0 - WAIT_BOOST;

		switch ( old_state ) {
		case STATE_DOWNLOAD:
			c_img.dispose();
			c_mimg.dispose();
			System.gc();
			break;
		case STATE_RELOADCONFIRM:
			if ( state == STATE_RELOAD ) {
				write_int(RESOURCE_TOP, 0);
			}
			break;
		case STATE_TITLE_LOADING:
		case STATE_SELECT_LOADING:
			dispose_image();

			if ( state == STATE_READY ) {
				change_col = 0;

				if ( level != 6 ) {
					shield_wait[0] = 0;
					shield_wait[1] = 0;

					first = (best_time[index_b()][0] == 99999) ? true : false;

					time[0] = 0;

					lap     = 0;
					dsp_lap = false;
					finish  = false;
				} else {
					old_distance = best_distance;
				}

				boost = false;

				if ( (level < 2) || (level == 7) ) {
					boolean tmp = (rand.nextInt() > 0) ? true : false;
					switch ( player ) {
					case 0:
						speeder[0].init(true, SPEEDER1, 0, 0);
						speeder[1].init(false, tmp ? SPEEDER2 : SPEEDER3, 0, -50);
						speeder[2].init(false, tmp ? SPEEDER3 : SPEEDER2, 0,  50);
						break;
					case 1:
						speeder[0].init(true, SPEEDER2, 0, 0);
						speeder[1].init(false, tmp ? SPEEDER1 : SPEEDER3, 0, -50);
						speeder[2].init(false, tmp ? SPEEDER3 : SPEEDER1, 0,  50);
						break;
					case 2:
						speeder[0].init(true, SPEEDER3, 0, 0);
						speeder[1].init(false, tmp ? SPEEDER1 : SPEEDER2, 0, -50);
						speeder[2].init(false, tmp ? SPEEDER2 : SPEEDER1, 0,  50);
						break;
					}
				} else {
					switch ( rand.nextInt() % 2 ) {
					case -1: speeder[0].init(true, SPEEDER1, (level != 6) ? 0 : 495, 0); break;
					case  0: speeder[0].init(true, SPEEDER4, (level != 6) ? 0 : 495, 0); break;
					case  1: speeder[0].init(true, SPEEDER5, (level != 6) ? 0 : 495, 0); break;
					}
				}
			}

			break;
		case STATE_CLEAR:
		case STATE_STOP:
			save_config();
			break;
		}

		switch ( state ) {
		case STATE_DOWNLOAD:
			load_cnt = 0;
			load_num = IMAGE_NUM;
			try {
				c_mimg = MediaManager.getImage("resource:///count.gif");
				c_mimg.use();
				c_img = c_mimg.getImage();
			} catch ( Exception e ) {
			}
			break;
		case STATE_DOWNLOADERROR:
		case STATE_RELOAD:
			canvas.setSoftLabel(Frame.SOFT_KEY_1, "");
			canvas.setSoftLabel(Frame.SOFT_KEY_2, "終了");
			break;
		case STATE_RELOADCONFIRM:
			canvas.setSoftLabel(Frame.SOFT_KEY_1, "はい");
			canvas.setSoftLabel(Frame.SOFT_KEY_2, "いいえ");
			break;
		case STATE_TITLE:
			if ( (old_state != STATE_HELP) && (old_state != STATE_SELECT) ) {
				pause = false;
				save_config();
			}
			dispose_image();
			canvas.setSoftLabel(Frame.SOFT_KEY_1, "HELP");
			canvas.setSoftLabel(Frame.SOFT_KEY_2, "EXIT");
			break;
		case STATE_HELP:
			canvas.setSoftLabel(Frame.SOFT_KEY_1, "TITLE");
			canvas.setSoftLabel(Frame.SOFT_KEY_2, "EXIT");
			help = 0;
			{
				int tmp;
				while ( true ) {
					tmp = (rand.nextInt() % 2) + 1;
					if ( tmp != help_back ) {
						help_back = tmp;
						break;
					}
				}
			}
			break;
		case STATE_SELECT:
			canvas.setSoftLabel(Frame.SOFT_KEY_1, "TITLE");
			canvas.setSoftLabel(Frame.SOFT_KEY_2, "EXIT");
			create_image(IMAGE_SPEEDER1);
			create_image(IMAGE_SPEEDER2);
			create_image(IMAGE_SPEEDER3);
			break;
		case STATE_READY:
			canvas.setSoftLabel(Frame.SOFT_KEY_1, "");
			canvas.setSoftLabel(Frame.SOFT_KEY_2, "");
			wave.create();
			stage.create();
			break;
		case STATE_CLEAR:
			new_time = false;
			if ( time[0] < best_time[index_b()][0] ) {
				new_time = first ? false : true;
				best_time[index_b()][0] = time[0];
				best_time[index_b()][1] = time[1];
				for ( int i = 2; i < 10; i++ ) {
					best_time[index_b()][i] = time[i] - time[i - 1];
				}
			}
			ranking = 1;
			if ( (level < 2) || (level == 7) ) {
				if ( speeder[0].distance() < speeder[1].distance() ) ranking++;
				if ( speeder[0].distance() < speeder[2].distance() ) ranking++;
				if ( ranking == 1 ) {
					win[index_w()][player]++;
				}
			}
			break;
		case STATE_STOP:
			new_distance = false;
			if ( speeder[0].distance() > best_distance ) {
				new_distance = (best_distance == 0) ? false : true;
				best_distance = speeder[0].distance();
			}
			break;
		}
	}

	/**
	 * 描画に使用する色を設定
	 */
	public void setCMYColor(int col) {
		switch ( col ) {
		case 0: g.setColor(COLOR_C); break;
		case 1: g.setColor(COLOR_M); break;
		case 2: g.setColor(COLOR_Y); break;
		}
	}

	int stringWidth(int type, String str) {
		return font[type].stringWidth(str);
	}
	int fontHeight(int type) {
		return font[type].getHeight();
	}
	int drawImage(Graphics g, Image img, int x0, int y0, int x, int y, int w, int h) {
		if ( (x0 + w) <= 0 ) {
			return -1;
		} else if ( x0 >= 240 ) {
			return 1;
		}
		g.drawImage(img, x0, y0, x, y, w, h);
		return 0;
	}
	void drawImage(Graphics g, Image img, int x0, int y0) {
		g.drawImage(img, x0, y0);
	}

	/**
	 * start
	 */
	public void start() {
		// よく使うフォント
		font = new Font[3];
		font[FONT_TINY  ] = Font.getFont(Font.FACE_SYSTEM | Font.STYLE_PLAIN | Font.SIZE_TINY  );
		font[FONT_SMALL ] = Font.getFont(Font.FACE_SYSTEM | Font.STYLE_PLAIN | Font.SIZE_SMALL );
		font[FONT_MEDIUM] = Font.getFont(Font.FACE_SYSTEM | Font.STYLE_PLAIN | Font.SIZE_MEDIUM);

		canvas = new MainCanvas();
		height = canvas.getHeight();

		// ゲームデータのダウンロード
		if ( (getLaunchType() == LAUNCHED_AFTER_DOWNLOAD) || !download_check() ) {
			lock_state();
			set_state(STATE_DOWNLOAD);
			unlock_state();

			Display.setCurrent(canvas);

			// スレッドでの描画開始
			DrawThread runner = new DrawThread();
			runner.start();

			if ( !download_check() ) {
				if ( !download() ) {
					lock_state();
					set_state(STATE_DOWNLOADERROR);
					unlock_state();
					return;
				}
			}

			// スレッドでの描画終了
			runner.end();
			try {
				runner.join();
			} catch ( Exception e ) {
			}
		}

		{
			lock_state();
			set_state(STATE_LAUNCH);
			unlock_state();

			Display.setCurrent(canvas);

			// スレッドでの描画開始
			DrawThread runner = new DrawThread();
			runner.start();

			shield_lag  = new int[2];
			shield_wait = new int[2];
			shield_col  = new int[2];

			time = new int[10];
			best_time = new int[7][10];
			win = new int[3][3];

			old_y = new int[2];
			new_y = new int[2];

			rand = new Random(System.currentTimeMillis());
			stage = new Stage();
			wave = new Wave();

			speeder = new Speeder[3];
			speeder[0] = new Speeder();
			speeder[1] = new Speeder();
			speeder[2] = new Speeder();

			main_mimg = new MediaImage[IMAGE_NUM];
			main_img = new Image[IMAGE_NUM];
			for ( int i = 0; i < IMAGE_NUM; i++ ) {
				main_img[i] = null;
			}

			load_config();

			// スレッドでの描画終了
			runner.end();
			try {
				runner.join();
			} catch ( Exception e ) {
			}
		}

		lock_state();
		set_state(STATE_TITLE);
		unlock_state();

		long start_time;
		long sleep_time;
		while ( true ) {
			start_time = System.currentTimeMillis();
			canvas.paint(g);
			sleep_time = FRAME_TIME - (System.currentTimeMillis() - start_time);
			if ( sleep_time > 0 ) {
				try {
					Thread.sleep(sleep_time);
				} catch ( Exception e ) {
				}
			}
		}
	}

	/**
	 * 描画をスレッドで行うクラス
	 */
	class DrawThread extends Thread {
		private boolean _run = true;
		public void run() {
			while ( _run ) {
				canvas.repaint();
				try {
					Thread.sleep(FRAME_TIME);
				} catch ( Exception e ) {
				}
			}
		}
		public void end() { _run = false; }
	}

	/**
	 * ストリームからコンマ区切りの文字列を読み出すクラス
	 */
	class StreamReader {
		char[] data;
		int data_size;
		int data_index;
		char[] word;
		InputStreamReader reader;
		StreamReader() {
			data = new char[DATA_SIZE];
			word = new char[16];
		}
		public void begin(InputStream in) {
			reader = new InputStreamReader(in);
			begin();
		}
		public void end() {
			try {
				reader.close();
			} catch ( IOException e ) {
			}
		}
		private int begin() {
			try {
				data_size = reader.read(data, 0, DATA_SIZE);
			} catch ( IOException e ) {
			}
			data_index = 0;
			return data_size;
		}
		private int read_chr() {
			if ( data_index >= data_size ) {
				if ( begin() <= 0 ) return -1;
			}
			int chr = data[data_index];
			data_index++;
			return chr;
		}
		public String read() {
			int word_index = 0;
			try {
				int chr = 0;

				// 現在位置が既に改行コードの場合に読み飛ばす
				while ( true ) {
					chr = read_chr();
					if ( chr <= 0 ) break;
					if ( (chr != '\r') && (chr != '\n') ) {
						if ( chr != ' ' ) {
							word[word_index] = (char)chr;
							word_index++;
						}
						break;
					}
				}
				if ( chr != ',' ) {
					while ( true ) {
						chr = read_chr();
						if ( (chr <= 0) || (chr == ',') || (chr == '\r') || (chr == '\n') ) break;
						if ( chr != ' ' ) {
							word[word_index] = (char)chr;
							word_index++;
						}
					}
				}
			} catch ( Exception e ) {
			}
			String str = new String(word, 0, word_index);
			return str;
		}
		public int read_val() {
			return Integer.parseInt(read());
		}
	}

	/**
	 * キャンバス
	 */
	class MainCanvas extends Canvas {
		/**
		 * コンストラクタ
		 */
		MainCanvas() {
			PhoneSystem.setAttribute(
				PhoneSystem.DEV_BACKLIGHT,
				PhoneSystem.ATTR_BACKLIGHT_ON
				);
			setSoftLabel(Frame.SOFT_KEY_1, "");
			setSoftLabel(Frame.SOFT_KEY_2, "");

			g = getGraphics();
		}

		/**
		 * 文字列センタリング描画
		 */
		private void centerDrawString(String str, int type, int y) {
			g.setFont(font[type]);

			int x;
			x = (240 - stringWidth(type, str)) / 2;
			y = y + fontHeight(type) / 2;

			g.drawString(str, x + 1, y);
			g.drawString(str, x    , y);
		}
		private void centerDrawString(String str, int type, int y, int col) {
			g.setFont(font[type]);

			int x;
			x = (240 - stringWidth(type, str)) / 2;
			y = y + fontHeight(type) / 2;

			g.setColor(COLOR_K);
			g.drawString(str, x + 2, y + 1);
			g.setColor(col);
			g.drawString(str, x + 1, y    );
			g.drawString(str, x    , y    );
		}

		/**
		 * 文字列折り返し描画
		 */
		private int drawStringTurn(String str, int x, int y, int width) {
			int len = str.length();
			char data[] = new char[len];
			str.getChars(0, len, data, 0);
			int start = 0;
			int end = 0;
			int h = font[FONT_SMALL].getHeight();
			boolean line_break;
			while ( len > 0 ) {
				end = font[FONT_SMALL].getLineBreak(str, start, len, width);

				// 行頭禁則
				line_break = false;
				while ( true ) {
					if ( end < str.length() ) {
						switch ( str.charAt(end) ) {
						case '!':
						case ')':
						case ',':
						case '.':
						case 'ﾞ':
						case 'ﾟ':
							end++;
							break;
						default:
							line_break = true;
							break;
						}
					} else {
						line_break = true;
					}
					if ( line_break ) {
						break;
					}
				}

				// 行末禁則
				line_break = false;
				while ( true ) {
					if ( end > (start + 1) ) {
						switch ( str.charAt(end - 1) ) {
						case '(':
							end--;
							break;
						default:
							line_break = true;
							break;
						}
					} else {
						line_break = true;
					}
					if ( line_break ) {
						break;
					}
				}

				g.drawChars(data, x, y, start, end - start);
				len -= (end - start);
				start = end;
				y += h;
			}
			return y;
		}

		/**
		 *
		 */
		private void drawHelpTitle(String str, int x, int y, int col) {
			x = x - stringWidth(FONT_SMALL, str);
			g.setColor(COLOR_K);
			g.drawString(str, x + 1, y + 1);
			g.setColor(col);
			g.drawString(str, x    , y    );
		}

		/**
		 *
		 */
		private int drawHelpButton(String str, int x, int y, int col) {
			int w = stringWidth(FONT_SMALL, str);
			int h = fontHeight(FONT_SMALL);
			g.setColor(COLOR_K);
			g.drawRect(x + 1, y - h - 1, w + 6, h + 4);
			g.drawString(str, x + 4, y + 1);
			g.setColor(col);
			g.drawRect(x, y - h - 2, w + 6, h + 4);
			g.drawString(str, x + 3, y);
			return x + w + 6;
		}

		/**
		 * ステータス描画
		 */
		private void drawStatus(boolean ready) {
			int i, x, y;
			int tmp;

			if ( level != 6 ) {
				drawImage(g, use_image(IMAGE_STATUS), 10, 0, 0, 26, 92, 24);
				x = 15 + 12 * 3;
				tmp = time[0];
				for ( i = 0; i < 4; i++ ) {
					drawImage(g, use_image(IMAGE_STATUS), x, 6, (tmp % 10) * 12, 0, 12, 13);
					tmp /= 10;
					x -= 12;
				}

				if ( !first && dsp_lap ) {
					if ( (lap > 0) && ((_elapse - _elapse_l) < WAIT_2) ) {
						drawImage(g, use_image(IMAGE_STATUS), 10, 24, 0, 26, 59, 24);
						x = 15 + 12 * 3;
						y = 0;
						tmp = lap_time;
						if ( tmp < 0 ) {
							tmp = 0 - tmp;
							drawImage(g, use_image(IMAGE_STATUS), 15, 30, 120, 13, 12, 13);
							y = 13;
						} else {
							drawImage(g, use_image(IMAGE_STATUS), 15, 30, 120, (tmp == 0) ? 26 : 0, 12, 13);
						}
						for ( i = 0; i < 3; i++ ) {
							drawImage(g, use_image(IMAGE_STATUS), x, 30, (tmp % 10) * 12, y, 12, 13);
							tmp /= 10;
							x -= 12;
						}
					} else {
						dsp_lap = false;
					}
				}
			}

			drawImage(g, use_image(IMAGE_STATUS), 148, 0, 0, 50, 82, 24);
			x = 190 + 12 * 2;
			tmp = ready ? 0 : speeder[0].speed();
			for ( i = 0; i < 3; i++ ) {
				drawImage(g, use_image(IMAGE_STATUS), x, 6, (tmp % 10) * 12, 0, 12, 13);
				tmp /= 10;
				x -= 12;
			}

			drawImage(g, use_image(IMAGE_STATUS), 0, 0, 132, 0, 10, height);
			drawImage(g, use_image(IMAGE_STATUS), 230, 0, 132, 0, 10, height);

			if ( (level < 2) || (level == 7) ) {
				for ( i = 1; i < 3; i++ ) {
					drawImage(g, use_image(IMAGE_STATUS), 1, height - (height * speeder[i].distance() / DISTANCE) - 4, 92, 34, 8, 8);
				}
				drawImage(g, use_image(IMAGE_STATUS), 1, height - (height * speeder[0].distance() / DISTANCE) - 4, 92, 26, 8, 8);

				for ( i = 1; i < 3; i++ ) {
					drawImage(g, use_image(IMAGE_STATUS), 231, (height / 2 - 4) - ((speeder[i].distance() - speeder[0].distance()) / 100), 92, 34, 8, 8);
				}
				drawImage(g, use_image(IMAGE_STATUS), 231, height / 2 - 4, 92, 26, 8, 8);
			} else if ( (level != 6) || (old_distance == 0) ) {
				y = height - (height * speeder[0].distance() / DISTANCE);
				drawImage(g, use_image(IMAGE_STATUS), 1, y - 4, 92, 26, 8, 8);
				drawImage(g, use_image(IMAGE_STATUS), 231, y - 4, 92, 26, 8, 8);
			} else {
				y = height - (height * old_distance / (old_distance * 2));
				drawImage(g, use_image(IMAGE_STATUS), 1, y - 4, 92, 34, 8, 8);
				drawImage(g, use_image(IMAGE_STATUS), 231, y - 4, 92, 34, 8, 8);
				y = height - (height * speeder[0].distance() / (old_distance * 2));
				drawImage(g, use_image(IMAGE_STATUS), 1, y - 4, 92, 26, 8, 8);
				drawImage(g, use_image(IMAGE_STATUS), 231, y - 4, 92, 26, 8, 8);
			}

			if ( boost ) {
				drawImage(g, use_image(IMAGE_STATUS), 184, 24, ((elapse() % 4) < 2) ? 0 : 46, 264, 46, 23);
			}
		}

		/**
		 * paint
		 */
		public void paint(Graphics _g) {
			lock_state();

			key = canvas.getKeypadState();

			switch ( state ) {
			case STATE_DOWNLOAD:
				g.lock();
				g.setColor(COLOR_K);
				g.fillRect(0, 0, 240, height);
				setCMYColor(_elapse % 3);
				centerDrawString("ｹﾞｰﾑﾃﾞｰﾀをﾀﾞｳﾝﾛｰﾄﾞ", FONT_SMALL, 110);
				centerDrawString("しています...", FONT_SMALL, 130);
				{
					int i, x;
					int tmp;
					x = 108 + 12;
					tmp = load_num - load_cnt;
					for ( i = 0; i < 2; i++ ) {
						g.drawImage(c_img, x, 160, (tmp % 10) * 12, 0, 12, 12);
						tmp /= 10;
						x -= 12;
					}
				}
				g.unlock(true);
				break;
			case STATE_DOWNLOADERROR:
				g.lock();
				g.setColor(COLOR_K);
				g.fillRect(0, 0, 240, height);
				g.setFont(font[FONT_SMALL]);
				g.setColor(COLOR_W);
				drawStringTurn("ﾀﾞｳﾝﾛｰﾄﾞに失敗しました.通信を許可で起動していない場合は,一旦終了して,通信を許可で起動してください.または,ﾈｯﾄﾜｰｸの調子が悪い可能性があります.申し訳ございませんが,一旦終了して,少し経ってから起動してみてください.", 10, 30, 220);
				g.unlock(true);
				break;
			case STATE_RELOADCONFIRM:
				g.lock();
				g.setColor(COLOR_K);
				g.fillRect(0, 0, 240, height);
				g.setFont(font[FONT_SMALL]);
				g.setColor(COLOR_Y);
				drawStringTurn("ｹﾞｰﾑﾃﾞｰﾀの更新を行います.よろしいですか?", 10, 110, 220);
				g.unlock(true);
				break;
			case STATE_RELOAD:
				g.lock();
				g.setColor(COLOR_K);
				g.fillRect(0, 0, 240, height);
				g.setFont(font[FONT_SMALL]);
				g.setColor(COLOR_W);
				drawStringTurn("ｹﾞｰﾑﾃﾞｰﾀの更新の準備が整いました.一旦終了して,通信を許可で起動してください.", 10, 100, 220);
				g.unlock(true);
				break;
			case STATE_LAUNCH:
				g.lock();
				g.setColor(COLOR_K);
				g.fillRect(0, 0, 240, height);
				setCMYColor(_elapse % 3);
				centerDrawString("起動中...", FONT_SMALL, 120);
				g.unlock(true);
				break;
			case STATE_TITLE:
			case STATE_TITLE_LOADING:
				// 描画
				g.lock();
				{
					int x;

					g.setColor(COLOR_K);
					g.fillRect(0, 0, 240, height);

					drawImage(g, use_image(IMAGE_LOGO), 0, 15);

					x = (240 - (TEXT_NEUTRAL_W + 8 + TEXT_OFF_W)) / 2;
					drawImage(g, use_image(IMAGE_TITLE), x, 100, TEXT_NEUTRAL_X, TEXT_NEUTRAL_Y, TEXT_NEUTRAL_W, TEXT_NEUTRAL_H); x += (TEXT_NEUTRAL_W + 8);
					if ( neutral ) {
						drawImage(g, use_image(IMAGE_TITLE), x, 100, TEXT_ON_X, TEXT_ON_Y, TEXT_ON_W, TEXT_ON_H);
					} else {
						drawImage(g, use_image(IMAGE_TITLE), x, 100, TEXT_OFF_X, TEXT_OFF_Y, TEXT_OFF_W, TEXT_OFF_H);
					}

					drawImage(g, use_image(IMAGE_TITLE), 115, 118, 141, 0, 9, 5);
					drawImage(g, use_image(IMAGE_TITLE), 115, 141, 141, 5, 9, 5);
					switch ( level ) {
					case 0:
						x = (240 - (TEXT_RACE_W + 8 + TEXT_EASY_W)) / 2;
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_RACE_X, TEXT_RACE_Y, TEXT_RACE_W, TEXT_RACE_H); x += (TEXT_RACE_W + 8);
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_EASY_X, TEXT_EASY_Y, TEXT_EASY_W, TEXT_EASY_H);
						break;
					case 1:
						x = (240 - (TEXT_RACE_W + 8 + TEXT_HARD_W)) / 2;
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_RACE_X, TEXT_RACE_Y, TEXT_RACE_W, TEXT_RACE_H); x += (TEXT_RACE_W + 8);
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_HARD_X, TEXT_HARD_Y, TEXT_HARD_W, TEXT_HARD_H);
						break;
					case 2:
						x = (240 - (TEXT_FREE_W + 8 + TEXT_EASY_W)) / 2;
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_FREE_X, TEXT_FREE_Y, TEXT_FREE_W, TEXT_FREE_H); x += (TEXT_FREE_W + 8);
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_EASY_X, TEXT_EASY_Y, TEXT_EASY_W, TEXT_EASY_H);
						break;
					case 3:
						x = (240 - (TEXT_FREE_W + 8 + TEXT_HARD_W)) / 2;
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_FREE_X, TEXT_FREE_Y, TEXT_FREE_W, TEXT_FREE_H); x += (TEXT_FREE_W + 8);
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_HARD_X, TEXT_HARD_Y, TEXT_HARD_W, TEXT_HARD_H);
						break;
					case 4:
						x = (240 - (TEXT_TRAINING_W + 8 + TEXT_1_W)) / 2;
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_TRAINING_X, TEXT_TRAINING_Y, TEXT_TRAINING_W, TEXT_TRAINING_H); x += (TEXT_TRAINING_W + 8);
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_1_X, TEXT_1_Y, TEXT_1_W, TEXT_1_H);
						break;
					case 5:
						x = (240 - (TEXT_TRAINING_W + 8 + TEXT_2_W)) / 2;
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_TRAINING_X, TEXT_TRAINING_Y, TEXT_TRAINING_W, TEXT_TRAINING_H); x += (TEXT_TRAINING_W + 8);
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_2_X, TEXT_2_Y, TEXT_2_W, TEXT_2_H);
						break;
					case 6:
						x = (240 - (TEXT_OMAKE_W + 8 + TEXT_1_W)) / 2;
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_OMAKE_X, TEXT_OMAKE_Y, TEXT_OMAKE_W, TEXT_OMAKE_H); x += (TEXT_OMAKE_W + 8);
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_1_X, TEXT_1_Y, TEXT_1_W, TEXT_1_H);
						break;
					case 7:
						x = (240 - (TEXT_OMAKE_W + 8 + TEXT_2_W)) / 2;
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_OMAKE_X, TEXT_OMAKE_Y, TEXT_OMAKE_W, TEXT_OMAKE_H); x += (TEXT_OMAKE_W + 8);
						drawImage(g, use_image(IMAGE_TITLE), x, 127, TEXT_2_X, TEXT_2_Y, TEXT_2_W, TEXT_2_H);
						break;
					}

					if ( level != 6 ) {
						drawImage(g, use_image(IMAGE_TITLE), (240 - TEXT_BESTTIME_W) / 2, 154, TEXT_BESTTIME_X, TEXT_BESTTIME_Y, TEXT_BESTTIME_W, TEXT_BESTTIME_H);
						if ( best_time[index_b()][0] == 99999 ) {
							drawImage(g, use_image(IMAGE_TITLE), 96, 170, 120, 0, 12, 12);
							drawImage(g, use_image(IMAGE_TITLE), 108, 170, 120, 0, 12, 12);
							drawImage(g, use_image(IMAGE_TITLE), 120, 170, 120, 0, 12, 12);
							drawImage(g, use_image(IMAGE_TITLE), 132, 170, 120, 0, 12, 12);
						} else {
							x = 96 + 12 * 3;
							int tmp = best_time[index_b()][0];
							for ( int i = 0; i < 4; i++ ) {
								drawImage(g, use_image(IMAGE_TITLE), x, 170, (tmp % 10) * 12, 0, 12, 12);
								tmp /= 10;
								x -= 12;
							}
						}
					} else {
						drawImage(g, use_image(IMAGE_TITLE), (240 - TEXT_DISTANCE_W) / 2, 154, TEXT_DISTANCE_X, TEXT_DISTANCE_Y, TEXT_DISTANCE_W, TEXT_DISTANCE_H);
						int i = 0;
						int tmp = best_distance / 5;
						while ( true ) {
							i++;
							tmp /= 10;
							if ( tmp == 0 ) {
								break;
							}
						}
						x = 240 - ((240 - (12 * i)) / 2);
						tmp = best_distance / 5;
						while ( true ) {
							x -= 12;
							drawImage(g, use_image(IMAGE_TITLE), x, 170, (tmp % 10) * 12, 0, 12, 12);
							tmp /= 10;
							if ( tmp == 0 ) {
								break;
							}
						}
					}

					if ( state == STATE_TITLE ) {
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							x = (240 - (TEXT_PRESS_W + 8 + TEXT_SELECT_W + 8 + TEXT_KEY_W)) / 2;
							drawImage(g, use_image(IMAGE_TITLE), x, 195, TEXT_PRESS_X, TEXT_PRESS_Y, TEXT_PRESS_W, TEXT_PRESS_H); x += (TEXT_PRESS_W + 8);
							drawImage(g, use_image(IMAGE_TITLE), x, 195, TEXT_SELECT_X, TEXT_SELECT_Y, TEXT_SELECT_W, TEXT_SELECT_H); x += (TEXT_SELECT_W + 8);
							drawImage(g, use_image(IMAGE_TITLE), x, 195, TEXT_KEY_X, TEXT_KEY_Y, TEXT_KEY_W, TEXT_KEY_H);
						}
					} else {
						drawImage(g, use_image(IMAGE_TITLE), (240 - TEXT_LOADING_W) / 2, 195, TEXT_LOADING_X, TEXT_LOADING_Y, TEXT_LOADING_W, TEXT_LOADING_H);
					}

					x = (240 - (TEXT_COPYRIGHT_W + 8 + TEXT_COPYRIGHT2_W)) / 2;
					drawImage(g, use_image(IMAGE_TITLE), x, 220, TEXT_COPYRIGHT_X, TEXT_COPYRIGHT_Y, TEXT_COPYRIGHT_W, TEXT_COPYRIGHT_H); x += (TEXT_COPYRIGHT_W + 8);
					drawImage(g, use_image(IMAGE_TITLE), x, 220, TEXT_COPYRIGHT2_X, TEXT_COPYRIGHT2_Y, TEXT_COPYRIGHT2_W, TEXT_COPYRIGHT2_H);
				}
				g.unlock(true);

				if ( state == STATE_TITLE_LOADING ) {
					if ( (level < 2) || (level == 7) ) {
						set_state(STATE_SELECT);
					} else {
						set_state(STATE_READY);
					}
				}

				break;
			case STATE_HELP:
				// 描画
				g.lock();
				g.setColor(COLOR_K);
				g.fillRect(0, 0, 240, height);
				switch ( help_back ) {
				case 0: drawImage(g, use_image(IMAGE_RAY), 0, 0); break;
				case 1: drawImage(g, use_image(IMAGE_COM), 0, 0); break;
				case 2: drawImage(g, use_image(IMAGE_RAX), 0, 0); break;
				}
				g.setFont(font[FONT_SMALL]);
				switch ( help ) {
				case 0:
					drawImage(g, use_image(IMAGE_MASK), 0, 0);
					{
						int y;
						for ( int i = 1; i >= 0; i-- ) {
							if ( i == 1 ) {
								g.setColor(COLOR_K);
							} else {
								g.setColor(COLOR_W);
							}
							y = drawStringTurn("ｺｰｽに配置されているﾊﾞｰと同色のｼｰﾙﾄﾞで加速!", 5 + i, 55 + i, 230);
							y = drawStringTurn("違う色のｼｰﾙﾄﾞを装着したり,ｺｰｽから外れると,減速してしまいます.", 5 + i, y + 10, 230);
							drawStringTurn("規定距離を走行し,ﾍﾞｽﾄﾀｲﾑをたたき出して下さい.", 5 + i, y + 10, 230);
						}
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▼", FONT_SMALL, 230, COLOR_W);
						}
					}
					break;
				case 1:
					drawImage(g, use_image(IMAGE_MASK), 0, 0);
					{
						int x;
						g.setColor(COLOR_W);
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▲", FONT_SMALL, 20, COLOR_W);
						}
						centerDrawString("ﾀｲﾄﾙ画面での操作", FONT_SMALL, 45, COLOR_W);
						drawHelpTitle("説明", 120, 80, COLOR_W);
						drawHelpButton("ｿﾌﾄ1", 130, 80, COLOR_W);
						drawHelpTitle("ｱﾌﾟﾘ終了", 120, 105, COLOR_W);
						drawHelpButton("ｿﾌﾄ2", 130, 105, COLOR_W);
						drawHelpTitle("ﾆｭｰﾄﾗﾙON/OFF", 120, 130, COLOR_W);
						x = drawHelpButton("←", 130, 130, COLOR_W);
						drawHelpButton("→", x + 5, 130, COLOR_W);
						drawHelpTitle("ﾚﾍﾞﾙ選択", 120, 155, COLOR_W);
						x = drawHelpButton("↑", 130, 155, COLOR_W);
						drawHelpButton("↓", x + 5, 155, COLOR_W);
						drawHelpTitle("ｷｬﾗｸﾀ選択へ", 120, 180, COLOR_W);
						drawHelpButton("決定", 130, 180, COLOR_W);
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▼", FONT_SMALL, 230, COLOR_W);
						}
					}
					break;
				case 2:
					drawImage(g, use_image(IMAGE_MASK), 0, 0);
					{
						int x;
						g.setColor(COLOR_W);
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▲", FONT_SMALL, 20, COLOR_W);
						}
						centerDrawString("ｷｬﾗｸﾀ選択画面での操作", FONT_SMALL, 45, COLOR_W);
						drawHelpTitle("ｷｬﾗｸﾀ選択", 100, 80, COLOR_W);
						x = drawHelpButton("←", 110, 80, COLOR_W);
						drawHelpButton("→", x + 5, 80, COLOR_W);
						drawHelpTitle("ｹﾞｰﾑ開始", 100, 105, COLOR_W);
						drawHelpButton("決定", 110, 105, COLOR_W);
						drawHelpTitle("ﾀｲﾄﾙに戻る", 100, 130, COLOR_W);
						drawHelpButton("ｿﾌﾄ1", 110, 130, COLOR_W);
						drawHelpTitle("ｱﾌﾟﾘ終了", 100, 155, COLOR_W);
						drawHelpButton("ｿﾌﾄ2", 110, 155, COLOR_W);
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▼", FONT_SMALL, 230, COLOR_W);
						}
					}
					break;
				case 3:
					drawImage(g, use_image(IMAGE_MASK), 0, 0);
					{
						int x;
						g.setColor(COLOR_W);
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▲", FONT_SMALL, 20, COLOR_W);
						}
						centerDrawString("ﾌﾟﾚｲ中の操作", FONT_SMALL, 45, COLOR_W);
						drawHelpTitle("ﾎﾟｰｽﾞ", 100, 80, COLOR_W);
						drawHelpButton("1", 110, 80, COLOR_W);
						drawHelpTitle("ﾀｲﾄﾙに戻る", 100, 105, COLOR_W);
						drawHelpButton("3", 110, 105, COLOR_W);
						drawHelpTitle("自機の移動", 100, 130, COLOR_W);
						x = drawHelpButton("←", 110, 130, COLOR_W);
						drawHelpButton("→", x + 5, 130, COLOR_W);
						drawHelpTitle("青色ｼｰﾙﾄﾞ", 100, 155, COLOR_C);
						x = drawHelpButton("ｿﾌﾄ1", 110, 155, COLOR_W);
						x = drawHelpButton("4", x + 5, 155, COLOR_W);
						x = drawHelpButton("7", x + 5, 155, COLOR_W);
						drawHelpButton("*", x + 5, 155, COLOR_W);
						drawHelpTitle("赤色ｼｰﾙﾄﾞ", 100, 180, COLOR_M);
						x = drawHelpButton("決定", 110, 180, COLOR_W);
						x = drawHelpButton("5", x + 5, 180, COLOR_W);
						x = drawHelpButton("8", x + 5, 180, COLOR_W);
						drawHelpButton("0", x + 5, 180, COLOR_W);
						drawHelpTitle("黄色ｼｰﾙﾄﾞ", 100, 205, COLOR_Y);
						x = drawHelpButton("ｿﾌﾄ2", 110, 205, COLOR_W);
						x = drawHelpButton("6", x + 5, 205, COLOR_W);
						x = drawHelpButton("9", x + 5, 205, COLOR_W);
						drawHelpButton("#", x + 5, 205, COLOR_W);
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▼", FONT_SMALL, 230, COLOR_W);
						}
					}
					break;
				case 4:
					drawImage(g, use_image(IMAGE_MASK), 0, 0);
					{
						g.setColor(COLOR_W);
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▲", FONT_SMALL, 20, COLOR_W);
						}
						centerDrawString("ｷｬﾗｸﾀ選択画面について", FONT_SMALL, 45, COLOR_W);
						for ( int i = 1; i >= 0; i-- ) {
							if ( i == 1 ) {
								g.setColor(COLOR_K);
							} else {
								g.setColor(COLOR_W);
							}
							drawStringTurn("ｷｬﾗｸﾀ毎に,1位になった回数を記録しています.1回でも1位になると,右上に回数が表示されるようになります.", 5 + i, 80 + i, 230);
						}
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▼", FONT_SMALL, 230, COLOR_W);
						}
					}
					break;
				case 5:
					drawImage(g, use_image(IMAGE_MASK), 0, 0);
					{
						int y;
						g.setColor(COLOR_W);
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▲", FONT_SMALL, 20, COLOR_W);
						}
						centerDrawString("ﾄﾚｰﾆﾝｸﾞﾓｰﾄﾞについて", FONT_SMALL, 45, COLOR_W);
						for ( int i = 1; i >= 0; i-- ) {
							if ( i == 1 ) {
								g.setColor(COLOR_K);
							} else {
								g.setColor(COLOR_W);
							}
							y = drawStringTurn("TRAINING 1:ｼｰﾙﾄﾞ切り替えのﾄﾚｰﾆﾝｸﾞです.ｽﾃｱﾘﾝｸﾞ操作が自動になります.", 5 + i, 80 + i, 230);
							drawStringTurn("TRAINING 2:ｽﾃｱﾘﾝｸﾞ操作のﾄﾚｰﾆﾝｸﾞです.ｼｰﾙﾄﾞ切り替えが自動になります.", 5 + i, y + 10, 230);
						}
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▼", FONT_SMALL, 230, COLOR_W);
						}
					}
					break;
				case 6:
					drawImage(g, use_image(IMAGE_MASK), 0, 0);
					{
						g.setColor(COLOR_W);
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▲", FONT_SMALL, 20, COLOR_W);
						}
						centerDrawString("ﾗｯﾌﾟﾀｲﾑについて", FONT_SMALL, 45, COLOR_W);
						for ( int i = 1; i >= 0; i-- ) {
							if ( i == 1 ) {
								g.setColor(COLOR_K);
							} else {
								g.setColor(COLOR_W);
							}
							drawStringTurn("ﾍﾞｽﾄﾀｲﾑをたたき出した時のﾗｯﾌﾟﾀｲﾑが記録されます.次回以降の走行時に,ﾗｯﾌﾟ毎の時間差が画面左上に表示されるようになります.", 5 + i, 80 + i, 230);
						}
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▼", FONT_SMALL, 230, COLOR_W);
						}
					}
					break;
				case 7:
					drawImage(g, use_image(IMAGE_MASK), 0, 0);
					{
						g.setColor(COLOR_W);
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							centerDrawString("▲", FONT_SMALL, 20, COLOR_W);
						}
						centerDrawString("ﾌﾞｰｽﾄについて", FONT_SMALL, 45, COLOR_W);
						for ( int i = 1; i >= 0; i-- ) {
							if ( i == 1 ) {
								g.setColor(COLOR_K);
							} else {
								g.setColor(COLOR_W);
							}
							drawStringTurn("ﾚｰｽﾓｰﾄﾞにおいて,ﾁｪｯｸﾎﾟｲﾝﾄを通過すると,ﾌﾞｰｽﾄが1回のみ使用可能になり,画面右上に「BOOST OK!」と表示されます.その状態で,現在のｼｰﾙﾄﾞと同じ色のｼｰﾙﾄﾞ切り替えﾎﾞﾀﾝを押すと,ｽﾋﾟｰﾄﾞが+100されます(ただしｽﾋﾟｰﾄﾞの上限は 500).", 5 + i, 80 + i, 230);
						}
					}
					break;
				case 8:
					break;
				}
				g.unlock(true);
				break;
			case STATE_SELECT:
			case STATE_SELECT_LOADING:
				// 描画
				g.lock();
				{
					int i;
					int x = 0;
					int tmp = 0;

					g.setColor(COLOR_K);
					g.fillRect(0, 0, 240, height);

					switch ( player ) {
					case 0: drawImage(g, use_image(IMAGE_RAY), 0, 0); break;
					case 1: drawImage(g, use_image(IMAGE_RAX), 0, 0); break;
					case 2: drawImage(g, use_image(IMAGE_COM), 0, 0); break;
					}
					drawImage(g, use_image(IMAGE_MASK), 0, 0);

//					drawImage(g, use_image(IMAGE_TITLE), (240 - TEXT_SELECTCHAR_W) / 2, 15, TEXT_SELECTCHAR_X, TEXT_SELECTCHAR_Y, TEXT_SELECTCHAR_W, TEXT_SELECTCHAR_H);
					g.setColor(COLOR_Y);
					centerDrawString("キャラクタを選んでね", FONT_SMALL, 20);

					drawImage(g, use_image(IMAGE_TITLE), 140 - TEXT_ACCELERATION_W, 140, TEXT_ACCELERATION_X, TEXT_ACCELERATION_Y, TEXT_ACCELERATION_W, TEXT_ACCELERATION_H);
					drawImage(g, use_image(IMAGE_TITLE), 140 - TEXT_SLOWDOWN_W, 160, TEXT_SLOWDOWN_X, TEXT_SLOWDOWN_Y, TEXT_SLOWDOWN_W, TEXT_SLOWDOWN_H);
					drawImage(g, use_image(IMAGE_TITLE), 140 - TEXT_STEERING_W, 180, TEXT_STEERING_X, TEXT_STEERING_Y, TEXT_STEERING_W, TEXT_STEERING_H);

					setCMYColor(_elapse % 3);
					g.drawRect(80, 45, 80, 80);
					drawImage(g, use_image(IMAGE_TITLE),  71, 81, 150, 0, 5, 9);
					drawImage(g, use_image(IMAGE_TITLE), 165, 81, 155, 0, 5, 9);

					switch ( player ) {
					case 0:
						for ( i = 0; i < 3; i++ ) {
							switch ( i ) {
							case 0: x =  65; tmp = win[index_w()][2]; break;
							case 1: x = 145; tmp = win[index_w()][0]; break;
							case 2: x = 225; tmp = win[index_w()][1]; break;
							}
							while ( tmp != 0 ) {
								drawImage(g, use_image(IMAGE_TITLE), x, 50, (tmp % 10) * 12, 0, 12, 12);
								tmp /= 10;
								x -= 12;
							}
						}

						drawImage(g, use_image(IMAGE_SPEEDER3),  40 - (SPEEDER3_W[0] / 2), 55, SPEEDER3_X[0], 0, SPEEDER3_W[0], 43);
						drawImage(g, use_image(IMAGE_SPEEDER1), 120 - (SPEEDER1_W[0] / 2), 55, SPEEDER1_X[0], 0, SPEEDER1_W[0], 43);
						drawImage(g, use_image(IMAGE_SPEEDER2), 200 - (SPEEDER2_W[0] / 2), 57, SPEEDER2_X[0], 0, SPEEDER2_W[0], 41);

						drawImage(g, use_image(IMAGE_TITLE), (240 - TEXT_RAY_W) / 2, 105, TEXT_RAY_X, TEXT_RAY_Y, TEXT_RAY_W, TEXT_RAY_H);

						drawImage(g, use_image(IMAGE_TITLE), 150, 140, TEXT_FAST_X, TEXT_FAST_Y, TEXT_FAST_W, TEXT_FAST_H);
						drawImage(g, use_image(IMAGE_TITLE), 150, 160, TEXT_NORMAL_X, TEXT_NORMAL_Y, TEXT_NORMAL_W, TEXT_NORMAL_H);
						drawImage(g, use_image(IMAGE_TITLE), 150, 180, TEXT_NORMAL_X, TEXT_NORMAL_Y, TEXT_NORMAL_W, TEXT_NORMAL_H);

						break;
					case 1:
						for ( i = 0; i < 3; i++ ) {
							switch ( i ) {
							case 0: x =  65; tmp = win[index_w()][0]; break;
							case 1: x = 145; tmp = win[index_w()][1]; break;
							case 2: x = 225; tmp = win[index_w()][2]; break;
							}
							while ( tmp != 0 ) {
								drawImage(g, use_image(IMAGE_TITLE), x, 50, (tmp % 10) * 12, 0, 12, 12);
								tmp /= 10;
								x -= 12;
							}
						}

						drawImage(g, use_image(IMAGE_SPEEDER1),  40 - (SPEEDER1_W[0] / 2), 55, SPEEDER1_X[0], 0, SPEEDER1_W[0], 43);
						drawImage(g, use_image(IMAGE_SPEEDER2), 120 - (SPEEDER2_W[0] / 2), 57, SPEEDER2_X[0], 0, SPEEDER2_W[0], 41);
						drawImage(g, use_image(IMAGE_SPEEDER3), 200 - (SPEEDER3_W[0] / 2), 55, SPEEDER3_X[0], 0, SPEEDER3_W[0], 43);

						drawImage(g, use_image(IMAGE_TITLE), (240 - TEXT_RAX_W) / 2, 105, TEXT_RAX_X, TEXT_RAX_Y, TEXT_RAX_W, TEXT_RAX_H);

						drawImage(g, use_image(IMAGE_TITLE), 150, 140, TEXT_MIDDLE_X, TEXT_MIDDLE_Y, TEXT_MIDDLE_W, TEXT_MIDDLE_H);
						drawImage(g, use_image(IMAGE_TITLE), 150, 160, TEXT_SLIGHT_X, TEXT_SLIGHT_Y, TEXT_SLIGHT_W, TEXT_SLIGHT_H);
						drawImage(g, use_image(IMAGE_TITLE), 150, 180, TEXT_NORMAL_X, TEXT_NORMAL_Y, TEXT_NORMAL_W, TEXT_NORMAL_H);

						break;
					case 2:
						for ( i = 0; i < 3; i++ ) {
							switch ( i ) {
							case 0: x =  65; tmp = win[index_w()][1]; break;
							case 1: x = 145; tmp = win[index_w()][2]; break;
							case 2: x = 225; tmp = win[index_w()][0]; break;
							}
							while ( tmp != 0 ) {
								drawImage(g, use_image(IMAGE_TITLE), x, 50, (tmp % 10) * 12, 0, 12, 12);
								tmp /= 10;
								x -= 12;
							}
						}

						drawImage(g, use_image(IMAGE_SPEEDER2),  40 - (SPEEDER2_W[0] / 2), 57, SPEEDER2_X[0], 0, SPEEDER2_W[0], 41);
						drawImage(g, use_image(IMAGE_SPEEDER3), 120 - (SPEEDER3_W[0] / 2), 55, SPEEDER3_X[0], 0, SPEEDER3_W[0], 43);
						drawImage(g, use_image(IMAGE_SPEEDER1), 200 - (SPEEDER1_W[0] / 2), 55, SPEEDER1_X[0], 0, SPEEDER1_W[0], 43);

						drawImage(g, use_image(IMAGE_TITLE), (240 - TEXT_COM_W) / 2, 105, TEXT_COM_X, TEXT_COM_Y, TEXT_COM_W, TEXT_COM_H);

						drawImage(g, use_image(IMAGE_TITLE), 150, 140, TEXT_SLOW_X, TEXT_SLOW_Y, TEXT_SLOW_W, TEXT_SLOW_H);
						drawImage(g, use_image(IMAGE_TITLE), 150, 160, TEXT_NORMAL_X, TEXT_NORMAL_Y, TEXT_NORMAL_W, TEXT_NORMAL_H);
						drawImage(g, use_image(IMAGE_TITLE), 150, 180, TEXT_QUICK_X, TEXT_QUICK_Y, TEXT_QUICK_W, TEXT_QUICK_H);

						break;
					}

					if ( state == STATE_SELECT ) {
						if ( (_elapse % WAIT_1) <= (WAIT_1 / 2) ) {
							x = (240 - (TEXT_PRESS_W + 8 + TEXT_SELECT_W + 8 + TEXT_KEY_W)) / 2;
							drawImage(g, use_image(IMAGE_TITLE), x, 210, TEXT_PRESS_X, TEXT_PRESS_Y, TEXT_PRESS_W, TEXT_PRESS_H); x += (TEXT_PRESS_W + 8);
							drawImage(g, use_image(IMAGE_TITLE), x, 210, TEXT_SELECT_X, TEXT_SELECT_Y, TEXT_SELECT_W, TEXT_SELECT_H); x += (TEXT_SELECT_W + 8);
							drawImage(g, use_image(IMAGE_TITLE), x, 210, TEXT_KEY_X, TEXT_KEY_Y, TEXT_KEY_W, TEXT_KEY_H);
						}
					} else {
						drawImage(g, use_image(IMAGE_TITLE), (240 - TEXT_LOADING_W) / 2, 210, TEXT_LOADING_X, TEXT_LOADING_Y, TEXT_LOADING_W, TEXT_LOADING_H);
					}
				}
				g.unlock(true);

				if ( state == STATE_SELECT_LOADING ) {
					set_state(STATE_READY);
				}

				break;
			case STATE_READY:
				// 描画
				g.lock();
				stage.draw(true);
				wave.draw();
				speeder[0].draw(true);
				if ( (level < 2) || (level == 7) ) {
					speeder[1].draw(true);
					speeder[2].draw(true);
				}
				switch ( level ) {
				case 4:
					drawImage(g, use_image(IMAGE_STATUS), (240 - TEXT_AUTOSTEERING_W) / 2, 80, TEXT_AUTOSTEERING_X, TEXT_AUTOSTEERING_Y, TEXT_AUTOSTEERING_W, TEXT_AUTOSTEERING_H);
					break;
				case 5:
					drawImage(g, use_image(IMAGE_STATUS), (240 - TEXT_AUTOSHIELD_W) / 2, 80, TEXT_AUTOSHIELD_X, TEXT_AUTOSHIELD_Y, TEXT_AUTOSHIELD_W, TEXT_AUTOSHIELD_H);
					break;
				}
				drawImage(g, use_image(IMAGE_STATUS), (240 - TEXT_READY_W) / 2, (240 - TEXT_READY_H) / 2, TEXT_READY_X, TEXT_READY_Y, TEXT_READY_W, TEXT_READY_H);
				drawStatus(true);
				g.unlock(true);

				// 一定時間過ぎたらゲーム開始
				if ( _elapse > WAIT_2 ) {
					set_state(STATE_PLAY);
				}

				break;
			case STATE_PLAY:
				if ( !pause ) {
					int i;

					time[0]++;

					// 更新前の座標を保持
					if ( (level < 2) || (level == 7) ) {
						old_y[0] = speeder[1].dsp_y();
						old_y[1] = speeder[2].dsp_y();
					}

					// 更新
					stage.update();
					wave.update();

					if ( (level < 2) || (level == 7) ) {
						for ( i = 0; i < 2; i++ ) {
							if ( shield_wait[i] > 0 ) {
								shield_wait[i]--;
								if ( shield_wait[i] == 0 ) {
									speeder[i + 1].shield(shield_col[i]);
								}
							}

							new_y[i] = speeder[i + 1].dsp_y();
							if ( (old_y[i] > -48) && (new_y[i] <= -48) ) {
								speeder[i + 1].out(wave.top_x());
							} else if ( (old_y[i] <= -48) && (new_y[i] > -48) ) {
								speeder[i + 1].in(wave.top_x());
							} else if ( (old_y[i] < 320) && (new_y[i] >= 320) ) {
								speeder[i + 1].out(wave.bottom_x());
							} else if ( (old_y[i] >= 320) && (new_y[i] < 320) ) {
								speeder[i + 1].in(wave.bottom_x());
							}

							if ( new_y[i] <= -48 ) {
								if ( speeder[0].speed() < 310 ) {
									speeder[i + 1].speed_limit(300);
								} else {
									speeder[i + 1].speed_limit(speeder[0].speed() - 10);
								}
							}
						}
					}

					// スピーダーの移動
					if ( level == 4 ) {
						switch ( speeder[0].auto() ) {
						case AUTO_MOVED_INERTIA: speeder[0].auto(AUTO_INERTIA); break;
						case AUTO_MOVED_NEUTRAL: speeder[0].auto(AUTO_NEUTRAL); break;
						case AUTO_INERTIA: speeder[0].inertia(false); break;
						case AUTO_NEUTRAL: speeder[0].inertia(true ); break;
						}
					} else {
						if      ( (key & (1 << Display.KEY_LEFT )) != 0 ) speeder[0].left ();
						else if ( (key & (1 << Display.KEY_RIGHT)) != 0 ) speeder[0].right();
						else speeder[0].inertia(neutral);
						if ( (level < 2) || (level == 7) ) {
							for ( i = 1; i < 3; i++ ) {
								switch ( speeder[i].auto() ) {
								case AUTO_MOVED_INERTIA: speeder[i].auto(AUTO_INERTIA); break;
								case AUTO_MOVED_NEUTRAL: speeder[i].auto(AUTO_NEUTRAL); break;
								case AUTO_INERTIA: speeder[i].inertia(false); break;
								case AUTO_NEUTRAL: speeder[i].inertia(true ); break;
								}
							}
						}
					}
				}

				// 描画
				g.lock();
				stage.draw(false);
				{
					int cnt = wave.draw();
					if ( (cnt < 0) || (stage.offset_x() < 0) ) {
						if ( (elapse() % 2) == 0 ) {
							drawImage(g, use_image(IMAGE_BAR), 10, 102, 200, 0, 40, 36);
						}
					} else if ( (cnt > 0) || (stage.offset_x() > 0) ) {
						if ( (elapse() % 2) == 0 ) {
							drawImage(g, use_image(IMAGE_BAR), 190, 102, 200, 36, 40, 36);
						}
					}
				}
				speeder[0].draw(false);
				if ( (level < 2) || (level == 7) ) {
					speeder[1].draw(false);
					speeder[2].draw(false);
				}
				if ( level != 6 ) {
					if ( _elapse < WAIT_2 ) {
						drawImage(g, use_image(IMAGE_STATUS), (240 - TEXT_START_W) / 2, (240 - TEXT_START_H) / 2, TEXT_START_X, TEXT_START_Y, TEXT_START_W, TEXT_START_H);
					}
				}
				if ( pause ) {
					if ( (_elapse_p % WAIT_1) <= (WAIT_1 / 2) ) {
						drawImage(g, use_image(IMAGE_STATUS), (240 - TEXT_PAUSE_W) / 2, 125, TEXT_PAUSE_X, TEXT_PAUSE_Y, TEXT_PAUSE_W, TEXT_PAUSE_H);
					}
				}
				drawStatus(false);
				g.unlock(true);

				if ( level != 6 ) {
					if ( finish ) {
						// ステージクリア
						set_state(STATE_CLEAR);
					}
				} else {
					if ( speeder[0].speed() == 0 ) {
						// ゲーム終了
						set_state(STATE_STOP);
					}
				}

				break;
			case STATE_CLEAR:
				{
					int i;

					// 更新前の座標を保持
					if ( (level < 2) || (level == 7) ) {
						old_y[0] = speeder[1].dsp_y();
						old_y[1] = speeder[2].dsp_y();
					}

					// 更新
					stage.update();
					wave.update();

					if ( (level < 2) || (level == 7) ) {
						for ( i = 0; i < 2; i++ ) {
							new_y[i] = speeder[i + 1].dsp_y();
							if ( (old_y[i] <= -48) && (new_y[i] > -48) ) {
								speeder[i + 1].in(speeder[0].x() - 88);
							} else if ( (old_y[i] >= 320) && (new_y[i] < 320) ) {
								speeder[i + 1].in(speeder[0].x() - 88);
							}
						}
					}

					// スピーダーの移動
					speeder[0].inertia(true);
					if ( (level < 2) || (level == 7) ) {
						speeder[1].inertia(true);
						speeder[2].inertia(true);
					}
				}

				// 描画
				g.lock();
				stage.draw(false);
				wave.draw();
				speeder[0].draw(false);
				if ( (level < 2) || (level == 7) ) {
					speeder[1].draw(false);
					speeder[2].draw(false);
				}
				if ( (level < 2) || (level == 7) ) {
					int y = (240 - (TEXT_FINISH_H + 10 + TEXT_1ST_H + 10 + TEXT_NEWRECORD_H)) / 2;
					drawImage(g, use_image(IMAGE_STATUS), (240 - TEXT_FINISH_W) / 2, y, TEXT_FINISH_X, TEXT_FINISH_Y, TEXT_FINISH_W, TEXT_FINISH_H);
					y += (TEXT_FINISH_H + 10);
					switch ( ranking ) {
					case 1:
						drawImage(g, use_image(IMAGE_STATUS), (240 - TEXT_1ST_W) / 2, y, TEXT_1ST_X, TEXT_1ST_Y, TEXT_1ST_W, TEXT_1ST_H);
						break;
					case 2:
						drawImage(g, use_image(IMAGE_STATUS), (240 - TEXT_2ND_W) / 2, y, TEXT_2ND_X, TEXT_2ND_Y, TEXT_2ND_W, TEXT_2ND_H);
						break;
					case 3:
						drawImage(g, use_image(IMAGE_STATUS), (240 - TEXT_3RD_W) / 2, y, TEXT_3RD_X, TEXT_3RD_Y, TEXT_3RD_W, TEXT_3RD_H);
						break;
					}
					y += (TEXT_1ST_H + 10);
					if ( new_time ) {
						drawImage(g, use_image(IMAGE_STATUS), (240 - TEXT_NEWRECORD_W) / 2, y, TEXT_NEWRECORD_X, TEXT_NEWRECORD_Y, TEXT_NEWRECORD_W, TEXT_NEWRECORD_H);
					}
				} else {
					drawImage(g, use_image(IMAGE_STATUS), (240 - TEXT_FINISH_W) / 2, (240 - TEXT_FINISH_H) / 2, TEXT_FINISH_X, TEXT_FINISH_Y, TEXT_FINISH_W, TEXT_FINISH_H);
					if ( new_time ) {
						drawImage(g, use_image(IMAGE_STATUS), (240 - TEXT_NEWRECORD_W) / 2, 140, TEXT_NEWRECORD_X, TEXT_NEWRECORD_Y, TEXT_NEWRECORD_W, TEXT_NEWRECORD_H);
					}
				}
				drawStatus(false);
				g.unlock(true);

				// 一定時間過ぎたらタイトル画面へ
				if ( _elapse > WAIT_3 ) {
					set_state(STATE_TITLE);
				}

				break;
			case STATE_STOP:
				// スピーダーの移動
				speeder[0].inertia(true);

				// 描画
				g.lock();
				stage.draw(false);
				wave.draw();
				speeder[0].draw(false);
				{
					int x = (240 - (TEXT_STOP_W + 3 + TEXT_PED_W)) / 2;
					int y = (240 - TEXT_STOP_H) / 2;
					drawImage(g, use_image(IMAGE_STATUS), x, y, TEXT_STOP_X, TEXT_STOP_Y, TEXT_STOP_W, TEXT_STOP_H); x += (TEXT_STOP_W + 3);
					drawImage(g, use_image(IMAGE_STATUS), x, y, TEXT_PED_X, TEXT_PED_Y, TEXT_PED_W, TEXT_PED_H);
				}
				if ( new_distance ) {
					drawImage(g, use_image(IMAGE_STATUS), (240 - TEXT_NEWRECORD_W) / 2, 140, TEXT_NEWRECORD_X, TEXT_NEWRECORD_Y, TEXT_NEWRECORD_W, TEXT_NEWRECORD_H);
				}
				drawStatus(false);
				g.unlock(true);

				// 一定時間過ぎたらタイトル画面へ
				if ( _elapse > WAIT_3 ) {
					set_state(STATE_TITLE);
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

			unlock_state();
		}

		/**
		 * キー入力処理
		 */
		public void processEvent(int type, int param) {
			if ( processingEvent ) return;
			processingEvent = true;

			if( type == Display.KEY_PRESSED_EVENT ) {
				switch ( state ) {
				case STATE_DOWNLOAD:
					break;
				case STATE_DOWNLOADERROR:
				case STATE_RELOAD:
					switch ( param ) {
					case Display.KEY_SOFT2:
						IApplication.getCurrentApp().terminate();
						break;
					}
					break;
				case STATE_RELOADCONFIRM:
					switch ( param ) {
					case Display.KEY_SOFT1:
						lock_state();
						set_state(STATE_RELOAD);
						unlock_state();
						break;
					case Display.KEY_SOFT2:
						lock_state();
						set_state(STATE_TITLE);
						unlock_state();
						break;
					}
					break;
				case STATE_LAUNCH:
					break;
				case STATE_TITLE:
					switch ( param ) {
					case Display.KEY_SOFT1:
						lock_state();
						set_state(STATE_HELP);
						unlock_state();
						break;
					case Display.KEY_SOFT2:
						IApplication.getCurrentApp().terminate();
						break;
					case Display.KEY_LEFT:
					case Display.KEY_RIGHT:
						lock_state();
						neutral = neutral ? false : true;
						unlock_state();
						break;
					case Display.KEY_UP:
						lock_state();
						level--; if ( level < 0 ) level = level_max();
						unlock_state();
						break;
					case Display.KEY_DOWN:
						lock_state();
						level++; if ( level > level_max() ) level = 0;
						unlock_state();
						break;
					case Display.KEY_SELECT:
						lock_state();
						set_state(STATE_TITLE_LOADING);
						unlock_state();
						break;
					case Display.KEY_0:
						lock_state();
						set_state(STATE_RELOADCONFIRM);
						unlock_state();
						break;
					}
					break;
				case STATE_TITLE_LOADING:
					break;
				case STATE_HELP:
					switch ( param ) {
					case Display.KEY_SOFT1:
						lock_state();
						set_state(STATE_TITLE);
						unlock_state();
						break;
					case Display.KEY_SOFT2:
						IApplication.getCurrentApp().terminate();
						break;
					case Display.KEY_UP:
						lock_state();
						help--; if ( help < 0 ) help = 0;
						unlock_state();
						break;
					case Display.KEY_DOWN:
						lock_state();
						help++; if ( help > 8 ) help = 8;
						unlock_state();
						break;
					}
					break;
				case STATE_SELECT:
					switch ( param ) {
					case Display.KEY_LEFT:
						lock_state();
						player--; if ( player < 0 ) player = 2;
						unlock_state();
						break;
					case Display.KEY_RIGHT:
						lock_state();
						player++; if ( player > 2 ) player = 0;
						unlock_state();
						break;
					case Display.KEY_SELECT:
						lock_state();
						set_state(STATE_SELECT_LOADING);
						unlock_state();
						break;
					case Display.KEY_SOFT1:
						lock_state();
						set_state(STATE_TITLE);
						unlock_state();
						break;
					case Display.KEY_SOFT2:
						IApplication.getCurrentApp().terminate();
						break;
					}
					break;
				case STATE_SELECT_LOADING:
					break;
				default:
					switch ( param ) {
					case Display.KEY_1:
						lock_state();
						pause = pause ? false : true; if ( pause ) _elapse_p = 0;
						unlock_state();
						break;
					case Display.KEY_3:
						lock_state();
						set_state(STATE_TITLE);
						unlock_state();
						break;
					case Display.KEY_SOFT1:
					case Display.KEY_4:
					case Display.KEY_7:
					case Display.KEY_ASTERISK:
						if ( level != 5 ) {
							if ( !pause ) {
								if ( boost && (speeder[0]._shield == 0) ) {
									_elapse_b = _elapse;
									boost = false;
									speeder[0].speed_up(400);
								} else {
									speeder[0].shield(0);
								}
							}
						}
						break;
					case Display.KEY_SELECT:
					case Display.KEY_5:
					case Display.KEY_8:
					case Display.KEY_0:
						if ( level != 5 ) {
							if ( !pause ) {
								if ( boost && (speeder[0]._shield == 1) ) {
									_elapse_b = _elapse;
									boost = false;
									speeder[0].speed_up(400);
								} else {
									speeder[0].shield(1);
								}
							}
						}
						break;
					case Display.KEY_SOFT2:
					case Display.KEY_6:
					case Display.KEY_9:
					case Display.KEY_POUND:
						if ( level != 5 ) {
							if ( !pause ) {
								if ( boost && (speeder[0]._shield == 2) ) {
									_elapse_b = _elapse;
									boost = false;
									speeder[0].speed_up(400);
								} else {
									speeder[0].shield(2);
								}
							}
						}
						break;
					}
					break;
				}
			}

			processingEvent = false;
		}
	}

	/**
	 * ステージ
	 */
	class Stage {
		int _back = -1;		// 背景の種類
		int _col;			// ウェーブの色
		int old_distance;
		int x, _move_x, _offset_x;
		boolean counter;
		int bar;
#ifdef _900i
		Vector star;		// 星情報
#endif // _900i

		/**
		 * コンストラクタ
		 */
		Stage() {
#ifdef _900i
			star = new Vector();
#endif // _900i
		}

		/**
		 * ステージデータ構築
		 */
		public void create() {
			int i;

#ifdef _900i
			star.removeAllElements();
			System.gc();
#endif // _900i

			int tmp;
			while ( true ) {
#ifdef _505i
				tmp = (rand.nextInt() % 3) + 2;
#endif // _505i
#ifdef _900i
				tmp = (rand.nextInt() % 4) + 3;
#endif // _900i
				if ( tmp != _back ) {
					_back = tmp;
					break;
				}
			}

			_col = (rand.nextInt() % 2) + 1;

			// シールド変更
			if ( level == 5 ) {
				speeder[0].shield(_col);
			}
			if ( (level < 2) || (level == 7) ) {
				speeder[1].shield(_col);
				speeder[2].shield(_col);
			}

#ifdef _900i
			for ( i = 0; i < height; i += 3 ) {
				star.addElement(new Star(120 + (rand.nextInt() % 360), i));
			}
#endif // _900i

			wave.add_bar(-100, 192, 3, (level != 6) ? 9 : 0, false);
			bar = 1;
			for ( i = 172; i > 0; i -= 20 ) {
				wave.add_bar(-100, i, _col);
				bar++;
			}

			old_distance = speeder[0].distance();
			x            = -100;
			_move_x      = 0;
			_offset_x    = 0;
			counter      = false;
		}

		/**
		 * ステージデータ更新
		 */
		public void update() {
			int i;

#ifdef _900i
			for ( i = star.size() - 1; i >= 0; i-- ) {
				Star tmp = (Star)star.elementAt(i);
				if ( !tmp.update() ) {
					star.removeElementAt(i);
					System.gc();
				}
			}

			if ( speeder[0].speed() > 0 ) {
				star.addElement(new Star(120 + (rand.nextInt() % 360), 0));
			}
#endif // _900i

			if ( level != 6 ) {
				for ( i = 0; i < 3; i++ ) {
					if (
					((i == 0) && wave.clear()) ||
					((i != 0) && (speeder[i].distance() > (DISTANCE + 2400)))
					) {
						speeder[i].speed_down(10);
					} else {
						speeder[i].speed_up(1);
					}
					speeder[i].add_distance(speeder[i].speed());
					if ( (level >= 2) && (level <= 6) ) break;
				}
			} else {
				if ( speeder[0].speed() < 300 ) {
					speeder[0].speed_down(5);
				}
				speeder[0].add_distance(speeder[0].speed());
			}

			if ( counter ) {
				if ( (speeder[0].distance() - old_distance) >= 240 ) {
					wave.add_bar(x, 0, 3, 9 - speeder[0].distance() / (DISTANCE / 9), false);
					bar++;
					if ( bar >= 12 ) {
						bar = 0;
						counter = false;
					}
					old_distance = speeder[0].distance();
				}
			} else {
				if ( bar > 20 ) {
					bar = 0;

					change_col = (level == 7) ? 1 : 2;

					switch ( level ) {
					case 0:
					case 2:
					case 4:
						_move_x += (12 * (rand.nextInt() % 2));
						if ( _move_x < -12 ) _move_x = -12;
						if ( _move_x >  12 ) _move_x =  12;
						break;
					case 1:
					case 3:
					case 5:
					case 6:
						_move_x += (12 * (rand.nextInt() % 3));
						if ( _move_x < -24 ) _move_x = -24;
						if ( _move_x >  24 ) _move_x =  24;
						break;
					case 7:
						_offset_x = (100 * (rand.nextInt() % 2));
						break;
					}
				} else if ( (level == 7) && (bar > 5) ) {
					if ( change_col == 1 ) change_col = 2;

					x += _offset_x;
					_offset_x = 0;
				}

				if ( change_col == 2 ) {
					change_col = 0;

					int old_col = _col;
					_col = (rand.nextInt() % 2) + 1;
					if ( _col != old_col ) {
						if ( (level < 2) || (level == 7) ) {
							// シールド切り替え速度計測開始
							_elapse_s = 1;

							// シールド変更
							for ( i = 0; i < 2; i++ ) {
								if ( shield_wait[i] == 0 ) {
									shield_wait[i] = shield_lag[i];
									shield_col [i] = _col;
								}
							}
						}
					}
				}

				if ( (speeder[0].distance() - old_distance) >= 500 ) {
					if ( level != 6 ) {
						if ( (speeder[0].distance() / (DISTANCE / 9)) != (old_distance / (DISTANCE / 9)) ) {
							wave.add_bar(x, 0, 3, 9 - (speeder[0].distance() / (DISTANCE / 9)), true);
							if ( (9 - (speeder[0].distance() / (DISTANCE / 9))) > 0 ) {
								bar = 1;
								counter = true;
								if ( (level < 2) || (level == 7) ) {
									boost = true;
								}
							}
						} else if ( speeder[0].distance() < DISTANCE ) {
							bar += (speeder[0].distance() - old_distance) / 500;
							x += _move_x;
							wave.add_bar(x, 0, _col);
						}
					} else {
						bar += (speeder[0].distance() - old_distance) / 500;
						x += _move_x;
						wave.add_bar(x, 0, _col);
					}
					old_distance = speeder[0].distance();
				}
			}
		}

		// ウェーブの色を確認
		public int col() { return _col; }

		public int move_x() { return _move_x; }

		public int offset_x() { return _offset_x; }

		/**
		 * 描画
		 */
		public void draw(boolean ready) {
#ifdef _505i
			switch ( _back ) {
			case 0: drawImage(g, use_image(IMAGE_BACK1), 0, 0); break;
			case 1: drawImage(g, use_image(IMAGE_BACK2), 0, 0); break;
			case 2: drawImage(g, use_image(IMAGE_BACK3), 0, 0); break;
			case 3: drawImage(g, use_image(IMAGE_BACK4), 0, 0); break;
			case 4: drawImage(g, use_image(IMAGE_BACK5), 0, 0); break;
			}
#endif // _505i
#ifdef _900i
			if ( _back < 5 ) {
				drawImage(g, use_image(IMAGE_BACK), 0,   0);
				drawImage(g, use_image(IMAGE_BACK), 0, 135);
			}

			int distance;
			distance = speeder[0].distance(); if ( distance > DISTANCE ) distance = DISTANCE;
			switch ( _back ) {
			case 0:
				drawImage(g, use_image(IMAGE_FORE1), 10, (120 * distance / DISTANCE) - 120);
				break;
			case 1:
				drawImage(g, use_image(IMAGE_FORE2), (120 * distance / DISTANCE) - 120, 0);
				break;
			case 2:
				drawImage(g, use_image(IMAGE_FORE3), 0 - (80 * distance / DISTANCE), height - 188);
				break;
			case 3:
				drawImage(g, use_image(IMAGE_FORE4), 120 - (240 * distance / DISTANCE), 0);
				break;
			case 4:
				drawImage(g, use_image(IMAGE_FORE4), 0, (240 * distance / DISTANCE) - 120);
				break;
			case 5:
				drawImage(g, use_image(IMAGE_FORE5A), 0, ((480 - height) * distance / DISTANCE) - (480 - height)      );
				drawImage(g, use_image(IMAGE_FORE5B), 0, ((480 - height) * distance / DISTANCE) - (480 - height) + 240);
				break;
			case 6:
				drawImage(g, use_image(IMAGE_FORE6A), 0 - (140 * distance / DISTANCE)      , 0);
				drawImage(g, use_image(IMAGE_FORE6B), 0 - (140 * distance / DISTANCE) + 190, 0);
				break;
			}

			g.setColor(COLOR_W);
			int h = ready ? 0 : (speeder[0].speed() / 50);
			for ( int i = star.size() - 1; i >= 0; i-- ) {
				Star tmp = (Star)star.elementAt(i);
				if ( (tmp.x() >= 0) && (tmp.x() < 240) ) {
					g.drawLine(tmp.x(), tmp.y(), tmp.x(), tmp.y() + h);
				}
			}
#endif // _900i
		}
	}

	/**
	 * ウェーブ
	 */
	class Wave {
		Vector bar;	// バー情報

		/**
		 * コンストラクタ
		 */
		Wave() {
			bar = new Vector();
		}

		/**
		 * 構築
		 */
		public void create() {
			bar.removeAllElements();
			System.gc();
		}

		/**
		 * バーを登録する
		 */
		public void add_bar(int x, int y, int col, int count, boolean border) {
			bar.addElement(new Bar(x, y, col, count, border));
		}
		public void add_bar(int x, int y, int col) {
			bar.addElement(new Bar(x, y, col, 0, false));
		}

		/**
		 * バーが無くなったかどうか
		 */
		public boolean clear() {
			if ( bar.size() <= 0 ) return true;
			return false;
		}

		public int top_x() {
			int x = 0;
			int y = 240;
			for ( int i = bar.size() - 1; i >= 0; i-- ) {
				Bar tmp = (Bar)bar.elementAt(i);
				if ( tmp.y() < y ) {
					y = tmp.y();
					x = tmp.x();
				}
			}
			return x;
		}
		public int bottom_x() {
			int x = 0;
			int y = 0;
			for ( int i = bar.size() - 1; i >= 0; i-- ) {
				Bar tmp = (Bar)bar.elementAt(i);
				if ( tmp.y() > y ) {
					y = tmp.y();
					x = tmp.x();
				}
			}
			return x;
		}

		/**
		 * ウェーブデータ更新
		 */
		public void update() {
			for ( int i = bar.size() - 1; i >= 0; i-- ) {
				Bar tmp = (Bar)bar.elementAt(i);
				if ( !tmp.update() ) {
					bar.removeElementAt(i);
					System.gc();
				}
			}
		}

		/**
		 * 描画
		 */
		public int draw() {
			int cnt = 0;
			for ( int i = bar.size() - 1; i >= 0; i-- ) {
				Bar tmp = (Bar)bar.elementAt(i);
				if ( tmp.col() == 3 ) {
					cnt += drawImage(g, use_image(IMAGE_BAR), 108 - (speeder[0].x() - tmp.x()), tmp.y(), 0, 36 * (elapse() % 2) + 12 * (elapse() % 3), 200, 12);
					drawImage(g, use_image(IMAGE_BAR), 108 - (speeder[0].x() - tmp.x()) - 24, tmp.y() - 6, 24 * tmp.count(), 72, 24, 24);
					drawImage(g, use_image(IMAGE_BAR), 108 - (speeder[0].x() - tmp.x()) + 200, tmp.y() - 6, 24 * tmp.count(), 72, 24, 24);
				} else {
					cnt += drawImage(g, use_image(IMAGE_BAR), 108 - (speeder[0].x() - tmp.x()), tmp.y(), 0, 36 * (elapse() % 2) + 12 * tmp.col(), 200, 12);
				}
			}
			if ( Math.abs(cnt) == bar.size() ) {
				return cnt;
			}
			return 0;
		}
	}

#ifdef _900i
	/**
	 * 星
	 */
	class Star extends Object {
		int _x, _y;
		Star(int x, int y) { _x = x; _y = y; }
		public int x() { return _x; }
		public int y() { return _y; }
		public boolean update() {
			_x -= speeder[0].direction() / 7;
			if ( speeder[0].speed() > 0 ) {
				_y += ((speeder[0].speed() / 50) + 1);
			}
			if ( _y >= height ) {
				return false;
			}
			return true;
		}
	}
#endif // _900i

	/**
	 * バー
	 */
	class Bar extends Object {
		int _x, _y;
		int _col;
		int _count;
		boolean _border;
		boolean[] _hit;
		Bar(int x, int y, int col, int count, boolean border) {
			_x      = x;
			_y      = y;
			_col    = col;
			_count  = count;
			_border = border;

			_hit = new boolean[3];
			_hit[0] = false;
			_hit[1] = false;
			_hit[2] = false;
		}
		public int x() { return _x; }
		public int y() { return _y; }
		public int col() { return _col; }
		public int count() { return _count; }
		public boolean update() {
			_y += speeder[0].speed() / 10;

			int y;
			int dsp_x0, dsp_y0;
			int dsp_x1, dsp_y1;
			int dsp_x2, dsp_y2;
			for ( int i = 0; i < 3; i++ ) {
				y = speeder[i].dsp_y();
				if ( (y > -48) && (y < 320) && (_y > y) && !_hit[i] ) {
					_hit[i] = true;

					if ( i != 0 ) {
						// 移動
						if ( speeder[i].x() <= (_x + 38) ) {
							speeder[i].right();
							speeder[i].auto(AUTO_MOVED_INERTIA);
						} else if ( speeder[i].x() >= (_x + 138) ) {
							speeder[i].left();
							speeder[i].auto(AUTO_MOVED_INERTIA);
						} else if ( speeder[i].x() != (_x + 88) ) {
							speeder[i].set_direction(((_x + 88) - speeder[i].x()) / 10);
							speeder[i].auto(AUTO_MOVED_NEUTRAL);
						} else {
							speeder[i].auto(AUTO_NEUTRAL);
						}

						// スライド
						dsp_x0 = speeder[0].dsp_x();
						dsp_y0 = speeder[0].dsp_y();
						dsp_x1 = speeder[1].dsp_x();
						dsp_y1 = speeder[1].dsp_y();
						dsp_x2 = speeder[2].dsp_x();
						dsp_y2 = speeder[2].dsp_y();
						switch ( i ) {
						case 1:
							if (
							( dsp_x1       <= (dsp_x0 + 24)) &&
							( dsp_y1       <= (dsp_y0 + 48)) &&
							((dsp_x1 + 24) >=  dsp_x0      ) &&
							((dsp_y1 + 48) >=  dsp_y0      )
							) {
								speeder[i].slide((speeder[0].x() < (_x + 88)) ? 1 : -1);
							} else if (
							( dsp_x1       <= (dsp_x2 + 24)) &&
							( dsp_y1       <= (dsp_y2 + 48)) &&
							((dsp_x1 + 24) >=  dsp_x2      ) &&
							((dsp_y1 + 48) >=  dsp_y2      )
							) {
								speeder[i].slide((speeder[2].x() < (_x + 88)) ? 1 : -1);
							}
							break;
						case 2:
							if (
							( dsp_x2       <= (dsp_x0 + 24)) &&
							( dsp_y2       <= (dsp_y0 + 48)) &&
							((dsp_x2 + 24) >=  dsp_x0      ) &&
							((dsp_y2 + 48) >=  dsp_y0      )
							) {
								speeder[i].slide((speeder[0].x() < (_x + 88)) ? 1 : -1);
							} else if (
							( dsp_x2       <= (dsp_x1 + 24)) &&
							( dsp_y2       <= (dsp_y1 + 48)) &&
							((dsp_x2 + 24) >=  dsp_x1      ) &&
							((dsp_y2 + 48) >=  dsp_y1      )
							) {
								speeder[i].slide((speeder[1].x() < (_x + 88)) ? 1 : -1);
							}
							break;
						}
					}

					// 移動
					if ( level == 4 ) {
						if ( speeder[0].x() <= (_x + 38) ) {
							speeder[0].right();
							speeder[0].auto(AUTO_MOVED_INERTIA);
						} else if ( speeder[0].x() >= (_x + 138) ) {
							speeder[0].left();
							speeder[0].auto(AUTO_MOVED_INERTIA);
						} else if ( speeder[0].x() != (_x + 88) ) {
							speeder[0].set_direction(((_x + 88) - speeder[0].x()) / 10);
							speeder[0].auto(AUTO_MOVED_NEUTRAL);
						} else {
							speeder[0].auto(AUTO_NEUTRAL);
						}
					}

					// シールド変更
					if ( level == 5 ) {
						if ( _col < 3 ) speeder[0].shield(_col);
					}

					// スピード変更
					boolean in = true;
					if ( (level != 4) && ((_x > speeder[i].x()) || ((_x + 176) < speeder[i].x())) ) {
						in = false;
					}
					if ( in && ((_col == 3) || (_col == speeder[i].shield())) ) {
						if ( level != 6 ) {
							speeder[i].speed_up();
							if ( _col == 3 ) {
								speeder[i].speed_up();
							}
						}
					} else {
						if ( level != 6 ) {
							speeder[i].speed_down();
						} else {
							speeder[i].speed_down(5);
						}
					}

					if ( i == 0 ) {
						// スピード変更
						if ( (level < 2) || (level == 7) ) {
							if ( speeder[1].out() ) {
								if ( (speeder[1].dsp_y() <= -48) && (shield_wait[0] > 0) ) {
									speeder[1].speed_down();
								} else {
									speeder[1].speed_up();
								}
							}
							if ( speeder[2].out() ) {
								if ( (speeder[2].dsp_y() <= -48) && (shield_wait[1] > 0) ) {
									speeder[2].speed_down();
								} else {
									speeder[2].speed_up();
								}
							}
						}

						// ラップタイム計測
						if ( _border ) {
							_elapse_l = _elapse;
							lap = 9 - _count;
							time[lap] = time[0];
							if ( lap == 1 ) {
								lap_time = time[lap] - best_time[index_b()][lap];
							} else {
								lap_time = (time[lap] - time[lap - 1]) - best_time[index_b()][lap];
							}
							dsp_lap = true;
							if ( lap == 9 ) {
								finish = true;
							}
						}
					}
				}
				if ( (level >= 2) && (level <= 6) ) break;
			}

			if ( _y >= 320 ) {
				return false;
			}
			return true;
		}
	}

	/**
	 * スピーダー
	 */
	class Speeder {
		boolean _jiki;	// 自機かどうか
		int _type;		// 種類
		int _auto;		// 自動移動の種類
		int _distance;	// 走行距離
		int _speed;		// スピード
		int _x, off_x;	// 位置
		boolean _out;	// 画面外かどうか
		int _direction;	// 移動の状態
		int _shield;	// シールドの状態

		/**
		 * コンストラクタ
		 */
		Speeder() {
		}

		/**
		 * 初期化
		 */
		public void init(boolean jiki, int type, int speed, int x) {
			_jiki      = jiki;
			_type      = type;
			_auto      = AUTO_INERTIA;
			_distance  = 0;
			_speed     = speed;
			_x         = x - 12;
			_out       = false;
			_direction = 0;
			_shield    = 0;
		}

		/**
		 * 左移動
		 */
		public void left() {
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

		/**
		 * 右移動
		 */
		public void right() {
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

		/**
		 * 慣性移動
		 */
		public void inertia(boolean neutral) {
			if ( neutral ) {
				if ( _direction > 0 ) {
					_direction--;
				} else if ( _direction < 0 ) {
					_direction++;
				}
			}
			_x += _direction;
		}

		/**
		 *
		 */
		public void set_direction(int target) {
			if ( _direction < target ) {
				right();
			} else if ( _direction > target ) {
				left();
			}
		}

		public void slide(int val) { _x += val; }

		public void out(int bar_x) {
			off_x = _x - bar_x;
			_out = true;
		}
		public void in(int bar_x) {
			if      ( off_x <   0 ) off_x =   0;
			else if ( off_x > 176 ) off_x = 176;
			_x = bar_x + off_x;
			_out = false;
			if ( !_jiki ) {
				_direction = (stage.move_x() * 15) / 24;
			}
		}
		public boolean out() { return _out; }

		public int type() { return _type; }

		// 自動移動の種類を変更
		public void auto(int type) { _auto = type; }

		// 自動移動の種類を確認
		public int auto() { return _auto; }

		// 走行距離を変更
		public void add_distance(int val) { _distance += val; }

		// 走行距離を確認
		public int distance() { return _distance; }

		/**
		 * スピードを上げる
		 */
		public void speed_up(int val) {
			_speed += val;
			if ( _speed > 505 ) _speed = 495;
		}
		public void speed_up() {
			switch ( _type ) {
			case SPEEDER1:
			case SPEEDER4:
			case SPEEDER5:
				speed_up(5);
				break;
			case SPEEDER2:
				speed_up(4);
				break;
			case SPEEDER3:
				speed_up(3);
				break;
			}
		}

		/**
		 * スピードを落とす
		 */
		public void speed_down(int val) {
			_speed -= val;
			if ( _speed < 0 ) _speed = 0;
		}
		public void speed_down() {
			switch ( _type ) {
			case SPEEDER1:
			case SPEEDER4:
			case SPEEDER5:
				speed_down(25);
				break;
			case SPEEDER2:
				speed_down(20);
				break;
			case SPEEDER3:
				speed_down(25);
				break;
			}
		}

		/**
		 * スピードを制限する
		 */
		public void speed_limit(int val) {
			if ( _speed > val ) _speed = val;
		}

		// スピードを確認
		public int speed() { return _speed; }

		// シールドの状態を変更
		public void shield(int col) {
			_shield = col;
			if ( _jiki && (_elapse_s > 0) && (_shield == stage.col()) ) {
				if ( _elapse_s <= 20 ) {
					shield_lag[shield_index] = (shield_lag[shield_index] + _elapse_s) / 2;
					shield_index++; if ( shield_index > 1 ) shield_index = 0;
				}
				_elapse_s = 0;
			}
		}

		// シールドの状態を確認
		public int shield() { return _shield; }

		// 位置を確認
		public int x() { return _x; }
		public int dsp_x() { return _jiki ? 108 : (108 + (_x - speeder[0].x())); }
		public int dsp_y() { return _jiki ? 192 : (192 - (_distance - speeder[0].distance()) / 10); }

		// 移動の状態を確認
		public int direction() { return _direction; }

		/**
		 * 描画
		 */
		public void draw(boolean ready) {
			int x = dsp_x();
			int y = dsp_y();
			if ( y <= -48 ) {
				return;
			}
			if ( _jiki && ((_elapse - _elapse_b) < WAIT_BOOST) ) {
				for ( int i = 1; i < 10; i++ ) {
					drawImage(g, use_image(IMAGE_SHIELD), x - _direction * i / 10, y + _speed * i / 50, 24 * _shield, 0, 24, 24);
				}
			} else if ( !ready && ((elapse() % 2) == 0) ) {
				drawImage(g, use_image(IMAGE_SHIELD), x -  _direction     , y + (_speed / 10), 24 * _shield, 96, 24, 48);
				drawImage(g, use_image(IMAGE_SHIELD), x - (_direction / 2), y + (_speed / 20), 24 * _shield, 48, 24, 48);
			}
			drawImage(g, use_image(IMAGE_SHIELD), x, y, 24 * _shield, 0, 24, 48);
			if ( _direction < 0 ) {
#ifdef _505i
				int d = ((0 - _direction) + 1) / 2;
#endif // _505i
#ifdef _900i
				int d = 0 - _direction;
#endif // _900i
				switch ( _type ) {
				case SPEEDER1:
					drawImage(g, use_image(IMAGE_SPEEDER1),
						x + 12 - (SPEEDER1_W[d] / 2), y + 3,
						SPEEDER1_X_M[d], 43,
						SPEEDER1_W[d], 43
						);
					break;
				case SPEEDER2:
				case SPEEDER4:
					drawImage(g, use_image(IMAGE_SPEEDER2),
						x + 12 - (SPEEDER2_W[d] / 2), y + 3,
						SPEEDER2_X_M[d], 41,
						SPEEDER2_W[d], 41
						);
					break;
				case SPEEDER3:
				case SPEEDER5:
					drawImage(g, use_image(IMAGE_SPEEDER3),
						x + 12 - (SPEEDER3_W[d] / 2), y + 3,
						SPEEDER3_X_M[d], 43,
						SPEEDER3_W[d], 43
						);
					break;
				}
			} else {
#ifdef _505i
				int d = (_direction + 1) / 2;
#endif // _505i
#ifdef _900i
				int d = _direction;
#endif // _900i
				switch ( _type ) {
				case SPEEDER1:
					drawImage(g, use_image(IMAGE_SPEEDER1),
						x + 12 - (SPEEDER1_W[d] / 2), y + 3,
						SPEEDER1_X[d], 0,
						SPEEDER1_W[d], 43
						);
					break;
				case SPEEDER2:
				case SPEEDER4:
					drawImage(g, use_image(IMAGE_SPEEDER2),
						x + 12 - (SPEEDER2_W[d] / 2), y + 3,
						SPEEDER2_X[d], 0,
						SPEEDER2_W[d], 41
						);
					break;
				case SPEEDER3:
				case SPEEDER5:
					drawImage(g, use_image(IMAGE_SPEEDER3),
						x + 12 - (SPEEDER3_W[d] / 2), y + 3,
						SPEEDER3_X[d], 0,
						SPEEDER3_W[d], 43
						);
					break;
				}
			}
		}
	}
}
