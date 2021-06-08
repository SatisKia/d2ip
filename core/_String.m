/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_String.h"

@implementation _String

- (id)init
{
	self = [super init];
	if( self != nil )
	{
		_str = [[NSMutableString alloc] initWithString:@""];
	}
	return self;
}

#ifdef NO_OBJC_ARC
- (void)dealloc
{
	[_str release];

	[super dealloc];
}
#endif // NO_OBJC_ARC

- (_String*)set:(NSString*)str
{
	[_str setString:str];
	return self;
}

- (_String*)set:(NSString*)str :(int)beginIndex :(int)endIndex
{
	[_str setString:[str substringWithRange:NSMakeRange( beginIndex, endIndex - beginIndex )]];
	return self;
}

- (_String*)setCStr:(char*)str
{
	NSString* tmp = [[NSString alloc] initWithUTF8String:str];
	[_str setString:tmp];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
	return self;
}

- (_String*)setData:(NSData*)data :(NSStringEncoding)encoding
{
	NSString* tmp = [[NSString alloc] initWithData:data encoding:encoding];
	[_str setString:tmp];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
	return self;
}

- (_String*)setInt:(int)val
{
	[_str setString:[NSString stringWithFormat:@"%d", val]];
	return self;
}

- (_String*)add:(NSString*)str
{
	[_str appendString:str];
	return self;
}

- (_String*)add:(NSString*)str :(int)beginIndex :(int)endIndex
{
	NSString* tmp = [str substringWithRange:NSMakeRange( beginIndex, endIndex - beginIndex )];
	[_str appendString:tmp];
	return self;
}

- (_String*)addCStr:(char*)str
{
	NSString* tmp = [[NSString alloc] initWithUTF8String:str];
	[_str appendString:tmp];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
	return self;
}

- (_String*)addData:(NSData*)data :(NSStringEncoding)encoding
{
	NSString* tmp = [[NSString alloc] initWithData:data encoding:encoding];
	[_str appendString:tmp];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
	return self;
}

- (_String*)addInt:(int)val
{
	[_str appendFormat:@"%d", val];
	return self;
}

- (int)length
{
	return (int)[_str length];
}

- (BOOL)equals:(NSString*)str
{
	return [_str isEqualToString:str];
}

- (int)indexOf:(NSString*)str
{
	NSRange range = [_str rangeOfString:str];
	if( range.location == NSNotFound )
	{
		return -1;
	}
	return (int)range.location;
}

- (BOOL)startsWith:(NSString*)str
{
	return [_str hasPrefix:str];
}

- (BOOL)endsWith:(NSString*)str
{
	return [_str hasSuffix:str];
}

- (int)parseInt
{
	return [_str intValue];
}

- (NSString*)str
{
	return _str;
}

- (char*)allocCStr
{
	char* ret = malloc( [_str length] + 1 );
	strcpy( ret, [_str UTF8String] );
	return ret;
}

- (NSData*)allocData:(NSStringEncoding)encoding
{
	NSMutableString* tmp = [[NSMutableString alloc] initWithString:_str];
	CFStringNormalize( (CFMutableStringRef)tmp, kCFStringNormalizationFormC );
#ifdef NO_OBJC_ARC
	NSData* ret = [[tmp dataUsingEncoding:encoding] retain];
#else
	NSData* ret = [tmp dataUsingEncoding:encoding];
#endif // NO_OBJC_ARC
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
	return ret;
}

- (NSString*)charAt:(int)index
{
	if( index >= [_str length] )
	{
		return @"";
	}
	return [_str substringWithRange:NSMakeRange( index, 1 )];
}

- (int)charCodeAt:(int)index
{
	if( index >= [_str length] )
	{
		return '\0';
	}
	NSString* tmp = [_str substringWithRange:NSMakeRange( index, 1 )];
	const char* tmp2 = [tmp UTF8String];
	int tmp3 = tmp2[0];
	for( int i = 1; i < strlen( tmp2 ); i++ )
	{
		tmp3 += (tmp2[i] << 8);
	}
	return tmp3;
}

- (_String*)topJSON
{
	if( [self length] > 0 )
	{
		if( ![[self charAt:([self length] - 1)] isEqualToString:@"{"] )
		{
			[self add:@","];
		}
	}
	[self add:@"{"];
	return self;
}

- (_String*)addJSON:(NSString*)key :(NSString*)value
{
	_String* tmp = [[_String alloc] init];
	[tmp set:value];
	_String* value2 = [[_String alloc] init];
	for( int i = 0; i < [tmp length]; i++ )
	{
		NSString* chr = [tmp charAt:i];
		if( [chr isEqualToString:@"\""] )
		{
			[value2 add:@"\\"];
		}
		[value2 add:chr];
	}

	if( ![[self charAt:([self length] - 1)] isEqualToString:@"{"] )
	{
		[self add:@","];
	}
	[self add:@"\""];
	[self add:key];
	[self add:@"\":\""];
	[self add:[value2 str]];
	[self add:@"\""];
	return self;
}

- (_String*)endJSON
{
	[self add:@"}"];
	return self;
}

@end
