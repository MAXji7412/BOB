//
//  BezierView.m
//  Bezier
//
//  Created by 汲群英 on 2018/12/6.
//  Copyright © 2018 汲群英. All rights reserved.
//

#import "BezierView.h"

#import <CoreText/CoreText.h>

typedef enum : NSUInteger {
    PathTypeText = 1,
    PathTypeCircle = 2,
} PathType;

@interface BezierView ()<CAAnimationDelegate>
{
    dispatch_block_t animationComplete;
    PathType pathType;
}
@end

@implementation BezierView

#pragma mark main func

//文字
- (void)showText:(NSString *)text :(UIFont *)font :(CGFloat)duration :(dispatch_block_t)complete
{
    if (pathType != PathTypeCircle)
    {
        pathType = PathTypeText;
    }
    UIBezierPath *path = [self seekTextPath:text font:font maxX:self.bounds.size.width];
    self.shapeLayer.path = path.CGPath;
    
    self.shapeLayer.lineWidth = font.pointSize/10;
    
    //添加到self上
    if (!self.backImageView.layer.mask)
    {
        self.backImageView.layer.mask = self.shapeLayer;//用shapeLayer来截取渐变层
    }
    if (!self.backImageView.superview)
    {
        [self addSubview:self.backImageView];
    }
    
    // 绘图动画,把“self.shapeLayer”的“strokeEnd”属性从0变到1,这种方式在动画完成之后strokeEnd属性值会复原
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = duration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.delegate = self;
    [self.shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
//    self.shapeLayer.strokeEnd = 1.0;
    
    animationComplete = complete;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (animationComplete)
    {
        animationComplete();
        animationComplete = nil;
    }
}

- (void)showProgressRate:(float)rate
{
    if (pathType != PathTypeText)
    {
        self.shapeLayer.strokeEnd = 0;
        pathType = PathTypeCircle;
        UIBezierPath *path = [self seekCirclePath];
        self.shapeLayer.path = path.CGPath;
    }
    
    if (!self.backImageView.layer.mask)
    {
        self.backImageView.layer.mask = self.shapeLayer;//用shapeLayer来截取渐变层
    }
    if (!self.backImageView.superview)
    {
        [self addSubview:self.backImageView];
    }
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0;
    pathAnimation.fromValue = @(self.shapeLayer.strokeEnd);
    pathAnimation.toValue = @(rate/100.0);
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.delegate = self;
    [self.shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    self.shapeLayer.strokeEnd = rate/100.0;
}

#pragma mark subview
- (CAShapeLayer *)shapeLayer
{
    if (_shapeLayer)
    {
        return _shapeLayer;
    }
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = self.bounds;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.strokeColor = [[UIColor redColor] CGColor];
    _shapeLayer.lineJoin = kCALineJoinMiter;
    _shapeLayer.lineCap = kCALineCapRound;
    
    return _shapeLayer;
}

/**
 获取圆圈路径

 @return 路径
 */
- (UIBezierPath *)seekCirclePath
{
    //构建圆形
    CGFloat lineWidth = 10;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) ;
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) /2 - lineWidth/2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:0
                                                      endAngle:M_PI *2
                                                     clockwise:YES];
    self.shapeLayer.lineWidth = lineWidth;
    return path;
}

/**
 获取文字路径

 @param text 文字
 @param font 文字属性
 @param maxX 最大边界，用来做换行
 @return 路径
 */
- (UIBezierPath *)seekTextPath:(NSString *)text font:(UIFont *)font maxX:(CGFloat)maxX
{
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    NSDictionary *attrs = @{
                            (__bridge id)kCTFontAttributeName:(__bridge id)ctFont
                            
                            };
    NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:text attributes:attrs];
    CGMutablePathRef paths = CGPathCreateMutable();
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attributed);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    CGRect lastRact = CGRectZero;
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            
            const CGSize *size = CTRunGetAdvancesPtr(run);
            
            //换行
            if ((CGRectGetMaxX(lastRact) + size -> width) > maxX)
            {
                lastRact.origin.y -= font.pointSize;
                lastRact.origin.x = 0;
            }else{
                lastRact.origin.x = CGRectGetMaxX(lastRact);
            }
            lastRact.size = CGSizeMake(size -> width, size -> height);
            
            CGPathRef path = CTFontCreatePathForGlyph(runFont, glyph, NULL);//核心，用字形创建路径
            
            CGAffineTransform t = CGAffineTransformMakeTranslation(lastRact.origin.x, lastRact.origin.y);
            CGPathAddPath(paths, &t, path);
            CGPathRelease(path);
        }
    }
    
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:paths];
    CGPathRelease(paths);
    
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];//上下翻转
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, font.pointSize)];//下移
    
    return path;
}

- (CALayer *)seekGradientLayer
{
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    gradientLayer1.frame = self.bounds;
    [gradientLayer1 setColors:@[(id)[UIColor blackColor].CGColor, (id)[UIColor whiteColor].CGColor]];
    [gradientLayer1 setLocations:@[@0, @1]];
    
    CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
    [gradientLayer2 setLocations:@[@0, @1]];
    gradientLayer2.frame = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height);
    [gradientLayer2 setColors:@[(id)[UIColor blueColor].CGColor, (id)[UIColor redColor].CGColor]];
    
    CALayer *gradientLayer = [CALayer layer];
    [gradientLayer addSublayer:gradientLayer1];
    [gradientLayer addSublayer:gradientLayer2];
    
    return gradientLayer;
}

- (UIImageView *)backImageView
{
    if (!_backImageView)
    {
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImageView.clipsToBounds = YES;
        _backImageView.contentMode = UIViewContentModeCenter;
        _backImageView.image = [UIImage imageNamed:@"22706.png"];
    }
    
    return _backImageView;
}

@end
