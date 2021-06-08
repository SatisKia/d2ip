#import "Star.h"

#import "MyCanvas.h"
#import "Speeder.h"

/*
 * 星
 */
@implementation Star

- (id)initWithCanvas:(MyCanvas*)m :(int)x :(int)y
{
	self = [super init];
	if ( self ) {
		_m = m;

		_x = x;
		_y = y;
	}
	return self;
}

#ifdef NO_OBJC_ARC
- (void)dealloc
{
	[super dealloc];
}
#endif // NO_OBJC_ARC

- (int)x { return _x; }
- (int)y { return _y; }
- (BOOL)update
{
	_x -= [_m->speeder[0] direction] / 7;
	if ( [_m->speeder[0] speed] > 0 ) {
		_y += (([_m->speeder[0] speed] / 50) + 1);
	}
	if ( _y >= _m->height ) {
		return NO;
	}
	return YES;
}

@end
