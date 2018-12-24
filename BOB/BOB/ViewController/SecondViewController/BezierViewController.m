//
//  BezierViewController.m
//  BOB
//
//  Created by 汲群英 on 2018/11/8.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "BezierViewController.h"

#import "BezierView.h"

@interface BezierViewController ()
{
    BezierView *bezierView;
    float rate;
    UITextField *textField;
}
@end

@implementation BezierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"demo";
    [self creatBezierView];
    [self creatCustomTextView];
}

- (void)creatBezierView
{
    bezierView = [[BezierView alloc] initWithFrame:CGRectMake(0, NavMaxY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - NavMaxY)];
    
    [self.view addSubview:bezierView];
    
    [bezierView showText:@"hello"
                        :[UIFont fontWithName:[UIFont familyNames].firstObject size:100]
                        :1
                        :nil];
}

- (void)creatCustomTextView
{
    int x, y, w, h;
    w = self.view.bounds.size.width * 3/4;
    x = (self.view.bounds.size.width - w)/2;
    h = 30;
    y = NavMaxY;
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    textField.placeholder = @"input";
    textField.backgroundColor = [UIColor lightGrayColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [bezierView showText:textField.text ?:textField.placeholder :[UIFont fontWithName:[UIFont familyNames].firstObject size:100] :3 :nil];
}

@end
