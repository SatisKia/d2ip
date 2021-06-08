#import "MyCanvas.h"

#import "_EventStep.h"

@interface MyTouchStep : _EventStep
{
}
@end

@implementation MyTouchStep

- (id)init
{
	self = [super init];
	if( self != nil )
	{
		[self start:TOUCH_DOWN_EVENT :TOUCH_UP_EVENT];
	}
	return self;
}

- (BOOL)_checkParam:(int)param
{
	return YES;
}

- (int)_checkTime { return 200/*1000 / 5*/; }

@end

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }
- (int)_touchNum { return 4; }

- (void)_init
{
	_Graphics* g = [self getGraphics];
	[g setFontSize:20];

	touch_down   = -1;
	touch_down_f = NO;
	touch_move   = -1;
	touch_move_f = NO;
	touch_up     = -1;
	touch_up_f   = NO;

	touchStep = [[MyTouchStep alloc] init];
}

#ifdef NO_OBJC_ARC
- (void)dealloc
{
	[touchStep release];

	[super dealloc];
}
#endif // NO_OBJC_ARC

- (void)_paint:(_Graphics*)g
{
	[g lock];

	[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
	[g fillRect:0 :0 :[self getWidth] :[self getHeight]];

	[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
	[g drawString:@"TOUCH_EVENT" :0 :24];
	if( touch_down >= 0 )
	{
		if( touch_down_f )
		{
			[g setColor:[_Graphics getColorOfRGB:255 :0 :255]];
		}
		else
		{
			[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
		}
		[g drawString:[NSString stringWithFormat:@"TOUCH_DOWN_EVENT %d", touch_down] :0 :48];
	}
	if( touch_move >= 0 )
	{
		if( touch_move_f )
		{
			[g setColor:[_Graphics getColorOfRGB:255 :0 :255]];
		}
		else
		{
			[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
		}
		[g drawString:[NSString stringWithFormat:@"TOUCH_MOVE_EVENT %d", touch_move] :0 :72];
	}
	if( touch_up >= 0 )
	{
		if( touch_up_f )
		{
			[g setColor:[_Graphics getColorOfRGB:255 :0 :255]];
		}
		else
		{
			[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
		}
		[g drawString:[NSString stringWithFormat:@"TOUCH_UP_EVENT %d", touch_up] :0 :96];
	}
	touch_down_f = NO;
	touch_move_f = NO;
	touch_up_f   = NO;
	[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
	for( int i = 0; i < [self getTouchNum]; i++ )
	{
		[g drawString:[NSString stringWithFormat:@"x : %d", [self getTouchX:i]] :i * 80 :120];
		[g drawString:[NSString stringWithFormat:@"y : %d", [self getTouchY:i]] :i * 80 :144];
	}

	[g drawLine:0 :150 :[self getWidth] :150];

	[g drawString:@"_EventStep TEST" :0 :174];
	[g drawString:[NSString stringWithFormat:@"touch step : %d", [touchStep step]] :0 :198];
	if( [touchStep isTimeout] )
	{
		[g drawString:@"TIMEOUT" :0 :222];
	}

	[g unlock];
}

- (void)_processEvent:(int)type :(int)param
{
	[touchStep handleEvent:type :param];

	switch( type )
	{
	case TOUCH_DOWN_EVENT:
		touch_down = param;
		touch_down_f = YES;
		break;
	case TOUCH_MOVE_EVENT:
		touch_move = param;
		touch_move_f = YES;
		break;
	case TOUCH_UP_EVENT:
		touch_up = param;
		touch_up_f = YES;
		break;
	}
}

@end
