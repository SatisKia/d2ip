#import "MyCanvas.h"

#import "_Sensor.h"

#define SENSOR_INTERVAL	0.1f

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }

- (void)_init
{
	_Graphics* g = [self getGraphics];
	[g setFontSize:20];

	sensor = [[_Sensor alloc] init];
	[sensor start:SENSOR_INTERVAL];
}

#ifdef NO_OBJC_ARC
- (void)_end
{
	[sensor release];
}
#endif // NO_OBJC_ARC

- (void)_suspend
{
	[sensor stop];
}

- (void)_resume
{
	[sensor start:SENSOR_INTERVAL];
}

- (void)_paint:(_Graphics*)g
{
	[g lock];

	[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
	[g fillRect:0 :0 :[self getWidth] :[self getHeight]];

	[g setColor:[_Graphics getColorOfRGB:0 :0 :255]];
	[g drawString:[NSString stringWithFormat:@"accelX : %d"      , (int)([sensor getAccelX] * 100)] :0 :24];
	[g drawString:[NSString stringWithFormat:@"accelY : %d"      , (int)([sensor getAccelY] * 100)] :0 :48];
	[g drawString:[NSString stringWithFormat:@"accelZ : %d"      , (int)([sensor getAccelZ] * 100)] :0 :72];
	[g drawString:[NSString stringWithFormat:@"gravityX : %d"    , (int)[sensor getGravityX]] :0 :96];
	[g drawString:[NSString stringWithFormat:@"gravityY : %d"    , (int)[sensor getGravityY]] :0 :120];
	[g drawString:[NSString stringWithFormat:@"gravityZ : %d"    , (int)[sensor getGravityZ]] :0 :144];
	[g drawString:[NSString stringWithFormat:@"linearAccelX : %d", (int)([sensor getLinearAccelX] * 100)] :0 :168];
	[g drawString:[NSString stringWithFormat:@"linearAccelY : %d", (int)([sensor getLinearAccelY] * 100)] :0 :192];
	[g drawString:[NSString stringWithFormat:@"linearAccelZ : %d", (int)([sensor getLinearAccelZ] * 100)] :0 :216];
	[g drawString:[NSString stringWithFormat:@"azimuth : %d"     , (int)[sensor getAzimuth]] :0 :240];
	[g drawString:[NSString stringWithFormat:@"pitch : %d"       , (int)[sensor getPitch]] :0 :264];
	[g drawString:[NSString stringWithFormat:@"roll : %d"        , (int)[sensor getRoll]] :0 :288];

	[g unlock];
}

@end
