//
//  TouchMoveImageView.m
//  BOB
//
//  Created by 汲群英 on 2018/10/23.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "TouchMoveImageView.h"

@interface TouchMoveImageView ()

@property (assign) CGPoint lastPoint;

@end

@implementation TouchMoveImageView

#pragma mark Rewrite Init
- (instancetype)init
{
    self = [super init];
    self.userInteractionEnabled = YES;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    self.userInteractionEnabled = YES;
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    self.userInteractionEnabled = YES;
    return self;
}

#pragma mark delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.lastPoint = [touches.allObjects.firstObject locationInView:self.superview];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [touches.allObjects.firstObject locationInView:self.superview];
    
    CGFloat offsetX = locationPoint.x - self.lastPoint.x;
    CGFloat offsetY = locationPoint.y - self.lastPoint.y;
    
    CGPoint center = self.center;
    
    if (self.crossJudgment)
    {
        BOOL XCross = ((self.center.x + offsetX + self.bounds.size.width/2) > self.superview.bounds.size.width) || ((self.center.x + offsetX - self.bounds.size.width/2) < 0);
        
        BOOL YCross = ((self.center.y + offsetY + self.bounds.size.height/2) > self.superview.bounds.size.height) || ((self.center.y + offsetY - self.bounds.size.height/2) < 0);
        
        if (!XCross) center.x += offsetX;
        if (!YCross) center.y += offsetY;
    }else
    {
        center.x += offsetX;
        center.y += offsetY;
    }
    
    self.lastPoint = locationPoint;
    self.center = center;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
