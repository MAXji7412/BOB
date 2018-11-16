//
//  BOBTool.h
//  BOB
//
//  Created by 汲群英 on 2018/9/28.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOBTool : NSObject


/**
 根据16进制颜色格式字符串获取颜色

 @param colorString 16进制颜色格式字符串
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)colorString;


/**
 比较v2是否比v1大

 @param v1 版本号1
 @param v2 版本号2
 @return 如果版本号2大于版本号1就返回YES，否则返回NO
 */
+ (BOOL)compareVersion:(NSString *)v1 to:(NSString *)v2;

@end
