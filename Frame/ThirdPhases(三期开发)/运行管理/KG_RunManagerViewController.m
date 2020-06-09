//
//  KG_RunManagerViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunManagerViewController.h"
#import "LoginViewController.h"
#import "KG_StationReportCell.h"
#import "KG_RunWeiHuCell.h"
#import "KG_RunReportCell.h"
#import "UIViewController+YQSlideMenu.h"
#import "KG_RunZhiHuiYunViewController.h"
#import "KG_StationReportAlarmViewController.h"
#import "KG_RunPromptViewController.h"
#import "KG_JiaoJieBanRecordViewController.h"
#import "KG_RunListViewController.h"
#import "PersonalPatrolController.h"
#import "KG_JiaoJieBanAlertView.h"
#import "KG_RunReportDetailViewController.h"
#import "KG_RunJiaoJieBanCell.h"
#import "KG_CreateReportAlertView.h"
#import "ZRDatePickerView.h"
#import "KG_RunManagerFirstCell.h"
#import "KG_RunManagerSecondCell.h"
#import "KG_RunManagerThirdCell.h"
#import "KG_RunManagerFourthCell.h"
#import "KG_RunMangerFifthCell.h"
#import "KG_ChooseJiaoJieBanAlertView.h"



@interface KG_RunManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UINavigationControllerDelegate,WYLDatePickerViewDelegate>
@property (strong, nonatomic) NSDictionary *currentStationDic;


@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UILabel   *titleLabel;

@property (nonatomic, strong)  UIView    *stationReportView;//台站任务提醒
@property (nonatomic, strong)  UIView    *stationWeihuView;//维护
@property (nonatomic, strong)  UIView    *runReprtView;//运行报告View
@property (nonatomic, strong)  UIView    *jiaojiebanView;//交接班View
@property (nonatomic, strong)  UIView    *zhihuiyunView;

@property (nonatomic, strong)  NSDictionary *loginNameInfo;

@property (nonatomic, strong)  NSArray    *reportListArr;//维护
@property (nonatomic, strong)  NSArray    *stationTaskInfoArr;//台站任务提醒
@property (nonatomic, strong)  NSArray    *stationRunReportArr;//台站运行报告arr
@property (nonatomic, strong)  NSArray    *jiaojiebanListArr;

@property (nonatomic, strong)  UITableView *reportTableView;//1
@property (nonatomic, strong)  UITableView *weihuTableView;//2
@property (nonatomic, strong)  UITableView *runReportTableView;//3
@property (nonatomic, strong)  UITableView *jiaoJieBanTableView;//3
@property (nonatomic, strong)  UITableView *tableView;//3
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong)  NSDictionary *jiaoJieBanInfo;
@property (nonatomic, strong) ZRDatePickerView *dataPickerview;
@property (nonatomic, strong)  KG_JiaoJieBanAlertView *jiaoJieBanAlertView;
@property (nonatomic, strong)  KG_CreateReportAlertView *createReportAlertView;
@property (nonatomic, strong)  KG_ChooseJiaoJieBanAlertView *jieBanAlertView;
@property (nonatomic ,assign) int currIndex;

@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;
@end

@implementation KG_RunManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate =self;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshYunxingData) name:@"refreshYunxingData" object:nil];
     
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    
    //获取当前的台站信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"station"]){
        self.currentStationDic = [userDefaults objectForKey:@"station"];
    }
    if(![userDefaults objectForKey:@"userAccount"]||[[userDefaults objectForKey:@"userAccount"] isEqualToString:@""]){
        
        if([CommonExtension isFirstLauch] == 1){//==2
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstLoginNotify) name:@"firstLoginNotify" object:nil];
        }else{
            [self firstLoginNotify];
        }
        return;
    }
    [self login];
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"station"]){
        NSDictionary *cuDic = [userDefaults objectForKey:@"station"];
        if (![cuDic[@"code"] isEqualToString:self.currentStationDic[@"code"]]) {
            self.currentStationDic = cuDic;
          
            [self queryData];
            [self quertFrameData];
            
        }
        
    }else {
        [self queryData];
        [self quertFrameData];
    }
    
           
}

- (void)refreshYunxingData {
   
    [self queryData];
    [self quertFrameData];
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    [self.navigationController setNavigationBarHidden:YES];
    
}


-(void)navigationController:(UINavigationController*)

navigationController willShowViewController:

(UIViewController *)viewController animated:(BOOL)animated

{
    
    [viewController viewWillAppear:animated];
    
}
- (void)login {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *userString = @"";
    NSString *passString = @"";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"password"]){
        passString = [userDefaults objectForKey:@"password"];
    }
    if([userDefaults objectForKey:@"loginName"]){
        userString = [userDefaults objectForKey:@"loginName"];
    }
    if (userString.length == 0 ||passString.length == 0) {
        return;
    }
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/api/login"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = userString;
    NSString * pwd = passString;//registrationID
    
    NSString *password=[[[[pwd MD5]  stringByAppendingString:params[@"username"]] MD5] MD5];
    
    params[@"password"] = password;
    
    //    params[@"registrationId"] = [userDefaults objectForKey:@"registrationID"];
    params[@"registrationId"] = @"1d13c2dc-fb3a-441f-976d-7a7537018245";
    NSString *specificStationCode = @"";
    if([userDefaults objectForKey:@"specificStationCode"]){
        specificStationCode = [userDefaults objectForKey:@"specificStationCode"];
    }
    params[@"specificStationCode"] = specificStationCode;
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        NSLog(@"resultresult %@",result);
        [self queryData];
        [self quertFrameData];
        
        [UserManager shareUserManager].loginSuccess = YES;
        
        [UserManager shareUserManager].userID = result[@"value"][@"userInfo"][@"id"];
        
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
    return ;
}


