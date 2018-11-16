//
//  Start.h
//  BOB
//
//  Created by 汲群英 on 2018/8/31.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^StartComplete)(void);

@interface Start : NSObject



/**
 启动

 @param complete 启动完成之后的回调，如已完成则直接回调
 */
+ (void)start:(StartComplete)complete;

@end
