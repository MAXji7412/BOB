//
//  MusicPlayViewController.m
//  BOB
//
//  Created by 汲群英 on 2018/9/20.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import "MusicPlayViewController.h"

#import "TabBarController.h"
#import <AVFoundation/AVFoundation.h>
#import "GlobalDefine.h"
#import <UIKit/UIKit.h>
#import "PlayTool.h"

#define ExcessTag 50

@interface MusicPlayViewController ()<AVAudioPlayerDelegate,UIScrollViewDelegate>
{
    NSTimer *_timer;
    UIScrollView *scrollV;
    NSArray<NSDictionary *> *musicDataArr;
    UIImageView *dynamicEffectImage;
}

@property (assign) NSInteger currentMusicIndex;//scrollview位置

@end

@implementation MusicPlayViewController

#pragma mark ViewControllerLife



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self defalutConfig];//默认配置
    [self creatScrollView];//播放视图
    [self creatAudience];
    
}


- (void)defalutConfig{
    self.view.backgroundColor = ArcColor;
    
    musicDataArr = [PlayTool getMusicData];
    if (!musicDataArr.count) {
        [SVProgressHUD showErrorWithStatus:@"资源错误"];
    }
    [self registeredKVO];//监听属性变化
}


#pragma mark KVO,图片旋转、滑动换音乐
- (void)registeredKVO{
    [self addObserver:self forKeyPath:@"self.currentMusicIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.currentMusicIndex"])//换歌
    {
        if (!musicDataArr.count) {
            [SVProgressHUD showErrorWithStatus:@"资源错误"];
            return;
        }
        
        NSInteger oldPage = [change[@"old"] integerValue];
        if ((_currentMusicIndex == oldPage) && [PlayTool getPlayer]) {
            
            return ;
        }
        if ((_currentMusicIndex >= musicDataArr.count) || _currentMusicIndex < 0 ) {
            _currentMusicIndex = 0;
        }
        [self reductionCurrentImageAngle:oldPage];
        NSDictionary *musicDic = musicDataArr[_currentMusicIndex];
        
        [self playMusic:musicDic];
        
        [UIView animateWithDuration:.3 animations:^{
            [scrollV setContentOffset:CGPointMake(_currentMusicIndex*ScreenSize.width, 0)];
        }];
    }
    
}

- (void)playMusic:(NSDictionary *)musicDic
{
    NSError *err = [PlayTool playByMusicInfo:musicDic delegate:self];
    NSString *name = musicDic[MusicNeme];
    self.title = name;
    if (!err) {
        
        [self palyResume];
        [SVProgressHUD showImage:nil status:name];
        [TalkingData trackEvent:@"musicPlay" label:name];
    }else{
        
        [SVProgressHUD showErrorWithStatus:err.description];
        [TalkingData trackEvent:@"musicPlay_Error"
                          label:name
                     parameters:@{
                                  @"error":err.description,
                                  @"path":CheckString(musicDic[MusicUrl])
                                  }];
    }
}

#pragma mark ScrollView
- (void)creatScrollView{
    scrollV = [[UIScrollView alloc] initWithFrame:self.view.frame];
    
    scrollV.contentSize = CGSizeMake(scrollV.bounds.size.width * musicDataArr.count, 0);
    scrollV.delegate = self;
    scrollV.bounces = YES;
    scrollV.pagingEnabled = YES;
    if (@available(iOS 11.0, *)) {
        scrollV.contentInsetAdjustmentBehavior = YES;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.showsVerticalScrollIndicator = NO;
    
    for (NSDictionary *musicDic in musicDataArr) {
        
        CGFloat orignX = [musicDataArr indexOfObject:musicDic] *scrollV.bounds.size.width;
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(orignX+50,
                                                                            164,
                                                                            200,
                                                                            200)];
        
        imageV.tag = [musicDataArr indexOfObject:musicDic] + ExcessTag;
        imageV.layer.cornerRadius = 10;
        imageV.layer.masksToBounds = NO;
        
        imageV.layer.shadowOpacity = 0.8;
        imageV.layer.shadowColor = ArcColor.CGColor;
        imageV.layer.shadowRadius = 10;
        
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.userInteractionEnabled = YES;
        [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(musicIconClick:)]];
        
        UIImage *image = musicDic[MusicImage];
        if (!image) {
            imageV.backgroundColor = ArcColor;
        }else{
            imageV.image = image;
        }
        [scrollV addSubview:imageV];
    }
    
    [self.view addSubview:scrollV];
}

