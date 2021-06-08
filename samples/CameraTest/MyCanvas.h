#import <UIKit/UIKit.h>

#import "_Canvas.h"

@class _Image;

@interface MyCanvas : _Canvas <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
	BOOL _reverse;

	UIImagePickerController* camera;

	_Image* test[6];

	int mode;
	int select;

	float transform;
}
@end
