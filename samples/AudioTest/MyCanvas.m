#import "MyCanvas.h"

#import "_Layout.h"
#import "_Main.h"
#import "_Music.h"
#import "_Sound.h"

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }

- (void)_init
{
	g = [self getGraphics];
	[g setStrokeWidth:2.0f];

	COLOR_BASE_LIGHT     = [_Graphics getColorOfRGB:100 :100 :110];
	COLOR_BASE_FACE      = [_Graphics getColorOfRGB: 60 : 60 : 90];
	COLOR_BASE_SHADOW    = [_Graphics getColorOfRGB: 20 : 20 : 30];
	COLOR_BUTTON_LIGHT   = [_Graphics getColorOfRGB:240 :255 :255];
	COLOR_BUTTON_FACE    = [_Graphics getColorOfRGB:190 :200 :210];
	COLOR_BUTTON_SHADOW  = [_Graphics getColorOfRGB:120 :130 :150];
	COLOR_BUTTON_DSHADOW = [_Graphics getColorOfRGB: 90 :100 :120];
	COLOR_BUTTON_TEXT    = [_Graphics getColorOfRGB: 50 : 60 : 80];
	COLOR_G              = [_Graphics getColorOfRGB:  0 :230 :  0];
	COLOR_K              = [_Graphics getColorOfRGB:  0 :  0 :  0];
	COLOR_W              = [_Graphics getColorOfRGB:255 :255 :255];

	name[0] = @"bgm_clear.mp3";
	name[1] = @"cursor07.mp3";
	name[2] = @"gun30.mp3";
	name[3] = @"shoot08.mp3";

	music1 = [[_Music alloc] initWithMain:[self getMain]];
	sound1 = [[_Sound alloc] init];
	[sound1 load:[[self getMain] resourceURL:name[1]]];
	sound2 = [[_Sound alloc] init];
	[sound2 load:[[self getMain] resourceURL:name[2]]];
	sound3 = [[_Sound alloc] init];
	[sound3 load:[[self getMain] resourceURL:name[3]]];

	layout = [[_Layout alloc] init];
	for( int i = 0; i < 4; i++ )
	{
		audio_stop[i] = NO;
		audio_loop[i] = NO;

		[layout add: 10 :45 + 80 * i :60 :25 :    10 * i];
		[layout add: 80 :45 + 80 * i :60 :25 :1 + 10 * i];
		[layout add:250 :13 + 80 * i :60 :24 :2 + 10 * i];
	}
	[self setLayout:layout];
}

#ifdef NO_OBJC_ARC
- (void)_end
{
	[music1 release];
	[sound1 release];
	[sound2 release];
	[sound3 release];

	[layout release];
}
#endif // NO_OBJC_ARC

- (void)drawTitleWindow:(int)x :(int)y :(int)w :(int)h :(NSString*)str
{
	[g setColor:COLOR_BASE_SHADOW];
	[g fillRect:x :y :w :h];
	[g setColor:COLOR_BASE_LIGHT];
	[g fillRect:x + 1 :y + 1 :w - 1 :h - 1];
	[g setColor:COLOR_K];
	[g fillRect:x + 1 :y + 1 :w - 2 :h - 2];
	[g setColor:COLOR_G];
	[g drawString:str :x + 10 :(y + h / 2) + ([g fontHeight] / 2)];
}

- (void)drawButton:(int)x :(int)y :(int)w :(int)h :(NSString*)str :(BOOL)down
{
	if( down )
	{
		[g setColor:COLOR_BUTTON_SHADOW];
		[g fillRect:x :y :w :h];
		[g setColor:COLOR_BUTTON_FACE];
		[g fillRect:x + 2 :y + 2 :w - 2 :h - 2];
		[g setColor:COLOR_BUTTON_DSHADOW];
		[g fillRect:x :y :w - 2 :h - 2];
		[g setColor:COLOR_BUTTON_SHADOW];
		[g fillRect:x + 2 :y + 2 :w - 4 :h - 4];
	}
	else
	{
		[g setColor:COLOR_BUTTON_FACE];
		[g fillRect:x :y :w :h];
		[g setColor:COLOR_BUTTON_SHADOW];
		[g fillRect:x + 2 :y + 2 :w - 2 :h - 2];
		[g setColor:COLOR_BUTTON_LIGHT];
		[g fillRect:x :y :w - 2 :h - 2];
		[g setColor:COLOR_BUTTON_FACE];
		[g fillRect:x + 2 :y + 2 :w - 4 :h - 4];
	}
	[g setColor:COLOR_BUTTON_TEXT];
	[g drawString:str
		:(x + w / 2) - ([g stringWidth:str] / 2)
		:(y + h / 2) + ([g fontHeight] / 2)
		];
}

