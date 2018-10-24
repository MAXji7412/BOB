//
//  Start.m
//  BOB
//
//  Created by 汲群英 on 2018/8/31.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import "Start.h"

#import "TalkingData.h"
#import "DeviceRelevant.h"
#import "TabBarController.h"
#import "AppDelegate.h"
#import "DirectTool.h"

@implementation Start

static BOOL _started;

+ (BOOL)started
{
    return _started;
}

+ (void)start
{
    if (_started) return;
    
    //系统设置
    [self sysConfig];
    
    //展示KeyWindow
    [self makeMainWindow];
    
    //启动数据采集
    [self talkingdataStart];
    
    //SVPconfig
    [self svpConfig];
    
    //3D touch配置
    [self config3Dtouch];
    
    //启动完毕发送通知
    _started = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:StartSuccessNotificationName object:nil];
}

+ (void)config3Dtouch
{
    if (@available(iOS 9.0, *)) {
        NSMutableArray *arrShortcutItem = [NSMutableArray array];
        
        UIApplicationShortcutItem *shoreJeoy = [[UIApplicationShortcutItem alloc] initWithType:@"joey" localizedTitle:@"Jeoy" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"3dtouch_beauty"] userInfo:@{ShortSeletViewControllerKey:@"1"}];
        [arrShortcutItem addObject:shoreJeoy];
        
        UIApplicationShortcutItem *shoreWeb = [[UIApplicationShortcutItem alloc] initWithType:@"shatan" localizedTitle:@"🏖" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"3dtouch_shatan"] userInfo:@{ShortSeletViewControllerKey:@"2"}];
        [arrShortcutItem addObject:shoreWeb];
        
        [UIApplication sharedApplication].shortcutItems = arrShortcutItem;
    }
}

+ (void)talkingdataStart
{
    [TalkingData setLogEnabled:NO];
    [TalkingData setExceptionReportEnabled:YES];//捕捉崩溃
    [TalkingData setSignalReportEnabled:YES];//异常信号
    [TalkingData setGlobalKV:@"deviceName" value:CheckString([DeviceRelevant getDeviceModelName])];
    
    //启动
//    [TalkingData sessionStarted:@"79997EA2B662472F88ED0EB267A0AFD7" withChannelId:@"safari"];
    
    [TalkingData trackEvent:@"BOB启动"];
}

+ (void)sysConfig
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

+ (void)makeMainWindow
{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appdel.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    appdel.window. backgroundColor = [DeviceRelevant deviceColor];
    
    appdel.window.rootViewController = [TabBarController share];
    
    [appdel.window makeKeyAndVisible];
}

+ (void)svpConfig
{
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setMaximumDismissTimeInterval:15];
}

@end
