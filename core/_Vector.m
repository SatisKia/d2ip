/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Vector.h"

@implementation _Vector

- (id)init
{
	self = [super init];
	if( self != nil )
	{
#ifdef NO_OBJC_ARC
		_object = [[NSMutableArray array] retain];
#else
		_object = [NSMutableArray array];
#endif // NO_OBJC_ARC
	}
	return self;
}

#ifdef NO_OBJC_ARC
- (void)dealloc
{
	[_object release];

	[super dealloc];
}
#endif // NO_OBJC_ARC

- (void)addElement:(NSObject*)object
{
	[_object addObject:object];
}

- (void)setElementAt:(NSObject*)object :(int)index
{
	[_object replaceObjectAtIndex:index withObject:object];
}

- (void)insertElementAt:(NSObject*)object :(int)index
{
	[_object insertObject:object atIndex:index];
}

- (void)removeElementAt:(int)index
{
	[_object removeObjectAtIndex:index];
}

- (void)removeAllElements
{
	[_object removeAllObjects];
}

- (NSObject*)elementAt:(int)index
{
	return [_object objectAtIndex:index];
}

- (NSObject*)firstElement
{
	return [_object objectAtIndex:0];
}

- (NSObject*)lastElement
{
	return [_object lastObject];
}

- (BOOL)isEmpty
{
	return ([_object count] == 0);
}

- (int)size
{
	return [_object count];
}

@end
