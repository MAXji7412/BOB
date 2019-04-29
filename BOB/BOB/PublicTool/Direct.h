//
//  Direct.h
//  BOB
//
//  Created by 汲群英 on 2018/10/22.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import <Foundation/Foundation.h>



#define ShortSeletViewControllerKey @"seletViewControllerIndexKey"

NS_ASSUME_NONNULL_BEGIN

@interface DirectTool : NSObject


/**
 处理3Dtouchs事件

 @param shortItem 3Dtouch事件模型
 @return 是否处理了该事件
 */
+ (BOOL)shortHandle:(UIApplicationShortcutItem *)shortItem API_AVAILABLE(ios(9.0));


@end

NS_ASSUME_NONNULL_END
