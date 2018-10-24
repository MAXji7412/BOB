//
//  DirectTool.m
//  BOB
//
//  Created by 汲群英 on 2018/10/22.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "DirectTool.h"

#import "TabBarController.h"

@implementation DirectTool

+ (BOOL)shortHandle:(UIApplicationShortcutItem *)shortItem API_AVAILABLE(ios(9.0))
{
    if (!shortItem || !shortItem.userInfo)
    {
        return NO;
    }
    
    //判断功能分类
    if ([shortItem.userInfo.allKeys containsObject:ShortSeletViewControllerKey])
    {
        //判断要跳转的控制器
        return [self seletViewControllerWithIndexStr:(NSString *)[shortItem.userInfo objectForKey:ShortSeletViewControllerKey]];
    }
    
    return NO;
}

//根据名字跳转控制器
+ (BOOL)seletViewControllerWithIndexStr:(NSString *)viewControllerIndexStr
{
    if (![viewControllerIndexStr isKindOfClass:NSString.class])
    {
        return NO;
    }
    
    NSInteger tabIndex = viewControllerIndexStr.integerValue;
    
    if (tabIndex > 0)
    {
        [TabBarController share].selectedIndex = tabIndex;
        return YES;
    }
    
    return NO;
}

@end
