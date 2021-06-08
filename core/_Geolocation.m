/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Geolocation.h"

#import "_Canvas.h"
#import "_Main.h"

@implementation _Geolocation

- (id)initWithMain:(_Main*)m
{
	self = [super init];
	if( self != nil )
	{
		_m = m;

		_locationmanager = [[CLLocationManager alloc] init];
		_locationmanager.delegate = nil;

		_enable_high_accuracy = NO;

		_latitude = 0.0;
		_longitude = 0.0;
		_accuracy = 0.0;
		_altitude = 0.0;
		_altitude_accuracy = 0.0;
		_heading = 0.0;
		_speed = 0.0;
		_timestamp = (time_t)0;
	}
	return self;
}

- (void)dealloc
{
	[self stop];

#ifdef NO_OBJC_ARC
	[_locationmanager release];
#endif // NO_OBJC_ARC

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation
{
	_latitude = [newLocation coordinate].latitude;
	_longitude = [newLocation coordinate].longitude;
	_accuracy = [newLocation horizontalAccuracy];
	_altitude = [newLocation altitude];
	_altitude_accuracy = [newLocation verticalAccuracy];
	_heading = [newLocation course];
	_speed = [newLocation speed];
	_timestamp = (time_t)[[newLocation timestamp] timeIntervalSince1970];

	[_m _onGeolocation:GEOLOCATION_SUCCESS];
	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] _onGeolocation:GEOLOCATION_SUCCESS];
	}
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
	int code = (error.code == kCLErrorDenied) ? GEOLOCATION_PERMISSION_DENIED : GEOLOCATION_POSITION_UNAVAILABLE;
	[_m _onGeolocation:code];
	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] _onGeolocation:code];
	}
}

- (void)setEnableHighAccuracy:(BOOL)enableHighAccuracy
{
	_enable_high_accuracy = enableHighAccuracy;
}

- (void)request:(int)type
{
	// iOS8以上
	if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 )
	{
		switch( type )
		{
		case GEOLOCATION_REQUEST_ALWAYS:
			[_locationmanager requestAlwaysAuthorization];
			break;
		case GEOLOCATION_REQUEST_WHENINUSE:
			[_locationmanager requestWhenInUseAuthorization];
			break;
		}
	}
}

- (void)start
{
	[self stop];

	if( [CLLocationManager locationServicesEnabled] )
	{
		if( _enable_high_accuracy )
		{
			_locationmanager.distanceFilter = 5;
			_locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
		}
		else
		{
			_locationmanager.distanceFilter = 10;
			_locationmanager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
		}

		_locationmanager.delegate = self;
		[_locationmanager startUpdatingLocation];
	}
	else
	{
		[_m _onGeolocation:GEOLOCATION_PERMISSION_DENIED];
		if( [_m getCurrent] != nil )
		{
			[[_m getCurrent] _onGeolocation:GEOLOCATION_PERMISSION_DENIED];
		}
	}
}

- (void)stop
{
	if( _locationmanager.delegate != nil )
	{
		[_locationmanager stopUpdatingLocation];
		_locationmanager.delegate = nil;
	}
}

- (void)timeout
{
	[self stop];

	[_m _onGeolocation:GEOLOCATION_TIMEOUT];
	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] _onGeolocation:GEOLOCATION_TIMEOUT];
	}
}

- (double)latitude
{
	return _latitude;
}
- (double)longitude
{
	return _longitude;
}
- (double)accuracy
{
	return _accuracy;
}
- (double)altitude
{
	return _altitude;
}
- (double)altitudeAccuracy
{
	return _altitude_accuracy;
}
- (double)heading
{
	return _heading;
}
- (double)speed
{
	return _speed;
}
- (time_t)timestamp
{
	return _timestamp;
}

@end
