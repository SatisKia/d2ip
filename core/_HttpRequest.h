/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class _Main;
@class _ViewController;

@interface _HttpRequest : NSObject
{
@private
	_Main* _m;
	_ViewController* _view;
	BOOL _use_cache;
	float _timeout;
	BOOL _busy;
}

- (id)initWithMain:(_Main*)m;
- (id)initWithViewController:(_ViewController*)view;
- (void)useCache:(BOOL)flag;
- (void)setTimeout:(float)min;
- (BOOL)get:(NSString*)url;
- (BOOL)post:(NSString*)url :(NSData*)data :(NSString*)content_type;
- (BOOL)busy;

@end
