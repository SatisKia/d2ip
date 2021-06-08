/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface _Scalable : NSObject
{
@protected
	float _scale;
}

- (void)setScale:(float)scale;
- (float)scale;
- (int)scaledValue:(int)val;

@end