- (void)_paint:(_Graphics*)_g
{
	int i;

	[g lock];

	[g setColor:COLOR_BASE_FACE];
	[g fillRect:0 :0 :320 :320];
	[g setColor:COLOR_BASE_SHADOW];
	[g fillRect:3 :3 :320 - 3 :320 - 3];
	[g setColor:COLOR_BASE_LIGHT];
	[g fillRect:0 :0 :320 - 3 :320 - 3];
	[g setColor:COLOR_BASE_FACE];
	[g fillRect:3 :3 :320 - 6 :320 - 6];

	[g setColor:COLOR_BASE_SHADOW];
	[g drawLine:0 : 78 :319 : 78];
	[g drawLine:0 :158 :319 :158];
	[g drawLine:0 :238 :319 :238];
	[g setColor:COLOR_BASE_LIGHT];
	[g drawLine:0 : 80 :319 : 80];
	[g drawLine:0 :160 :319 :160];
	[g drawLine:0 :240 :319 :240];

	[g setFontSize:16];
	for( i = 0; i < 4; i++ )
	{
		[self drawTitleWindow:10 :12 + 80 * i :320 - 90 :25 :name[i]];
	}

	[g setFontSize:20];
	BOOL playing;
	for( i = 0; i < 4; i++ )
	{
		switch( i )
		{
		case 0: playing = [music1 isPlaying]; break;
		case 1: playing = [sound1 isPlaying]; break;
		case 2: playing = [sound2 isPlaying]; break;
		case 3: playing = [sound3 isPlaying]; break;
		}
		[self drawButton:[layout getLeft:10 * i]
			:[layout getTop:10 * i]
			:[layout getWidth:10 * i]
			:[layout getHeight:10 * i]
			:@"Play"
			:playing
			];
		[self drawButton:[layout getLeft:1 + 10 * i]
			:[layout getTop:1 + 10 * i]
			:[layout getWidth:1 + 10 * i]
			:[layout getHeight:1 + 10 * i]
			:@"Stop"
			:audio_stop[i]
			];
		audio_stop[i] = NO;
	}

	[g setFontSize:16];
	for( i = 0; i < 4; i++ )
	{
		[self drawButton:[layout getLeft:2 + 10 * i]
			:[layout getTop:2 + 10 * i]
			:[layout getWidth:2 + 10 * i]
			:[layout getHeight:2 + 10 * i]
			:@"LOOP"
			:audio_loop[i]
			];
	}

	NSString* tmp;
	tmp = [NSString stringWithFormat:@"%d/%d", [music1 getCurrentTime], [music1 getTotalTime]];
	[g setFontSize:20];
	[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
	[g drawString:tmp :[self getWidth] - 10 - [g stringWidth:tmp] :80 - 10];

	[g unlock];
}

- (void)_processEvent:(int)type :(int)param
{
	if( type == LAYOUT_DOWN_EVENT )
	{
		switch( param % 10 )
		{
		case 0:
			switch( param / 10 )
			{
			case 0: [music1 play:[[self getMain] resourceURL:name[0]] :0 :audio_loop[0]]; break;
			case 1: [sound1 play:audio_loop[1]]; break;
			case 2: [sound2 play:audio_loop[2]]; break;
			case 3: [sound3 play:audio_loop[3]]; break;
			}
			break;
		case 1:
			switch( param / 10 )
			{
			case 0: [music1 stop]; break;
			case 1: [sound1 stop]; break;
			case 2: [sound2 stop]; break;
			case 3: [sound3 stop]; break;
			}
			audio_stop[param / 10] = YES;
			break;
		case 2:
			switch( param / 10 )
			{
			case 0: [music1 stop]; break;
			case 1: [sound1 stop]; break;
			case 2: [sound2 stop]; break;
			case 3: [sound3 stop]; break;
			}
			audio_loop[param / 10] = !audio_loop[param / 10];
			break;
		}
	}
}

@end
