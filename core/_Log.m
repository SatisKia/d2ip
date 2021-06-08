/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Log.h"

@implementation _Log

- (id)initWithLength:(int)len
{
	self = [super init];
	if( self != nil )
	{
		_len = len;
#ifdef NO_OBJC_ARC
		_log = [[NSMutableArray array] retain];
#else
		_log = [NSMutableArray array];
#endif // NO_OBJC_ARC
		for( int i = 0; i < _len; i++ )
		{
#if !defined( NO_OBJC_ARC )
@autoreleasepool
{
#endif // !defined( NO_OBJC_ARC )
			NSMutableString* tmp = [[NSMutableString alloc] initWithString:@""];
			[_log addObject:tmp];
#ifdef NO_OBJC_ARC
			[tmp release];
#endif // NO_OBJC_ARC
#if !defined( NO_OBJC_ARC )
}
#endif // !defined( NO_OBJC_ARC )
		}
		_top = _len;
		_cur = 0;
	}
	return self;
}

#ifdef NO_OBJC_ARC
- (void)dealloc
{
	[_log release];

	[super dealloc];
}
#endif // NO_OBJC_ARC

- (void)clear
{
	for( int i = 0; i < _len; i++ )
	{
		NSMutableString* tmp = (NSMutableString*)[_log objectAtIndex:i];
		[tmp setString:@""];
	}
	_top = _len;
}

- (void)add:(NSString*)str
{
	if( _top > 0 )
	{
		_top--;
	}
	for( int i = _top; i < _len - 1; i++ )
	{
		NSMutableString* src = (NSMutableString*)[_log objectAtIndex:(i + 1)];
		NSMutableString* dst = (NSMutableString*)[_log objectAtIndex:i];
		[dst setString:src];
	}
	NSMutableString* tmp = (NSMutableString*)[_log objectAtIndex:(_len - 1)];
	[tmp setString:str];
}

- (void)beginGet
{
	_cur = _top;
}

- (NSString*)get
{
	if( _cur >= _len )
	{
		return nil;
	}
	_cur++;
	NSMutableString* tmp = (NSMutableString*)[_log objectAtIndex:(_cur - 1)];
	return tmp;
}

- (int)lineNum
{
	return _cur - _top;
}

@end
