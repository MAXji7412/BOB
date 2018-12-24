//
//  BezierView.h
//  Bezier
//
//  Created by 汲群英 on 2018/12/6.
//  Copyright © 2018 汲群英. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BezierView : UIView


/**
 ShapeLayer,用来承载path的layer
 */
@property(nonatomic, strong) CAShapeLayer *shapeLayer;

/**
 背景图片
 */
@property(nonatomic, strong) UIImageView *backImageView;

/**
 展示文字path

 @param text 要展示的文字
 @param font 文字属性，取fontname和size
 @param duration 动画时间
 @param complete 动画已经停止的回调
 */
- (void)showText:(NSString *)text :(UIFont *)font :(CGFloat)duration :(nullable dispatch_block_t)complete;

/**
 展示进度条

 @param rate 进度，0 - 100
 */
- (void)showProgressRate:(float)rate;

@end

NS_ASSUME_NONNULL_END
