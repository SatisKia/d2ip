/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "_Canvas.h"

@interface _Canvas3D : _Canvas
{
@private
	BOOL _multi_sample;
	BOOL _multi_sample_f;

	EAGLContext* _context;

	GLuint _framebuffer;
	GLuint _renderbuffer;
	GLuint _depthbuffer;

	GLuint _msaa_framebuffer;
	GLuint _msaa_renderbuffer;
}

- (int)getViewportWidth;
- (int)getViewportHeight;

- (void)lock3D;
- (void)unlock3D;
- (void)setMultiSample:(BOOL)flag;
- (BOOL)multiSample;

- (BOOL)_multiSample;

- (void)_init3D;
- (void)_reset3D;
- (void)_end3D;
- (void)_paint3D:(_Graphics*)g;

@end
