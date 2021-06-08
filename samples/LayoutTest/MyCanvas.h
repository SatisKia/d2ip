#import <Foundation/Foundation.h>

#import "_Canvas.h"

@class _Layout;

@interface MyCanvas : _Canvas
{
	NSMutableString* str[9];
	_Layout* layout;
}
@end
