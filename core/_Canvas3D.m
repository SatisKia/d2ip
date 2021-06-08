/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_Canvas3D.h"

#import "_Main.h"

@implementation _Canvas3D

+ (Class)layerClass
{
	return [CAEAGLLayer class];
}

- (void)_initSub
{
	CAEAGLLayer* eaglLayer = (CAEAGLLayer*)super.layer;
	if( [super _applyScale] )
	{
		eaglLayer.contentsScale = [UIScreen mainScreen].scale;
	}
	eaglLayer.opaque = NO;
	eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
		kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
		nil
		];

	_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	[EAGLContext setCurrentContext:_context];

	glGenFramebuffersOES( 1, &_framebuffer );
	glGenRenderbuffersOES( 1, &_renderbuffer );
	glGenRenderbuffersOES( 1, &_depthbuffer );

	glBindFramebufferOES( GL_FRAMEBUFFER_OES, _framebuffer );
	glBindRenderbufferOES( GL_RENDERBUFFER_OES, _renderbuffer );
	[_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:eaglLayer];
	glFramebufferRenderbufferOES(
		GL_FRAMEBUFFER_OES,
		GL_COLOR_ATTACHMENT0_OES,
		GL_RENDERBUFFER_OES,
		_renderbuffer
		);

	int width, height;
	glGetRenderbufferParameterivOES( GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &width );
	glGetRenderbufferParameterivOES( GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &height );

	if( _multi_sample )
	{
		GLint maxSamples;
		glGetIntegerv( GL_MAX_SAMPLES_APPLE, &maxSamples );

		glGenFramebuffersOES( 1, &_msaa_framebuffer );
		glGenRenderbuffersOES( 1, &_msaa_renderbuffer );
		glBindFramebufferOES( GL_FRAMEBUFFER_OES, _msaa_framebuffer );
		glBindRenderbufferOES( GL_RENDERBUFFER_OES, _msaa_renderbuffer );
		glRenderbufferStorageMultisampleAPPLE(
			GL_RENDERBUFFER_OES,
			maxSamples,
			GL_RGBA8_OES,
			width,
			height
			);
		glFramebufferRenderbufferOES(
			GL_FRAMEBUFFER_OES,
			GL_COLOR_ATTACHMENT0_OES,
			GL_RENDERBUFFER_OES,
			_msaa_renderbuffer
			);
		glBindRenderbufferOES( GL_RENDERBUFFER_OES, _depthbuffer );
		glRenderbufferStorageMultisampleAPPLE(
			GL_RENDERBUFFER_OES,
			maxSamples,
			GL_DEPTH_COMPONENT16_OES,
			width,
			height
			);
	}
	else
	{
		glBindRenderbufferOES( GL_RENDERBUFFER_OES, _depthbuffer );
		glRenderbufferStorageOES(
			GL_RENDERBUFFER_OES,
			GL_DEPTH_COMPONENT16_OES,
			width,
			height
			);
	}
	glFramebufferRenderbufferOES(
		GL_FRAMEBUFFER_OES,
		GL_DEPTH_ATTACHMENT_OES,
		GL_RENDERBUFFER_OES,
		_depthbuffer
		);

	// デプスバッファを有効にする
	glEnable( GL_DEPTH_TEST );

	UIColor* color = [[self getMain] _backgroundColor];
	const CGFloat* rgba = CGColorGetComponents( color.CGColor );
	int n = CGColorGetNumberOfComponents( color.CGColor );
	glClearColor(
		rgba[0],
		rgba[(n == 4) ? 1 : 0],
		rgba[(n == 4) ? 2 : 0],
		1.0f/*rgba[(n == 4) ? 3 : 1]*/
		);
	glClearDepthf( 1.0f );
}

- (void)_endSub
{
	glDeleteFramebuffersOES( 1, &_framebuffer );
	glDeleteRenderbuffersOES( 1, &_renderbuffer );
	glDeleteRenderbuffersOES( 1, &_depthbuffer );

	if( _multi_sample )
	{
		glDeleteFramebuffersOES( 1, &_msaa_framebuffer );
		glDeleteRenderbuffersOES( 1, &_msaa_renderbuffer );
	}

	if( [EAGLContext currentContext] == _context )
	{
		[EAGLContext setCurrentContext:nil];
	}
#ifdef NO_OBJC_ARC
	[_context release];
#endif // NO_OBJC_ARC
}

- (void)_init
{
	_multi_sample = [self _multiSample];

	[self _initSub];

	[self _init3D];
}

- (void)_end
{
	[self _end3D];

	[self _endSub];
}

- (void)_prePaint
{
	if( [super _applyScaleFlag] || _multi_sample_f )
	{
		if( [super _initFlag] )
		{
			[self _endSub];
		}

		[super _setApplyScale];

		if( _multi_sample_f )
		{
			_multi_sample = !_multi_sample;
			_multi_sample_f = NO;
		}

		if( [super _initFlag] )
		{
			[self _initSub];

			[self _reset3D];
		}
	}
}

- (int)getViewportWidth
{
	if( [super _applyScale] )
	{
		return (int)((float)[self getWidth] * [UIScreen mainScreen].scale);
	}

	float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	return (iOSVersion >= 7.0) ? [self getWidth] : [self _getFrameWidth];
}
- (int)getViewportHeight
{
	if( [super _applyScale] )
	{
		return (int)((float)[self getHeight] * [UIScreen mainScreen].scale);
	}

	float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	return (iOSVersion >= 7.0) ? [self getHeight] : [self _getFrameHeight];
}

- (void)lock3D
{
	glBindFramebufferOES( GL_FRAMEBUFFER_OES, _multi_sample ? _msaa_framebuffer : _framebuffer );

	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
}

- (void)unlock3D
{
	if( _multi_sample )
	{
		GLenum attachments[] = { GL_DEPTH_ATTACHMENT_OES };
		glDiscardFramebufferEXT( GL_READ_FRAMEBUFFER_APPLE, 1, attachments );
		glBindFramebufferOES( GL_READ_FRAMEBUFFER_APPLE, _msaa_framebuffer );
		glBindFramebufferOES( GL_DRAW_FRAMEBUFFER_APPLE, _framebuffer );
		glResolveMultisampleFramebufferAPPLE();
	}

	glBindRenderbufferOES( GL_RENDERBUFFER_OES, _renderbuffer );
	[_context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)_paint:(_Graphics*)g
{
	[self _paint3D:g];
}

- (void)setMultiSample:(BOOL)flag
{
	if( flag != _multi_sample )
	{
		_multi_sample_f = YES;
	}
}

- (BOOL)multiSample
{
	return _multi_sample;
}

- (BOOL)_multiSample { return NO; }

- (void)_init3D {}
- (void)_reset3D {}
- (void)_end3D {}
- (void)_paint3D:(_Graphics*)g {}

@end
