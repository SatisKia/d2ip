#import <Foundation/Foundation.h>

#import "_Canvas3D.h"

@class _GLGraphics;
@class _ScalableGraphics;
@class MyGLTexture;

@interface MyCanvas : _Canvas3D
{
	MyGLTexture* glt;
	_GLGraphics* g;
	_ScalableGraphics* g2;

	int width2D;
	int height2D;

	int step;
	int x, y;
	int angle;
}
@end
