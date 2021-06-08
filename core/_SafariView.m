/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_SafariView.h"

#import "_Main.h"

@implementation _SafariView

- (id)initWithMain:(_Main*)m
{
	self = [super init];
	if( self != nil )
	{
		_m = m;

		_safari_view = nil;
	}
	return self;
}

- (void)dealloc
{
	if( _safari_view != nil)
	{
		_safari_view.delegate = nil;
#ifdef NO_OBJC_ARC
		[_safari_view release];
#endif // NO_OBJC_ARC
	}

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (void)openURL:(NSString*)url
{
	_safari_view = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
	_safari_view.delegate = self;
	[self presentViewController:_safari_view animated:YES completion:^{
		[_m _onSafariViewStart];
	}];
}

- (void)openResource:(NSString*)name
{
	NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
	if( path != nil )
	{
		_safari_view = [[SFSafariViewController alloc] initWithURL:[NSURL fileURLWithPath:path]];
		_safari_view.delegate = self;
		[self presentViewController:_safari_view animated:YES completion:^{
			[_m _onSafariViewStart];
		}];
	}
}

- (void)safariViewControllerDidFinish:(SFSafariViewController*)controller
{
	[self dismissViewControllerAnimated:YES completion:^{
		_safari_view.delegate = nil;
#ifdef NO_OBJC_ARC
		[_safari_view release];
#endif // NO_OBJC_ARC
		_safari_view = nil;

		[_m _onSafariViewFinish];
	}];
}

@end
