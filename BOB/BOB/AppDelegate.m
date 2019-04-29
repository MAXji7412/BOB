//
//  AppDelegate.m
//  BOB
//
//  Created by ying on 2017/10/27.
//  Copyright © 2017年 qunyingji. All rights reserved.
//

#import "AppDelegate.h"

#import "Start.h"
#import "PlayTool.h"
#import "Direct.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark root function
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Start start:^{
        BOBLog(@"启动完成");
    }];
    
    return YES;
}

/**
 将要失去活跃状态

 @param application app
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [PlayTool backgroundPlayer];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//3D touch 入口
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler  API_AVAILABLE(ios(9.0))
{
    [Start start:^{
        completionHandler([DirectTool shortHandle:shortcutItem]);
    }];
}

/**
 远程通知

 @param event 远程事件
 */
-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    [PlayTool remoteControlReceivedWithEvent:event];
}



@end
