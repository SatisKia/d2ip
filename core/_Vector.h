/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface _Vector : NSObject
{
@private
	NSMutableArray* _object;
}

- (void)addElement:(NSObject*)object;
- (void)setElementAt:(NSObject*)object :(int)index;
- (void)insertElementAt:(NSObject*)object :(int)index;
- (void)removeElementAt:(int)index;
- (void)removeAllElements;
- (NSObject*)elementAt:(int)index;
- (NSObject*)firstElement;
- (NSObject*)lastElement;
- (BOOL)isEmpty;
- (int)size;

@end
