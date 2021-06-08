/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <UIKit/UIKit.h>

#import "_Canvas.h"

#import "_Layout.h"
#import "_Main.h"

@implementation _Canvas

- (id)initWithMain:(_Main*)m
{
	CGRect frame;
	if( [m _fullScreen] )
	{
		frame = [[UIScreen mainScreen] bounds];
	}
	else
	{
		frame = [[UIScreen mainScreen] applicationFrame];
	}
	self = [super initWithFrame:frame];
	if( self != nil )
	{
		_apply_scale = NO;

		_timer = nil;

		_frame_width  = frame.size.width;
		_frame_height = frame.size.height;

		// レイアウト
		_layout = nil;

		// タッチイベント用
		self.multipleTouchEnabled = ([self _touchNum] > 1);
#ifdef NO_OBJC_ARC
		_touch = [[NSMutableArray array] retain];
#else
		_touch = [NSMutableArray array];
#endif // NO_OBJC_ARC

		_init_f = NO;
		_hide_f = NO;
	}
	return self;
}

- (void)dealloc
{
#ifdef NO_OBJC_ARC
	if( _timer != nil )
	{
		[_timer release];
	}
#endif // NO_OBJC_ARC

	if( _init_f )
	{
		[self _end];

#ifdef NO_OBJC_ARC
		[_view release];
#endif // NO_OBJC_ARC

#ifdef NO_OBJC_ARC
		[_g release];
#endif // NO_OBJC_ARC
	}

#ifdef NO_OBJC_ARC
	[_touch release];
#endif // NO_OBJC_ARC

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (void)_setApplyScale:(BOOL)flag
{
	if( flag != _apply_scale )
	{
		_apply_scale_f = YES;
	}
}

- (void)_setApplyScale
{
	if( _apply_scale_f )
	{
		_apply_scale = !_apply_scale;

		[_m _setApplyScale:_apply_scale];

		if( _init_f )
		{
			[_g _setScale:(_apply_scale ? [UIScreen mainScreen].scale : 1.0f)];
		}

		_apply_scale_f = NO;
	}
}

- (BOOL)_applyScaleFlag
{
	return _apply_scale_f;
}

- (BOOL)_applyScale
{
	return _apply_scale;
}

- (BOOL)_initFlag
{
	return _init_f;
}

- (BOOL)_hideFlag
{
	return _hide_f;
}

- (void)_setHide:(BOOL)flag
{
	if( flag )
	{
		[self _suspend];
		[self _hide];
	}
	else
	{
		[self _show];
		[self _resume];
	}
	_hide_f = flag;
}

- (void)_setTimer:(_Main*)m
{
	_m = m;

	if( !_init_f )
	{
		int width  = [_m getWidth ];
		int height = [_m getHeight];
		_size.width  = width;
		_size.height = height;

		_view = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, width, height )];
		[self addSubview:_view];

		_g = [[_Graphics alloc] init];
		[_g _setCanvas:self];
		if( _apply_scale )
		{
			[_g _setScale:[UIScreen mainScreen].scale];
		}

		[self _init];

		_init_f = YES;
	}

	if( _timer == nil )
	{
#ifdef NO_OBJC_ARC
		_timer = [[NSTimer
#else
		_timer = [NSTimer
#endif // NO_OBJC_ARC
			scheduledTimerWithTimeInterval:((float)[self _frameTime] / 1000.0f)
			target:self
			selector:@selector(_onTimer:)
			userInfo:nil
			repeats:YES
#ifdef NO_OBJC_ARC
			] retain];
#else
			];
#endif // NO_OBJC_ARC
	}
}

- (void)_killTimer
{
	if( _timer != nil )
	{
#ifdef NO_OBJC_ARC
		[_timer release];
#endif // NO_OBJC_ARC
		_timer = nil;
	}
}

- (void)_prePaint
{
	[self _setApplyScale];
}

- (void)_lock
{
	if( _apply_scale && (UIGraphicsBeginImageContextWithOptions != NULL) )
	{
		UIGraphicsBeginImageContextWithOptions( _size, NO, [UIScreen mainScreen].scale );
	}
	else
	{
		UIGraphicsBeginImageContext( _size );
	}
}

- (void)_unlock
{
	[_view setImage:UIGraphicsGetImageFromCurrentImageContext()];
	UIGraphicsEndImageContext();
}

