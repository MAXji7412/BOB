//
//  UIViewController+AdditionalFunc.m
//  BOB
//
//  Created by 汲群英 on 2018/11/7.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "UIViewController+AdditionalFunc.h"

#import "UIButton+ClickBlock.h"
#import "PanMoveView.h"
#import <objc/runtime.h>
#import "MethodSwizzle.h"

#define DismissBtnVisibleKey "DismissBtnVisibleKey"
#define BtnTag 0x1234

@implementation UIViewController (AdditionalFunc)

+ (void)load
{
    [MethodSwizzle swizzleInstanceMethodWithAClass:self.class instanceSelector:@selector(viewWillAppear:) BClass:self.class instanceSelector:@selector(swizzle_viewWillAppear:)];
}

- (void)swizzle_viewWillAppear:(BOOL)animated
{
    [self swizzle_viewWillAppear:animated];
    [self creatModalDismissButton];
}

- (void)setDismissBtnVisible:(BOOL)dismissBtnVisible
{
    objc_setAssociatedObject(self, DismissBtnVisibleKey, @(dismissBtnVisible), OBJC_ASSOCIATION_ASSIGN);
    if (dismissBtnVisible)
    {
        [self creatModalDismissButton];
    }
    else
    {
        [self removeDismissBtn];
    }
}

- (BOOL)dismissBtnVisible
{
    NSNumber *dismissBtnVisibleNumberValue = objc_getAssociatedObject(self, DismissBtnVisibleKey);
    return dismissBtnVisibleNumberValue.boolValue;
}

- (void)creatModalDismissButton
{
    if (!self.presentingViewController || !self.dismissBtnVisible)
    {
        return;
    }
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
    
    dismissBtn.tag = BtnTag;
    [dismissBtn setImage:[UIImage imageNamed:@"MotalVC_Close"] forState:0];
    dismissBtn.backgroundColor = ArcColor;
    dismissBtn.layer.cornerRadius = CGRectGetMidX(dismissBtn.bounds);
    
    __weak typeof(self) weakSelf = self;
    dismissBtn.click = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self.view addSubview:dismissBtn];
}

- (void)removeDismissBtn
{
    [[self.view viewWithTag:BtnTag] removeFromSuperview];;
}

@end
