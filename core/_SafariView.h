/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <SafariServices/SafariServices.h>

@class _Main;

@interface _SafariView : UIViewController <SFSafariViewControllerDelegate>
{
@private
	_Main* _m;

	SFSafariViewController* _safari_view;
}

- (id)initWithMain:(_Main*)m;
- (void)openURL:(NSString*)url;

@end
