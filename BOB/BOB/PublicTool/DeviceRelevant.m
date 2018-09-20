//
//  DeviceRelevant.m
//  BOB
//
//  Created by ying on 2017/11/1.
//  Copyright © 2017年 qunyingji. All rights reserved.
//

#import "DeviceRelevant.h"
#import <sys/utsname.h>

@implementation DeviceRelevant

extern NSString *CTSettingCopyMyPhoneNumber(void);

+ (NSDictionary *)getDeviceInfo{
    
    UIDevice *curDev = [UIDevice currentDevice];
    
    //设备名称
    NSString *deviceName = [curDev name];
    //手机设备型号
    NSString *phoneModelName = [self getDeviceModelName];
    //操作系统
    NSString *phoneSystem = [curDev systemName];
    //手机系统版本名称
    NSString *phoneVersion = [curDev systemVersion];
    //手机号码
    NSString *phoneNumber = CTSettingCopyMyPhoneNumber();
    
    return @{
             @"deviceName":deviceName,
             @"phoneModelName":phoneModelName,
             @"phoneSystem":phoneSystem,
             @"phoneVersion":phoneVersion,
             @"phoneNumber":CheckString(phoneNumber)
             };
}

+ (NSString *)getDeviceModelName{
    
    static NSString *phoneModelName;
    if (phoneModelName) {
        return phoneModelName;
    }
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *hardwareVersion = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSDictionary *complexInstructionSetComputer_Map_DeviceModle_Dic =
    @{
      @"i386"       : @"Simulator",
      @"x86_64"     : @"Simulator",
      @"iPod1,1"    : @"iPod1",
      @"iPod2,1"    : @"iPod2",
      @"iPod3,1"    : @"iPod3",
      @"iPod4,1"    : @"iPod4",
      @"iPod5,1"    : @"iPod5",
      @"iPod7,1"    : @"iPod6",
      @"iPad1,1"    : @"iPad1",
      @"iPad2,1"    : @"iPad2",
      @"iPad2,2"    : @"iPad2",
      @"iPad2,3"    : @"iPad2",
      @"iPad2,4"    : @"iPad2",
      @"iPad2,5"    : @"iPadMini1",
      @"iPad2,6"    : @"iPadMini1",
      @"iPad2,7"    : @"iPadMini1",
      @"iPhone3,1"  : @"iPhone4",
      @"iPhone3,2"  : @"iPhone4",
      @"iPhone3,3"  : @"iPhone4",
      @"iPhone4,1"  : @"iPhone4S",
      @"iPhone5,1"  : @"iPhone5",
      @"iPhone5,2"  : @"iPhone5",
      @"iPhone5,3"  : @"iPhone5C",
      @"iPhone5,4"  : @"iPhone5C",
      @"iPad3,1"    : @"iPad3",
      @"iPad3,2"    : @"iPad3",
      @"iPad3,3"    : @"iPad3",
      @"iPhone1,1"  : @"iPhone2G",
      @"iPhone1,2"  : @"iPhone3G",
      @"iPhone2,1"  : @"iPhone3GS",
      @"iPad3,4"    : @"iPad4",
      @"iPad3,5"    : @"iPad4",
      @"iPad3,6"    : @"iPad4",
      @"iPhone6,1"  : @"iPhone5S",
      @"iPhone6,2"  : @"iPhone5S",
      @"iPad4,1"    : @"iPadAir1",
      @"iPad4,2"    : @"iPadAir1",
      @"iPad4,3"    : @"iPadAir1",
      @"iPad5,3"    : @"iPadAir2",
      @"iPad5,4"    : @"iPadAir2",
      @"iPad6,3"    : @"iPadPro_9_7",
      @"iPad6,4"    : @"iPadPro_9_7",
      @"iPad6,7"    : @"iPadPro_12_9",
      @"iPad6,8"    : @"iPadPro_12_9",
      @"iPad4,4"    : @"iPadMini2",
      @"iPad4,5"    : @"iPadMini2",
      @"iPad4,6"    : @"iPadMini2",
      @"iPad4,7"    : @"iPadMini3",
      @"iPad4,8"    : @"iPadMini3",
      @"iPad4,9"    : @"iPadMini3",
      @"iPad5,1"    : @"iPadMini4",
      @"iPad5,2"    : @"iPadMini4",
      @"iPhone7,1"  : @"iPhone6plus",
      @"iPhone7,2"  : @"iPhone6",
      @"iPhone8,1"  : @"iPhone6S",
      @"iPhone8,2"  : @"iPhone6Splus",
      @"iPhone9,1"  : @"iPhone7",
      @"iPhone9,2"  : @"iPhone7plus",
      @"iPhone9,3"  : @"iPhone7",
      @"iPhone9,4"  : @"iPhone7plus",
      @"iPhone8,3"  : @"iPhoneSE",
      @"iPhone8,4"  : @"iPhoneSE",
      @"iPhone10,1" : @"iPhone8",
      @"iPhone10,2" : @"iPhone8plus",
      @"iPhone10,3" : @"iPhoneX",
      @"iPhone10,4" : @"iPhone8",
      @"iPhone10,5" : @"iPhone8plus",
      @"iPhone10,6" : @"iPhoneX",
      };
    
    phoneModelName = complexInstructionSetComputer_Map_DeviceModle_Dic[hardwareVersion];
    
    return phoneModelName;
}

@end

