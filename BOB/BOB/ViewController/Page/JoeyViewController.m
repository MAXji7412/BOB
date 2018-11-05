//
//  JoeyViewController.m
//  BOB
//
//  Created by 汲群英 on 2018/10/19.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "JoeyViewController.h"

#import "PanMoveWindow.h"

@interface JoeyViewController ()

@property (strong) UIImageView *joeyImageV;
@property (strong) PanMoveWindow *panWin;

@end

@implementation JoeyViewController


#pragma mark controller life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatWindow];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self displayJoeyImage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark Joey View

- (void)creatWindow
{
    if (self.panWin) {
        return;
    }
    
    CGFloat X, Y, W, H;
    W = 150;
    H = 140;
    X = ScreenSize.width *(1 - 0.618) - W/2;
    Y = (ScreenSize.height - NavMaxY) *(1 - 0.618) - H/2;
    self.panWin = [[PanMoveWindow alloc] initWithFrame:CGRectMake(X, Y, W, H)];
    
    self.panWin.layer.masksToBounds = YES;
    self.panWin.layer.cornerRadius = MIN(W, H)/2;
    self.panWin.crossJudgment = YES;
//    self.panWin.windowLevel = MAXFLOAT;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.panWin addGestureRecognizer:tap];
}

- (void)displayJoeyImage
{
    if (!self.joeyImageV)
    {
        self.joeyImageV = [UIImageView new];
        
        self.joeyImageV.contentMode = UIViewContentModeScaleAspectFit;
        self.joeyImageV.layer.shadowColor = ArcColor.CGColor;
    }
    
    if (!self.joeyImageV.superview)
    {
        self.joeyImageV.frame = self.panWin.bounds;
        
        [self.panWin addSubview:self.joeyImageV];
    }
    self.panWin.hidden = NO;
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

- (void)dismiss
{
    [self disMissJoeyImage:nil];
}

- (void)disMissJoeyImage:(void(^)(void))complete
{
    [UIView animateWithDuration:.2 animations:^{
        
        self.joeyImageV.alpha = 0;
        self.joeyImageV.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:^(BOOL finished) {
        
        self.panWin.hidden = YES;
        if (complete) complete();
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
