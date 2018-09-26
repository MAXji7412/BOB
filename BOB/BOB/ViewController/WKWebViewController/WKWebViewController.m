//
//  WKWebViewController.m
//  BOB
//
//  Created by 汲群英 on 2018/9/23.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import "WKWebViewController.h"


@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@end

@implementation WKWebViewController


#pragma mark controller life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatWebview];
    [self registerNotification];
    [self loadRequest];
    [self creatGoBackAndGoForwardButton];
}

- (void)dealloc
{
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleStatusBarOrientationWillChange:)
                                                name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
    
}

- (void)creatWebview
{
    if (self.webview) {
        return;
    }
    WKWebViewConfiguration *wkWebviewConfig = [WKWebViewConfiguration new];
    
    wkWebviewConfig.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    self.webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:wkWebviewConfig];
    
    self.webview.navigationDelegate = self;
    self.webview.UIDelegate = self;
    
    [self configWebViewContent];
    
    if (@available(iOS 11.0, *)) {
        self.webview.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.view addSubview:self.webview];
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

-  (void)configWebViewContent
{
    CGFloat navH = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat tabH = 0;
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:UITabBarController.class]) {
        
        UITabBarController *tabBarVC = (UITabBarController *)rootVC;
        tabH = tabBarVC.tabBar.bounds.size.height;
    }
    else if ([rootVC isKindOfClass:UINavigationController.class])
    {
        UINavigationController *navVC = (UINavigationController *)rootVC;
        UITabBarController *tabBarVC = navVC.viewControllers.firstObject;
        if ([tabBarVC isKindOfClass:UITabBarController.class]) {
            tabH = tabBarVC.tabBar.bounds.size.height;
        }
    }
    
    
    self.webview.scrollView.contentInset = UIEdgeInsetsMake(navH, 0, tabH, 0);
    
    self.webview.frame = self.view.bounds;
}

- (void)creatGoBackAndGoForwardButton
{
    //back
    UIImage *goBackIcon = [UIImage imageNamed:@"nav_back"];
    goBackIcon = [goBackIcon.copy imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *goBackButton = [[UIBarButtonItem alloc] initWithImage:goBackIcon
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(webviewGoBack)];
    
    //forward
    UIImage *goForwardIcon = [UIImage imageNamed:@"nav_forward"];
    goForwardIcon = [goForwardIcon.copy imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *goForwardBtn = [[UIBarButtonItem alloc] initWithImage:goForwardIcon
                                                                     style:2
                                                                    target:self
                                                                    action:@selector(webviewGoForward)];
    //add to navigation
    self.navigationItem.leftBarButtonItems = @[goBackButton,goForwardBtn];
}

- (void)webviewGoBack
{
    if ([self.webview canGoBack]) {
        [self.webview goBack];
    }else{
        
        
        [self.webview reload];
    }
    
}

- (void)webviewGoForward
{
    if ([self.webview canGoForward]) {
        [self.webview goForward];
    }else{
        [SVProgressHUD showImage:nil status:@"没有前进了"];
        [SVProgressHUD dismissWithDelay:1];
    }
    
}













#pragma mark WKWebView WKUIDelegate

/**
 webView中弹出警告框时调用, 只能有一个按钮
 
 @param webView webView
 @param message 提示信息
 @param frame 可用于区分哪个窗口调用的
 @param completionHandler 警告框消失的时候调用, 回调给JS
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    [SVProgressHUD showImage:nil status:message];
    NSAssert(0, @"look");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:message preferredStyle:(UIAlertControllerStyleAlert)];
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
    
    [SVProgressHUD showImage:nil status:message];
    NSAssert(0, @"look");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"同意" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不同意" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
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
    
    [SVProgressHUD showImage:nil status:prompt];
    NSAssert(0, @"look");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入" message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入";
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *tf = [alert.textFields firstObject];
        
        completionHandler(tf.text);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(defaultText);
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark WKNavigationDelegate

// 决定导航的动作，通常用于处理跨域的链接能否导航。
// WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接单独处理。
// 但是，对于Safari是允许跨域的，不用这么处理。
// 这个是决定是否Request
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //  在发送请求之前，决定是否跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 是否接收响应
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    // 在收到响应后，决定是否跳转和发送请求之前那个允许配套使用
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler{
    
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling ,nil);
}

// main frame的导航开始请求时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"1");
    [TalkingData trackEvent:@"网络请求" label:@"网页地址" parameters:@{@"urlStr":webView.URL.absoluteString}];
}

// 当main frame接收到服务重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"2");
    // 接收到服务器跳转请求之后调用
}

// 当main frame开始加载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"3");
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"4");
}

//当main frame导航完成时，会回调
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    // 页面加载完成之后调用
    if (!self.title.length) {
        self.title = webView.title;
    }
    NSLog(@"5");
}

// 当main frame最后下载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"6");
}

// 当web content处理完成时，会回调
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"7");
}


#pragma mark notification
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
        if ([valueNew isKindOfClass:NSNumber.class]) {
            NSString *progressStr = [NSString stringWithFormat:@"%@",valueNew];
            float progress = progressStr.floatValue;
            if (progress < 1) {
                [SVProgressHUD showProgress:progress];
            }else{
                [SVProgressHUD dismiss];
            }
            
        }
        
    }
}

@end