- (void)queryData{
    [self getRunPromptDetailData];
    [self getRunReportDetailData];
    [self queryJiaoJieBaneListData];
    [self queryTypeData];
    // 创建全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        // 请求一
        [self getLoginNameInfo:group];
    });
    dispatch_group_async(group, queue, ^{
        // 请求二
        [self getStationReportAlarmInfo:group];
    });
    dispatch_group_async(group, queue, ^{
        // 请求三
        [self getJiaoJieBanStatus:group];
        //        [self getRunPromptData:group];
    });
    
    dispatch_group_notify(group, queue, ^{
        
        NSLog(@"请求完成");
        NSLog(@"当前线程：%@，是否是主线程：%@...7777···",[NSThread currentThread],[NSThread isMainThread]?@"是":@"否");//当前线程：<NSThread: 0x60400026a540>{number = 3, name = (null)}，是否是主线程：否...7777···
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"当前线程：%@，是否是主线程：%@...8888···",[NSThread currentThread],[NSThread isMainThread]?@"是":@"否");//当前线程：<NSThread: 0x604000069700>{number = 1, name = main}，是否是主线程：是...8888···
            [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self createUI];
            
            [MBProgressHUD hideHUD];
            
        });
        
        //
        
    });
    
    
    
}
- (void)quertFrameData{
    //    NSString *FrameRequestURL = @"http://10.33.33.147:8089/intelligent/api/stationList";
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/stationList"]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUDForView:JSHmainWindow];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
        [UserManager shareUserManager].stationList = result[@"value"];
        
        [self createData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUDForView:JSHmainWindow];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            return;
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

- (void)createData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"station"]){
        self.currentStationDic = [userDefaults objectForKey:@"station"];
    }else {
        self.currentStationDic = [[UserManager shareUserManager].stationList firstObject][@"station"];
    }
    NSString *specificStationCode = @"";
    if([userDefaults objectForKey:@"specificStationCode"]){
        specificStationCode = [userDefaults objectForKey:@"specificStationCode"];
    }
    if (specificStationCode.length >0) {
        for (NSDictionary *stationDic in [UserManager shareUserManager].stationList) {
            if ([safeString(stationDic[@"station"][@"code"])  isEqualToString:specificStationCode]) {
                self.currentStationDic = stationDic[@"station"];
                break;
            }
        }
    }
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithDictionary:self.currentStationDic];
    for (NSString*s in [dataDic allKeys]) {
        if ([dataDic[s] isEqual:[NSNull null]]) {
            [dataDic setObject:@"" forKey:s];
        }
    }
    [userDefaults setObject:dataDic forKey:@"station"];
    
    [UserManager shareUserManager].currentStationDic = self.currentStationDic;
}

- (void)createUI {
    [self setupDataSubviews];
    [self setUpDataTableView];
   
//    //第一个
//    [self setUpStationReportView];
//    //    //第二个
//    [self setUpWeihuView];
//    //    //第三个
//    [self setUpRunReportView];
//    //
//    [self setUpJiaoJieBanView];
//    //
//    [self setUpzhihuiyunView];
    //
    //
    
}

- (void) setUpDataTableView{
    //scroView
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.width.equalTo(self.view.mas_width);
        make.top.equalTo(self.navigationView.mas_bottom).offset(5);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TABBAR_HEIGHT);
    }];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.tableView reloadData];
