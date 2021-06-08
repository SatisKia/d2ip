/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Layout.h"

#import "_Canvas.h"

@interface _LayoutInfo : NSObject
{
@public
	int _left;
	int _top;
	int _right;
	int _bottom;
	int _id;
}
@end

@implementation _LayoutInfo
@end

@implementation _Layout

- (id)init
{
	self = [super init];
	if( self != nil )
	{
#ifdef NO_OBJC_ARC
		_layout = [[NSMutableArray array] retain];
#else
		_layout = [NSMutableArray array];
#endif // NO_OBJC_ARC
		_window = NO;
	}
	return self;
}

#ifdef NO_OBJC_ARC
- (void)dealloc
{
	[_layout release];

	[super dealloc];
}
#endif // NO_OBJC_ARC

- (void)setWindow:(BOOL)window
{
	_window = window;
}

- (void)clear
{
	[_layout removeAllObjects];
}

- (void)add:(int)left :(int)top :(int)width :(int)height :(int)id
{
	_LayoutInfo* tmp = [[_LayoutInfo alloc] init];
	tmp->_left   = left;
	tmp->_top    = top;
	tmp->_right  = left + width;
	tmp->_bottom = top + height;
	tmp->_id     = id;
	[_layout addObject:tmp];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
}

- (int)getLeft:(int)id
{
	_LayoutInfo* tmp;
	for( int i = [_layout count] - 1; i >= 0; i-- )
	{
		tmp = (_LayoutInfo*)[_layout objectAtIndex:i];
		if( tmp->_id == id )
		{
			return tmp->_left;
		}
	}
	return 0;
}
- (int)getTop:(int)id
{
	_LayoutInfo* tmp;
	for( int i = [_layout count] - 1; i >= 0; i-- )
	{
		tmp = (_LayoutInfo*)[_layout objectAtIndex:i];
		if( tmp->_id == id )
		{
			return tmp->_top;
		}
	}
	return 0;
}
- (int)getRight:(int)id
{
	_LayoutInfo* tmp;
	for( int i = [_layout count] - 1; i >= 0; i-- )
	{
		tmp = (_LayoutInfo*)[_layout objectAtIndex:i];
		if( tmp->_id == id )
		{
			return tmp->_right;
		}
	}
	return 0;
}
- (int)getBottom:(int)id
{
	_LayoutInfo* tmp;
	for( int i = [_layout count] - 1; i >= 0; i-- )
	{
		tmp = (_LayoutInfo*)[_layout objectAtIndex:i];
		if( tmp->_id == id )
		{
			return tmp->_bottom;
		}
	}
	return 0;
}
- (int)getWidth:(int)id
{
	_LayoutInfo* tmp;
	for( int i = [_layout count] - 1; i >= 0; i-- )
	{
		tmp = (_LayoutInfo*)[_layout objectAtIndex:i];
		if( tmp->_id == id )
		{
			return tmp->_right - tmp->_left;
		}
	}
	return 0;
}
- (int)getHeight:(int)id
{
	_LayoutInfo* tmp;
	for( int i = [_layout count] - 1; i >= 0; i-- )
	{
		tmp = (_LayoutInfo*)[_layout objectAtIndex:i];
		if( tmp->_id == id )
		{
			return tmp->_bottom - tmp->_top;
		}
	}
	return 0;
}

- (BOOL)_isWindow
{
	return _window;
}

- (int)_check:(int)x :(int)y
{
	_LayoutInfo* tmp;
	for( int i = [_layout count] - 1; i >= 0; i-- )
	{
		tmp = (_LayoutInfo*)[_layout objectAtIndex:i];
		if(
			(x >= tmp->_left) && (x < tmp->_right ) &&
			(y >= tmp->_top ) && (y < tmp->_bottom)
		){
			return tmp->_id;
		}
	}
	return -1;
}

- (void)_draw:(_Canvas*)canvas :(_Graphics*)g
{
	_LayoutInfo* tmp;
	for( int i = [_layout count] - 1; i >= 0; i-- )
	{
		tmp = (_LayoutInfo*)[_layout objectAtIndex:i];
		if( _window )
		{
			int left   = [canvas screenX:tmp->_left];
			int top    = [canvas screenY:tmp->_top];
			int right  = [canvas screenX:tmp->_right];
			int bottom = [canvas screenY:tmp->_bottom];
			[g drawRoundRect:left :top :right - left - 1 :bottom - top - 1 :10];
			[g drawString:[NSString stringWithFormat:@"%d", tmp->_id] :left + 5 :top + 5 + [g fontHeight]];
		}
		else
		{
			[g drawRoundRect:tmp->_left :tmp->_top :tmp->_right - tmp->_left - 1 :tmp->_bottom - tmp->_top - 1 :10];
			[g drawString:[NSString stringWithFormat:@"%d", tmp->_id] :tmp->_left + 5 :tmp->_top + 5 + [g fontHeight]];
		}
	}
}

@end
