//
//  ComponentDeviceInfo.h
//  BOB
//
//  Created by 汲群英 on 2018/10/18.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComponentDeviceInfo : NSObject

+ (void)deviceInfo:(NSDictionary *)param :(NSString *)callback :(WKWebView *)webview;


@end

NS_ASSUME_NONNULL_END