//
//    self.scrollView = [[UIScrollView alloc] init];
//    NSLog(@"SCREEN_HEIGHT %f",SCREEN_HEIGHT);
//    NSLog(@"HEIGHT_SCREEN %f",HEIGHT_SCREEN);
//    self.scrollView.frame = CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT);
//    self.scrollView.delegate = self;
//    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.scrollEnabled = YES;
//    self.scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT +120);
//    self.scrollView.showsVerticalScrollIndicator = NO;
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    [self.view addSubview:self.scrollView];
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.top.equalTo(self.view.mas_top);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-TABBAR_HEIGHT);
//    }];
}
//智慧云view
- (void)setUpzhihuiyunView {
    
    self.zhihuiyunView =  [[UIView alloc]init];
    [self.scrollView addSubview:self.zhihuiyunView];
    //    zhihuiyun_gotoImage
    [self.zhihuiyunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(16);
        make.right.equalTo(self.scrollView.mas_right).offset(-16);
        make.top.equalTo(self.jiaojiebanView.mas_bottom).offset(15);
        make.height.equalTo(@94);
    }];
    
    UIImageView *bgImage = [[UIImageView alloc]init];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.zhihuiyunView addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zhihuiyunView.mas_left);
        make.right.equalTo(self.zhihuiyunView.mas_right);
        make.top.equalTo(self.zhihuiyunView.mas_top);
        make.bottom.equalTo(self.zhihuiyunView.mas_bottom);
    }];
    bgImage.image = [UIImage imageNamed:@"zhihuiyun_bgImage"];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.zhihuiyunView addSubview:titleLabel];
    titleLabel.text = @"智慧云";
    titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightHeavy];
    titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImage.mas_left).offset(24);
        make.top.equalTo(bgImage.mas_top).offset(19);
        make.width.equalTo(@100);
        make.height.equalTo(@28);
    }];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    [self.zhihuiyunView addSubview:detailLabel];
    detailLabel.text = @"零备件/技术资料/巡视维护记录";
    detailLabel.font = [UIFont systemFontOfSize:14];
    detailLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImage.mas_left).offset(24);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.width.equalTo(@250);
        make.height.equalTo(@28);
    }];
    
    UIButton *goToZhiYunBtn = [[UIButton alloc]init];
    [self.zhihuiyunView addSubview:goToZhiYunBtn];
    [goToZhiYunBtn setImage:[UIImage imageNamed:@"zhihuiyun_gotoImage"] forState:UIControlStateNormal];
    [goToZhiYunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.zhihuiyunView.mas_right).offset(-15);
        make.width.height.equalTo(@64);
        make.centerY.equalTo(self.zhihuiyunView.mas_centerY);
    }];
    [goToZhiYunBtn addTarget:self action:@selector(goToZhiHuiYunMethod) forControlEvents:UIControlEventTouchUpInside];
    
}
//跳转智慧云
- (void)goToZhiHuiYunMethod {
    
    KG_RunZhiHuiYunViewController *vc = [[KG_RunZhiHuiYunViewController alloc]init];
    vc.isPush = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setUpJiaoJieBanView {
    self.jiaojiebanView =  [[UIView alloc]init];
    [self.scrollView addSubview:self.jiaojiebanView];
    
  
    [self.jiaojiebanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.right.equalTo(self.scrollView.mas_right);
        make.top.equalTo(self.runReprtView.mas_bottom);
        make.height.equalTo(@(self.jiaojiebanListArr.count *80+40));
    }];
    
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor colorWithHexString:@"#2A6EFD"];
    [self.runReprtView addSubview:leftView];
    leftView.layer.cornerRadius = 2;
    leftView.layer.masksToBounds = YES;
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jiaojiebanView.mas_left).offset(16);
        make.width.equalTo(@4);
        make.top.equalTo(self.jiaojiebanView.mas_top).offset(10);
        make.height.equalTo(@15);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.jiaojiebanView addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = [NSString stringWithFormat:@"%@",@"交接班记录"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).offset(4);
        make.centerY.equalTo(leftView.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@17);
    }];
    UIButton *Btn1 = [[UIButton alloc]init];

    [self.jiaojiebanView addSubview:Btn1];
    [Btn1 addTarget:self action:@selector(jiaojieBanRecord) forControlEvents:UIControlEventTouchUpInside];
    [Btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@100);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(self.jiaojiebanView.mas_right).offset(-16);
    }];

    UIButton *reportRightBtn = [[UIButton alloc]init];
    [reportRightBtn setImage:[UIImage imageNamed:@"common_right"] forState:UIControlStateNormal];
    [self.jiaojiebanView addSubview:reportRightBtn];
    [reportRightBtn addTarget:self action:@selector(jiaojieBanRecord) forControlEvents:UIControlEventTouchUpInside];
    [reportRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(self.jiaojiebanView.mas_right).offset(-16);
    }];
    UILabel *recordLabel = [[UILabel alloc]init];
    [self.jiaojiebanView addSubview:recordLabel];
    recordLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    recordLabel.font = [UIFont systemFontOfSize:12];
    recordLabel.textAlignment = NSTextAlignmentRight;
    recordLabel.text = [NSString stringWithFormat:@""];
    [recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(reportRightBtn.mas_left);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@17);
    }];
    //
    
    [self.jiaojiebanView addSubview:self.jiaoJieBanTableView];
    [self.jiaoJieBanTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jiaojiebanView.mas_left);
        make.right.equalTo(self.jiaojiebanView.mas_right);
        make.top.equalTo(recordLabel.mas_bottom).offset(10);
        make.height.equalTo(@(self.jiaojiebanListArr.count *80));
    }];
    [self.jiaoJieBanTableView reloadData];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E1E1E5"];
    [self.jiaojiebanView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.equalTo(self.jiaojiebanView.mas_left).offset(15);
        make.right.equalTo(self.jiaojiebanView.mas_right).offset(-17);
        make.top.equalTo(self.jiaoJieBanTableView.mas_bottom).offset(0.5);
    }];
    
}
//交接班记录
- (void)jiaojieBanRecord{
    KG_JiaoJieBanRecordViewController *vc = [[KG_JiaoJieBanRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)setUpRunReportView {
    self.runReprtView =  [[UIView alloc]init];
    
    [self.scrollView addSubview:self.runReprtView];
    int tableHeight = 80 *2;
    [self.runReprtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.right.equalTo(self.scrollView.mas_right);
        make.top.equalTo(self.stationWeihuView.mas_bottom).offset(10);
        make.height.equalTo(@(55+ tableHeight +70));
    }];
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor colorWithHexString:@"#2A6EFD"];
    [self.runReprtView addSubview:leftView];
    leftView.layer.cornerRadius = 2;
    leftView.layer.masksToBounds = YES;
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runReprtView.mas_left).offset(16);
        make.width.equalTo(@4);
        make.top.equalTo(self.stationWeihuView.mas_bottom).offset(22);
        make.height.equalTo(@15);
    }];
    
    UILabel *stationReportLabel = [[UILabel alloc]init];
    [self.runReprtView addSubview:stationReportLabel];
    stationReportLabel.text = @"台站运行报告";
    stationReportLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    stationReportLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [stationReportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).offset(8);
        make.centerY.equalTo(leftView.mas_centerY);
        make.width.equalTo(@150);
    }];
    
    UIButton *reportRightBtn = [[UIButton alloc]init];
    [reportRightBtn setImage:[UIImage imageNamed:@"common_right"] forState:UIControlStateNormal];
    [self.runReprtView addSubview:reportRightBtn];
    [reportRightBtn addTarget:self action:@selector(reportRightMethod) forControlEvents:UIControlEventTouchUpInside];
    [reportRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.centerY.equalTo(stationReportLabel.mas_centerY);
        make.right.equalTo(self.runReprtView.mas_right).offset(-26);
    }];
    
    [self.runReprtView addSubview:self.runReportTableView];
    self.runReportTableView.layer.cornerRadius = 9;
    self.runReportTableView.layer.masksToBounds = YES;
    [self.runReportTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runReprtView.mas_left).offset(16);
        make.height.equalTo(@(tableHeight));
        make.right.equalTo(self.runReprtView.mas_right).offset(-16);
        make.top.equalTo(reportRightBtn.mas_bottom).offset(15);
    }];
    [self.runReportTableView reloadData];
    UIView *createReportView = [[UIView alloc]init];
    [self.runReprtView addSubview:createReportView];
    [createReportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@147);
        make.height.equalTo(@37);
        make.left.equalTo(self.runReprtView.mas_left).offset(16);
        make.top.equalTo(self.runReportTableView.mas_bottom).offset(16);
    }];
    createReportView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    createReportView.layer.cornerRadius = 20;
    createReportView.layer.masksToBounds = YES;
    
    UIImageView *createIcon = [[UIImageView alloc]init];
    [createReportView addSubview:createIcon];
    createIcon.image = [UIImage imageNamed:@"run_createIcon"];
    [createIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@16);
        make.height.equalTo(@19);
        make.left.equalTo(createReportView.mas_left).offset(13);
        make.centerY.equalTo(createReportView.mas_centerY);
    }];
    
    UILabel *createReportLabel = [[UILabel alloc]init];
    [createReportView addSubview:createReportLabel];
    createReportLabel.text = @"生成运行报告";
    createReportLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    createReportLabel.font = [UIFont systemFontOfSize:16];
    [createReportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(createIcon.mas_right).offset(6);
        make.centerY.equalTo(createIcon.mas_centerY);
        make.right.equalTo(createReportView.mas_right).offset(-6);
        make.height.equalTo(@22);
    }];
    
    UIButton *createReportBtn = [[UIButton alloc]init];
    [createReportBtn setBackgroundColor:[UIColor clearColor]];
    [createReportView addSubview:createReportBtn];
    [createReportBtn addTarget:self action:@selector(CreateReportMethod) forControlEvents:UIControlEventTouchUpInside];
    [createReportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(createReportView.mas_height);
        make.centerY.equalTo(createReportView.mas_centerY);
        make.left.equalTo(createReportView.mas_left);
        make.right.equalTo(createReportView.mas_right);
    }];
    
    UIButton *jiaobanBtn  = [[UIButton alloc]init];
    [jiaobanBtn setBackgroundColor:[UIColor clearColor]];
    jiaobanBtn.layer.borderWidth = 1;
    jiaobanBtn.layer.borderColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
    [jiaobanBtn setTitle:@"交班"  forState:UIControlStateNormal];
    jiaobanBtn.layer.cornerRadius = 20;
    jiaobanBtn.layer.masksToBounds = YES;
    [jiaobanBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    jiaobanBtn.titleLabel.font  = [UIFont systemFontOfSize:16];
    [self.runReprtView addSubview:jiaobanBtn];
    [jiaobanBtn addTarget:self action:@selector(jiaobanMethod) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *jiebanBtn  = [[UIButton alloc]init];
    [jiebanBtn setBackgroundColor:[UIColor clearColor]];
    jiebanBtn.layer.borderWidth = 1;
    jiebanBtn.layer.cornerRadius = 20;
    jiebanBtn.titleLabel.font  = [UIFont systemFontOfSize:16];
    [jiebanBtn setTitle:@"接班"  forState:UIControlStateNormal];
    jiebanBtn.layer.masksToBounds = YES;
    jiebanBtn.layer.borderColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
    [jiebanBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    jiaobanBtn.titleLabel.font  = [UIFont systemFontOfSize:16];
    [self.runReprtView addSubview:jiebanBtn];
    [jiebanBtn addTarget:self action:@selector(jiebanMethod) forControlEvents:UIControlEventTouchUpInside];
    [jiebanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@37);
        make.centerY.equalTo(createReportView.mas_centerY);
        make.width.equalTo(@64);
        make.right.equalTo(self.runReprtView.mas_right).offset(-16);
    }];
    [jiaobanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@37);
        make.centerY.equalTo(createReportView.mas_centerY);
        make.right.equalTo(jiebanBtn.mas_left).offset(-9);
        make.width.equalTo(@64);
    }];
    //是否为接班人
    if([self.jiaoJieBanInfo[@"isSuccessor"] boolValue]) {
        jiebanBtn.layer.borderColor =  [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
        [jiebanBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
        jiebanBtn.userInteractionEnabled = YES;
    }else {
        jiebanBtn.layer.borderColor = [[UIColor colorWithHexString:@"#E3E3E5"] CGColor];
        [jiebanBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
        jiebanBtn.userInteractionEnabled = NO;
    }
    //是否为交班人
    if([self.jiaoJieBanInfo[@"isHandoverPerson"] boolValue]) {
        jiaobanBtn.layer.borderColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
        [jiaobanBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
        jiaobanBtn.userInteractionEnabled = YES;
    }else {
        jiaobanBtn.layer.borderColor = [[UIColor colorWithHexString:@"#E3E3E5"] CGColor];
        [jiaobanBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
        jiaobanBtn.userInteractionEnabled = NO;
    }
    //是否能生成运行报告
    if([self.jiaoJieBanInfo[@"isRunReport"] boolValue]) {
        createReportView.layer.borderColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
        createReportView.layer.borderWidth = 1;
        createIcon.image = [UIImage imageNamed:@"run_createIcon"];
        createReportLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        createReportBtn.userInteractionEnabled = YES;
        createReportView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    }else {
        createReportView.layer.borderColor = [[UIColor colorWithHexString:@"#E3E3E5"] CGColor];
        createReportView.layer.borderWidth = 1;
        createIcon.image = [UIImage imageNamed:@"create_unselIcon"];
        createReportLabel.textColor = [UIColor colorWithHexString:@"#BEBFC7"];
        createReportBtn.userInteractionEnabled = NO;
        createReportView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        
    }
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E1E1E5"];
    [self.runReprtView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.equalTo(self.runReprtView.mas_left).offset(15);
        make.right.equalTo(self.runReprtView.mas_right).offset(-17);
        make.top.equalTo(jiaobanBtn.mas_bottom).offset(16);
    }];
}

//交班
- (void)jiaobanMethod {
//    交班接口：
//    请求地址：/atcChangeShiftsRecord/shiftHandover/{post}/{runReportId}
//    请求方式：POST
//    请求参数：post岗位编码 runReportId报告id
//    请求返回：
//    如：
//    {
//        "errCode": 0,
//        "errMsg": "",
//        "value": true              //交接成功返回true
//    }
    if ([self.jiaoJieBanInfo[@"handoverInfo"] count] == 1) {
        KG_RunReportDetailViewController  *vc = [[KG_RunReportDetailViewController alloc]init];
        
        vc.dataDic = [self.jiaoJieBanInfo[@"handoverInfo"] firstObject];
        
        vc.pushType = @"jieban";
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        self.jiaoJieBanAlertView.hidden = NO;
        self.jiaoJieBanAlertView.confirmBlockMethod = ^(NSDictionary * _Nonnull dataDic) {
            self.jiaoJieBanAlertView.hidden = YES;
            KG_RunReportDetailViewController  *vc = [[KG_RunReportDetailViewController alloc]init];
            
            vc.dataDic = dataDic;
            
            vc.pushType = @"jiaoban";
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    
    
   
   
}
//接班
- (void)jiebanMethod {
//    接班接口：
//    请求地址：/atcChangeShiftsRecord/succession/{post}/{runReportId}
//    请求方式：POST
//    请求参数：post岗位编码 runReportId报告id
//    请求返回：
//    如：
//    {
//        "errCode": 0,
//
    
    if ([self.jiaoJieBanInfo[@"successInfo"] count] == 1) {
        KG_RunReportDetailViewController  *vc = [[KG_RunReportDetailViewController alloc]init];
        
        vc.dataDic = [self.jiaoJieBanInfo[@"successInfo"] firstObject];
        
        vc.pushType = @"jieban";
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        self.jieBanAlertView.hidden = NO;
        self.jieBanAlertView.confirmBlockMethod = ^(NSDictionary * _Nonnull dataDic) {
            self.jieBanAlertView.hidden = YES;
            KG_RunReportDetailViewController  *vc = [[KG_RunReportDetailViewController alloc]init];
            
            vc.dataDic = dataDic;
            
            vc.pushType = @"jieban";
            [self.navigationController pushViewController:vc animated:YES];
        };
        
    }
   
    
   
    
    
    
}
//生成运行报告
- (void)CreateReportMethod {
    self.createReportAlertView.hidden = NO;
    self.createReportAlertView.selTimeBlockMethod = ^(NSInteger tag) {
        self.currIndex = (int)tag;
        [UIView animateWithDuration:0.3 animations:^{
            self.dataPickerview.frame = CGRectMake(0,  self.view.frame.size.height-300, self.view.frame.size.width, 300);
            [self.dataPickerview  show];
        }];
    };
    self.createReportAlertView.confirmBlockMethod = ^(NSDictionary * _Nonnull dataDic, NSString * _Nonnull endTime) {
        self.createReportAlertView .hidden = YES;
        
        [self  getReportIdData:dataDic withEndTime:endTime];
       
       
    };
}
//新增运行报告接口：
//请求地址：/atcRunReport/
//请求方式：POST
//请求Body：
//{
//    "title":"xxx",
//    "reportRange":"xxx",
//    "startTime":xxx,
//    "endTime":xxxx,
//    "post":"xxx",
//    "submitter":"xxx",
//    "fileUrl":"xxx"
//}请求返回：
- (void)getReportIdData:(NSDictionary *)dataDic withEndTime:(NSString *)endTime {
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/atcRunReport"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *title = [NSString stringWithFormat:@"%@%@-%@%@",[CommonExtension getWorkType:safeString(dataDic[@"post"])],safeString(dataDic[@"time"]),safeString(endTime),@"运行报告"];
    params[@"title"] = title;
    params[@"reportRange"] =safeString(dataDic[@"stationName"]);
    params[@"startTime"] =[self CurTimeMilSec:safeString(dataDic[@"time"])] ;
    params[@"endTime"] = [self CurTimeMilSec:safeString(endTime)];
    params[@"post"] = safeString(dataDic[@"post"]);
    params[@"submitter"] = safeString(self.loginNameInfo[@"userName"]);
   
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        NSMutableDictionary *ddic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [ddic addEntriesFromDictionary:dataDic];
        [ddic setValue:safeString(result[@"value"][@"id"]) forKey:@"id"];
        NSLog(@"resultresult %@",result);
        KG_RunReportDetailViewController  *vc = [[KG_RunReportDetailViewController alloc]init];
        vc.endTime = endTime;
        vc.dataDic = ddic;
        vc.pushType = @"create";
        [self.navigationController pushViewController:vc animated:YES];
        
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
       
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
}
-(NSString *) CurTimeMilSec:(NSString*)pstrTime
{
    NSDateFormatter *pFormatter= [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *pCurrentDate = [pFormatter dateFromString:pstrTime];
    return [NSString stringWithFormat:@"%.f",[pCurrentDate timeIntervalSince1970] * 1000];
}


- (void)reportRightMethod {
    KG_RunListViewController *vc = [[KG_RunListViewController alloc]init];
//    vc.dataArray = self.stationRunReportArr;
    [self.navigationController pushViewController:vc animated:YES];
}

//第二个维护view
- (void)setUpWeihuView {
    self.stationWeihuView = [[UIView alloc]init];
    [self.scrollView addSubview:self.stationWeihuView];
    self.stationWeihuView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.stationWeihuView.layer.cornerRadius = 10;
    self.stationWeihuView.layer.masksToBounds = YES;
    [self.stationWeihuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(16);
        make.right.equalTo(self.stationReportView.mas_right);
        make.top.equalTo(self.stationReportView.mas_bottom).offset(10);
        make.height.equalTo(@72);
    }];
    
    UIImageView *weihuIcon = [[UIImageView alloc]init];
    [self.stationWeihuView addSubview:weihuIcon];
    weihuIcon.image = [UIImage imageNamed:@"run_weihuIcon"];
    [weihuIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@56);
        make.left.equalTo(self.stationWeihuView.mas_left).offset(3);
        make.centerY.equalTo(self.stationWeihuView.mas_centerY);
    }];
    UIImageView *shuLineIcon = [[UIImageView alloc]init];
    [self.stationWeihuView addSubview:shuLineIcon];
    shuLineIcon.image = [UIImage imageNamed:@"run_weihuLine"];
    [shuLineIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@2);
        make.height.equalTo(@41);
        make.left.equalTo(weihuIcon.mas_right).offset(6);
        make.centerY.equalTo(self.stationWeihuView.mas_centerY);
    }];
    
    [self.stationWeihuView addSubview:self.weihuTableView];
    [self.weihuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stationWeihuView.mas_right).offset(-40);
        make.height.equalTo(@64);
        make.left.equalTo(shuLineIcon.mas_right).offset(9);
        make.centerY.equalTo(self.stationWeihuView.mas_centerY);
    }];
    UIButton *rightBtn1 = [[UIButton alloc]init];
    
    [self.stationWeihuView addSubview:rightBtn1];
    [rightBtn1 addTarget:self action:@selector(weihuMethod) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.centerY.equalTo(self.stationWeihuView.mas_centerY);
        make.right.equalTo(self.stationWeihuView.mas_right);
    }];
    
    
    
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn setImage:[UIImage imageNamed:@"common_right"] forState:UIControlStateNormal];
    [self.stationWeihuView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(weihuMethod) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.stationWeihuView.mas_centerY);
        make.right.equalTo(self.stationWeihuView.mas_right).offset(-10);
    }];
    
    
}
//维护显示全部
- (void)weihuMethod{
    KG_RunPromptViewController *vc = [[KG_RunPromptViewController alloc]init];
    
    vc.dataArray = self.reportListArr;
    [self.navigationController pushViewController:vc animated:YES];
}
//台站任务提醒
- (void)setUpStationReportView {
    self.stationReportView = [[UIView alloc]init];
    [self.scrollView addSubview:self.stationReportView];
    if (self.stationTaskInfoArr.count == 0) {
        [self.stationReportView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.mas_left).offset(16);
            make.right.equalTo(self.scrollView.mas_right).offset(-16);
            make.top.equalTo(self.navigationView.mas_bottom).offset(10);
            make.height.equalTo(@(58+44));
        }];
    }else {
        if (self.stationTaskInfoArr.count >=3) {
            [self.stationReportView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView.mas_left).offset(16);
                make.right.equalTo(self.scrollView.mas_right).offset(-16);
                make.top.equalTo(self.navigationView.mas_bottom).offset(10);
                make.height.equalTo(@(58+96));
            }];
            
        }else {
            
            [self.stationReportView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView.mas_left).offset(16);
                make.right.equalTo(self.scrollView.mas_right).offset(-16);
                make.top.equalTo(self.navigationView.mas_bottom).offset(10);
                make.height.equalTo(@(58+(32 *self.stationTaskInfoArr.count) ));
            }];
        }
        
    }
    
    
    UIView *topView = [[UIView alloc]init];
    [self.stationReportView addSubview:topView];
    topView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stationReportView.mas_left);
        make.right.equalTo(self.stationReportView.mas_right);
        make.top.equalTo(self.stationReportView.mas_top);
        make.height.equalTo(@44);
    }];
    topView.layer.cornerRadius = 8;
    topView.layer.masksToBounds = YES;
    
    UILabel *promptLabel = [[UILabel alloc]init];
    [topView addSubview:promptLabel];
    promptLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    promptLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    promptLabel.textAlignment = NSTextAlignmentLeft;
    promptLabel.text = @"台站任务提醒";
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(16);
        make.top.equalTo(topView.mas_top);
        make.bottom.equalTo(topView.mas_bottom);
        make.width.equalTo(@100);
    }];
    
    UIButton *totalBtn = [[UIButton alloc]init];
    [totalBtn setImage:[UIImage imageNamed:@"white_jiantou"] forState:UIControlStateNormal];
    [totalBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [topView addSubview:totalBtn];
    [totalBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 77, 0, 0)];
    [totalBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    totalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [totalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-20);
        make.width.equalTo(@90);
        make.height.equalTo(topView.mas_height);
        make.centerY.equalTo(topView.mas_centerY);
    }];
    [totalBtn addTarget:self action:@selector(watahTotalMethod) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.stationTaskInfoArr.count == 0) {
        
        UIView *noDataView = [[UIView alloc]init];
        [self.stationReportView addSubview:noDataView];
        noDataView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stationReportView.mas_left);
            make.right.equalTo(self.stationReportView.mas_right);
            make.height.equalTo(@58);
            make.top.equalTo(self.stationReportView.mas_top).offset(44);
        }];
        
        UILabel *noDataLabel = [[UILabel alloc]init];
        [noDataView addSubview:noDataLabel];
        noDataLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
        noDataLabel.font = [UIFont systemFontOfSize:14];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        noDataLabel.text = @"当前暂无任务";
        [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(noDataView.mas_left);
            make.right.equalTo(noDataView.mas_right);
            make.top.equalTo(noDataView.mas_top);
            make.bottom.equalTo(noDataView.mas_bottom);
        }];
    }else {
        [self.stationReportView addSubview:self.reportTableView];
        NSInteger tableHeight = 96;
        if (self.stationTaskInfoArr.count >=3) {
            tableHeight = 96;
        }else {
            tableHeight = self.stationTaskInfoArr.count *32;
        }
        [self.reportTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stationReportView.mas_left);
            make.right.equalTo(self.stationReportView.mas_right);
            make.top.equalTo(self.stationReportView.mas_top).offset(53);
            make.height.equalTo(@(tableHeight));
        }];
        [self.reportTableView reloadData];
    }
    
    UIImageView *bgImage1 = [[UIImageView alloc]init];
    [self.stationReportView addSubview:bgImage1];
    bgImage1.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    
    [bgImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stationReportView.mas_left);
        make.right.equalTo(self.stationReportView.mas_right);
        make.top.equalTo(self.stationReportView.mas_top).offset(35);
        make.height.equalTo(@18);
    }];
    
    UIImageView *bgImage = [[UIImageView alloc]init];
    [self.stationReportView addSubview:bgImage];
    bgImage.image = [UIImage imageNamed:@"run_longCircle"];
    //    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stationReportView.mas_left);
        make.right.equalTo(self.stationReportView.mas_right);
        make.top.equalTo(self.stationReportView.mas_top).offset(35);
        make.height.equalTo(@18);
    }];
    
    
}
//查看全部
- (void)watahTotalMethod {
    
    KG_StationReportAlarmViewController *vc = [[KG_StationReportAlarmViewController alloc]init];
    vc.dataArray = self.stationTaskInfoArr;
    
    [self.navigationController pushViewController:vc animated:YES];
    //    [self.navigationController pushViewController:vc animated:YES];
    
}
//创建视图
-(void)setupDataSubviews
{
    /** 导航栏 **/
    self.navigationView = [[UIView alloc]init];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navigationView];
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(NAVIGATIONBAR_HEIGHT));
        make.top.equalTo(self.view.mas_top);
    }];
    
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIButton *leftImage = [[UIButton alloc] init];
    
    [self.navigationView addSubview:leftImage];
    leftImage.layer.cornerRadius =17.f;
    leftImage.layer.masksToBounds = YES;
    [leftImage setImage:[UIImage imageNamed:@"head_blueIcon"] forState:UIControlStateNormal];
    [leftImage addTarget:self action:@selector(leftCenterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    
    /** 添加标题栏 **/
    [self.navigationView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImage.mas_right).offset(8);
        make.height.equalTo(@22);
        make.width.equalTo(@250);
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar+9);
    }];
    NSString *name = safeString(self.loginNameInfo[@"userName"]);
    NSString *zhiban = @"今日不值班";
    if ([self.loginNameInfo[@"isOnDuty"] boolValue]) {
        zhiban = @"今日值班";
    }
    titleLabel.text = [NSString stringWithFormat:@"%@-%@",name,zhiban];
    
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationView.mas_left).offset(16);
        make.width.height.equalTo(@34);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    UIButton *zhibanBtn = [[UIButton alloc]init];
    [zhibanBtn setTitle:@"查看值班表" forState:UIControlStateNormal];
    [self.navigationView addSubview:zhibanBtn];
    [zhibanBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    zhibanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [zhibanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navigationView.mas_right).offset(-20);
        make.width.equalTo(@90);
        make.height.equalTo(@20);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    [zhibanBtn addTarget:self action:@selector(zhibanMethod) forControlEvents:UIControlEventTouchUpInside];
    
}
/**
 弹出个人中心
 */
