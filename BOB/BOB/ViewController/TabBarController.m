//
//  TabBarController.m
//  BOB
//
//  Created by 汲群英 on 2018/9/20.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import "TabBarController.h"

#import "AppDelegate.h"
#import "MusicPlayViewController.h"
#import "ShaTanViewController.h"
#import "NavigationController.h"
#import "WKWebViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

+ (instancetype)share
{
    static TabBarController *tabInstance;
    static BOOL falg = YES;
    
    if (falg) {
        falg = NO;
        tabInstance = [self new];
    }
    
    return tabInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NavigationController *tabNC0 = [[NavigationController alloc] initWithRootViewController:[MusicPlayViewController new]];
    tabNC0.tabBarItem.image = [UIImage imageNamed:@"tab_niu"];
//    tabNC0.tabBarItem.badgeValue = @"bob";
    
    
    UIViewController *tuziVC = [UIViewController new];
    
    tuziVC.title = @"bob";
    NavigationController *tabNC1 = [[NavigationController alloc] initWithRootViewController:tuziVC];
    tabNC1.tabBarItem.image = [UIImage imageNamed:@"tab_tuzi"];
    
    
    WKWebViewController *shatanVC = [ShaTanViewController new];
    shatanVC.title = @"🏖🏖🏖";
    NavigationController *tabNC2 = [[NavigationController alloc] initWithRootViewController:shatanVC];
    tabNC2.tabBarItem.image = [UIImage imageNamed:@"tab_shatan"];
    
    
    
    
    
    
    NSArray *viewControllers = @[tabNC0,tabNC1,tabNC2];
    
    for (NavigationController *tabVC in viewControllers) {
        
        [tabVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}
                                        forState:UIControlStateSelected];
        [tabVC.tabBarItem setTitleTextAttributes:@{NSBackgroundColorAttributeName:[UIColor orangeColor]}
                                        forState:UIControlStateNormal];
        
    }
    
    self.tabBar.barStyle = UIBarStyleBlack;
    self.tabBar.tintColor = ArcColor;
//    self.tabBar.barTintColor = ArcColor;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setViewControllers:viewControllers animated:YES];
    });
    
}








@end
