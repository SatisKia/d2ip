/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_InAppPurchase.h"

#import "_Canvas.h"
#import "_Main.h"

@implementation _InAppPurchase

- (id)initWithMain:(_Main*)m
{
	self = [super init];
	if( self != nil )
	{
		_m = m;
	}
	return self;
}

/*
 * In-App Purchase が使えるかチェック
 */
- (BOOL)isAvailable
{
	return [SKPaymentQueue canMakePayments];
}

/*
 * プロダクトの購入
 */
- (void)purchase:(NSString*)identifier
{
	// リクエスト
	NSSet* set = [NSSet setWithObjects:identifier, nil];
	SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
	productsRequest.delegate = self;
	[productsRequest start];
}
- (void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response
{
	// 無効なプロダクトがないかチェック
	for( NSString* identifier in response.invalidProductIdentifiers )
	{
		[_m _inAppPurchaseInvalid:identifier];
		if( [_m getCurrent] != nil )
		{
			[[_m getCurrent] _inAppPurchaseInvalid:identifier];
		}
		return;
	}

	// 購入処理の開始
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	for( SKProduct* product in response.products )
	{
		SKPayment* payment = [SKPayment paymentWithProduct:product];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
}
- (void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray*)transactions
{
	for( SKPaymentTransaction* transaction in transactions )
	{
		switch( transaction.transactionState )
		{
		case SKPaymentTransactionStatePurchasing:
			break;
		case SKPaymentTransactionStatePurchased:
			[_m _inAppPurchasePurchaseOK:transaction.payment.productIdentifier :transaction.transactionReceipt];
			if( [_m getCurrent] != nil )
			{
				[[_m getCurrent] _inAppPurchasePurchaseOK:transaction.payment.productIdentifier :transaction.transactionReceipt];
			}

			[queue finishTransaction:transaction];

			break;
		case SKPaymentTransactionStateRestored:
			[_m _inAppPurchaseRestoreOK:transaction.payment.productIdentifier];
			if( [_m getCurrent] != nil )
			{
				[[_m getCurrent] _inAppPurchaseRestoreOK:transaction.payment.productIdentifier];
			}

			[queue finishTransaction:transaction];

			break;
		case SKPaymentTransactionStateFailed:
			if( transaction.error.code == SKErrorPaymentCancelled )
			{
				[_m _inAppPurchaseCancelled:transaction.payment.productIdentifier];
				if( [_m getCurrent] != nil )
				{
					[[_m getCurrent] _inAppPurchaseCancelled:transaction.payment.productIdentifier];
				}
			}
			else
			{
				[_m _inAppPurchasePurchaseNG:transaction.payment.productIdentifier];
				if( [_m getCurrent] != nil )
				{
					[[_m getCurrent] _inAppPurchasePurchaseNG:transaction.payment.productIdentifier];
				}
			}

			[queue finishTransaction:transaction];

			break;
		}
	}
}
- (void)paymentQueue:(SKPaymentQueue*)queue removedTransactions:(NSArray*)transactions
{
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

/*
 * プロダクトのリストア
 */
- (void)restore
{
	// リストアの開始
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
- (void)paymentQueue:(SKPaymentQueue*)queue restoreCompletedTransactionsFailedWithError:(NSError*)error
{
	// リストアの失敗
	[_m _inAppPurchaseRestoreNG];
	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] _inAppPurchaseRestoreNG];
	}
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue*)queue
{
	// 全てのリストア処理が終了
	[_m _inAppPurchaseRestoreCompleted];
	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] _inAppPurchaseRestoreCompleted];
	}
}

@end
