#import "MyCanvas.h"

#import "_Layout.h"

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }
- (int)_touchNum { return 6; }

- (void)_init
{
	_Graphics* g = [self getGraphics];
	[g setStrokeWidth:2];
	[g setFontSize:20];

	for( int i = 0; i < 9; i++ )
	{
		str[i] = [[NSMutableString alloc] initWithString:@""];
	}

	layout = [[_Layout alloc] init];
	[layout add: 10 : 10 :90 :90 :0];
	[layout add:115 : 10 :90 :90 :1];
	[layout add:220 : 10 :90 :90 :2];
	[layout add: 10 :115 :90 :90 :3];
	[layout add:115 :115 :90 :90 :4];
	[layout add:220 :115 :90 :90 :5];
	[layout add: 10 :220 :90 :90 :6];
	[layout add:115 :220 :90 :90 :7];
	[layout add:220 :220 :90 :90 :8];
	[self setLayout:layout];
}

#ifdef NO_OBJC_ARC
- (void)_end
{
	for( int i = 0; i < 9; i++ )
	{
		[str[i] release];
	}

	[layout release];
}
#endif // NO_OBJC_ARC

- (void)_paint:(_Graphics*)g
{
	int state = [self getLayoutState];

	[g lock];

	[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
	[g fillRect:0 :0 :[self getWidth] :[self getHeight]];

	for( int i = 0; i < 9; i++ )
	{
		[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
		if( (state & (1 << i)) != 0 )
		{
			[g fillRect:[layout getLeft:i] :[layout getTop:i] :90 :90];
			[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
			[g drawString:str[i]
				:[layout getLeft:i] + 45 - [g stringWidth:str[i]] / 2
				:[layout getTop:i] + 45 + [g fontHeight] / 2
				];
		}
		else
		{
			[g drawRect:[layout getLeft:i] :[layout getTop:i] :89 :89];
			[g drawString:str[i]
				:[layout getLeft:i] + 45 - [g stringWidth:str[i]] / 2
				:[layout getTop:i] + 45 + [g fontHeight] / 2
				];
		}
	}

	[g unlock];
}

- (void)_processEvent:(int)type :(int)param
{
	switch( type )
	{
	case LAYOUT_DOWN_EVENT:
		[str[param] setString:@"DOWN"];
		break;
	case LAYOUT_UP_EVENT:
		[str[param] setString:@"UP"];
		break;
	}
}

@end
