//
//  KG_ZhiTaiNaviTopView.m
//  Frame
//
//  Created by zhangran on 2020/4/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ZhiWeiNaviTopView.h"
#import "KG_YiJianXunShiViewController.h"
#import "KG_LiXingWeiHuViewController.h"
#import "KG_TeShuBaoZhangViewController.h"
#define nvbH 40
@interface KG_ZhiWeiNaviTopView (){
    
    UIScrollView *scrollView;
    
}

@end

@implementation KG_ZhiWeiNaviTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupDataSubviews];
        
    }
    return self;
}


//创建视图
-(void)setupDataSubviews
{
    NSArray *array = @[@"一键巡视",@"例行维护",@"特殊保障"];
    self.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@40);
        make.top.equalTo(self.mas_top);
    }];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:array];
    segmentedControl.frame = CGRectMake(16, 8, SCREEN_WIDTH - 32,30);
    [segmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]}forState:UIControlStateSelected];
    
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2F5ED1"],NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]}forState:UIControlStateNormal];
    [self addSubview:segmentedControl];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor redColor];
    segmentedControl.layer.borderWidth = 1;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    segmentedControl.layer.borderColor = [UIColor colorWithHexString:@"#2F5ED1"].CGColor; //     边框颜色
    [segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]]
                                forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#2F5ED1"]]
                                forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    //scroView
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,nvbH,SCREEN_WIDTH,SCREEN_HEIGHT-nvbH)];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - nvbH);
    [self addSubview:scrollView];
    //把页面添加到scroView的三个页面
    KG_YiJianXunShiViewController *one = [[KG_YiJianXunShiViewController alloc]init];
    
    one.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - nvbH);
    [scrollView addSubview:one.view];
    KG_LiXingWeiHuViewController *two = [[KG_LiXingWeiHuViewController alloc]init];
    two.view.frame = CGRectMake(SCREEN_WIDTH * 1, 0, SCREEN_WIDTH, SCREEN_HEIGHT - nvbH);
    [scrollView addSubview:two.view];
    KG_TeShuBaoZhangViewController *three = [[KG_TeShuBaoZhangViewController alloc]init];
    three.view.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - nvbH);
    [scrollView addSubview:three.view];
}
- (void)change:(UISegmentedControl *)sender {
    NSLog(@"测试");
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"1");
    }else if (sender.selectedSegmentIndex == 1){
        NSLog(@"2");
    }else if (sender.selectedSegmentIndex == 2){
        NSLog(@"3");
    }else if (sender.selectedSegmentIndex == 3){
        NSLog(@"4");
    }
    switch (sender.selectedSegmentIndex) {
        case 0:
            [scrollView setContentOffset:CGPointMake(0, 0)];
            break;
        case 1:
            [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
            break;
        case 2:
            [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0)];
            break;
        default:
            break;
    }
}
- (UIImage*)createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
