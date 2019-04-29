//
//  MethodSwizzle.h
//  BOB
//
//  Created by 汲群英 on 2019/4/8.
//  Copyright © 2019 qunyingji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MethodSwizzle : NSObject

/**
 实例方法交换

 @param aClass a类
 @param aSel a类实例方法
 @param bClass b类
 @param bSel b类实例方法
 */
+ (void)swizzleInstanceMethodWithAClass:(Class)aClass instanceSelector:(SEL)aSel BClass:(Class)bClass instanceSelector:(SEL)bSel;

/**
 类方法交换

 @param aClass a类
 @param aSel a类类方法
 @param bClass b类
 @param bSel b类类方法
 */
+ (void)swizzleClassMethodWithAClass:(Class)aClass classSelector:(SEL)aSel BClass:(Class)bClass classSelector:(SEL)bSel;

@end

NS_ASSUME_NONNULL_END