- (void)leftCenterButtonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyingHeadNotification" object:self];
    [self.slideMenuController showMenu];
}
//查看值班表
- (void)zhibanMethod {
    PersonalPatrolController *PatrolController = [[PersonalPatrolController alloc] init];
    [self.navigationController pushViewController:PatrolController animated:YES];
    
}


- (void)loginSuccess {
    if (self.currentStationDic.count == 0) {
        [self login];
    }else {
        [self queryData];
        [self quertFrameData];
    }
}
#pragma mark - life cycle 生命周期方法
-(void)firstLoginNotify{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults objectForKey:@"userAccount"]||[[userDefaults objectForKey:@"userAccount"] isEqualToString:@""]){
        //跳转登陆页
        LoginViewController *login = [[LoginViewController alloc] init];
        
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
        return ;
    }
}
//获取登录人值班信息接口：
//请求地址：/
//请求方式：GET
//请求返回：

- (void) getLoginNameInfo:(dispatch_group_t)group {
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcShiftManagement/getShiftInfo"]];
        [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
            
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                return ;
            }
            self.loginNameInfo = result[@"value"];
            NSLog(@"完成3");
            dispatch_group_leave(group);
            
            NSLog(@"");
        } failure:^(NSURLSessionDataTask *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            NSLog(@"完成3");
            dispatch_group_leave(group);
            
        }];
    });
    
}
//请求地址：/intelligent/atcPatrolRecode/getStationTaskInfo
//请求方式：GET
//请求返回内容格式：
//{
- (void)getStationReportAlarmInfo:(dispatch_group_t)group {
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/getStationTaskInfo"]];
        [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
            
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                return ;
            }
            self.stationTaskInfoArr = result[@"value"];
            dispatch_group_leave(group);
            NSLog(@"2");
        } failure:^(NSURLSessionDataTask *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            NSLog(@"完成2");
            dispatch_group_leave(group);
        }];
    });
    
}

