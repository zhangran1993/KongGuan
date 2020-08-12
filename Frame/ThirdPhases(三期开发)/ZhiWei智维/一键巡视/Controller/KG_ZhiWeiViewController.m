//
//  KG_ZhiWeiViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ZhiWeiViewController.h"
#import "KG_ZhiWeiNaviTopView.h"
#import "KG_XunShiReportDetailViewController.h"
#import "UIViewController+CBPopup.h"
#import "KG_ZhiTaiStationModel.h"
#import "KG_NewContentViewController.h"
#import "RS_ConditionSearchView.h"
#import "KG_HistoryTaskViewController.h"
#import "KG_CreateXunShiContentViewController.h"
#import "UIViewController+YQSlideMenu.h"
#import "KG_WeihuDailyReportDetailViewController.h"
#import <UIButton+WebCache.h>
@interface KG_ZhiWeiViewController ()<UITableViewDelegate,UITableViewDataSource>
/**  标题栏 */
@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;
@property (nonatomic, strong)  KG_ZhiWeiNaviTopView *naviTopView;

@property(strong,nonatomic)   NSArray *stationArray;
@property(strong,nonatomic)   UITableView *stationTabView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic ,strong) RS_ConditionSearchView *searchView;

@property (nonatomic, strong)  UIButton    *leftIconImage;

@end

