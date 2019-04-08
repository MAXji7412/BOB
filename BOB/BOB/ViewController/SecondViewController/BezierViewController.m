//
//  BezierViewController.m
//  BOB
//
//  Created by 汲群英 on 2018/11/8.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "BezierViewController.h"

#import "BezierView.h"

@interface BezierViewController ()<UITextFieldDelegate>
{
    BezierView *bezierView;
    float rate;
    BOOL originNavBarHidden;
}
@end

@implementation BezierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"Bezier";
    [self creatBezierViewWithOriginY:[self creatTextField]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    originNavBarHidden = self.navigationController.isNavigationBarHidden;
    if (!originNavBarHidden)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:originNavBarHidden animated:YES];
}

- (void)creatBezierViewWithOriginY:(int)originY
{
    bezierView = [[BezierView alloc] initWithFrame:CGRectMake(0, originY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - originY)];
    bezierView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:bezierView];
    
    [bezierView showText:@"hello"
                        :[UIFont fontWithName:[UIFont familyNames].firstObject size:100]
                        :1
                        :nil];
}

- (int)creatTextField
{
    int x, y, w, h;
    w = self.view.bounds.size.width * 3/4;
    x = (self.view.bounds.size.width - w)/2;
    h = 30;
    y = NavMaxY + 5;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    textField.delegate = self;
    textField.placeholder = @"input";
    textField.backgroundColor = [UIColor lightGrayColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:textField];
    
    return CGRectGetMaxY(textField.frame) + 5;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSArray *fontNameArr = [UIFont familyNames];
    NSString *fontName = [fontNameArr objectAtIndex:arc4random() % fontNameArr.count];
    
    NSString *text = textField.text ?:textField.placeholder;
    
    [bezierView showText:text
                        :[UIFont fontWithName:fontName size:100]
                        :text.length * 0.5
                        :nil];
}


@end
