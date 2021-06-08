/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Twitter/Twitter.h>

#import "_Twitter.h"

#import "_Canvas.h"
#import "_Main.h"

@implementation _Twitter

- (id)initWithMain:(_Main*)m
{
	self = [super init];
	if( self != nil )
	{
		_m = m;

		_account_store = [[ACAccountStore alloc] init];

		_accounts = nil;
	}
	return self;
}

#ifdef NO_OBJC_ARC
- (void)dealloc
{
	if( _accounts != nil )
	{
		[_accounts release];
	}

	[_account_store release];

	[super dealloc];
}
#endif // NO_OBJC_ARC

- (void)auth
{
	ACAccountType* type = [_account_store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	[_account_store requestAccessToAccountsWithType:type
		withCompletionHandler:^( BOOL granted, NSError* error ){
			if( granted )
			{
#ifdef NO_OBJC_ARC
				if( _accounts != nil )
				{
					[_accounts release];
				}
#endif // NO_OBJC_ARC
#ifdef NO_OBJC_ARC
				_accounts = [[_account_store accountsWithAccountType:type] retain];
#else
				_accounts = [_account_store accountsWithAccountType:type];
#endif // NO_OBJC_ARC
				if( [_accounts count] > 0 )
				{
					[_m _twitterAuthOK];
					if( [_m getCurrent] != nil )
					{
						[[_m getCurrent] _twitterAuthOK];
					}
				}
				else
				{
					[_m _twitterAuthNG];
					if( [_m getCurrent] != nil )
					{
						[[_m getCurrent] _twitterAuthNG];
					}
				}
			}
			else
			{
				[_m _twitterAuthNG];
				if( [_m getCurrent] != nil )
				{
					[[_m getCurrent] _twitterAuthNG];
				}
			}
		}];
}

- (int)getAccountNum
{
	if( _accounts == nil )
	{
		return 0;
	}
	return [_accounts count];
}
- (NSString*)getAccountID:(int)index
{
	if( _accounts == nil )
	{
		return nil;
	}
	return [(ACAccount*)[_accounts objectAtIndex:index] identifier];
}
- (NSString*)getAccountName:(int)index
{
	if( _accounts == nil )
	{
		return nil;
	}
	return [(ACAccount*)[_accounts objectAtIndex:index] username];
}

- (ACAccount*)getAccount:(NSString*)id
{
	return [_account_store accountWithIdentifier:id];
}

- (void)tweet:(ACAccount*)account :(NSString*)text
{
	TWRequest* request = [[TWRequest alloc]
		initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"]
		parameters:[NSDictionary dictionaryWithObject:text forKey:@"status"]
		requestMethod:TWRequestMethodPOST
		];
	[request setAccount:account];
	[request performRequestWithHandler:^( NSData* data, NSHTTPURLResponse* response, NSError* error ){
		if( [response statusCode] == 200 )
		{
			[_m _twitterTweetOK];
			if( [_m getCurrent] != nil )
			{
				[[_m getCurrent] _twitterTweetOK];
			}
		}
		else
		{
			[_m _twitterTweetNG:[response statusCode]];
			if( [_m getCurrent] != nil )
			{
				[[_m getCurrent] _twitterTweetNG:[response statusCode]];
			}
		}
#ifdef NO_OBJC_ARC
		[request release];
#endif // NO_OBJC_ARC
	}];
}

- (void)showTweetComposeView:(NSString*)text
{
	TWTweetComposeViewController* tweet = [[TWTweetComposeViewController alloc] init];
	[tweet setInitialText:text];
	tweet.completionHandler = ^( TWTweetComposeViewControllerResult result ){
		if( [_m getCurrent] != nil )
		{
			[[_m getCurrent] clearTouch];
		}

		[[_m getViewController] dismissModalViewControllerAnimated:YES];

		[_m _twitterCloseTweetComposeView];
		if( [_m getCurrent] != nil )
		{
			[[_m getCurrent] _twitterCloseTweetComposeView];
		}
	};

	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] clearTouch];
	}

	[[_m getViewController] presentModalViewController:tweet animated:YES];
#ifdef NO_OBJC_ARC
	[tweet release];
#endif // NO_OBJC_ARC
}

@end
