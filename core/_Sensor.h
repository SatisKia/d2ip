/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

//@interface _Sensor : NSObject <UIAccelerometerDelegate, CLLocationManagerDelegate>
@interface _Sensor : NSObject <CLLocationManagerDelegate>
{
@private
//	UIAccelerometer* _accelerometer;
	CLLocationManager* _locationmanager;
	CMMotionManager* _motionmanager;

	float _accel_x;
	float _accel_y;
	float _accel_z;
	float _gravity_x;
	float _gravity_y;
	float _gravity_z;
	float _linear_accel_x;
	float _linear_accel_y;
	float _linear_accel_z;
	float _azimuth;
	float _pitch;
	float _roll;
}

- (void)start:(float)interval;
- (void)stop;
- (float)getAccelX;
- (float)getAccelY;
- (float)getAccelZ;
- (float)getGravityX;
- (float)getGravityY;
- (float)getGravityZ;
- (float)getLinearAccelX;
- (float)getLinearAccelY;
- (float)getLinearAccelZ;
- (float)getAzimuth;
- (float)getPitch;
- (float)getRoll;

@end