//请求地址：/atcPatrolRecode/getCurrTaskInfo
//请求方式：GET
//请求返回内容格式：

- (void)getTodayReportInfo:(dispatch_group_t)group {
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/getStationTaskInfo"]];
        [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
            
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                return ;
            }
            //            self.reportListArr = result[@"value"];
            dispatch_group_leave(group);
            NSLog(@"完成1");
        } failure:^(NSURLSessionDataTask *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            dispatch_group_leave(group);
            NSLog(@"完成1");
        }];
        
    });
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if ([tableView isEqual:self.reportTableView]) {
//        return self.stationTaskInfoArr.count;
//    }else if ([tableView isEqual:self.weihuTableView]) {
//        return self.reportListArr.count;
//    }else if ([tableView isEqual:self.runReportTableView]) {
//        return 2;
//    }else if ([tableView isEqual:self.jiaoJieBanTableView]) {
//        return self.jiaojiebanListArr.count;
//    }
//    return 0;
    
    return 1;
    
}


- (UITableView *)reportTableView {
    if (!_reportTableView) {
        _reportTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _reportTableView.delegate = self;
        _reportTableView.dataSource = self;
        _reportTableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _reportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _reportTableView.scrollEnabled = YES;
        
        
    }
    return _reportTableView;
}

- (UITableView *)runReportTableView {
    if (!_runReportTableView) {
        _runReportTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _runReportTableView.delegate = self;
        _runReportTableView.dataSource = self;
        _runReportTableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _runReportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _runReportTableView.scrollEnabled = YES;
        
        
    }
    return _runReportTableView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
        
    }
    return _tableView;
}
- (UITableView *)jiaoJieBanTableView {
    if (!_jiaoJieBanTableView) {
        _jiaoJieBanTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _jiaoJieBanTableView.delegate = self;
        _jiaoJieBanTableView.dataSource = self;
        _jiaoJieBanTableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _jiaoJieBanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _jiaoJieBanTableView.scrollEnabled = YES;
        
        
    }
    return _jiaoJieBanTableView;
}



