/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface _ViewController : UIViewController

// _HttpRequest クラス用
- (void)_onHttpResponse:(NSData*)data;
- (void)_onHttpError:(int)status :(NSData*)data;

@end
