//
//  FingerEvaluateManager.m
//  FingerEvaluate
//
//  Created by 汲群英 on 2019/4/3.
//  Copyright © 2019 汲群英. All rights reserved.
//

#import "FingerEvaluateManager.h"

#import <LocalAuthentication/LocalAuthentication.h>

@implementation FingerEvaluateManager

+ (void)evaluateWithComplete:(void (^)(BOOL, EvaluateError))complete
{
    LAContext *lac = [LAContext new];
    
    NSError *error = nil;
    
    //判断指纹认证功能状态
    BOOL canEvaluate = [lac canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
    
    if (canEvaluate)
    {
        //认证
        [self evaluateLAContext:lac :complete];
    }
    else
    {
        EvaluateError err = [self seekErrorByLAError:error.code];
        complete(canEvaluate, err);
    }
}

+ (void)evaluateLAContext:(LAContext *)lac :(void(^)(BOOL, EvaluateError))complete
{
    [lac evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"🏖 🏖 🏖" reply:^(BOOL success, NSError * _Nullable error)
     {
         EvaluateError err = [self seekErrorByLAError:error.code];
         [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             complete(success, err);
         }];
     }];
}

/**
 错误信息映射

 @param LAError 系统返回错误
 @return 自定义错误
 */
+ (EvaluateError)seekErrorByLAError:(LAError)LAError
{
    EvaluateError evaluateError;
    switch (LAError)
    {
        case LAErrorAuthenticationFailed:
        {
            evaluateError = EvaluateError_AuthenticationFailed;
            break;
        }
        case LAErrorSystemCancel:
        case LAErrorUserCancel:
        {
            evaluateError = EvaluateError_UserCancel;
            break;
        }
        case LAErrorUserFallback:
        {
            evaluateError = EvaluateError_UserFallback;
            break;
        }
        case LAErrorPasscodeNotSet:
        case LAErrorTouchIDNotAvailable:
        case LAErrorTouchIDNotEnrolled:
        {
            evaluateError = EvaluateError_NotSet;
            break;
        }
        case LAErrorTouchIDLockout:
        {
            evaluateError = EvaluateError_Lock;
            break;
        }
        default:
        {
            evaluateError = EvaluateError_None;
            break;
        }
    }
    return evaluateError;
}

@end

//LAPolicyDeviceOwnerAuthentication:生物指纹识别或系统密码验证;   LAPolicyDeviceOwnerAuthenticationWithBiometrics:生物指纹识别


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