- (UITableView *)weihuTableView {
    if (!_weihuTableView) {
        _weihuTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _weihuTableView.delegate = self;
        _weihuTableView.dataSource = self;
        _weihuTableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _weihuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _weihuTableView.scrollEnabled = YES;
        
        
    }
    return _weihuTableView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    
    return headView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (void)gotoDetailPage:(NSDictionary *)dataDic {

    KG_RunReportDetailViewController *vc = [[KG_RunReportDetailViewController alloc]init];
    
    vc.dataDic = dataDic;
    [self.navigationController pushViewController:vc animated:YES];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
         KG_RunManagerFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunManagerFirstCell"];
        if (cell == nil) {
            cell = [[KG_RunManagerFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunManagerFirstCell"];
            cell.stationTaskInfoArr = self.stationTaskInfoArr;
        }
        cell.watchTotal = ^{
            [self watahTotalMethod];
        };
        cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
    }else if (indexPath.section == 1) {
        KG_RunManagerSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunManagerSecondCell"];
        if (cell == nil) {
            cell = [[KG_RunManagerSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunManagerSecondCell"];
            cell.reportListArr = self.reportListArr;
        }
        cell.weihuBlockMethod = ^{
            [self weihuMethod];
        };
       
        cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
    }else if (indexPath.section == 2) {
        KG_RunManagerThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunManagerThirdCell"];
        if (cell == nil) {
            cell = [[KG_RunManagerThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunManagerThirdCell"];
            cell.jiaoJieBanInfo = self.jiaoJieBanInfo;
            cell.stationRunReportArr = self.stationRunReportArr;
        }
        cell.runReportBlockMethod = ^{
            [self reportRightMethod];
        };
        cell.gotoDetailBlockMethod = ^(NSDictionary * _Nonnull dic) {
                   [self gotoDetailPage:dic];
               };
        cell.jiaobanBlockMethod = ^{
            [self jiaobanMethod];
        };
        cell.jiebanBlockMethod = ^{
            [self jiebanMethod];
        };
        cell.createReportBlockMethod = ^{
            [self CreateReportMethod];
        };
        cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
       
        return cell;
    }else if (indexPath.section == 3) {
        KG_RunManagerFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunManagerFourthCell"];
        if (cell == nil) {
            cell = [[KG_RunManagerFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunManagerFourthCell"];
            cell.jiaojiebanListArr = self.jiaojiebanListArr;
            
        }
        cell.jiaojiebanBlockMethod  = ^{
            [self jiaojieBanRecord];
        };
        
        cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 4) {
        KG_RunMangerFifthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunMangerFifthCell"];
        if (cell == nil) {
            cell = [[KG_RunMangerFifthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunMangerFifthCell"];
        }
        cell.gotuYunBlockMethod = ^{
            [self goToZhiHuiYunMethod];
        };
        cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        return cell;
    }
    
//    if ([tableView isEqual:self.reportTableView]) {
//        KG_StationReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_StationReportCell"];
//        if (cell == nil) {
//            cell = [[KG_StationReportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_StationReportCell"];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSDictionary *dataDic = self.stationTaskInfoArr[indexPath.row];
//        cell.dataDic = dataDic;
//
//        return cell;
//    }else if ([tableView isEqual:self.weihuTableView]) {
//
//        KG_RunWeiHuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunWeiHuCell"];
//        if (cell == nil) {
//            cell = [[KG_RunWeiHuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunWeiHuCell"];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSDictionary *dataDic = self.reportListArr[indexPath.row];
//        cell.dataDic = dataDic;
//
//        return cell;
//    }else if ([tableView isEqual:self.runReportTableView]) {
//
//        KG_RunReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportCell"];
//        if (cell == nil) {
//            cell = [[KG_RunReportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportCell"];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSDictionary *dataDic = self.stationRunReportArr[indexPath.row];
//        cell.dataDic = dataDic;
//
//        return cell;
//    }else if ([tableView isEqual:self.jiaoJieBanTableView]) {
//
//        KG_RunJiaoJieBanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunJiaoJieBanCell"];
//        if (cell == nil) {
//            cell = [[KG_RunJiaoJieBanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunJiaoJieBanCell"];
//        }
//        cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSDictionary *dataDic = self.jiaojiebanListArr[indexPath.row];
//        cell.dic = dataDic;
//
//        return cell;
//    }
//
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    if(indexPath.section == 0){
        if (self.stationTaskInfoArr.count == 0) {
            return 53+44;
        }else {
            if (self.stationTaskInfoArr.count >=3) {
                return 53+96;
            }else {
                return 53+(32 *self.stationTaskInfoArr.count);
            }
            
        }
        return 150;
    }else if(indexPath.section == 1){
        return 72;
    }else if(indexPath.section == 2){
        return 125 +80*self.stationRunReportArr.count;
    }else if(indexPath.section == 3){
        return self.jiaojiebanListArr.count *80+40;
    }else if(indexPath.section == 4){
        return 94;
    }
    
    return 50;
}


//KG_RunReportDetailViewController *vc = [[KG_RunReportDetailViewController alloc]init];
//  NSDictionary *dataDic = self.dataArray[indexPath.section];
//  vc.dataDic = dataDic;
//  [self.navigationController pushViewController:vc animated:YES];

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
    //    NSString *str = self.dataArray[indexPath.row];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //在这里设置一下 不然滚动不了
    self.scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT +120+self.jiaojiebanListArr.count *80);
}
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
    if(decelerate) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            printf("STOP IT!!\n");
        //            [scrollView setContentOffset:scrollView.contentOffset animated:NO];
        //        });
    }
}
///intelligent/atcRunPrompt/{pageNum}/{pageSize}
//请求方式：POST
//请求Body：
//{
//    "stationCode": "XXX",         //台站编码，非必填
//    "title": "XXX",               //名字，非必填
//    "time": "XXX",               //时间，非必填，过滤time介于开始~结束时间之间
//}
- (void)getRunPromptData:(dispatch_group_t)group {
    
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/atcRunPrompt/1/20"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"stationCode"] = self.currentStationDic[@"stationCode"];
        
        params[@"title"] = @"";
        params[@"time"] = @"";
        
        [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code != 0){
                
                return ;
            }
            
            NSLog(@"resultresult %@",result);
            self.reportListArr = result[@"value"][@"records"];
            
            dispatch_group_leave(group);
        }  failure:^(NSError *error) {
            NSLog(@"请求失败 原因：%@",error);
            dispatch_group_leave(group);
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        } ];
    });
    
}
- (void)getRunPromptDetailData{
    
    
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/atcRunPrompt/1/20"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"stationCode"] = self.currentStationDic[@"stationCode"];
    
    params[@"title"] = @"";
    params[@"time"] = @"";
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        
        NSLog(@"resultresult %@",result);
        self.reportListArr = result[@"value"][@"records"];
      
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
    
}
//查询运行报告列表接口：
//请求地址：/atcRunReport/{pageNum}/{pageSize}
//请求方式：POST
//请求Body：
//{
//"title": "XXX",          //名字，非必填
//    "time": "XXX",          //提交时间，非必填，格式"2020-05-25"。提交时间在time当天
//"reportRange": "XXX"    //报告范围，非必填
//}
//请求返回：

- (void)getRunReportDetailData{
    
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/atcRunReport/1/2"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"reportRange"] = self.currentStationDic[@"stationCode"];
    
    params[@"title"] = @"";
    params[@"time"] = @"";
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        
        NSLog(@"resultresult %@",result);
        self.stationRunReportArr = result[@"value"][@"records"];
      
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
    
}

//交接班状态接口：
//请求地址：/atcChangeShiftsRecord /verification/{userId}
//请求方式：GET
//请求返回：
//如：

- (void)getJiaoJieBanStatus :(dispatch_group_t)group {
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcChangeShiftsRecord/verification/%@",[UserManager shareUserManager].userID]];
        
        [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
            
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                return ;
            }
            self.jiaoJieBanInfo = result[@"value"];
            NSLog(@"完成3");
            dispatch_group_leave(group);
            
            NSLog(@"");
        } failure:^(NSURLSessionDataTask *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            
            dispatch_group_leave(group);
            
        }];
    });
}

