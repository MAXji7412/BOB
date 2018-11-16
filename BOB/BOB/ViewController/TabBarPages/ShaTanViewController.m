//
//  ShaTanViewController.m
//  BOB
//
//  Created by 汲群英 on 2018/9/21.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import "ShaTanViewController.h"

#import "TabBarController.h"

#define WebsitesDicKey @"WebsitesDicKey"

@interface ShaTanViewController ()

@end

@implementation ShaTanViewController

#pragma mark controller life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webview.scrollView.contentInset = UIEdgeInsetsMake(NavMaxY, 0, TabBarH, 0);
    self.urlStr = self.websitesDicM.allValues.firstObject;
    [self loadRequest];
}

@end
