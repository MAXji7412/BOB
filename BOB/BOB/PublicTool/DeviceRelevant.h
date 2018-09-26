//
//  DeviceRelevant.h
//  BOB
//
//  Created by ying on 2017/11/1.
//  Copyright © 2017年 qunyingji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceRelevant : NSObject

+ (NSDictionary *)getDeviceInfo;

+ (NSString *)getDeviceModelName;

@end
