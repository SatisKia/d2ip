/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Sensor.h"

#define _SENSOR_ALPHA	0.8f

@implementation _Sensor

- (id)init
{
	self = [super init];
	if( self != nil )
	{
//		_accelerometer = [UIAccelerometer sharedAccelerometer];
		_locationmanager = [[CLLocationManager alloc] init];
		_motionmanager = [[CMMotionManager alloc] init];

		_accel_x = 0.0f;
		_accel_y = 0.0f;
		_accel_z = 0.0f;
		_gravity_x = 0.0f;
		_gravity_y = 0.0f;
		_gravity_z = 0.0f;
		_linear_accel_x = 0.0f;
		_linear_accel_y = 0.0f;
		_linear_accel_z = 0.0f;
		_azimuth = 0.0f;
		_pitch = 0.0f;
		_roll = 0.0f;
	}
	return self;
}

- (void)dealloc
{
	[self stop];

#ifdef NO_OBJC_ARC
	[_locationmanager release];
	[_motionmanager release];
#endif // NO_OBJC_ARC

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (void)accelerometer:(float)x :(float)y :(float)z
{
	_accel_x = x * -10.0f;
	_accel_y = y * -10.0f;
	_accel_z = z * -10.0f;
	_gravity_x = _SENSOR_ALPHA * _gravity_x + (1.0f - _SENSOR_ALPHA) * _accel_x;
	_gravity_y = _SENSOR_ALPHA * _gravity_y + (1.0f - _SENSOR_ALPHA) * _accel_y;
	_gravity_z = _SENSOR_ALPHA * _gravity_z + (1.0f - _SENSOR_ALPHA) * _accel_z;
	_linear_accel_x = _accel_x - _gravity_x;
	_linear_accel_y = _accel_y - _gravity_y;
	_linear_accel_z = _accel_z - _gravity_z;
}
/*
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	_accel_x = acceleration.x * -10.0f;
	_accel_y = acceleration.y * -10.0f;
	_accel_z = acceleration.z * -10.0f;
	_gravity_x = _SENSOR_ALPHA * _gravity_x + (1.0f - _SENSOR_ALPHA) * _accel_x;
	_gravity_y = _SENSOR_ALPHA * _gravity_y + (1.0f - _SENSOR_ALPHA) * _accel_y;
	_gravity_z = _SENSOR_ALPHA * _gravity_z + (1.0f - _SENSOR_ALPHA) * _accel_z;
	_linear_accel_x = _accel_x - _gravity_x;
	_linear_accel_y = _accel_y - _gravity_y;
	_linear_accel_z = _accel_z - _gravity_z;
}
*/

- (void)locationManager:(CLLocationManager*)manager didUpdateHeading:(CLHeading*)heading
{
	_azimuth = heading.magneticHeading;
}

- (void)motionManager:(CMDeviceMotion*)motion
{
	_pitch = motion.attitude.pitch * -180.0f / M_PI;
	_roll  = motion.attitude.roll  * -180.0f / M_PI;
}

- (void)start:(float)interval
{
	_accel_x = 0.0f;
	_accel_y = 0.0f;
	_accel_z = 0.0f;
	_gravity_x = 0.0f;
	_gravity_y = 0.0f;
	_gravity_z = 0.0f;
	_linear_accel_x = 0.0f;
	_linear_accel_y = 0.0f;
	_linear_accel_z = 0.0f;
	_azimuth = 0.0f;
	_pitch = 0.0f;
	_roll = 0.0f;

//	_accelerometer.updateInterval = interval;
//	_accelerometer.delegate = self;
	_motionmanager.accelerometerUpdateInterval = interval;
	[_motionmanager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
		withHandler:^( CMAccelerometerData* data, NSError* error ){
			[self accelerometer:data.acceleration.x :data.acceleration.y :data.acceleration.z];
		}];

	_locationmanager.delegate = self;
	if( [CLLocationManager headingAvailable] )
	{
		[_locationmanager startUpdatingHeading];
	}

	_motionmanager.deviceMotionUpdateInterval = interval;
	[_motionmanager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
		withHandler:^( CMDeviceMotion* motion, NSError* error ){
			[self motionManager:motion];
		}];
}

- (void)stop
{
//	_accelerometer.delegate = nil;

	if( [CLLocationManager headingAvailable] )
	{
		[_locationmanager stopUpdatingHeading];
	}
	_locationmanager.delegate = nil;
}

- (float)getAccelX
{
	return _accel_x;
}
- (float)getAccelY
{
	return _accel_y;
}
- (float)getAccelZ
{
	return _accel_z;
}

- (float)getGravityX
{
	return _gravity_x;
}
- (float)getGravityY
{
	return _gravity_y;
}
- (float)getGravityZ
{
	return _gravity_z;
}

- (float)getLinearAccelX
{
	return _linear_accel_x;
}
- (float)getLinearAccelY
{
	return _linear_accel_y;
}
- (float)getLinearAccelZ
{
	return _linear_accel_z;
}

- (float)getAzimuth
{
	return _azimuth;
}
- (float)getPitch
{
	return _pitch;
}
- (float)getRoll
{
	return _roll;
}

@end
