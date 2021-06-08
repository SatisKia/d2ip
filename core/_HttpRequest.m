/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_HttpRequest.h"

#import "_Canvas.h"
#import "_Main.h"
#import "_ViewController.h"

@implementation _HttpRequest

- (id)initWithMain:(_Main*)m
{
	self = [super init];
	if( self != nil )
	{
		_m = m;
		_view = nil;
		_use_cache = YES;
		_timeout = 60.0f;
		_busy = NO;
	}
	return self;
}
- (id)initWithViewController:(_ViewController*)view
{
	self = [super init];
	if( self != nil )
	{
		_m = nil;
		_view = view;
		_use_cache = YES;
		_timeout = 60.0f;
		_busy = NO;
	}
	return self;
}

- (void)useCache:(BOOL)flag
{
	_use_cache = flag;
}

- (void)setTimeout:(float)min
{
	_timeout = min;
}

- (void)execute:(NSString*)url :(BOOL)post :(NSData*)data :(NSString*)content_type
{
	dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^{
		NSMutableURLRequest* request = [NSMutableURLRequest
			requestWithURL:[NSURL URLWithString:url]
			cachePolicy:(_use_cache ? NSURLRequestUseProtocolCachePolicy : NSURLRequestReloadIgnoringLocalCacheData)
			timeoutInterval:_timeout
			];
		if( post )
		{
			[request setHTTPMethod:@"POST"];
			[request setHTTPBody:data];
			if( content_type != nil )
			{
				[request setValue:content_type forHTTPHeaderField:@"Content-Type"];
			}
		}
		else
		{
			[request setHTTPMethod:@"GET"];
		}
		NSHTTPURLResponse* response = nil;
		NSError* error = nil;
		NSData* data = [NSURLConnection
			sendSynchronousRequest:request
			returningResponse:&response
			error:&error
			];
		dispatch_async( dispatch_get_main_queue(), ^{
			if( error == nil )
			{
				if( [response statusCode] == 200 )
				{
					if( _m != nil )
					{
						[_m _onHttpResponse:data];
						if( [_m getCurrent] != nil )
						{
							[[_m getCurrent] _onHttpResponse:data];
						}
					}
					if( _view != nil )
					{
						[_view _onHttpResponse:data];
					}
				}
				else
				{
					if( _m != nil )
					{
						[_m _onHttpError:[response statusCode]];
						if( [_m getCurrent] != nil )
						{
							[[_m getCurrent] _onHttpError:[response statusCode]];
						}
					}
					if( _view != nil )
					{
						[_view _onHttpError:[response statusCode] :data];
					}
				}
			}
			else
			{
				if( _m != nil )
				{
					[_m _onHttpError:0];
					if( [_m getCurrent] != nil )
					{
						[[_m getCurrent] _onHttpError:0];
					}
				}
				if( _view != nil )
				{
					[_view _onHttpError:0 :data];
				}
			}
			_busy = NO;
		} );
	} );
}

- (BOOL)get:(NSString*)url
{
	if( _busy )
	{
		return NO;
	}
	_busy = YES;
	[self execute:url :NO :nil :nil];
	return YES;
}

- (BOOL)post:(NSString*)url :(NSData*)data :(NSString*)content_type
{
	if( _busy )
	{
		return NO;
	}
	_busy = YES;
	[self execute:url :YES :data :content_type];
	return YES;
}

- (BOOL)busy
{
	return _busy;
}

@end
