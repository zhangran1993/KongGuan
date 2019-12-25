//
//  HomeHotInfoView.m
//  RHYM
//
//  Created by shmily on 2018/2/5.
//  Copyright © 2018年 HuaZhengInfo. All rights reserved.
//

#import "HomeCarouselView.h"
#import "UIView+LX_Frame.h"
#import "WheelModel.h"
#define Home_NEWINFO_H (40)
@interface HomeCarouselView()
@property (weak, nonatomic) IBOutlet UIView *viewR;
@property(nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
@implementation HomeCarouselView
{
    UIButton * flagBtn;
    UIScrollView * flagScrollView;
    NSInteger flagindex;
    NSInteger flagRows;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    flagindex = 0;
    flagRows = 0;
    self.topLine.backgroundColor = RGBColor(243, 243, 243);
    self.bottomLine.backgroundColor = RGBColor(243, 243, 243);
    self.backgroundColor = [UIColor redColor];
    
    _homeLight.opaque = NO;
    _homeLight.userInteractionEnabled = NO;//用户不可交互
    _homeLight.backgroundColor = [UIColor whiteColor];
    NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle]pathForResource:@"green" ofType:@"gif"]];
    [_homeLight loadRequest:[NSURLRequest requestWithURL:url]];
    [_homeLight setScalesPageToFit:YES];//自动适应当前frame大小
    // [_homeLight loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
}


- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    CGFloat scrollH = self.lx_height;
    CGFloat scrollW = WIDTH_SCREEN - 100;
    CGFloat scrollConH = scrollH;
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.viewR.bounds;
    scrollView.lx_height = self.lx_height;
    [self.viewR addSubview:scrollView];
    
    flagScrollView = scrollView;
    flagRows =dataArr.count;
    NSTimer * timer = [NSTimer timerWithTimeInterval:2.5 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(scrollW, scrollConH);
    scrollView.pagingEnabled = YES;
    
    CGFloat btnY = 0;
    for (int i = 0; i<dataArr.count; i++) {
        WheelModel *model = dataArr[i];
        NSString * str = model.context;
        
        UIButton * btn = [[UIButton alloc] init];
        btn.tag = i;
        [scrollView addSubview:btn];
        if (flagBtn) {
            btnY = CGRectGetMaxY(flagBtn.frame);
        }
        btn.frame = CGRectMake(0, btnY, scrollW, self.lx_height);
        flagBtn = btn;
        
        [scrollView addSubview:btn];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleLabel.font = FontSize(14);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)timeAction{
    flagindex ++;
    if (flagindex == flagRows) {
        flagindex = 0;
        flagScrollView.contentOffset = CGPointMake(0, flagindex * CGRectGetHeight(flagScrollView.frame));
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            flagScrollView.contentOffset = CGPointMake(0, flagindex * CGRectGetHeight(flagScrollView.frame));
        }];
    }
}


- (void)btnAction:(UIButton *)btn{
    NSInteger index = btn.tag;
    if ([self.delegate respondsToSelector:@selector(HomeCarouselViewDelegateClickAtIndex:)]) {
        [self.delegate HomeCarouselViewDelegateClickAtIndex:index];
    }
}


-(void)dealloc{
    [_timer invalidate];
    //[_homeLight release];
    [super dealloc];
}

@end
