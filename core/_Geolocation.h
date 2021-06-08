/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@class _Main;

// 認証リクエストの種類
#define GEOLOCATION_REQUEST_ALWAYS		0
#define GEOLOCATION_REQUEST_WHENINUSE	1

// Geolocation
#define GEOLOCATION_ERROR					0
#define GEOLOCATION_PERMISSION_DENIED		1
#define GEOLOCATION_POSITION_UNAVAILABLE	2
#define GEOLOCATION_TIMEOUT					3
#define GEOLOCATION_SUCCESS					4

@interface _Geolocation : NSObject <CLLocationManagerDelegate>
{
@private
	_Main* _m;

	CLLocationManager* _locationmanager;

	BOOL _enable_high_accuracy;

	double _latitude;
	double _longitude;
	double _accuracy;
	double _altitude;
	double _altitude_accuracy;
	double _heading;
	double _speed;
	time_t _timestamp;
}

- (id)initWithMain:(_Main*)m;
- (void)setEnableHighAccuracy:(BOOL)enableHighAccuracy;
- (void)request:(int)type;
- (void)start;
- (void)stop;
- (void)timeout;
- (double)latitude;
- (double)longitude;
- (double)accuracy;
- (double)altitude;
- (double)altitudeAccuracy;
- (double)heading;
- (double)speed;
- (time_t)timestamp;

@end
