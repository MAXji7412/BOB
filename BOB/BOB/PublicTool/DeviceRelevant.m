//
//  DeviceRelevant.m
//  BOB
//
//  Created by ying on 2017/11/1.
//  Copyright © 2017年 qunyingji. All rights reserved.
//

#import "DeviceRelevant.h"
#import <sys/utsname.h>
#import <CoreTelephony/CoreTelephonyDefines.h>
#import <CoreTelephony/CTCall.h>
#import <dlfcn.h>

NSString *const Device_Simulator = @"Simulator";
NSString *const Device_iPod1 = @"iPod1";
NSString *const Device_iPod2 = @"iPod2";
NSString *const Device_iPod3 = @"iPod3";
NSString *const Device_iPod4 = @"iPod4";
NSString *const Device_iPod5 = @"iPod5";
NSString *const Device_iPod6 = @"iPod6";
NSString *const Device_iPad1 = @"iPad1";
NSString *const Device_iPad2 = @"iPad2";
NSString *const Device_iPad3 = @"iPad3";
NSString *const Device_iPad4 = @"iPad4";
NSString *const Device_iPhone2G = @"iPhone2G";
NSString *const Device_iPhone3G = @"iPhone3G";
NSString *const Device_iPhone3GS = @"iPhone3GS";
NSString *const Device_iPhone4 = @"iPhone 4";
NSString *const Device_iPhone4S = @"iPhone 4S";
NSString *const Device_iPhone5 = @"iPhone 5";
NSString *const Device_iPhone5S = @"iPhone 5S";
NSString *const Device_iPhone5C = @"iPhone 5C";
NSString *const Device_iPadMini1 = @"iPad Mini 1";
NSString *const Device_iPadMini2 = @"iPad Mini 2";
NSString *const Device_iPadMini3 = @"iPad Mini 3";
NSString *const Device_iPadMini4 = @"iPad Mini 4";
NSString *const Device_iPadAir1 = @"iPad Air 1";
NSString *const Device_iPadAir2 = @"iPad Air 2";
NSString *const Device_iPadPro_9_7 = @"iPad Pro 9.7";
NSString *const Device_iPadPro_12_9 = @"iPad Pro 12.9";
NSString *const Device_iPadPro_10_5 = @"iPad Pro 10.5";
NSString *const Device_iPhone6 = @"iPhone 6";
NSString *const Device_iPhone6plus = @"iPhone 6 Plus";
NSString *const Device_iPhone6S = @"iPhone 6S";
NSString *const Device_iPhone6Splus = @"iPhone 6S Plus";
NSString *const Device_iPhone7 = @"iPhone 7";
NSString *const Device_iPhone7plus = @"iPhone 7 Plus";
NSString *const Device_iPhoneSE = @"iPhone SE";
NSString *const Device_iPhone8 = @"iPhone 8";
NSString *const Device_iPhone8plus = @"iPhone 8 Plus";
NSString *const Device_iPhoneX = @"iPhone X";
NSString *const Device_iPhoneXR = @"iPhone XR";
NSString *const Device_iPhoneXS = @"iPhone XS";
NSString *const Device_iPhoneXSMax = @"iPhone XSMax";
NSString *const Device_Unrecognized = @"?unrecognized?";

@implementation DeviceRelevant

+ (NSDictionary *)getDeviceInfo{
    
    UIDevice *curDev = [UIDevice currentDevice];
    
    //设备名称
    NSString *deviceName = [curDev name];
    //手机设备型号
    NSString *phoneModelName = [self getDeviceModelName];
    //操作系统
    NSString *phoneSystem = [curDev systemName];
    //手机系统版本
    NSString *phoneVersion = [curDev systemVersion];
    [self deviceColor];
    return @{
             @"deviceName":deviceName,
             @"phoneModelName":phoneModelName,
             @"phoneSystem":phoneSystem,
             @"phoneVersion":phoneVersion
             };
}

