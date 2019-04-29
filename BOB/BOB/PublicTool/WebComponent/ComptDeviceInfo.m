//
//  ComponentDeviceInfo.m
//  BOB
//
//  Created by 汲群英 on 2018/10/18.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "CompDeviceInfo.h"

#import "DeviceRelevant.h"

@implementation ComponentDeviceInfo

+ (void)deviceInfo:(NSDictionary *)param :(NSString *)callback :(WKWebView *)webview
{
    NSDictionary *deviceInfo = [DeviceRelevant getDeviceInfo];
    
    NSString *json = [deviceInfo conversionToJson];
    
    NSString *jsCode = [NSString stringWithFormat:@"bobAlert('%@')",json];
    
    [webview evaluateJavaScript:jsCode completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
        BOBLog(@"%@",obj);
    }];
    
}

@end
