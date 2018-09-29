//
//  DeviceRelevant.h
//  BOB
//
//  Created by ying on 2017/11/1.
//  Copyright © 2017年 qunyingji. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const Device_Simulator;
extern NSString *const Device_iPod1;
extern NSString *const Device_iPod2;
extern NSString *const Device_iPod3;
extern NSString *const Device_iPod4;
extern NSString *const Device_iPod5;
extern NSString *const Device_iPod6;
extern NSString *const Device_iPad1;
extern NSString *const Device_iPad2;
extern NSString *const Device_iPad3;
extern NSString *const Device_iPad4;
extern NSString *const Device_iPhone2G;
extern NSString *const Device_iPhone3G;
extern NSString *const Device_iPhone3GS;
extern NSString *const Device_iPhone4;
extern NSString *const Device_iPhone4S;
extern NSString *const Device_iPhone5;
extern NSString *const Device_iPhone5S;
extern NSString *const Device_iPhone5C;
extern NSString *const Device_iPadMini1;
extern NSString *const Device_iPadMini2;
extern NSString *const Device_iPadMini3;
extern NSString *const Device_iPadMini4;
extern NSString *const Device_iPadAir1;
extern NSString *const Device_iPadAir2;
extern NSString *const Device_iPadPro_9_7;
extern NSString *const Device_iPadPro_12_9;
extern NSString *const Device_iPadPro_10_5;
extern NSString *const Device_iPhone6;
extern NSString *const Device_iPhone6plus;
extern NSString *const Device_iPhone6S;
extern NSString *const Device_iPhone6Splus;
extern NSString *const Device_iPhone7;
extern NSString *const Device_iPhone7plus;
extern NSString *const Device_iPhoneSE;
extern NSString *const Device_iPhone8;
extern NSString *const Device_iPhone8plus;
extern NSString *const Device_iPhoneX;
extern NSString *const Device_iPhoneXR;
extern NSString *const Device_iPhoneXS;
extern NSString *const Device_iPhoneXSMax;
extern NSString *const Device_Unrecognized;


@interface DeviceRelevant : NSObject

+ (NSDictionary *)getDeviceInfo;

+ (NSString *)getDeviceModelName;

+ (UIColor *)deviceColor;

@end