#pragma mark 听众
//创建
- (void)creatAudience{
    if (dynamicEffectImage) {
        return;
    }
    
    CGSize imageSize = CGSizeMake(100, 100);
    
    NSArray *imageNameArr = @[@"dongdong1",@"dongdong2",@"dongdong3"];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:imageNameArr.count];
    for (NSString *imageName in imageNameArr) {
        
        NSString *imageName_scale = [NSString stringWithFormat:@"%@@%dx.tiff",imageName,(int)[UIScreen mainScreen].scale];
        UIImage *image = [UIImage imageNamed:imageName_scale];
        if (image) {
            [images addObject:image];
        }
    }
    
    
    CGFloat Y = ScreenSize.height - imageSize.height - CGRectGetHeight([TabBarController share].tabBar.bounds);
    dynamicEffectImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, Y, imageSize.width, imageSize.height)];
    
    dynamicEffectImage.layer.masksToBounds = NO;
    dynamicEffectImage.animationImages = images;
    dynamicEffectImage.contentMode = UIViewContentModeCenter;
    dynamicEffectImage.animationDuration = .4;
    [dynamicEffectImage startAnimating];
    
    [self.view addSubview:dynamicEffectImage];
    
    [self audiencePause];
}

//继续
- (void)audienceContinue
{
    if (dynamicEffectImage.layer.speed == 1) {
        return;
    }
    
    // 动画的暂停时间
    CFTimeInterval pausedTime = dynamicEffectImage.layer.timeOffset;
    // 动画初始化
    dynamicEffectImage.layer.speed = 1;
    dynamicEffectImage.layer.timeOffset = 0;
    //    dynamicEffectImage.layer.beginTime = 0;
    // 程序到这里，动画就能继续进行了，但不是连贯的，而是动画在背后默默“偷跑”的位置，如果超过一个动画周期，则是初始位置
    // 当前时间（恢复时的时间）
    CFTimeInterval continueTime = [dynamicEffectImage.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 暂停到恢复之间的空档
    CFTimeInterval timePause = continueTime - pausedTime;
    // 动画从timePause的位置从动画头开始
    dynamicEffectImage.layer.beginTime = timePause;
}

//暂停
- (void)audiencePause
{
    CFTimeInterval pauseTime = [dynamicEffectImage.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 停止动画
    dynamicEffectImage.layer.speed = 0;
    // 动画的位置（动画进行到当前时间所在的位置，如timeOffset=1表示动画进行1秒时的位置）
    dynamicEffectImage.layer.timeOffset = pauseTime;
}



//图片点击事件
- (void)musicIconClick:(UITapGestureRecognizer *)tap{
    if (![PlayTool getPlayer]) {
        self.currentMusicIndex = 0;
        return;
    }
    
    if ([PlayTool getPlayer].playing)//播放--》暂停
    {
        [self playSuspend];
        
    }else//暂停--》播放
    {
        
        [self palyResume];
        
    }
    
    //    tap.view
    
}

//播放
- (void)palyResume
{
    [PlayTool play];
    [self creatTimer];
    _timer.fireDate = [NSDate date];
    [self audienceContinue];
    
}

//暂停
- (void)playSuspend
{
    _timer.fireDate = [NSDate distantFuture];
    [PlayTool suspend];
    [self audiencePause];
    
}

#pragma mark 定时器
//定时器，用来使图片旋转
- (void)creatTimer{
    
    if (_timer) {
        return;
    }
    //定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:.04
                                              target:self
                                            selector:@selector(timerLoop)
                                            userInfo:nil
                                             repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerLoop
{
    float accounting = ([PlayTool getPlayer].currentTime/[PlayTool getPlayer].duration)*M_PI*2;
    UIImageView *imageV = [scrollV viewWithTag:self.currentMusicIndex + ExcessTag];
    imageV.transform = CGAffineTransformMakeRotation(accounting);
}

#pragma mark viewcontroller delegate

//屏幕方向将要发生改变
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

//屏幕方向已经发生改变
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [self configScrViewContent];
}

- (void)configScrViewContent
{
    scrollV.frame = self.view.bounds;
    for (UIView *subView in scrollV.subviews) {
        NSInteger viewIndex = [scrollV.subviews indexOfObject:subView];
        
        CGFloat orignX = viewIndex *scrollV.bounds.size.width;
        
        subView.frame = CGRectMake(orignX+50, 164, 200, 200);
    }
    
    scrollV.contentOffset = CGPointMake(_currentMusicIndex * scrollV.bounds.size.width, 0);
}

#pragma mark AudioPlayer Delegate
//一首播放结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (!flag) {
        return ;
    }
    NSLog(@"%@:播放结束",player.url);
    [self reductionCurrentImageAngle:self.currentMusicIndex];
    self.currentMusicIndex++;
    
}

#pragma mark scrollView delegate
//滑动动画结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    self.currentMusicIndex = (NSInteger)(scrollView.contentOffset.x/ScreenSize.width);
}

- (void)reductionCurrentImageAngle:(NSInteger)pageIndex
{
    UIImageView *imageV = [scrollV viewWithTag:pageIndex + ExcessTag];
    imageV.transform = CGAffineTransformMakeRotation(0);
}

@end

