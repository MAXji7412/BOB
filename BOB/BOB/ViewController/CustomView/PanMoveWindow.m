//
//  PanMoveWindow.m
//  BOB
//
//  Created by 汲群英 on 2018/10/25.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "PanMoveWindow.h"

@interface PanMoveWindow ()
{
    CGPoint _lastPoint;
    UIWindow *_mainWindow;
}
@end

@implementation PanMoveWindow

#pragma mark rewrite init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _mainWindow = [UIApplication sharedApplication].delegate.window;
    self.hidden = NO;
    return self;
}

#pragma mark event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _lastPoint = [touches.allObjects.firstObject locationInView:_mainWindow];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [touches.allObjects.firstObject locationInView:_mainWindow];
    
    CGFloat offsetX = locationPoint.x - _lastPoint.x;
    CGFloat offsetY = locationPoint.y - _lastPoint.y;
    
    CGPoint center = self.center;
    
    if (self.crossJudgment)
    {
        BOOL XCross = ((self.center.x + offsetX + self.bounds.size.width/2) > _mainWindow.bounds.size.width) || ((self.center.x + offsetX - self.bounds.size.width/2) < 0);
        
        BOOL YCross = ((self.center.y + offsetY + self.bounds.size.height/2) > _mainWindow.bounds.size.height) || ((self.center.y + offsetY - self.bounds.size.height/2) < 0);
        
        if (!XCross) center.x += offsetX;
        if (!YCross) center.y += offsetY;
    }else
    {
        center.x += offsetX;
        center.y += offsetY;
    }
    
    _lastPoint = locationPoint;
    self.center = center;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
