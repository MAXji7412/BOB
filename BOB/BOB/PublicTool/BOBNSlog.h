//
//  BOBNSLog.h
//  BOB
//
//  Created by 汲群英 on 2018/10/11.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BOBLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
NS_ASSUME_NONNULL_BEGIN

@interface BOBNSLog : NSObject

@end

NS_ASSUME_NONNULL_END
