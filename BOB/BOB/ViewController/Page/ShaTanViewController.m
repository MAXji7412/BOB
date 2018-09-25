//
//  ShaTanViewController.m
//  BOB
//
//  Created by 汲群英 on 2018/9/21.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import "ShaTanViewController.h"

#import "TabBarController.h"

@interface BgView :UIView
@end

@implementation BgView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self removeFromSuperview];
}

@end

#define RowHight 30

@interface ShaTanViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) NSDictionary *websitesDic;
@property (nonatomic,retain) BgView *moreWebsitesBgView;

@end

@implementation ShaTanViewController

#pragma mark controller life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.urlStr = self.websitesDic.allValues.firstObject;
    [self loadRequest];
    [self creatNavBarRightItem];
}


//导航栏右按钮
- (void)creatNavBarRightItem
{
    //moreWebsites
    UIImage *moreWebsitesIcon = [UIImage imageNamed:@"nav_net"];
    moreWebsitesIcon = [moreWebsitesIcon.copy imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *moreWebsitesSeleted = [[UIBarButtonItem alloc] initWithImage:moreWebsitesIcon
                                                                     style:2
                                                                    target:self
                                                                    action:@selector(moreWebsitesSel)];
    //add to navigation
    self.navigationItem.rightBarButtonItem = moreWebsitesSeleted;
}

//点击右按钮，弹出网站选择
- (void)moreWebsitesSel
{
    if (!self.moreWebsitesBgView) {
        self.moreWebsitesBgView = [[BgView alloc] initWithFrame:self.view.bounds];
        
        self.moreWebsitesBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [UIView animateWithDuration:.2 animations:^{
            self.moreWebsitesBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        } completion:^(BOOL finished) {
            [self creatTabViewIn:self.moreWebsitesBgView];
        }];
    }
    
    if (!self.moreWebsitesBgView.superview) {
        
        [self.navigationController.view addSubview:self.moreWebsitesBgView];
    }
    
}

- (void)disMissMoreWebsitesBgView
{
    [self.moreWebsitesBgView removeFromSuperview];
}

- (void)creatTabViewIn:(UIView *)bgView
{
    CGFloat X,Y,W,H ;
    CGFloat gap = 10;
    
    W = bgView.bounds.size.width/3;
    H = MIN(RowHight *self.websitesDic.count, CGRectGetHeight(bgView.bounds)/2);
    X = bgView.bounds.size.width - W - gap;
    Y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(X, Y, W, H) style:UITableViewStylePlain];
    
//    tabView.bounces = NO;
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.layer.masksToBounds = YES;
    tabView.layer.cornerRadius = gap;
    tabView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tabView.layer.borderWidth = 1;
    tabView.delegate = self;
    tabView.dataSource = self;
    
    
    [bgView addSubview:tabView];
}

#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.websitesDic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RowHight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    footerBtn.backgroundColor = ArcColor;
    [footerBtn setTitle:@"输入网址" forState:0];
    
    [footerBtn addTarget:self action:@selector(urlInput) forControlEvents:UIControlEventTouchUpInside];
    
    return footerBtn;
}

- (void)urlInput
{
    [self disMissMoreWebsitesBgView];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"输入网址"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:nil];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * action) {
                                                              self.urlStr = alert.textFields.firstObject.text;
                                                              [self loadRequest];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                          handler:nil];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"cell_%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [self.websitesDic.allKeys objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.urlStr = [self.websitesDic.allValues objectAtIndex:indexPath.row];
    [self loadRequest];
    [self disMissMoreWebsitesBgView];
}


#pragma mark data
- (NSDictionary *)websitesDic
{
    if (_websitesDic) {
        return _websitesDic;
    }
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


@end
