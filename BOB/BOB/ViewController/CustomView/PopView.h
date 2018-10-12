//
//  PopView.h
//  BOB
//
//  Created by 汲群英 on 2018/10/10.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SeletedBlock)(NSInteger index);

@interface PopView : UIView

+ (void)showWithArray:(NSArray *)dataArr complete:(SeletedBlock)block;

@end
