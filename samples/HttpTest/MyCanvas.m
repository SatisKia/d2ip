#import "MyCanvas.h"

#import "_HttpRequest.h"
#import "_String.h"

@implementation MyCanvas

- (int)_frameTime { return 100/*1000 / 10*/; }

- (void)_init
{
	_Graphics* g = [self getGraphics];
	[g setFontSize:20];

	http = [[_HttpRequest alloc] initWithMain:[self getMain]];

	server = @"http://aaa/";

	str1 = [[NSMutableString alloc] initWithString:@""];
	str2 = [[NSMutableString alloc] initWithString:@""];

	step = 0;
	elapse = 0;
}

#ifdef NO_OBJC_ARC
- (void)_end
{
	[http release];

	[str1 release];
	[str2 release];
}
#endif // NO_OBJC_ARC

- (void)_paint:(_Graphics*)g
{
	elapse++;

	[g lock];

	[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
	[g fillRect:0 :0 :[self getWidth] :[self getHeight]];

	[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];

	if( [http busy] )
	{
		switch( elapse % 3 )
		{
		case 0: [g drawString:@"通信中."   :0 :24]; break;
		case 1: [g drawString:@"通信中.."  :0 :24]; break;
		case 2: [g drawString:@"通信中..." :0 :24]; break;
		}
	}
	else
	{
		[g drawString:@"タッチしてください" :0 :24];
	}

	[g drawString:@"通信URL" :0 :72];
	[g drawString:server :0 :96];
	[g drawString:str1 :0 :120];

	[g drawString:@"レスポンス" :0 :168];
	[g drawString:str2 :0 :192];

	[g unlock];
}

- (void)_processEvent:(int)type :(int)param
{
	if( [http busy] )
	{
		return;
	}

	_String* tmp = [[_String alloc] init];

	if( type == TOUCH_DOWN_EVENT )
	{
		switch( step )
		{
		case 0:
			[str1 setString:@"test1.php?user=guest"];
			[http get:[[[tmp set:server] add:str1] str]];
			step = 1;
			break;
		case 1:
			[str1 setString:@"test2.php"];
			{
				_String* post_str = [[_String alloc] init];
				[post_str set:@"user=guest"];
				NSData* post_data = [post_str allocData:NSShiftJISStringEncoding];
				[http post:[[[tmp set:server] add:str1] str] :post_data :nil];
#ifdef NO_OBJC_ARC
				[post_data release];
				[post_str release];
#endif // NO_OBJC_ARC
			}
			step = 2;
			break;
		case 2:
			[str1 setString:@"test3.php?user=guest"];
			[http get:[[[tmp set:server] add:str1] str]];
			step = 3;
			break;
		case 3:
			[str1 setString:@"test4.php"];
			{
				_String* post_str = [[_String alloc] init];
				[post_str set:@"user=guest"];
				NSData* post_data = [post_str allocData:NSShiftJISStringEncoding];
				[http post:[[[tmp set:server] add:str1] str] :post_data :nil];
#ifdef NO_OBJC_ARC
				[post_data release];
				[post_str release];
#endif // NO_OBJC_ARC
			}
			step = 0;
			break;
		}
	}

#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
}

- (void)_onHttpResponse:(NSData*)data
{
	NSString* tmp = [[NSString alloc] initWithData:data encoding:NSShiftJISStringEncoding];
	[str2 setString:tmp];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
}

- (void)_onHttpError:(int)status
{
	[str2 setString:[NSString stringWithFormat:@"通信エラー %d", status]];
}

@end
