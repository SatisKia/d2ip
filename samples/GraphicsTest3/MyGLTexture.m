#import "MyGLTexture.h"

@implementation MyGLTexture

- (NSString*)_resourceName:(int)index
{
	switch( index )
	{
	case 0: return @"sample.png";
	}
	return @"";
}

@end
