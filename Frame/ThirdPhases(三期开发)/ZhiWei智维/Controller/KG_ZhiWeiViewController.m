//
//  KG_ZhiWeiViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ZhiWeiViewController.h"
#import "KG_ZhiWeiNaviTopView.h"
@interface KG_ZhiWeiViewController ()
/**  标题栏 */
@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;
@property (nonatomic, strong)  KG_ZhiWeiNaviTopView *naviTopView;
@end

@implementation KG_ZhiWeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(18),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#24252A"]}] ;
    [self createNaviTopView];
    
    [self getTaskReportData];
    [self getWeiHuTaskData];
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    self.navigationController.navigationBarHidden = NO;
    
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navigationView];
    
    /** 添加标题栏 **/
    [self.navigationView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationView.mas_centerX);
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar+9);
    }];
    self.titleLabel.text = @"智维";
    
    /** 返回按钮 **/
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.navigationView.mas_left);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = IMAGE(@"ZhiWei_Lefticon");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    UIButton *histroyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    histroyBtn.titleLabel.font = FontSize(12);
    
    
    [histroyBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [histroyBtn setImage:[UIImage imageNamed:@"history_icon"] forState:UIControlStateNormal];
    histroyBtn.frame = CGRectMake(0,0,81,22);
    [self.view addSubview:histroyBtn];
    [histroyBtn addTarget:self action:@selector(historyAction) forControlEvents:UIControlEventTouchUpInside];
    [histroyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@24);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.height.equalTo(@24);
        make.right.equalTo(self.view.mas_right).offset(-16);
    }];
       
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.titleLabel.font = FontSize(12);
    self.rightButton.layer.borderColor = [[UIColor colorWithHexString:@"#DFDFDF"]CGColor];
    self.rightButton.layer.borderWidth = 0.5f;
    self.rightButton.layer.cornerRadius = 12.5f;
    self.rightButton.layer.masksToBounds = YES;
    
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"黄城导航台" forState:UIControlStateNormal];
    self.rightButton.frame = CGRectMake(0,0,81,22);
    [self.rightButton setImage:[UIImage imageNamed:@"ZhiWei_rightIcon"] forState:UIControlStateNormal];
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0,0 )];
    [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0,0 )];
    [self.view addSubview:self.rightButton];
    [self.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@81);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.height.equalTo(@22);
        make.right.equalTo(histroyBtn.mas_left).offset(-6);
    }];
    
    self.naviTopView = [[KG_ZhiWeiNaviTopView alloc]init];
    self.naviTopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.naviTopView];
    [self.naviTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    
    
}
- (void)rightAction {
    
    
}
- (void)historyAction {
    
    
}

- (void)backButtonClick:(UIButton *)button {
    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    
}
/** 标题栏 **/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

//获取任务状态字典接口：
//请求地址：/intelligent/atcDictionary?type_code=taskStatus
//请求方式：GET
//请求返回：
//如：http://192.168.100.173:8089/intelligent/atcDictionary?type_code=taskStatus

- (void)getTaskReportData {
    NSString *  FrameRequestURL  =  [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/atcDictionary?type_code=taskStatus"];
      [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
          NSInteger code = [[result objectForKey:@"errCode"] intValue];
          if(code  <= -1){
              [FrameBaseRequest showMessage:result[@"errMsg"]];
              return ;
          }
         
          NSLog(@"1");
      } failure:^(NSURLSessionDataTask *error)  {
          FrameLog(@"请求失败，返回数据 : %@",error);
          NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
          if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
              [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
              [FrameBaseRequest logout];
              UIViewController *viewCtl = self.navigationController.viewControllers[0];
              [self.navigationController popToViewController:viewCtl animated:YES];
              return;
          }else if(responses.statusCode == 502){
              
          }
          [FrameBaseRequest showMessage:@"网络链接失败"];
          return ;
          
      }];
}
//
//获取例行维护下任务子类型字典接口：
//请求地址：/intelligent/atcDictionary?type_code=routineMaintenance
//请求方式：GET
//请求返回：
//如：http://192.168.100.173:8089/intelligent/atcDictionary?type_code=routineMaintenance

- (void)getWeiHuTaskData {
    NSString *  FrameRequestURL  =  [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/atcDictionary?type_code=routineMaintenance"];
      [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
          NSInteger code = [[result objectForKey:@"errCode"] intValue];
          if(code  <= -1){
              [FrameBaseRequest showMessage:result[@"errMsg"]];
              return ;
          }
         
          NSLog(@"1");
      } failure:^(NSURLSessionDataTask *error)  {
          FrameLog(@"请求失败，返回数据 : %@",error);
          NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
          if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
              [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
              [FrameBaseRequest logout];
              UIViewController *viewCtl = self.navigationController.viewControllers[0];
              [self.navigationController popToViewController:viewCtl animated:YES];
              return;
          }else if(responses.statusCode == 502){
              
          }
          [FrameBaseRequest showMessage:@"网络链接失败"];
          return ;
          
      }];
}

//获取一键巡视下任务子类型字典接口：
//请求地址：/intelligent/atcDictionary?type_code=oneTouchTour
//请求方式：GET
//请求返回：
//如：http://192.168.100.173:8089/intelligent/atcDictionary?type_code=oneTouchTour


- (void)getXunShiTaskData {
    NSString *  FrameRequestURL  =  [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/atcDictionary?type_code=oneTouchTour"];
      [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
          NSInteger code = [[result objectForKey:@"errCode"] intValue];
          if(code  <= -1){
              [FrameBaseRequest showMessage:result[@"errMsg"]];
              return ;
          }
         
          NSLog(@"1");
      } failure:^(NSURLSessionDataTask *error)  {
          FrameLog(@"请求失败，返回数据 : %@",error);
          NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
          if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
              [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
              [FrameBaseRequest logout];
              UIViewController *viewCtl = self.navigationController.viewControllers[0];
              [self.navigationController popToViewController:viewCtl animated:YES];
              return;
          }else if(responses.statusCode == 502){
              
          }
          [FrameBaseRequest showMessage:@"网络链接失败"];
          return ;
          
      }];
}
@end