- (void)_onTimer:(NSTimer*)timer
{
	if( [_m _isActive] )
	{
		[self _prePaint];

		[self _paint:_g];
	}
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	int i, j;
	NSArray* objects = [touches allObjects];
	int count = [objects count];
	for( i = 0; i < count; i++ )
	{
		if( [_touch count] < [self _touchNum] )
		{
			[_touch addObject:[objects objectAtIndex:i]];
			j = [_touch count] - 1;
			if( ![self _setLayoutEvent:LAYOUT_DOWN_EVENT :j] )
			{
				[self _processEvent:TOUCH_DOWN_EVENT :j];
			}
		}
	}
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	int i, j;
	NSArray* objects = [touches allObjects];
	int count = [objects count];
	NSObject* object;
	for( i = 0; i < count; i++ )
	{
		object = [objects objectAtIndex:i];
		for( j = [_touch count] - 1; j >= 0; j-- )
		{
			if( [object isEqual:[_touch objectAtIndex:j]] )
			{
				[self _processEvent:TOUCH_MOVE_EVENT :j];
			}
		}
	}
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	int i, j;
	NSArray* objects = [touches allObjects];
	int count = [objects count];
	NSObject* object;
	for( i = 0; i < count; i++ )
	{
		object = [objects objectAtIndex:i];
		for( j = [_touch count] - 1; j >= 0; j-- )
		{
			if( [object isEqual:[_touch objectAtIndex:j]] )
			{
				if( ![self _setLayoutEvent:LAYOUT_UP_EVENT :j] )
				{
					[self _processEvent:TOUCH_UP_EVENT :j];
				}
			}
		}
		for( j = [_touch count] - 1; j >= 0; j-- )
		{
			if( [object isEqual:[_touch objectAtIndex:j]] )
			{
				[_touch removeObjectAtIndex:j];
			}
		}
	}
}
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self touchesEnded:touches withEvent:event];
}

- (_Main*)getMain
{
	return _m;
}

- (int)_getFrameWidth
{
	return _frame_width;
}
- (int)_getFrameHeight
{
	return _frame_height;
}

- (int)getWidth
{
	return [_m getWidth];
}
- (int)getHeight
{
	return [_m getHeight];
}

- (_Graphics*)getGraphics
{
	return _g;
}

- (void)clearTouch
{
	[_touch removeAllObjects];
}

- (int)getTouchNum
{
	return [_touch count];
}
- (int)getTouchX:(int)index
{
	CGPoint pos = [[_touch objectAtIndex:index] locationInView:self];
	return (int)(pos.x);
}
- (int)getTouchY:(int)index
{
	CGPoint pos = [[_touch objectAtIndex:index] locationInView:self];
	return (int)(pos.y);
}

- (void)setWindow:(int)left :(int)top :(int)right :(int)bottom :(int)width :(int)height
{
	_win_left   = left;
	_win_top    = top;
	_win_right  = right;
	_win_bottom = bottom;
	_win_width  = width;
	_win_height = height;
}
- (void)setWindow:(int)width :(int)height
{
	int ww = [_m getWidth ];
	int hh = [_m getHeight];
	int w, h;
	if( (float)hh / (float)height < (float)ww / (float)width )
	{
		h = hh;
		w = (width * h) / height;
	}
	else
	{
		w = ww;
		h = (height * w) / width;
	}
	_win_left   = (ww - w) / 2;
	_win_top    = (hh - h) / 2;
	_win_right  = _win_left + w;
	_win_bottom = _win_top  + h;
	_win_width  = width;
	_win_height = height;
}
- (int)getWindowLeft
{
	return _win_left;
}
- (int)getWindowTop
{
	return _win_top;
}
- (int)getWindowRight
{
	return _win_right;
}
- (int)getWindowBottom
{
	return _win_bottom;
}

- (int)windowX:(int)x
{
	return (x - _win_left) * _win_width / (_win_right - _win_left);
}
- (int)windowY:(int)y
{
	return (y - _win_top) * _win_height / (_win_bottom - _win_top);
}

