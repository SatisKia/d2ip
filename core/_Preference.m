/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Preference.h"

@implementation _Preference

- (id)init
{
	self = [super init];
	if( self != nil )
	{
		_pref = [NSUserDefaults standardUserDefaults];
	}
	return self;
}

- (NSString*)getParameter:(NSString*)key :(NSString*)defValue
{
	NSString* value = [_pref stringForKey:key];
	if( value == nil )
	{
		return defValue;
	}
	return value;
}

- (void)setParameter:(NSString*)key :(NSString*)value
{
	[_pref setObject:value forKey:key];
	[_pref synchronize];
}

- (void)beginRead
{
	_index = -1;
}

- (NSString*)read:(NSString*)defValue
{
	_index++;
	return [self getParameter:[NSString stringWithFormat:@"%d", _index] :defValue];
}

- (void)endRead
{
}

- (void)beginWrite
{
	_index = -1;
}

- (void)write:(NSString*)value
{
	_index++;
	[_pref setObject:value forKey:[NSString stringWithFormat:@"%d", _index]];
}

- (void)endWrite
{
	[_pref synchronize];
}

@end
