//
//  BezierViewController.m
//  BOB
//
//  Created by 汲群英 on 2018/11/8.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "BezierViewController.h"

@interface BezierViewController ()

@end

@implementation BezierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ArcColor;
    
    CGFloat gap = 100;
    CGFloat width = ScreenSize.width - gap*2;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(gap, NavMaxY + gap, width, width)];
    imageView.image = [UIImage imageNamed:@"light.jpg"];
    [self lineLayerToView:imageView];
    
    [self.view addSubview:imageView];
}


//线
- (void)lineLayerToView:(UIView *)view
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    CGPoint basisPoint = CGPointMake(0, CGRectGetMaxY(view.bounds));
    [bezierPath moveToPoint:basisPoint];
    
    [bezierPath addQuadCurveToPoint:CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds)) controlPoint:CGPointMake(0, 0)];
    [bezierPath addQuadCurveToPoint:CGPointMake(CGRectGetMaxX(view.bounds), CGRectGetMaxY(view.bounds)) controlPoint:CGPointMake(CGRectGetMaxY(view.bounds), 0)];
    
    [bezierPath closePath];
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = bezierPath.CGPath;
    view.layer.mask = circleLayer;
}

@end
