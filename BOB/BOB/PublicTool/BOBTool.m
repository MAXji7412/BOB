//
//  BOBTool.m
//  BOB
//
//  Created by 汲群英 on 2018/9/28.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import "BOBTool.h"

@implementation BOBTool

+ (UIColor *)colorWithHexString:(NSString *)colorString
{
    if (![CheckString(colorString) hasPrefix:@"#"]) {
        return nil;
    }
    
    colorString = [colorString.copy substringFromIndex:1];
    
    if (colorString.length != 6 && colorString.length != 8) {
        return nil;
    }
    
    unsigned int r,g,b,a;
    
    //16进制转10进制
    [[NSScanner scannerWithString:[colorString substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&r];
    [[NSScanner scannerWithString:[colorString substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&g];
    [[NSScanner scannerWithString:[colorString substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&b];
    
    if (colorString.length == 8) {
        [[NSScanner scannerWithString:[colorString substringWithRange:NSMakeRange(6, 2)]] scanHexInt:&a];
    }else
    {
        a = 255;
    }
    
    
    UIColor *color = [UIColor colorWithRed:(r/255.0)
                                     green:(g/255.0)
                                      blue:(b/255.0)
                                     alpha:(a/255.0)];
    
    return color;
}

+ (BOOL)compareVersion:(NSString *)v1 andNewStr: (NSString *)v2
{
    if (![v1 isKindOfClass:NSString.class] || ![v2 isKindOfClass:NSString.class]) {
        return NO;
    }
    return ([v1 compare:v2 options:NSNumericSearch] == NSOrderedAscending);
}

@end
