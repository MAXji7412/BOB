//
//  GlobalDefine.h
//  BOB
//
//  Created by 汲群英 on 2018/8/31.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h



#define CheckString(string) [string isKindOfClass:NSString.class]?string:@""

#define ArcColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]

#define ScreenSize [UIScreen mainScreen].bounds.size

#define NavMaxY (self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height)


#endif /* GlobalDefine_h */
