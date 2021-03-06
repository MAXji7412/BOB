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
#import "JoeyViewController.h"
#import "Start.h"

@interface TabBarController ()

@end

@implementation TabBarController


#pragma mark controller life
+ (instancetype)share
{
    static TabBarController *tabInstance;
    static BOOL falg = YES;
    
    @synchronized (self)
    {
        if (falg) {
            falg = NO;
            tabInstance = [self new];
        }
    }
    
    return tabInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.barStyle = UIBarStyleBlack;
    
    //将viewcontroller设置到tabbar，需要keywindow，检查启动是否完成
    [Start start:^{
        self.viewControllers = [self seekViewControllers];
    }];
}

- (NSArray *)seekViewControllers
{
    //1
    NavigationController *tabNC0 = [[NavigationController alloc] initWithRootViewController:[MusicPlayViewController new]];
    tabNC0.tabBarItem.title = @"音乐";
    tabNC0.tabBarItem.image = [[UIImage imageNamed:@"music"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //2
    NavigationController *tabNC1 = [[NavigationController alloc] initWithRootViewController:[JoeyViewController new]];
    tabNC1.tabBarItem.title = @"joey";
    tabNC1.tabBarItem.image = [[UIImage imageNamed:@"peace"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //3
    NavigationController *tabNC2 = [[NavigationController alloc] initWithRootViewController:[ShaTanViewController new]];
    tabNC2.tabBarItem.title = @"沙滩";
    tabNC2.tabBarItem.image = [[UIImage imageNamed:@"tab_shatan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return @[tabNC0, tabNC1, tabNC2];
}

#pragma mark event
- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController
{
    //如果当前控制器不是选择的控制器，让选择的控制器成为当前控制器。否则，发送自定义控制器点击事件
    if (![selectedViewController isEqual:self.selectedViewController])
    {
        [super setSelectedViewController:selectedViewController];
    }
    else
    {
        SEL onTabRepeatClick = NSSelectorFromString(@"onTabRepeatClick");
        if ([selectedViewController respondsToSelector:onTabRepeatClick])
        {
            IMP imp = [selectedViewController methodForSelector:onTabRepeatClick];
            void (* func) (id, SEL) = (void *)imp;
            func(selectedViewController, onTabRepeatClick);
        }
    }
}


@end
