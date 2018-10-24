//
//  Start.h
//  BOB
//
//  Created by 汲群英 on 2018/8/31.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import <Foundation/Foundation.h>

#define StartSuccessNotificationName @"StartSuccessNotificationName"

@interface Start : NSObject

+ (void)start;

+ (BOOL)started;

@end
