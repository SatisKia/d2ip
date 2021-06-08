/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@class _Main;

@interface _InAppPurchase : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
@private
	_Main* _m;
}

- (id)initWithMain:(_Main*)m;
- (BOOL)isAvailable;
- (void)purchase:(NSString*)identifier;
- (void)restore;

@end
