//
//  UIButton+ClickBlock.m
//  PAEBank
//
//  Created by 汲群英 on 2017/7/27.
//  Copyright © 2017年 PingAn. All rights reserved.
//

#import "UIButton+ClickBlock.h"

#import <objc/runtime.h>

static const void *associatedKey = "associatedKey";

@implementation UIButton (ClickBlock)


//Category中的属性，只会生成setter和getter方法，不会生成成员变量
- (void)setClick:(clickBlock)click{
    objc_setAssociatedObject(self, associatedKey, click, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self removeTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    if (click) {
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (clickBlock)click{
    return objc_getAssociatedObject(self, associatedKey);
}
- (void)buttonClick{
    if (self.click) {
        self.click();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
