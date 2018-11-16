//
//  PanMoveView.m
//  BOB
//
//  Created by 汲群英 on 2018/11/7.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "PanMoveView.h"

@interface PanMoveView  ()
{
    CGPoint _lastPoint;
}

@end

@implementation PanMoveView

#pragma mark event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _lastPoint = [touches.allObjects.firstObject locationInView:self.superview];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [touches.allObjects.firstObject locationInView:self.superview];
    
    CGFloat offsetX = locationPoint.x - _lastPoint.x;
    CGFloat offsetY = locationPoint.y - _lastPoint.y;
    
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
