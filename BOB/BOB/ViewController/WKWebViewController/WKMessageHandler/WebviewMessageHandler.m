//
//  WebviewMessageHandler.m
//  BOB
//
//  Created by 汲群英 on 2018/10/18.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "WebviewMessageHandler.h"

#import <WebKit/WebKit.h>

@interface WebviewMessageHandler ()<WKScriptMessageHandler>

@end

@implementation WebviewMessageHandler

#pragma mark main func
- (void)userContentController:(nonnull WKUserContentController *)userContentController
      didReceiveScriptMessage:(nonnull WKScriptMessage *)message
{
    BOBLog(@"%@",message.body);
    
    NSArray *messageArr = [self paramCheck:message];
    if (messageArr.count < 2)
    {
        return;
    }
    
    //分析参数，调用方法
    NSString *classStr = nil;
    NSString *funcStr = nil;
    NSDictionary *paramDic = nil;
    NSString *callbackStr = nil;
    
    for (NSString *message in messageArr)
    {
        NSInteger index = [messageArr indexOfObject:message];
        
        switch (index)
        {
                case 0:
            {
                classStr = CheckString(message);
                break;
            }
                case 1:
            {
                funcStr = [CheckString(message) stringByAppendingString:@":"];//添加固定参数(webview);
                break;
            }
                case 2:
            {
                funcStr = [funcStr stringByAppendingString:@":"];
                if ([message isKindOfClass:NSDictionary.class])
                {
                    paramDic = (NSDictionary *)message;
                }else if ([message isKindOfClass:NSString.class])
                {
                    callbackStr = message;
                }
                break;
            }
                case 3:
            {
                funcStr = [funcStr stringByAppendingString:@":"];
                callbackStr = CheckString(message);
                break;
            }
            default:
                break;
        }
    }
    
    Class component = NSClassFromString(classStr);
    SEL sel = NSSelectorFromString(funcStr);
    
    if (![component respondsToSelector:sel])
    {
        BOBLog(@"未找到类方法：%@，%@",NSStringFromClass(component),NSStringFromSelector(sel));
        return;
    }
    
    IMP imp = [component methodForSelector:sel];
    
    //判断有无入参、回调，然后调起方法
    if (paramDic && callbackStr)
    {
        void (* func)(Class, SEL, NSDictionary *, NSString *, WKWebView *) = (void *)imp;
        func(component, sel, paramDic, callbackStr, message.webView);
    }
    else if (paramDic)
    {
        void (* func)(Class, SEL, NSDictionary *, WKWebView *) = (void *)imp;
        func(component, sel, paramDic, message.webView);
    }
    else if (callbackStr)
    {
        void (* func)(Class, SEL, NSString *, WKWebView *) = (void *)imp;
        func(component, sel, callbackStr, message.webView);
    }
    else
    {
        void (* func)(Class, SEL, WKWebView *) = (void *)imp;
        func(component, sel, message.webView);
    }
    
}

//检查H5入参
- (NSArray *)paramCheck:(WKScriptMessage *)message
{
    if (!message.body || ![JsMessageName isEqualToString:message.name])
    {
        return nil;
    }
    
    NSArray *messageArr = message.body;
    
    if (![messageArr isKindOfClass:NSArray.class] || messageArr.count < 2) {
        return nil;
    }
    
    /*
     messageArr:[组件名，方法名，入参（nulllabel），回调函数id(nulllabel)]
     */
    
    NSMutableArray *messageArrM = [NSMutableArray arrayWithCapacity:messageArr.count];
    for (NSString *paramStr in messageArr)
    {
        if (![paramStr isKindOfClass:NSString.class] && ![paramStr isKindOfClass:NSDictionary.class])
        {
            continue;
        }
        
        [messageArrM addObject:paramStr];
    }
    
    return messageArrM;
}

@end
