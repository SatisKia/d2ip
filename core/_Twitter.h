/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Accounts/Accounts.h>
#import <Foundation/Foundation.h>

@class _Main;

@interface _Twitter : NSObject
{
@private
	_Main* _m;

	ACAccountStore* _account_store;
	NSArray* _accounts;
}

- (id)initWithMain:(_Main*)m;
- (void)auth;
- (int)getAccountNum;
- (NSString*)getAccountID:(int)index;
- (NSString*)getAccountName:(int)index;
- (ACAccount*)getAccount:(NSString*)id;
- (void)tweet:(ACAccount*)account :(NSString*)text;
- (void)showTweetComposeView:(NSString*)text;

@end
