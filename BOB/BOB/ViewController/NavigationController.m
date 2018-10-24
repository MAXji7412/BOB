//
//  NavigationController.m
//  BOB
//
//  Created by 汲群英 on 2018/9/21.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark event
- (void)onTabRepeatClick
{
    for (UIViewController *VC in self.viewControllers)
    {
        SEL onTabRepeatClickSel = NSSelectorFromString(@"onTabRepeatClick");
        if ([VC respondsToSelector:onTabRepeatClickSel])
        {
            IMP imp = [VC methodForSelector:onTabRepeatClickSel];
            void (* func)(id, SEL) = (void *)imp;
            func(VC, onTabRepeatClickSel);
        }
    }
}

@end
