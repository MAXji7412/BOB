//
//  WKWebViewController.h
//  BOB
//
//  Created by 汲群英 on 2018/9/23.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WebKit/WebKit.h>

@interface WKWebViewController : UIViewController

@property (retain) WKWebView *webview;
@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,retain) NSMutableDictionary *websitesDicM;


/**
 load self.urlStr
 */
- (void)loadRequest;

@end
