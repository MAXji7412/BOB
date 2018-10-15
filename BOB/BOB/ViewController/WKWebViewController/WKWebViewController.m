//
//  WKWebViewController.m
//  BOB
//
//  Created by 汲群英 on 2018/9/23.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import "WKWebViewController.h"

#define WebsitesDicKey @"WebsitesDicKey"


@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@end

@implementation WKWebViewController


#pragma mark controller life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatWebview];
    [self registerNotification];
    [self loadRequest];
    [self creatNavBarRightItem];
}

- (void)dealloc
{
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//注册通知
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleStatusBarOrientationWillChange:)
                                                name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
    
}

//创建Webview
- (void)creatWebview
{
    if (self.webview) {
        return;
    }
    WKWebViewConfiguration *wkWebviewConfig = [WKWebViewConfiguration new];
    
    
    wkWebviewConfig.userContentController = [self getWKUserContentController];
    wkWebviewConfig.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    self.webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:wkWebviewConfig];
    
    self.webview.navigationDelegate = self;
    self.webview.UIDelegate = self;
    self.webview.allowsBackForwardNavigationGestures = YES;
    self.webview.scrollView.contentInset = UIEdgeInsetsMake(NavMaxY, 0, TabBarH, 0);
    
    if (@available(iOS 11.0, *)) {
        self.webview.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.view addSubview:self.webview];
}


- (WKUserContentController *)getWKUserContentController
{
    WKUserContentController *userContentCon = [WKUserContentController new];
    
    /*
     point:这里的name是js调用native时的标识
     window.webkit.messageHandlers.bob.postMessage({cc:"ss"})
     */
    [userContentCon addScriptMessageHandler:self name:@"bob"];
    
    
    /*
    //提前注入JS方法
    NSString *jsCode = @"alerttt";

    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jsCode
                                                      injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                   forMainFrameOnly:NO];
    [userContentCon addUserScript:userScript];
    */
    
    return userContentCon;
}

- (void)loadRequest{
    
    if (![self.urlStr isKindOfClass:NSString.class] || !self.urlStr.length) {
        return;
    }
    
    NSString *urlPrefix = @"http://";
    NSString *secUrlPrefix = @"https://";
    NSString *singleSlashPrefix = @"http:/";
    NSString *secSingleSlashPrefix = @"https:/";
    if (![self.urlStr hasPrefix:urlPrefix] && ![self.urlStr hasPrefix:secUrlPrefix] && [self.urlStr hasPrefix:singleSlashPrefix] && [self.urlStr hasPrefix:secSingleSlashPrefix])
    {
        self.urlStr = [secUrlPrefix stringByAppendingString:self.urlStr];//todo
    }
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    if (!url) {
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webview stopLoading];
    [self.webview loadRequest:request];
}


#pragma mark 导航栏右侧按钮及按钮事件
//导航栏右按钮
- (void)creatNavBarRightItem
{
    //moreWebsites
    UIBarButtonItem *moreBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"•••"
                                                                    style:2
                                                                   target:self
                                                                   action:@selector(moreSel)];
    
    //saveURL
    UIImage *bookMarkIcon = [UIImage imageNamed:@"nav_book"];
    bookMarkIcon = [bookMarkIcon.copy imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *bookMarkBtnItem = [[UIBarButtonItem alloc] initWithImage:bookMarkIcon
                                                                        style:2
                                                                       target:self
                                                                       action:@selector(bookMarkSel)];
    
    
    //add to navigation
    self.navigationItem.rightBarButtonItems = @[moreBtnItem,bookMarkBtnItem];
}

//点击右按钮，弹出网站选择
- (void)moreSel
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"更多"
                                                                   message:@"功能选择"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* reload = [UIAlertAction actionWithTitle:@"刷新"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                       [self.webview reload];
                                                   }];
    
    UIAlertAction* input = [UIAlertAction actionWithTitle:@"输入"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [self inputUrl];
                                                            }];
    
    UIAlertAction* save = [UIAlertAction actionWithTitle:@"添加到书签"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     
                                                     [self saveCurrentUrl];
                                                 }];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:@"移除某个书签"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                       [self bookMarkSelDelete:YES];
                                                   }];
    
    UIAlertAction* orignBookMark = [UIAlertAction actionWithTitle:@"重置书签"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [self resetbookMark];
                                                          }];
    
    UIAlertAction* footprint = [UIAlertAction actionWithTitle:@"足迹"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          [self footprint];
                                                      }];
    
    UIAlertAction* takeSnapshot = [UIAlertAction actionWithTitle:@"网页快照"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self takeSnapshot];
                                                         }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [alert addAction:reload];
    [alert addAction:input];
    [alert addAction:save];
    [alert addAction:delete];
    [alert addAction:orignBookMark];
    [alert addAction:footprint];
    [alert addAction:takeSnapshot];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//书签
