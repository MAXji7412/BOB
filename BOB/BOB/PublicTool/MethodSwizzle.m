//
//  MethodSwizzle.m
//  BOB
//
//  Created by 汲群英 on 2019/4/8.
//  Copyright © 2019 qunyingji. All rights reserved.
//

#import "MethodSwizzle.h"

#import <objc/runtime.h>

@implementation MethodSwizzle

+ (void)swizzleInstanceMethodWithAClass:(Class)aClass instanceSelector:(SEL)aSel BClass:(Class)bClass instanceSelector:(SEL)bSel
{
    if (!aClass || !aSel || !bClass || !bSel)
    {
        return;
    }
    Method aMethod = class_getInstanceMethod(aClass, aSel);
    Method bMethod = class_getInstanceMethod(bClass, bSel);
    if (!aMethod || !bMethod)
    {
        return;
    }
    
    //交换Implementations
    method_exchangeImplementations(aMethod, bMethod);
}

+ (void)swizzleClassMethodWithAClass:(Class)aClass classSelector:(SEL)aSel BClass:(Class)bClass classSelector:(SEL)bSel
{
    
}

@end