//查询交接班列表接口：
//请求地址：/atcChangeShiftsRecord /{pageNum}/{pageSize}
//请求方式：POST
//请求Body：
//{
//"post": "XXX",       //岗位，非必填
//"time": "XXX",               //日期，非必填
//}
//
//请求返回：
//如：

- (void)queryJiaoJieBaneListData {
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/atcChangeShiftsRecord/1/20"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"post"] = @"";
    params[@"time"] = @"";
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        NSMutableArray *dateArr = [NSMutableArray arrayWithCapacity:0];
        NSArray *arr = result[@"value"][@"records"];
        NSDate *date=[NSDate date];
        NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd"] stringFromDate:date];
        for (NSDictionary *dateDic in arr) {
           
            NSString *ti = [self timestampToTimeStr:safeString(dateDic[@"createTime"])];
            if ([timeStr isEqualToString:ti]) {
                [dateArr addObject:dateDic];
            }
        }
        self.jiaojiebanListArr = dateArr;
      
        NSLog(@"resultresult %@",result);
       
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
    
}
- (KG_CreateReportAlertView *)createReportAlertView {
    
    if (!_createReportAlertView) {
        _createReportAlertView = [[KG_CreateReportAlertView alloc]initWithCondition:self.jiaoJieBanInfo];
        [JSHmainWindow addSubview:_createReportAlertView];
        [_createReportAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];
        
    }
    return _createReportAlertView;
    
}
- (KG_ChooseJiaoJieBanAlertView *)jieBanAlertView {
    
    if (!_jieBanAlertView) {
        _jieBanAlertView = [[KG_ChooseJiaoJieBanAlertView alloc]initWithCondition:self.jiaoJieBanInfo];
        [JSHmainWindow addSubview:_jieBanAlertView];
        [_jieBanAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];
        
    }
    return _jieBanAlertView;
    
}
- (KG_JiaoJieBanAlertView *)jiaoJieBanAlertView {
    
    if (!_jiaoJieBanAlertView) {
        _jiaoJieBanAlertView = [[KG_JiaoJieBanAlertView alloc]initWithCondition:self.jiaoJieBanInfo];
        [JSHmainWindow addSubview:_jiaoJieBanAlertView];
        [_jiaoJieBanAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];
        
    }
    return _jiaoJieBanAlertView;
    
}