- (void)bookMarkSel
{
    [self bookMarkSelDelete:NO];
}

- (void)inputUrl
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入地址"
                                                                   message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"前往"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
                                                   self.urlStr = alert.textFields.firstObject.text;
                                                   [self loadRequest];
                                               }];
    
    
    [alert addAction:ok];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//选择书签,delete:跳转或删除
- (void)bookMarkSelDelete:(BOOL)delete
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"书签"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *key in self.websitesDicM.allKeys)
    {
        if (![key isKindOfClass:NSString.class])
        {
            continue;
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:key
                                                         style:0
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           if (delete)
                                                           {
                                                               [self deleteUrlWithTitle:action.title];
                                                               [SVProgressHUD showImage:nil status:@"done"];
                                                           }else
                                                           {
                                                               self.urlStr = self.websitesDicM[action.title];
                                                               [self loadRequest];
                                                           }
                                                           
                                                       }];
        
        [alert addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//足迹
- (void)footprint
{
    NSArray<WKBackForwardListItem *> *backForwardList = [[NSMutableArray arrayWithArray:self.webview.backForwardList.backList] arrayByAddingObjectsFromArray:self.webview.backForwardList.forwardList];
    
    if (!backForwardList.count)
    {
        [SVProgressHUD showImage:nil status:@"没有足迹"];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"足迹"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (WKBackForwardListItem *backForwardListItem in backForwardList)
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:backForwardListItem.title
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           [self.webview goToBackForwardListItem:backForwardListItem];
                                                       }];
        
        [alert addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//网页快照
- (void)takeSnapshot
{
    if (@available(iOS 11.0, *)) {
        WKSnapshotConfiguration *snapshotConfig = [WKSnapshotConfiguration new];
        snapshotConfig.rect = CGRectMake(0, 0, 1000, 1000);
        [self.webview takeSnapshotWithConfiguration:nil completionHandler:^(UIImage * _Nullable snapshotImage, NSError * _Nullable error) {
            
            NSString *msg = nil;
            if (error)
            {
                msg = error.description;
                
            }
            else if (!snapshotImage)
            {
                msg = @"未知错误";
            }
            
            if (msg)
            {
                [SVProgressHUD showImage:nil status:error.description];
                return ;
            }
            
            UIImageWriteToSavedPhotosAlbum(snapshotImage,
                                           self,
                                           @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:),
                                           nil);
            
        }];
    } else {
        // Fallback on earlier versions
        [SVProgressHUD showImage:nil status:@"系统版本不支持(iOS 11.0)"];
    }
}

//保存快照完成后调用的方法
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo
{
    if (error) {
        [SVProgressHUD showImage:nil status:error.description];
    }
    else {
        [SVProgressHUD showImage:nil status:@"图片已保存到相册"];
    }
}

#pragma mark 网站选择
//书签列表
- (NSMutableDictionary *)websitesDicM
{
    if (_websitesDicM) {
        return _websitesDicM;
    }
    
    _websitesDicM = [[NSUserDefaults standardUserDefaults] objectForKey:WebsitesDicKey];
    if ([_websitesDicM isKindOfClass:NSDictionary.class])
    {
        _websitesDicM = [NSMutableDictionary dictionaryWithDictionary:_websitesDicM];
        return _websitesDicM;
    }
    
    _websitesDicM = [self.class defaultWeblist].mutableCopy;
    [[NSUserDefaults standardUserDefaults] setObject:_websitesDicM forKey:WebsitesDicKey];
    
    return _websitesDicM;
}

//保存地址到书签
- (void)saveCurrentUrl
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存"
                                                                   message:CheckString(self.webview.URL.absoluteString)
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = CheckString(self.webview.title);
    }];
    
    
    UIAlertAction *determine = [UIAlertAction
                                actionWithTitle:@"存入"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action) {
                                    NSString *title = CheckString(alert.textFields.firstObject.text);
                                    if(title.length)
                                    {
                                        [self.websitesDicM setObject:CheckString(self.webview.URL.absoluteString) forKey:title];
                                        [[NSUserDefaults standardUserDefaults] setObject:self.websitesDicM forKey:WebsitesDicKey];
                                    }
                                }];
    
    [alert addAction:determine];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

//重置书签数据
- (void)resetbookMark
{
    self.websitesDicM = [self.class defaultWeblist].mutableCopy;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WebsitesDicKey];
}

//根据标题删除书签
- (void)deleteUrlWithTitle:(NSString *)title
{
    if (![title isKindOfClass:NSString.class]) {
        return;
    }
    
    [self.websitesDicM removeObjectForKey:title];
    [[NSUserDefaults standardUserDefaults] setObject:self.websitesDicM forKey:WebsitesDicKey];
}

