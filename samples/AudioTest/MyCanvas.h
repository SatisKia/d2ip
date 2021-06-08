#import <Foundation/Foundation.h>

#import "_Canvas.h"

@class _Layout;
@class _Music;
@class _Sound;

@interface MyCanvas : _Canvas
{
	_Graphics* g;

	int COLOR_BASE_LIGHT;
	int COLOR_BASE_FACE;
	int COLOR_BASE_SHADOW;
	int COLOR_BUTTON_LIGHT;
	int COLOR_BUTTON_FACE;
	int COLOR_BUTTON_SHADOW;
	int COLOR_BUTTON_DSHADOW;
	int COLOR_BUTTON_TEXT;
	int COLOR_G;
	int COLOR_K;
	int COLOR_W;

	NSString* name[4];

	_Music* music1;
	_Sound* sound1;
	_Sound* sound2;
	_Sound* sound3;
	BOOL audio_stop[4];
	BOOL audio_loop[4];

	_Layout* layout;
}
@end
