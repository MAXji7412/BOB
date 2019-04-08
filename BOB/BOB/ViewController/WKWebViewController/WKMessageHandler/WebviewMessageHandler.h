//
//  WebviewMessageHandler.h
//  BOB
//
//  Created by 汲群英 on 2018/10/18.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WebKit/WebKit.h>

#define JsMessageName @"bob"


NS_ASSUME_NONNULL_BEGIN

@interface WebviewMessageHandler : NSObject<WKScriptMessageHandler>


@end

NS_ASSUME_NONNULL_END
