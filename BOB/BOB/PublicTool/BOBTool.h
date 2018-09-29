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

@end