//默认书签列表
+ (NSDictionary *)defaultWeblist
{
    return @{
             @"新浪微博":@"https://weibo.com",
             @"虎牙":@"https://huya.com",
             @"百度":@"https://baidu.com",
             @"百度百科":@"https://baike.baidu.com",
             @"talkingdata":@"https://www.talkingdata.com",
             @"简书":@"https://www.jianshu.com",
             @"酷我":@"http://www.kuwo.cn"
             };
}










#pragma mark ============== delegate ==============

#pragma mark WKWebView WKUIDelegate

/**
 webView中弹出警告框时调用, 只能有一个按钮
 
 @param webView webView
 @param message 提示信息
 @param frame 可用于区分哪个窗口调用的
 @param completionHandler 警告框消失的时候调用, 回调给JS
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"我知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

/** 对应js的confirm方法
 webView中弹出选择框时调用, 两个按钮
 
 @param webView webView description
 @param message 提示信息
 @param frame 可用于区分哪个窗口调用的
 @param completionHandler 确认框消失的时候调用, 回调给JS, 参数为选择结果: YES or NO
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

/** 对应js的prompt方法
 webView中弹出输入框时调用, 两个按钮 和 一个输入框
 
 @param webView webView description
 @param prompt 提示信息
 @param defaultText 默认提示文本
 @param frame 可用于区分哪个窗口调用的
 @param completionHandler 输入框消失的时候调用, 回调给JS, 参数为输入的内容
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入" message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText ?: @"请输入";
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *tf = [alert.textFields firstObject];
        
        completionHandler(tf.text);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark WKNavigationDelegate

// 决定导航的动作，通常用于处理跨域的链接能否导航。
// WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接单独处理。
// 但是，对于Safari是允许跨域的，不用这么处理。
// 这个是决定是否Request
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //  在发送请求之前，决定是否跳转,我怎么决定
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 是否接收响应
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    // 在收到响应后，决定是否跳转和发送请求之前那个允许配套使用
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler
{
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling ,nil);
}

// main frame的导航开始请求时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [TalkingData trackEvent:@"网络请求" label:@"网页地址" parameters:@{@"urlStr":webView.URL.absoluteString}];
}

// 当main frame接收到服务重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    // 接收到服务器跳转请求之后调用
}

// 当main frame开始加载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
}

//当main frame导航完成时，会回调
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    // 页面加载完成之后调用
    if (!self.title.length) {
        self.title = webView.title;
    }
}

// 当main frame最后下载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
}

// 当web content处理完成时，会回调
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
}

#pragma mark ================== WKScriptMessageHandler =============================

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message
{
    if (!message.body)
    {
        return;
    }
    
    
    BOBLog(@"%@",message.body);
}

#pragma mark ================ notification ================
//接收到屏幕方向将要发生改变的通知
- (void)handleStatusBarOrientationWillChange:(NSNotification *)noti
{
    
     UIInterfaceOrientation currentInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    id value = noti.userInfo[UIApplicationStatusBarOrientationUserInfoKey];
    
    UIInterfaceOrientation interfaceOrientation = [NSString stringWithFormat:@"%@",value].integerValue;
    
    if ((currentInterfaceOrientation == interfaceOrientation) || (currentInterfaceOrientation == UIInterfaceOrientationUnknown) || (interfaceOrientation == UIInterfaceOrientationUnknown))
    {
        return;
    }
    
    CGFloat navMaxY = 0;
    CGFloat tabMinY = 0;
    
    if (((currentInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || currentInterfaceOrientation == UIInterfaceOrientationLandscapeRight) && (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)))
    {
        //横>竖
        navMaxY = 64;
        tabMinY = 49;
    }
    else if
    (((currentInterfaceOrientation == UIInterfaceOrientationPortrait || currentInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) && (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)))
    {
        //竖>横
        navMaxY = 32;
        tabMinY = 32;
    }
    
    
    if (!navMaxY) {
        return;
    }
    CGRect rect = self.webview.frame;
    CGFloat width = rect.size.width;
    rect.size.width = rect.size.height;
    rect.size.height = width;
    
    self.webview.frame = rect;
    
    self.webview.scrollView.contentInset = UIEdgeInsetsMake(navMaxY, 0, tabMinY, 0);
}

#pragma mark event

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        id valueNew = change[NSKeyValueChangeNewKey];
        if (![valueNew isKindOfClass:NSNumber.class])
        {
            return;
        }
        
        NSString *progressStr = [NSString stringWithFormat:@"%@",valueNew];
        float progress = progressStr.floatValue;
        if (progress < 1)
        {
            [SVProgressHUD showProgress:progress];
        }else
        {
            [SVProgressHUD dismiss];
        }
    }
}

@end
