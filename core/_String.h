/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>

#define ENCODING_ASCII	NSASCIIStringEncoding
#define ENCODING_EUC_JP	NSJapaneseEUCStringEncoding
#define ENCODING_SJIS	NSShiftJISStringEncoding
#define ENCODING_UTF_8	NSUTF8StringEncoding

@interface _String : NSObject
{
@private
	NSMutableString* _str;
}

- (_String*)set:(NSString*)str;
- (_String*)set:(NSString*)str :(int)beginIndex :(int)endIndex;
- (_String*)setCStr:(char*)str;
- (_String*)setData:(NSData*)data :(NSStringEncoding)encoding;
- (_String*)setInt:(int)val;
- (_String*)add:(NSString*)str;
- (_String*)add:(NSString*)str :(int)beginIndex :(int)endIndex;
- (_String*)addCStr:(char*)str;
- (_String*)addData:(NSData*)data :(NSStringEncoding)encoding;
- (_String*)addInt:(int)val;
- (int)length;
- (BOOL)equals:(NSString*)str;
- (int)indexOf:(NSString*)str;
- (BOOL)startsWith:(NSString*)str;
- (BOOL)endsWith:(NSString*)str;
- (int)parseInt;
- (NSString*)str;
- (char*)allocCStr;
- (NSData*)allocData:(NSStringEncoding)encoding;
- (NSString*)charAt:(int)index;
- (int)charCodeAt:(int)index;

- (_String*)topJSON;
- (_String*)addJSON:(NSString*)key :(NSString*)value;
- (_String*)endJSON;

@end
