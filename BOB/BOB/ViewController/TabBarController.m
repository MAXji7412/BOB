//
//  TabBarController.m
//  BOB
//
//  Created by 汲群英 on 2018/9/20.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import "TabBarController.h"

#import "AppDelegate.h"
#import "TabViewController.h"
#import "MusicPlayViewController.h"

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
    // Do any additional setup after loading the view.
    MusicPlayViewController *tabVC0 = [MusicPlayViewController new];
    tabVC0.tabBarItem.image = [UIImage imageNamed:@"tab_niu"];
    tabVC0.tabBarItem.badgeValue = @"bob";
    
    TabViewController *tabVC1 = [TabViewController new];
    tabVC1.tabBarItem.title = @"灯泡";
    tabVC1.tabBarItem.image = [UIImage imageNamed:@"tab_tuzi"];
    
    TabViewController *tabVC2 = [TabViewController new];
    tabVC2.tabBarItem.title = @"🏖";
    tabVC2.tabBarItem.image = [UIImage imageNamed:@"tab_shatan"];
    
    NSArray *viewControllers = @[tabVC0,tabVC1,tabVC2];
    
    for (TabViewController *tabVC in viewControllers) {
        
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
    
//    self.navigationController.navigationBarHidden = NO;
    
    
}




@end
