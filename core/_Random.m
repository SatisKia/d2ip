/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Random.h"

@implementation _Random

- (id)init
{
	self = [super init];
	if( self != nil )
	{
		srand( time( NULL ) );
		rand();
	}
	return self;
}

- (int)nextInt
{
	if( (rand() % 2) == 0 )
	{
		return 0 - rand();
	}
	return rand();
}

@end
