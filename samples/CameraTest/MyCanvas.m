#import <Foundation/Foundation.h>

#import "MyCanvas.h"

#import "_Image.h"
#import "_Main.h"

#define MODE_SELECT	0
#define MODE_CAMERA	1

#define IMAGE_SIZE	256
#define CAMERA_SIZE	200

@implementation MyCanvas

- (int)_frameTime { return 33/*1000 / 30*/; }

- (void)writePNG:(UIImage*)image :(int)index
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString* documentDirectory = [paths objectAtIndex:0];
	NSString* filePath = [NSString stringWithFormat:@"%@/test%d.png", documentDirectory, index];

	NSData* data = UIImagePNGRepresentation( image );
	[data writeToFile:filePath atomically:YES];
}

- (UIImage*)readPNG:(int)index
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString* documentDirectory = [paths objectAtIndex:0];
	NSString* filePath = [NSString stringWithFormat:@"%@/test%d.png", documentDirectory, index];

	if( [[NSFileManager defaultManager] fileExistsAtPath:filePath] )
	{
		return [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
	}

	return nil;
}

- (BOOL)enableCamera
{
	return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void)startCamera
{
	camera = [[UIImagePickerController alloc] init];
	camera.sourceType = UIImagePickerControllerSourceTypeCamera;
	camera.cameraDevice = UIImagePickerControllerCameraDeviceFront;
	camera.showsCameraControls = NO;
	camera.allowsEditing = NO;
	camera.delegate = self;
	camera.cameraOverlayView = self;

	float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	if( iOSVersion >= 7.0 )
	{
		transform = 1.7f;
	}
	else
	{
		transform = 1.3f;
	}
	camera.cameraViewTransform = CGAffineTransformScale( camera.cameraViewTransform, transform, transform );

	[self clearTouch];

	[[[self getMain] getViewController] presentModalViewController:camera animated:YES];
}

- (void)endCamera
{
	[self clearTouch];

	[[[self getMain] getViewController] dismissModalViewControllerAnimated:YES];

#ifdef NO_OBJC_ARC
	[camera release];
#endif // NO_OBJC_ARC
	camera = nil;
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary*)editingInfo
{
	[self endCamera];

	_Image* tmp = [[_Image alloc] init];
	[tmp attach:image];

#ifdef NO_OBJC_ARC
	if( test[select] != nil )
	{
		[test[select] release];
	}
#endif // NO_OBJC_ARC
	test[select] = [[_Image alloc] init];
	[test[select] create:IMAGE_SIZE :IMAGE_SIZE];
	_Graphics* g = [test[select] getGraphics];

	if( _reverse )
	{
		[g setFlipMode:FLIP_HORIZONTAL];
	}
	else
	{
		[g setFlipMode:FLIP_VERTICAL];
	}
	int size;
	float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	if( iOSVersion >= 7.0 )
	{
		size = (int)((float)(CAMERA_SIZE * [tmp getWidth] / [self getWidth]) / 1.3f);
	}
	else
	{
		size = (int)((float)(CAMERA_SIZE * [tmp getWidth] / [self getWidth]) / 1.15f);
	}
	int offset = ([tmp getWidth] - (int)((float)[tmp getWidth] / transform)) / 2;
	int sx = ([tmp getWidth] - offset - size) / 2 + offset;
	int sy = ([tmp getHeight] - size) / 2;
	[g drawScaledImage:tmp :0 :0 :IMAGE_SIZE :IMAGE_SIZE :sx :sy :size :size];
	[g setFlipMode:FLIP_NONE];

#ifdef NO_OBJC_ARC
	[tmp release];
#endif // NO_OBJC_ARC

	[self writePNG:[test[select] getImage] :select];

	mode = MODE_SELECT;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
	[self endCamera];

	mode = MODE_SELECT;
}

- (void)_init
{
	_reverse = NO;
	if( [[self getMain] getOrientation] == UIInterfaceOrientationLandscapeLeft )
	{
		_reverse = YES;
	}

	camera = nil;

	UIImage* tmp[6];
	for( int i = 0; i < 6; i++ )
	{
		tmp[i] = [self readPNG:i];
		if( tmp[i] != nil )
		{
			test[i] = [[_Image alloc] init];
			[test[i] attach:tmp[i]];
		}
		else
		{
			test[i] = nil;
		}
	}

	mode = MODE_SELECT;
}

#ifdef NO_OBJC_ARC
- (void)_end
{
	if( camera != nil )
	{
		[camera release];
	}

	for( int i = 0; i < 6; i++ )
	{
		if( test[i] != nil )
		{
			[test[i] release];
		}
	}
}
#endif // NO_OBJC_ARC

- (void)_paint:(_Graphics*)g
{
	[g lock];

	if( mode == MODE_SELECT )
	{
		int size = [self getHeight] / 2;

		for( int i = 0; i < 6; i++ )
		{
			if( test[i] != nil )
			{
				[g drawScaledImage:test[i] :size * (i % 3) :size * (i / 3) :size :size :0 :0 :IMAGE_SIZE :IMAGE_SIZE];
			}

			[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
			[g drawRect:size * (i % 3) :size * (i / 3) :size :size];
		}

		NSString* tmp = @"ボックスを選択してください";
		[g setFontSize:20];
		[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
		[g drawString:tmp :([self getWidth] - [g stringWidth:tmp]) / 2 :25];
	}
	else
	{
		[g drawRect:([self getWidth] - CAMERA_SIZE) / 2 :([self getHeight] - CAMERA_SIZE) / 2 :CAMERA_SIZE :CAMERA_SIZE];

		NSString* tmp = @"画面をタッチしてください";
		[g setFontSize:20];
		[g setColor:[_Graphics getColorOfRGB:255 :255 :255]];
		[g drawString:tmp :([self getWidth] - [g stringWidth:tmp]) / 2 :25];
	}

	[g unlock];
}

- (void)_processEvent:(int)type :(int)param
{
	switch( type )
	{
	case TOUCH_DOWN_EVENT:
		if( [self enableCamera] )
		{
			if( mode == MODE_SELECT )
			{
				int size = [self getHeight] / 2;
				if( [self getTouchX:0] < size * 3 )
				{
					mode = MODE_CAMERA;

					select = (([self getTouchY:0] < size) ? 0 : 3) + [self getTouchX:0] / size;

					[self startCamera];
				}
			}
			else
			{
				[camera takePicture];
			}
		}
		break;
	}
}

- (void)_onOrientationChange:(UIInterfaceOrientation)orientation
{
	_reverse = (orientation == UIInterfaceOrientationLandscapeLeft);
}

@end