- (void)queryTypeData {
    
    //    获取任务状态字典接口：
    //    请求地址：/intelligent/atcDictionary?type_code=taskStatus
    //    请求方式：GET
    //    请求返回：
    //    如：http://192.168.100.173:8089/intelligent/atcDictionary?type_code=taskStatus
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=shiftPositionCategory"]];
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
      
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
    
}
- (BOOL)validateWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
//    components.hour = 8;
    // 当天起始时间
    NSDate *startDate = [calendar dateFromComponents:components];
    // 当天结束时间
    NSDate *expireDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    if ([date compare:startDate] == NSOrderedDescending && [date compare:expireDate] == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}

//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd"] stringFromDate:date];
    //    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd"] stringFromDate:date];
    return timeStr;
    
}
- (NSDateFormatter *)dateFormatWith:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];//@"YYYY-MM-dd HH:mm:ss"
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    return formatter;
}

- (ZRDatePickerView *)dataPickerview
{
    if (!_dataPickerview) {
        _dataPickerview = [[ZRDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300) withDatePickerType:WYLDatePickerTypeYMD];
        _dataPickerview.delegate = self;
        _dataPickerview.title = @"请选择时间";
        _dataPickerview.isSlide = NO;
        _dataPickerview.toolBackColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _dataPickerview.toolTitleColor = [UIColor colorWithHexString:@"#555555"];
        _dataPickerview.saveTitleColor = [UIColor colorWithHexString:@"#EA3425"];
        _dataPickerview.cancleTitleColor = [UIColor colorWithHexString:@"#EA3425"];
        
        [self.view addSubview:_dataPickerview];
        
    }
    return _dataPickerview;
}

- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
  
    if (self.currIndex == 0) {
        self.startTime = timer;
       
        
    }else {
        //end
        self.endTime = timer;
       
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
        
        [self.dataPickerview  show];
    }];
    
}
/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
        [self.dataPickerview  show];
    }];
}

@end
