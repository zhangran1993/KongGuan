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
        self.xunshiString = @"一键巡视";
        [self getXunShiNameData];
          
//        [self quertTaskChildData];
       
    }
    return self;
}


//创建视图
-(void)setupDataSubviews
{
    NSArray *array = @[safeString(self.xunshiString) ,@"例行维护",@"特殊保障"];
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
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:array];
    self.segmentedControl.frame = CGRectMake(16, 8, SCREEN_WIDTH - 32,30);
    [self.segmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]}forState:UIControlStateSelected];
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2F5ED1"],NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]}forState:UIControlStateNormal];
    [self addSubview:self.segmentedControl];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.tintColor = [UIColor whiteColor];
    self.segmentedControl.layer.borderWidth = 1;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    self.segmentedControl.layer.borderColor = [UIColor colorWithHexString:@"#2F5ED1"].CGColor; //     边框颜色
    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]]
                                forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#2F5ED1"]]
                                forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    //scroView
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,nvbH,SCREEN_WIDTH,SCREEN_HEIGHT-nvbH -Height_TabBar  -NAVIGATIONBAR_HEIGHT  )];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    [self addSubview:scrollView];
    //把页面添加到scroView的三个页面
    KG_YiJianXunShiViewController *one = [[KG_YiJianXunShiViewController alloc]init];
    one.didsel = ^(NSDictionary * _Nonnull dataDic, NSString * _Nonnull statusType) {
        if (self.didsel) {
            self.didsel(dataDic, statusType);
        }
    };
    
    one.addMethod  = ^(NSString * _Nonnull statusType) {
        if (self.addMethod) {
            self.addMethod(statusType);
        }
    };
    one.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, scrollView.frame.size.height);
    [scrollView addSubview:one.view];
    KG_LiXingWeiHuViewController *two = [[KG_LiXingWeiHuViewController alloc]init];
    two.didsel = ^(NSDictionary * _Nonnull dataDic, NSString * _Nonnull statusType) {
           if (self.didsel) {
               self.didsel(dataDic, statusType);
           }
       };
    two.addMethod  = ^(NSString * _Nonnull statusType) {
        if (self.addMethod) {
            self.addMethod(statusType);
        }
    };
    two.view.frame = CGRectMake(SCREEN_WIDTH * 1, 0, SCREEN_WIDTH, scrollView.frame.size.height );
    [scrollView addSubview:two.view];
    KG_TeShuBaoZhangViewController *three = [[KG_TeShuBaoZhangViewController alloc]init];
    three.view.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, scrollView.frame.size.height);
    three.didsel = ^(NSDictionary * _Nonnull dataDic, NSString * _Nonnull statusType) {
           if (self.didsel) {
               self.didsel(dataDic, statusType);
           }
       };
    three.addMethod  = ^(NSString * _Nonnull statusType) {
        if (self.addMethod) {
            self.addMethod(statusType);
        }
    };
    [scrollView addSubview:three.view];
    
    
    [self.segmentedControl setSelectedSegmentIndex:[UserManager shareUserManager].zhiweiSegmentCurIndex];
    switch ([UserManager shareUserManager].zhiweiSegmentCurIndex) {
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
    [UserManager shareUserManager].zhiweiSegmentCurIndex = sender.selectedSegmentIndex;
    switch (sender.selectedSegmentIndex) {
        case 0:
            [scrollView setContentOffset:CGPointMake(0, 0)];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshZhiWeiFirstData" object:self];
            break;
        case 1:
            [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshZhiWeiSecondData" object:self];
            break;
        case 2:
            [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0)];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshZhiWeiThirdData" object:self];
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
//获取一键巡视下任务子类型字典接口：
//请求地址：/intelligent/atcDictionary?type_code=oneTouchTour
//请求方式：GET

- (void)quertTaskChildData {
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=oneTouchTour"]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
             
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
      
        
    }];
    
}
//判断显示一键巡视还是现场巡视
- (void)getXunShiNameData {
//    {stationCode}
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/templateVerify/%@",safeString(currDic[@"code"])]];
      [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
          NSInteger code = [[result objectForKey:@"errCode"] intValue];
          if(code  <= -1){
              [FrameBaseRequest showMessage:result[@"errMsg"]];
              return ;
          }
          
          if(![result[@"value"] boolValue]) {
              
              self.xunshiString = @"现场巡视";
          }else {
              self.xunshiString = @"一键巡视";
          }
          [self setupDataSubviews];
         
          NSLog(@"1");
      } failure:^(NSURLSessionDataTask *error)  {
          FrameLog(@"请求失败，返回数据 : %@",error);
          NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
         
          [FrameBaseRequest showMessage:@"网络链接失败"];
          return ;
          
      }];
}

@end
