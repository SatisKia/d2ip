#import "MyCanvas.h"

#import "_Geolocation.h"

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }

- (void)_init
{
	_Graphics* g = [self getGraphics];
	[g setFontSize:20];

	geolocation = [[_Geolocation alloc] initWithMain:[self getMain]];
	[geolocation setEnableHighAccuracy:YES];

	code = -2;
	elapse = 0;

	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
}

#ifdef NO_OBJC_ARC
- (void)_end
{
	[geolocation release];

	[formatter release];
}
#endif // NO_OBJC_ARC

- (void)_suspend
{
//	[geolocation stop];
//	code = -2;
}

- (void)_resume
{
	elapse = 0;
}

- (void)_onGeolocation:(int)_code
{
	[geolocation stop];
	code = _code;
}

- (void)_paint:(_Graphics*)g
{
	if( code == -1 )
	{
		elapse++;
		if( elapse >= 30 * 30 )
		{
			[geolocation timeout];
		}
	}

	[g lock];

	[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
	[g fillRect:0 :0 :[self getWidth] :[self getHeight]];

	[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
	NSString* tmp;
	switch( code )
	{
	case GEOLOCATION_ERROR               : tmp = [NSString stringWithString:@"(ERROR)"]               ; break;
	case GEOLOCATION_PERMISSION_DENIED   : tmp = [NSString stringWithString:@"(PERMISSION_DENIED)"]   ; break;
	case GEOLOCATION_POSITION_UNAVAILABLE: tmp = [NSString stringWithString:@"(POSITION_UNAVAILABLE)"]; break;
	case GEOLOCATION_TIMEOUT             : tmp = [NSString stringWithString:@"(TIMEOUT)"]             ; break;
	case GEOLOCATION_SUCCESS             : tmp = [NSString stringWithString:@"(SUCCESS)"]             ; break;
	default                              : tmp = [NSString stringWithString:@""]                      ; break;
	}
	[g drawString:[NSString stringWithFormat:@"code : %d%@", code, tmp] :0 :24];
	[g drawString:[NSString stringWithFormat:@"time : %f", (double)elapse / 30.0] :0 :48];
	[g drawString:[NSString stringWithFormat:@"緯度 : %f", [geolocation latitude]] :0 :72];
	[g drawString:[NSString stringWithFormat:@"経度 : %f", [geolocation longitude]] :0 :96];
	[g drawString:[NSString stringWithFormat:@"緯度/経度の精度 : %f", [geolocation accuracy]] :0 :120];
	[g drawString:[NSString stringWithFormat:@"高度 : %f", [geolocation altitude]] :0 :144];
	[g drawString:[NSString stringWithFormat:@"高度の精度 : %f", [geolocation altitudeAccuracy]] :0 :168];
	[g drawString:[NSString stringWithFormat:@"方角 : %f", [geolocation heading]] :0 :192];
	[g drawString:[NSString stringWithFormat:@"速度 : %f", [geolocation speed]] :0 :216];
	[g drawString:@"timestamp :" :0 :240];
	[g drawString:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[geolocation timestamp]]] :0 :264];

	[g unlock];
}

- (void)_processEvent:(int)type :(int)param
{
	if( type == TOUCH_UP_EVENT )
	{
		// 認証リクエスト
		[geolocation request:GEOLOCATION_REQUEST_WHENINUSE];

		if( code != -1 )
		{
			code = -1;
			elapse = 0;
			[geolocation start];
		}
	}
}

@end
