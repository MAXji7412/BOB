//
//  FingerEvaluateManager.h
//  FingerEvaluate
//
//  Created by 汲群英 on 2019/4/3.
//  Copyright © 2019 汲群英. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 LAErrorAuthenticationFailed//认证失败，不是本人
 LAErrorUserCancel//点击取消
 LAErrorUserFallback//点击了备选方案，密码
 LAErrorSystemCancel//系统取消，比如其他APP切入、退出后台等
 
 LAErrorPasscodeNotSet//未设置密码
 LAErrorTouchIDNotAvailable//未打开指纹
 LAErrorTouchIDNotEnrolled //未录入指纹
 LAErrorBiometryNotAvailable//未打开指纹
 LAErrorBiometryNotEnrolled//未录入指纹
 
 LAErrorTouchIDLockout//锁定
 LAErrorBiometryLockout//锁定
 
 LAErrorAppCancel//程序调用了取消认证方法
 LAErrorInvalidContext//LAContext失效？
 LAErrorNotInteractive//弹框使用了不可交互模式
 */

typedef enum : NSUInteger {
    EvaluateError_None,
    EvaluateError_AuthenticationFailed,
    EvaluateError_UserCancel,
    EvaluateError_Lock,
    EvaluateError_NotSet,
    EvaluateError_UserFallback
} EvaluateError;

@interface FingerEvaluateManager : NSObject

+ (void)evaluateWithComplete:(void(^)(BOOL success, EvaluateError err))complete;

@end

NS_ASSUME_NONNULL_END
