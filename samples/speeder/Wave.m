#import "Wave.h"

#import "_Vector.h"
#import "Bar.h"
#import "MyCanvas.h"
#import "Speeder.h"

/*
 * ウェーブ
 */
@implementation Wave

- (id)initWithCanvas:(MyCanvas*)m
{
	self = [super init];
	if ( self ) {
		_m = m;

		bar = [[_Vector alloc] init];
	}
	return self;
}

#ifdef NO_OBJC_ARC
- (void)dealloc
{
	[bar release];

	[super dealloc];
}
#endif // NO_OBJC_ARC

/*
 * 構築
 */
- (void)create
{
	[bar removeAllElements];
}

/*
 * バーを登録する
 */
- (void)add_bar:(int)x :(int)y :(int)col :(int)count :(BOOL)border
{
	Bar* tmp = [[Bar alloc] initWithCanvas:_m :x :y :col :count :border];
	[bar addElement:tmp];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
}
- (void)add_bar:(int)x :(int)y :(int)col
{
	Bar* tmp = [[Bar alloc] initWithCanvas:_m :x :y :col :0 :NO];
	[bar addElement:tmp];
#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC
}

/*
 * バーが無くなったかどうか
 */
- (BOOL)clear
{
	if ( [bar size] <= 0 ) return YES;
	return NO;
}

- (int)top_x
{
	int x = 0;
	int y = 240;
	for ( int i = [bar size] - 1; i >= 0; i-- ) {
		Bar* tmp = (Bar*)[bar elementAt:i];
		if ( [tmp y] < y ) {
			y = [tmp y];
			x = [tmp x];
		}
	}
	return x;
}
- (int)bottom_x
{
	int x = 0;
	int y = 0;
	for ( int i = [bar size] - 1; i >= 0; i-- ) {
		Bar* tmp = (Bar*)[bar elementAt:i];
		if ( [tmp y] > y ) {
			y = [tmp y];
			x = [tmp x];
		}
	}
	return x;
}

/*
 * ウェーブデータ更新
 */
- (void)update
{
	for ( int i = [bar size] - 1; i >= 0; i-- ) {
		Bar* tmp = (Bar*)[bar elementAt:i];
		if ( ![tmp update] ) {
			[bar removeElementAt:i];
		}
	}
}

/*
 * 描画
 */
- (int)draw
{
	int cnt = 0;
	for ( int i = [bar size] - 1; i >= 0; i-- ) {
		Bar* tmp = (Bar*)[bar elementAt:i];
		if ( [tmp col] == 3 ) {
			cnt += [_m drawImage:[_m use_image:IMAGE_BAR] :108 - ([_m->speeder[0] x] - [tmp x]) :[tmp y] :0 :36 * ([_m elapse] % 2) + 12 * ([_m elapse] % 3) :200 :12];
			[_m->g drawImage:[_m use_image:IMAGE_BAR] :108 - ([_m->speeder[0] x] - [tmp x]) - 24 :[tmp y] - 6 :24 * [tmp count] :72 :24 :24];
			[_m->g drawImage:[_m use_image:IMAGE_BAR] :108 - ([_m->speeder[0] x] - [tmp x]) + 200 :[tmp y] - 6 :24 * [tmp count] :72 :24 :24];
		} else {
			cnt += [_m drawImage:[_m use_image:IMAGE_BAR] :108 - ([_m->speeder[0] x] - [tmp x]) :[tmp y] :0 :36 * ([_m elapse] % 2) + 12 * [tmp col] :200 :12];
		}
	}
	if ( abs(cnt) == [bar size] ) {
		return cnt;
	}
	return 0;
}

@end
