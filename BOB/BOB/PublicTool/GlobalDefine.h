//
//  GlobalDefine.h
//  BOB
//
//  Created by 汲群英 on 2018/8/31.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h



#define CheckString(string) ([string isKindOfClass:NSString.class]?string:@"")

#define ArcColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]

#define ScreenSize [UIScreen mainScreen].bounds.size

#define StateBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

//navBar底端
#define NavMaxY ({UITabBarController *tabCon = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;\
UINavigationController *navCon = tabCon.viewControllers.firstObject;\
(navCon.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);})\

//tabBar顶端
#define TabBarH ({CGFloat tabH = 0;\
UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;\
if ([rootVC isKindOfClass:UITabBarController.class]) {\
UITabBarController *tabBarVC = (UITabBarController *)rootVC;\
tabH = tabBarVC.tabBar.bounds.size.height;}\
else if ([rootVC isKindOfClass:UINavigationController.class]){\
UINavigationController *navVC = (UINavigationController *)rootVC;\
UITabBarController *tabBarVC = navVC.viewControllers.firstObject;\
if ([tabBarVC isKindOfClass:UITabBarController.class]) {\
tabH = tabBarVC.tabBar.bounds.size.height;\
}}\
tabH;})\

//安全区
#define SafeAreaHeight ({ int tmp = 0;if (@available(iOS 11.0, *)) {tmp = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;}tmp;})



#endif /* GlobalDefine_h */
