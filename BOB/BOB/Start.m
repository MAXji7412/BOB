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

@implementation Start

+ (void)start
{
    //系统设置
    [self sysConfig];
    
    //展示KeyWindow
    [self makeMainWindow];
    
    //启动数据采集
    [self talkingdataStart];
}

+ (void)talkingdataStart
{
    [TalkingData setLogEnabled:NO];
    [TalkingData setExceptionReportEnabled:YES];//捕捉崩溃
    [TalkingData setSignalReportEnabled:YES];//异常信号
    [TalkingData sessionStarted:@"79997EA2B662472F88ED0EB267A0AFD7" withChannelId:@"safari"];
    [TalkingData setGlobalKV:@"deviceName" value:CheckString([DeviceRelevant getDeviceModelName])];
    
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

@end