+ (NSString *)getDeviceModelName
{
    static NSString* deviceModeName;
    if (deviceModeName) {
        return deviceModeName;
    }
    
    //生成设备映射表
    NSDictionary* deviceNamesByCode =  @{
                                         @"i386"       : Device_Simulator,
                                         @"x86_64"     : Device_Simulator,
                                         @"iPod1,1"    : Device_iPod1,
                                         @"iPod2,1"    : Device_iPod2,
                                         @"iPod3,1"    : Device_iPod3,
                                         @"iPod4,1"    : Device_iPod4,
                                         @"iPod5,1"    : Device_iPod5,
                                         @"iPod7,1"    : Device_iPod6,
                                         @"iPad1,1"    : Device_iPad1,
                                         @"iPad2,1"    : Device_iPad2,
                                         @"iPad2,2"    : Device_iPad2,
                                         @"iPad2,3"    : Device_iPad2,
                                         @"iPad2,4"    : Device_iPad2,
                                         @"iPad2,5"    : Device_iPadMini1,
                                         @"iPad2,6"    : Device_iPadMini1,
                                         @"iPad2,7"    : Device_iPadMini1,
                                         @"iPhone3,1"  : Device_iPhone4,
                                         @"iPhone3,2"  : Device_iPhone4,
                                         @"iPhone3,3"  : Device_iPhone4,
                                         @"iPhone4,1"  : Device_iPhone4S,
                                         @"iPhone5,1"  : Device_iPhone5,
                                         @"iPhone5,2"  : Device_iPhone5,
                                         @"iPhone5,3"  : Device_iPhone5C,
                                         @"iPhone5,4"  : Device_iPhone5C,
                                         @"iPad3,1"    : Device_iPad3,
                                         @"iPad3,2"    : Device_iPad3,
                                         @"iPad3,3"    : Device_iPad3,
                                         @"iPhone1,1"  : Device_iPhone2G,
                                         @"iPhone1,2"  : Device_iPhone3G,
                                         @"iPhone2,1"  : Device_iPhone3GS,
                                         @"iPad3,4"    : Device_iPad4,
                                         @"iPad3,5"    : Device_iPad4,
                                         @"iPad3,6"    : Device_iPad4,
                                         @"iPhone6,1"  : Device_iPhone5S,
                                         @"iPhone6,2"  : Device_iPhone5S,
                                         @"iPad4,1"    : Device_iPadAir1,
                                         @"iPad4,2"    : Device_iPadAir1,
                                         @"iPad4,3"    : Device_iPadAir1,
                                         @"iPad5,3"    : Device_iPadAir2,
                                         @"iPad5,4"    : Device_iPadAir2,
                                         @"iPad6,3"    : Device_iPadPro_9_7,
                                         @"iPad6,4"    : Device_iPadPro_9_7,
                                         @"iPad6,7"    : Device_iPadPro_12_9,
                                         @"iPad6,8"    : Device_iPadPro_12_9,
                                         @"iPad6,11"   : Device_iPadAir1,
                                         @"iPad6,12"   : Device_iPadAir1,
                                         @"iPad7,1"    : Device_iPadPro_12_9,
                                         @"iPad7,2"    : Device_iPadPro_12_9,
                                         @"iPad7,3"    : Device_iPadPro_10_5,
                                         @"iPad7,4"    : Device_iPadPro_10_5,
                                         @"iPad7,5"    : Device_iPadAir2,
                                         @"iPad7,6"    : Device_iPadAir2,
                                         @"iPad4,4"    : Device_iPadMini2,
                                         @"iPad4,5"    : Device_iPadMini2,
                                         @"iPad4,6"    : Device_iPadMini2,
                                         @"iPad4,7"    : Device_iPadMini3,
                                         @"iPad4,8"    : Device_iPadMini3,
                                         @"iPad4,9"    : Device_iPadMini3,
                                         @"iPad5,1"    : Device_iPadMini4,
                                         @"iPad5,2"    : Device_iPadMini4,
                                         @"iPhone7,1"  : Device_iPhone6plus,
                                         @"iPhone7,2"  : Device_iPhone6,
                                         @"iPhone8,1"  : Device_iPhone6S,
                                         @"iPhone8,2"  : Device_iPhone6Splus,
                                         @"iPhone9,1"  : Device_iPhone7,
                                         @"iPhone9,2"  : Device_iPhone7plus,
                                         @"iPhone9,3"  : Device_iPhone7,
                                         @"iPhone9,4"  : Device_iPhone7plus,
                                         @"iPhone8,3"  : Device_iPhoneSE,
                                         @"iPhone8,4"  : Device_iPhoneSE,
                                         @"iPhone10,1" : Device_iPhone8,
                                         @"iPhone10,2" : Device_iPhone8plus,
                                         @"iPhone10,3" : Device_iPhoneX,
                                         @"iPhone10,4" : Device_iPhone8,
                                         @"iPhone10,5" : Device_iPhone8plus,
                                         @"iPhone10,6" : Device_iPhoneX,
                                         @"iPhone11,2" : Device_iPhoneXS,
                                         @"iPhone11,4" : Device_iPhoneXSMax,
                                         @"iPhone11,6" : Device_iPhoneXSMax,
                                         @"iPhone11,8" : Device_iPhoneXR
                                         };
    
    //根据生产型号找到对应设备型号,返回当前设备机型
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    deviceModeName = [deviceNamesByCode objectForKey:code];
    if(!deviceModeName)
    {
        deviceModeName = Device_Unrecognized;
    }
    return deviceModeName;
}

+ (UIColor *)deviceColor
{
    UIDevice *device = [UIDevice currentDevice];
    
    SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
    if (![device respondsToSelector:selector])
    {
        selector = NSSelectorFromString(@"_deviceInfoForKey:");
    }
    if (![device respondsToSelector:selector]) {
        return nil;
    }
    
    IMP imp = [device methodForSelector:NSSelectorFromString(@"_deviceInfoForKey:")];
    NSString * (*func)(id, SEL, NSString *) = (void *)imp;
    
    //        NSString *deviceColor  = func(device, selector, @"DeviceColor");
    NSString *deviceEnclosureColor  = func(device, selector, @"DeviceEnclosureColor");
    
    return [BOBTool colorWithHexString:deviceEnclosureColor];
}

@end

