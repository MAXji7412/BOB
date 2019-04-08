//
//  JoeyViewController.m
//  BOB
//
//  Created by 汲群英 on 2018/10/19.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "JoeyViewController.h"

#import "PanMoveWindow.h"
#import "BezierViewController.h"
#import "WKWebViewController.h"
#import <AVKit/AVKit.h>
#import "FingerEvaluateManager.h"

@interface JoeyViewController ()

@property (nonatomic, strong) PanMoveWindow *panWin;
@property (nonatomic, strong) UIVisualEffectView *joeyView;
@property (nonatomic, strong) UIImageView *joeyImageView;
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation JoeyViewController


#pragma mark controller life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ArcColor;
    
    [self playGTR];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.player pause];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.player play];
}

- (void)dealloc
{
    [self.player pause];
    self.player = nil;
}

#pragma mark event
- (void)onTabRepeatClick
{
    [self dismissJoeyImage:^{
        [self displayJoeyImage:nil];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [FingerEvaluateManager evaluateWithComplete:^(BOOL success, EvaluateError err)
     {
         if (err == EvaluateError_UserCancel)
         {
             return;
         }
         
         BezierViewController *bezierVC = [BezierViewController new];
         bezierVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         bezierVC.dismissBtnVisible = YES;
//         bezierVC.hidesBottomBarWhenPushed = YES;
         
//             [self presentViewController:bezierVC animated:YES completion:nil];
         [self.navigationController pushViewController:bezierVC animated:YES];
         
     }];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event
{
    [self dismissJoeyImage:^{
        [self displayJoeyImage:nil];
    }];
}

#pragma mark joey show

- (void)displayJoeyImage:(void(^)(void))complete
{
    if (!self.joeyImageView.superview)
    {
        [self.panWin addSubview:self.joeyImageView];
    }
    
    self.joeyImageView.image = [UIImage imageNamed:[self getImageName]];
    
    self.panWin.hidden = NO;
    self.panWin.alpha = 0;
    self.panWin.transform = CGAffineTransformScale(CGAffineTransformIdentity, .3, .3);
    [UIView animateWithDuration:.15 animations:^{
        
        self -> _panWin.alpha = 1;
        self -> _panWin.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.07 animations:^{
            
            self -> _panWin.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        } completion:^(BOOL finished) {
            
            if (!self.joeyView.superview)
            {
                [self -> _panWin insertSubview:self -> _joeyView belowSubview:self -> _joeyImageView];
            }
            if (complete) complete();
        }];
        
    }];
}

- (NSString *)getImageName
{
    NSArray *imageNames = @[@"joey",@"joey1",@"joey2",@"joey3"];
    
    return imageNames[(arc4random() % imageNames.count)];
}

- (void)dismiss
{
    [self dismissJoeyImage:nil];
}

- (void)dismissJoeyImage:(void(^)(void))complete
{
    [UIView animateWithDuration:.2 animations:^{
        
        self -> _panWin.alpha = 0;
    } completion:^(BOOL finished) {
        [self -> _joeyView removeFromSuperview];
        self -> _panWin.hidden = YES;
        if (complete) complete();
    }];
}

#pragma mark GTR show

- (void)playGTR
{
    NSURL *videoUrl = [[NSBundle mainBundle] URLForResource:@"GTR" withExtension:@"mp4"];
    self.player = [AVPlayer playerWithURL:videoUrl];
    
    //player图层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    playerLayer.frame = CGRectMake(0, NavMaxY, CGRectGetWidth(self.view.bounds), 240);
    
    playerLayer.masksToBounds = YES;
    playerLayer.cornerRadius = 20.0f;
    
    //设置模式
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.view.layer addSublayer:playerLayer];
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note)
     {
         [playerLayer removeFromSuperlayer];
     }];
}

#pragma Lazy load
- (PanMoveWindow *)panWin
{
    if (_panWin)
    {
        return _panWin;
    }
    
    CGFloat X, Y, W, H;
    W = 150;
    H = 150;
    X = ScreenSize.width *(1 - 0.618) - W/2;
    Y = (ScreenSize.height - NavMaxY) *(1 - 0.618) - H/2;
    _panWin = [[PanMoveWindow alloc] initWithFrame:CGRectMake(X, Y, W, H)];
    
    _panWin.layer.masksToBounds = YES;
    _panWin.layer.cornerRadius = MIN(W, H)/2;
    _panWin.crossJudgment = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_panWin addGestureRecognizer:tap];
    
    return _panWin;
}

- (UIVisualEffectView *)joeyView
{
    if (_joeyView)
    {
        return _joeyView;
    }
    
    UIBlurEffect *eff = [UIBlurEffect effectWithStyle:1];
    _joeyView = [[UIVisualEffectView alloc] initWithEffect:eff];
    
    _joeyView.frame = self.panWin.bounds;
    
    return _joeyView;
}

- (UIImageView *)joeyImageView
{
    if (_joeyImageView)
    {
        return _joeyImageView;
    }
    
    _joeyImageView = [[UIImageView alloc] initWithFrame:self.joeyView.bounds];
    _joeyImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return _joeyImageView;
}

@end