- (int)screenX:(int)x
{
	return _win_left + x * (_win_right - _win_left) / _win_width;
}
- (int)screenY:(int)y
{
	return _win_top + y * (_win_bottom - _win_top) / _win_height;
}
- (int)screenWidth:(int)width
{
	return width * (_win_right - _win_left) / _win_width;
}
- (int)screenHeight:(int)height
{
	return height * (_win_bottom - _win_top) / _win_height;
}

- (void)setLayout:(_Layout*)layout
{
	_layout = layout;
}
- (BOOL)_setLayoutEvent:(int)type :(int)index
{
	if( _layout != nil )
	{
		int param = -1;
		if( [_layout _isWindow] )
		{
			param = [_layout _check:[self windowX:[self getTouchX:index]] :[self windowY:[self getTouchY:index]]];
		}
		else
		{
			param = [_layout _check:[self getTouchX:index] :[self getTouchY:index]];
		}
		if( param >= 0 )
		{
			[self _processEvent:type :param];
			return YES;
		}
	}
	return NO;
}
- (int)getLayoutState
{
	int ret = 0;
	if( _layout != nil )
	{
		for( int i = [self getTouchNum] - 1; i >= 0; i-- )
		{
			int id = -1;
			if( [_layout _isWindow] )
			{
				id = [_layout _check:[self windowX:[self getTouchX:i]] :[self windowY:[self getTouchY:i]]];
			}
			else
			{
				id = [_layout _check:[self getTouchX:i] :[self getTouchY:i]];
			}
			if( id >= 0 )
			{
				ret |= (1 << id);
			}
		}
	}
	return ret;
}

- (void)drawLayout:(_Graphics*)g
{
	if( _layout != nil )
	{
		[_layout _draw:self :g];
	}
}

- (void)addView:(UIView*)view :(int)tag
{
	view.tag = tag;
	[self addSubview:view];
#ifdef NO_OBJC_ARC
	[view release];
#endif // NO_OBJC_ARC
}
- (void)removeView:(int)tag
{
	for( UIView* subview in self.subviews )
	{
		if( subview.tag == tag )
		{
			[subview removeFromSuperview];
			break;
		}
	}
}

- (int)_frameTime { return 16/*1000 / 60*/; }
- (int)_touchNum { return 2; }

- (void)_init {}
- (void)_end {}
- (void)_paint:(_Graphics*)g {}
- (void)_suspend {}
- (void)_resume {}
- (void)_hide {}
- (void)_show {}
- (void)_processEvent:(int)type :(int)param {}

- (void)_onOrientationChange:(UIInterfaceOrientation)orientation {}

- (void)_gameCenterAuthOK {}
- (void)_gameCenterAuthNG {}
- (void)_gameCenterReportAchievementOK:(NSString*)identifier :(float)percent {}
- (void)_gameCenterReportAchievementNG:(NSString*)identifier :(float)percent {}
- (void)_gameCenterCloseAchievementView {}
- (void)_gameCenterReportScoreOK:(NSString*)category :(int64_t)score {}
- (void)_gameCenterReportScoreNG:(NSString*)category :(int64_t)score {}
- (void)_gameCenterCloseLeaderboardView {}

- (void)_onGeolocation:(int)code {}

- (void)_onHttpResponse:(NSData*)data {}
- (void)_onHttpError:(int)status {}

- (void)_inAppPurchaseInvalid:(NSString*)identifier {}
- (void)_inAppPurchasePurchaseOK:(NSString*)identifier :(NSData*)receipt {}
- (void)_inAppPurchasePurchaseNG:(NSString*)identifier {}
- (void)_inAppPurchaseRestoreOK:(NSString*)identifier {}
- (void)_inAppPurchaseRestoreNG {}
- (void)_inAppPurchaseRestoreCompleted {}
- (void)_inAppPurchaseCancelled:(NSString*)identifier {}

- (void)_musicComplete:(id)music {}

- (void)_twitterAuthOK {}
- (void)_twitterAuthNG {}
- (void)_twitterTweetOK {}
- (void)_twitterTweetNG:(int)status {}
- (void)_twitterCloseTweetComposeView {}

- (BOOL)_onWebViewShouldStartLoad:(NSString*)url :(NSString*)mainUrl { return NO; }
- (void)_onWebViewStartLoad:(NSString*)url :(NSString*)mainUrl {}
- (void)_onWebViewFinishLoad:(id)webView {}
- (void)_onWebViewLoadError:(NSError*)error :(id)webView {}

@end