@implementation KG_ZhiWeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshZhiWeiData) name:@"refreshZhiWeiData" object:nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(18),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#24252A"]}] ;
    [self createNaviTopView];
    [self loadData];
    [self getLeaderNameData];
    //    [self getTaskReportData];
    
    //    [self queryData];
    //    //获取执行负责人
    //    [self quertPersonData];
    //    //获取任务执行负责人/执行人列表，与组织结构关联：
    //    [self quertHeadListData];
    
}
//刷新智维页面数据
- (void)refreshZhiWeiData {
    
    [self.naviTopView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.naviTopView = nil;
    [self.naviTopView removeFromSuperview];
    [self createSegmentView];
}
-(void)dealloc
{
    [super dealloc];
    //第一种方法.这里可以移除该控制器下的所有通知
    //移除当前所有通知
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)loadData {
    //获取任务状态字典接口：
    [self getTaskStatusDic];
    //获取例行维护下任务子类型字典接口
    [self getWeiHuTaskData];
    //获取特殊保障下任务子类型字典接口：
    [self querySpecialTaskData];
}
//获取任务状态字典接口：
- (void)getTaskStatusDic {
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=taskStatus"]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [UserManager shareUserManager].taskStatusArr = result[@"value"];
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
    [self.naviTopView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.naviTopView = nil;
    [self.naviTopView removeFromSuperview];
    [self createSegmentView];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    if (currDic.count) {
        [self.rightButton setTitle:safeString(currDic[@"alias"]) forState:UIControlStateNormal];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"icon"]){
        
        [self.leftIconImage sd_setImageWithURL:[NSURL URLWithString:[WebNewHost stringByAppendingString:[userDefaults objectForKey:@"icon"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_blueIcon"]];
    }else {
        
        [self.leftIconImage setImage:[UIImage imageNamed:@"head_blueIcon"] forState:UIControlStateNormal] ;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    
    
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
        make.left.equalTo(self.navigationView.mas_left).offset(10);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    self.leftIconImage = [[UIButton alloc] init];
    
    [self.navigationView addSubview:self.leftIconImage];
    self.leftIconImage.layer.cornerRadius =17.f;
    self.leftIconImage.layer.masksToBounds = YES;
    [self.leftIconImage setImage:[UIImage imageNamed:@"head_blueIcon"] forState:UIControlStateNormal];
    [self.leftIconImage addTarget:self action:@selector(leftCenterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"icon"]){
        
        [self.leftIconImage sd_setImageWithURL:[NSURL URLWithString:[WebNewHost stringByAppendingString:[userDefaults objectForKey:@"icon"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_blueIcon"]];
        
    }else {
        
        [self.leftIconImage setImage: [UIImage imageNamed:@"head_blueIcon"] forState:UIControlStateNormal];
    }
      
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
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    if (currDic.count) {
        [self.rightButton setTitle:safeString(currDic[@"alias"]) forState:UIControlStateNormal];
    }
    [self.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@81);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.height.equalTo(@22);
        make.right.equalTo(histroyBtn.mas_left).offset(-6);
    }];
    [self.leftIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationView.mas_left).offset(16);
        make.width.height.equalTo(@34);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    //单台站不可点击
    self.rightButton.userInteractionEnabled = NO;
    [self createSegmentView];
    
    
}

- (void)createSegmentView {
    self.naviTopView = [[KG_ZhiWeiNaviTopView alloc]init];
    self.naviTopView.selIndex = [UserManager shareUserManager].zhiweiSegmentCurIndex;
    self.naviTopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.naviTopView];
    self.naviTopView.didsel = ^(NSDictionary * _Nonnull dataDic, NSString * _Nonnull statusType) {
        if([safeString(dataDic[@"status"]) isEqualToString:@"5"]){
            [FrameBaseRequest showMessage:@"请先领取任务"];
            return;
        }
        NSString *ss = safeString(dataDic[@"patrolCode"]);
        if ([ss isEqualToString:@"monthSafeguard"] || [ss isEqualToString:@"daySafeguard"]  || [ss isEqualToString:@"yearSafeguard"] ||[ss isEqualToString:@"weekSafeguard"]  ) {
            
            KG_WeihuDailyReportDetailViewController *vc = [[KG_WeihuDailyReportDetailViewController alloc]init];
            vc.dataDic = dataDic;
            
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            KG_XunShiReportDetailViewController *vc = [[KG_XunShiReportDetailViewController alloc]init];
            vc.dataDic = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
        }
       
    };
    self.naviTopView.addMethod = ^(NSString * _Nonnull statusType) {
        KG_CreateXunShiContentViewController *vc = [[KG_CreateXunShiContentViewController alloc]init];
        
        vc.statusType = statusType;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    [self.naviTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
}

- (void)rightAction {
    
    [self stationAction];
}

- (void)historyAction {
    
    KG_HistoryTaskViewController *vc = [[KG_HistoryTaskViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backButtonClick:(UIButton *)button {
    [self leftCenterButtonClick];
//    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    
}
/**
 弹出个人中心
 */
- (void)leftCenterButtonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyingHeadNotification" object:self];
    [self.slideMenuController showMenu];
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
    //    NSString *  FrameRequestURL  =  [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/atcDictionary?type_code=taskStatus"];
    //
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/atcDictionary?type_code=taskStatus"];
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
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
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
    //    NSString *  FrameRequestURL  =  [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/atcDictionary?type_code=routineMaintenance"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/atcDictionary?type_code=routineMaintenance"];
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
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
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
    //    NSString *  FrameRequestURL  =  [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/atcDictionary?type_code=oneTouchTour"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/atcDictionary?type_code=oneTouchTour"];
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
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
}

- (void)queryData {
    
    //    获取任务状态字典接口：
    //    请求地址：/intelligent/atcDictionary?type_code=taskStatus
    //    请求方式：GET
    //    请求返回：
    //    如：http://192.168.100.173:8089/intelligent/atcDictionary?type_code=taskStatus
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=taskStatus"]];
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
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
    
}
//获取监控平台下所有用户列表，用来获取执行负责人名称：
- (void)quertPersonData {
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/userList"]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [UserManager shareUserManager].exeHeadArr = result[@"value"];
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
               NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}

//获取任务执行负责人/执行人列表，与组织结构关联：
- (void)quertHeadListData {
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/userListByOrg"]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [UserManager shareUserManager].executiveList = result[@"value"];
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
               NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}

-(void)getStationList{
    
    UIViewController *vc = [UIViewController new];
    //按钮背景 点击消失
    UIButton * bgBtn = [[UIButton alloc]init];
    [vc.view addSubview:bgBtn];
    [bgBtn setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    bgBtn.alpha = 0.1;
    [bgBtn addTarget:self action:@selector(closeFrame) forControlEvents:UIControlEventTouchUpInside];
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vc.view.mas_top);
        make.left.equalTo(vc.view.mas_left);
        make.right.equalTo(vc.view.mas_right);
        make.bottom.equalTo(vc.view.mas_bottom);
    }];
    
    [vc.view addSubview:bgBtn];
    vc.view.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT -64 +44, SCREEN_WIDTH,  SCREEN_HEIGHT);
    //_vc.view.layer.cornerRadius = 4.0;
    vc.view.layer.masksToBounds = YES;
    UIImageView *topImage = [[UIImageView alloc]init];
    topImage.image = [UIImage imageNamed:@"slider_up"];
    
    [vc.view addSubview:topImage];
    //设置滚动
    self.stationTabView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -162- 16, FrameWidth(20), 162 ,294)];
    self.stationTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [vc.view addSubview:self.stationTabView];
    self.stationTabView.dataSource = self;
    self.stationTabView.delegate = self;
    self.stationTabView.separatorStyle = NO;
    [self.stationTabView reloadData];
    float xDep = NAVIGATIONBAR_HEIGHT;
    
    [self.stationTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vc.view.mas_top).offset(xDep);
        make.right.equalTo(vc.view.mas_right).offset(-16);
        make.width.equalTo(@162);
        make.height.equalTo(@311);
    }];
    self.stationTabView.layer.cornerRadius = 8.f;
    self.stationTabView.layer.masksToBounds = YES;
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stationTabView.mas_top).offset(-7);
        make.right.equalTo(vc.view.mas_right).offset(-28);
        make.width.equalTo(@25);
        make.height.equalTo(@7);
    }];
    
    
    
    
    
    
    [self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentLeft overlayDismissed:nil];
    
}
-(void)closeFrame{//消失
    
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableviewDatasource 数据源方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.stationTabView){
        
        return 40;
    }
    return FrameWidth(210);
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.stationTabView){
        return self.stationArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.2 去缓存池中取Cell
    if(tableView == self.stationTabView){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        KG_ZhiTaiStationModel *model = self.stationArray[indexPath.row];
        cell.textLabel.text = safeString(model.name) ;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        
        return cell;
        
    }
    
    
    
    return nil;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_ZhiTaiStationModel *model = self.stationArray[indexPath.row];
    NSLog(@"1");
    [UserManager shareUserManager].currentStationDic = [model mj_keyValues];
    [self.rightButton setTitle:safeString(model.name) forState:UIControlStateNormal];
    [[UserManager shareUserManager] saveStationData:[model mj_keyValues]];
    
    
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
    self.naviTopView = nil;
    [self.naviTopView removeFromSuperview];
    self.naviTopView = [[KG_ZhiWeiNaviTopView alloc]init];
    self.naviTopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.naviTopView];
   
    
    self.naviTopView.didsel = ^(NSDictionary * _Nonnull dataDic, NSString * _Nonnull statusType) {
        if([safeString(dataDic[@"status"]) isEqualToString:@"5"]){
            [FrameBaseRequest showMessage:@"请先领取任务"];
            return;
        }
        NSString *ss = safeString(dataDic[@"patrolCode"]);
        if ([ss isEqualToString:@"monthSafeguard"] || [ss isEqualToString:@"daySafeguard"]  || [ss isEqualToString:@"yearSafeguard"] ||[ss isEqualToString:@"weekSafeguard"]) {
            
            KG_WeihuDailyReportDetailViewController *vc = [[KG_WeihuDailyReportDetailViewController alloc]init];
            vc.dataDic = dataDic;
            
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            KG_XunShiReportDetailViewController *vc = [[KG_XunShiReportDetailViewController alloc]init];
            vc.dataDic = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    };
    
    [self.naviTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
}


-(void)stationAction {
    
    
    NSArray *array = [UserManager shareUserManager].stationList;
    
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *stationDic in array) {
        [list addObject:stationDic[@"station"]];
    }
    self.stationArray = [KG_ZhiTaiStationModel mj_objectArrayWithKeyValuesArray:list];
    [self getStationList];
    
    
    
}
//获取特殊保障下任务子类型字典接口：
//特殊保障，分为特殊巡视和特殊维护。
//获取特殊巡视下任务子类型字典接口：
//请求地址：/intelligent/atcDictionary?type_code=specialTour
//请求方式：GET
//请求返回：
//如：http://192.168.100.173:8089/intelligent/atcDictionary?type_code=specialTour


- (void)querySpecialTaskData {
    
    //    获取任务状态字典接口：
    //    请求地址：/intelligent/atcDictionary?type_code=taskStatus
    //    请求方式：GET
    //    请求返回：
    //    如：http://192.168.100.173:8089/intelligent/atcDictionary?type_code=taskStatus
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=specialTour"]];
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
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
    
}
//获取执行负责人列表
- (void)getLeaderNameData {
    
//
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/userList"]];
    [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [UserManager shareUserManager].leaderNameArray = result[@"value"];
        NSLog(@"完成");
       
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSLog(@"完成");
        
    }];

}

@end
