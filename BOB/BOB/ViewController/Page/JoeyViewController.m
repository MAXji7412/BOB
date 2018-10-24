//
//  JoeyViewController.m
//  BOB
//
//  Created by 汲群英 on 2018/10/19.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "JoeyViewController.h"

#import "TouchMoveImageView.h"

@interface JoeyViewController ()

@property (strong) TouchMoveImageView *joeyImageV;

@end

@implementation JoeyViewController


#pragma mark controller life
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self displayJoeyImage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self disMissJoeyImage:nil];
}

#pragma mark Joey View
- (void)displayJoeyImage
{
    if (!self.joeyImageV)
    {
        self.joeyImageV = [TouchMoveImageView new];
        self.joeyImageV.crossJudgment = YES;
        self.joeyImageV.contentMode = UIViewContentModeScaleAspectFit;
        self.joeyImageV.layer.shadowColor = ArcColor.CGColor;
    }
    
    if (!self.joeyImageV.superview)
    {
        CGFloat X, Y, W, H;
        W = 150;
        H = 140;
        X = ScreenSize.width *(1 - 0.618) - W/2;
        Y = (ScreenSize.height - NavMaxY) *(1 - 0.618) - H/2;
        
        self.joeyImageV.frame = CGRectMake( X, Y, W, H);
        [self.view addSubview:self.joeyImageV];
    }
    
    self.joeyImageV.image = [UIImage imageNamed:[self getImageName]];
    self.joeyImageV.alpha = 0;
    [UIView animateWithDuration:.55 animations:^{
        self.joeyImageV.alpha = 1;
        self.joeyImageV.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    }];
}

- (NSString *)getImageName
{
    NSArray *imageNames = @[@"joey",@"joey1",@"joey2",@"joey3"];
    
    NSInteger imageIndex = arc4random() % 4;
    
    BOBLog(@"%d",(int)imageIndex);
    
    return imageNames[imageIndex];
}

- (void)disMissJoeyImage:(void(^)(void))complete
{
    [UIView animateWithDuration:.25 animations:^{
        
        self.joeyImageV.alpha = 0;
        self.joeyImageV.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:^(BOOL finished) {
        
        [self.joeyImageV removeFromSuperview];
        if (complete)
        {
            complete();
        }
    }];
}

#pragma mark event

- (void)onTabRepeatClick
{
    [self disMissJoeyImage:^{
        [self displayJoeyImage];
    }];
}

@end
