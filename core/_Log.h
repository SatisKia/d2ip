/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface _Log : NSObject
{
@private
	NSMutableArray* _log;
	int _len;
	int _top;
	int _cur;
}

- (id)initWithLength:(int)len;
- (void)clear;
- (void)add:(NSString*)str;
- (void)beginGet;
- (NSString*)get;
- (int)lineNum;

@end
