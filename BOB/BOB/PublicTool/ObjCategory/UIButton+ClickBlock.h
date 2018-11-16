//
//  UIButton+ClickBlock.h
//  PAEBank
//
//  Created by 汲群英 on 2017/7/27.
//  Copyright © 2017年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickBlock)(void);

@interface UIButton (ClickBlock)

@property (nonatomic,copy) clickBlock click;

@end
