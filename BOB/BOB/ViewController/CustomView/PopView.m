//
//  PopView.m
//  BOB
//
//  Created by 汲群英 on 2018/10/10.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import "PopView.h"

#define RowHight 30
#define GAP RowHight/3

@interface PopView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) NSArray *dataArr;
@property (nonatomic,copy) SeletedBlock seletedblock;

@end

@implementation PopView

#pragma mark entrance func
+ (void)showWithArray:(NSArray *)dataArr complete:(SeletedBlock)block;
{
    PopView *popView = [[PopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    popView.dataArr = dataArr;
    popView.seletedblock = block;
    [popView mainInit];
    
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
}

- (void)mainInit
{
    
    [self creatTableView];//tableview
    [self animations];//动画
}

- (void)creatTableView
{
    CGFloat X,Y,W,H ;
    
    W = self.bounds.size.width/3;
    H = MIN(RowHight *self.dataArr.count, CGRectGetHeight(self.bounds)/2);
    X = self.bounds.size.width - W - GAP;
    Y = NavMaxY + GAP;
    
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(X, Y, W, H) style:UITableViewStylePlain];
    
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.layer.masksToBounds = YES;
    tabView.layer.cornerRadius = GAP;
    tabView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tabView.layer.borderWidth = 1;
    tabView.delegate = self;
    tabView.dataSource = self;
    
    [self addSubview:tabView];
    [self setNeedsDisplay];
}

- (void)animations
{
    self.alpha = 0;
    [UIView animateWithDuration:.15 animations:^{
        self.alpha = 1;
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.5];
    }];
    
}

#pragma mark delegate

#pragma viewcontroller delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
 // Drawing code
     
    //拿到当前视图准备好的画板
    CGContextRef  context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);//路径开始标志
    
    CGFloat location = self.bounds.size.width;
    CGFloat dependX = location -  RowHight;
    CGFloat dependY = NavMaxY;
    
    //勾股定理, 全等三角形斜边长X,pow(X, 2) - pow(X/2, 2) = pow(高, 2)，X = sqrt(pow(高, 2) * pow(2, 2) / 3)
    CGFloat hypotenuseLength = sqrt(pow(GAP, 2) * pow(2, 2) / 3);
    
    CGContextMoveToPoint(context, dependX, dependY);//设置起点（三角形顶）
    CGContextAddLineToPoint(context, dependX - hypotenuseLength/2, GAP+dependY);//经过点（三角形左下角）
    CGContextAddLineToPoint(context, dependX + hypotenuseLength/2, GAP+dependY);//经过点（三角形右下角）
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor whiteColor] setFill];//设置填充色
    [[UIColor whiteColor] setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
 }

#pragma TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RowHight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"cell_%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [self.dataArr objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeFromSuperview];
    
    if (self.seletedblock)
    {
        self.seletedblock(indexPath.row);
    }
}


@end
