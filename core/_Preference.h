/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface _Preference : NSObject
{
@private
	NSUserDefaults* _pref;
	int _index;
}

- (NSString*)getParameter:(NSString*)key :(NSString*)defValue;
- (void)setParameter:(NSString*)key :(NSString*)value;
- (void)beginRead;
- (NSString*)read:(NSString*)defValue;
- (void)endRead;
- (void)beginWrite;
- (void)write:(NSString*)value;
- (void)endWrite;

@end
