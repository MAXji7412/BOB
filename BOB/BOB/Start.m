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

@implementation Start

+ (void)start
{
    [self talkingdataStart];
}

+ (void)talkingdataStart
{
    [TalkingData setLogEnabled:NO];
    [TalkingData setExceptionReportEnabled:YES];//捕捉崩溃
    [TalkingData setSignalReportEnabled:YES];//异常信号
    [TalkingData sessionStarted:@"79997EA2B662472F88ED0EB267A0AFD7" withChannelId:@"safari"];
    
    [TalkingData setGlobalKV:@"deviceName" value:[DeviceRelevant getDeviceInfo][@"deviceName"]];
    
    [TalkingData trackEvent:@"BOB启动"];
}

@end