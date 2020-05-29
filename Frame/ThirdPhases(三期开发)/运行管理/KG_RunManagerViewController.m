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
@interface KG_RunManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (strong, nonatomic) NSDictionary *currentStationDic;


@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UILabel   *titleLabel;

@property (nonatomic, strong)  UIView    *stationReportView;//台站任务提醒
@property (nonatomic, strong)  UIView    *stationWeihuView;//维护
@property (nonatomic, strong)  UIView    *runReprtView;//运行报告View
@property (nonatomic, strong)  UIView    *jiaojiebanView;//交接班View
@property (nonatomic, strong)  UIView    *zhihuiyunView;

@property (nonatomic, strong)  NSDictionary *loginNameInfo;

@property (nonatomic, strong)  NSArray    *reportListArr;
@property (nonatomic, strong)  NSArray    *stationTaskInfoArr;

@property (nonatomic, strong)  UITableView *reportTableView;//1
@property (nonatomic, strong)  UITableView *weihuTableView;//2
@property (nonatomic, strong)  UITableView *runReportTableView;//3
@property (nonatomic, strong)  UITableView *tableView;//3
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation KG_RunManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
       [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
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
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    
    
}
- (void)login {
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
      
       
        
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
    return ;
}


- (void)queryData{
  
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
        [self getTodayReportInfo:group];
    });
    
    dispatch_group_notify(group, queue, ^{
       
        NSLog(@"请求完成");
        NSLog(@"当前线程：%@，是否是主线程：%@...7777···",[NSThread currentThread],[NSThread isMainThread]?@"是":@"否");//当前线程：<NSThread: 0x60400026a540>{number = 3, name = (null)}，是否是主线程：否...7777···
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"当前线程：%@，是否是主线程：%@...8888···",[NSThread currentThread],[NSThread isMainThread]?@"是":@"否");//当前线程：<NSThread: 0x604000069700>{number = 1, name = main}，是否是主线程：是...8888···
            [self createUI];
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
    [self setUpDataTableView];
    [self setupDataSubviews];
    //第一个
    [self setUpStationReportView];
//    //第二个
    [self setUpWeihuView];
//    //第三个
    [self setUpRunReportView];
//
    [self setUpJiaoJieBanView];
//
    [self setUpzhihuiyunView];
//
//
    
}

- (void) setUpDataTableView{
    //scroView
    
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.width.equalTo(self.view.mas_width);
//        make.height.equalTo(self.view.mas_height);
//    }];
//    [self.tableView reloadData];
    
    self.scrollView = [[UIScrollView alloc] init];
    NSLog(@"SCREEN_HEIGHT %f",SCREEN_HEIGHT);
    NSLog(@"HEIGHT_SCREEN %f",HEIGHT_SCREEN);
    self.scrollView.frame = CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT);
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT +120);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
//智慧云view
- (void)setUpzhihuiyunView {
    
    self.zhihuiyunView =  [[UIView alloc]init];
    [self.scrollView addSubview:self.zhihuiyunView];
//    zhihuiyun_gotoImage
    [self.zhihuiyunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.right.equalTo(self.scrollView.mas_right);
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
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.left.equalTo(bgImage.mas_left).offset(2)
//    }];
    
}

- (void)setUpJiaoJieBanView {
    self.jiaojiebanView =  [[UIView alloc]init];
    [self.scrollView addSubview:self.jiaojiebanView];
    
    [self.jiaojiebanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.right.equalTo(self.scrollView.mas_right);
        make.top.equalTo(self.runReprtView.mas_bottom);
        make.height.equalTo(@94);
    }];
        
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.jiaojiebanView addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = [NSString stringWithFormat:@"%@:%@",@"交接班岗位",@"管制服务岗"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jiaojiebanView.mas_left).offset(28);
        make.top.equalTo(self.jiaojiebanView.mas_top).offset(10);
        make.width.equalTo(@200);
        make.height.equalTo(@17);
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
    recordLabel.text = [NSString stringWithFormat:@"交接班记录"];
    [recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(reportRightBtn.mas_left);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@17);
    }];
//
    
    UIImageView *centerImage = [[UIImageView alloc]init];
    [self.jiaojiebanView addSubview:centerImage];
    centerImage.image = [UIImage imageNamed:@"jiaojiebanjiantou"];
   
    
    UIView *leftView = [[UIView alloc]init];
    [self.jiaojiebanView addSubview:leftView];
    int viewWidth =( SCREEN_WIDTH -32 -38 )/2;
    leftView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jiaojiebanView.mas_left).offset(16);
        make.width.equalTo(@(viewWidth));
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@40);
    }];
    
    UIImageView *leftIcon = [[UIImageView alloc]init];
    [leftView addSubview:leftIcon];
    leftIcon.backgroundColor = [UIColor blueColor];
    [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.left.equalTo(leftView.mas_left).offset(12);
        make.centerY.equalTo(leftView.mas_centerY);
    }];
    UILabel *leftTitleLabel = [[UILabel alloc]init];
    [leftView addSubview:leftTitleLabel];
    leftTitleLabel.text = @"张树剑告";
    leftTitleLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    leftTitleLabel.font = [UIFont systemFontOfSize:12];
    [leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIcon.mas_right).offset(9);
        make.top.equalTo(leftView.mas_top).offset(5);
        make.right.equalTo(leftView.mas_right);
        make.height.equalTo(@17);
    }];
    UILabel *leftTimeLabel = [[UILabel alloc]init];
    [leftView addSubview:leftTimeLabel];
    leftTimeLabel.text = @"2020.05.07 08:00:23";
    leftTimeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    leftTimeLabel.font = [UIFont systemFontOfSize:10];
    [leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIcon.mas_right).offset(9);
        make.top.equalTo(leftTitleLabel.mas_bottom);
        make.right.equalTo(leftView.mas_right);
        make.height.equalTo(@14);
    }];
    
    
    UIView *rightView = [[UIView alloc]init];
    [self.jiaojiebanView addSubview:rightView];
    rightView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.jiaojiebanView.mas_right).offset(-16);
        make.width.equalTo(@(viewWidth));
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@40);
    }];
       
    
    UIImageView *rightIcon = [[UIImageView alloc]init];
    [rightView addSubview:rightIcon];
    rightIcon.backgroundColor = [UIColor blueColor];
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.left.equalTo(rightView.mas_left).offset(12);
        make.centerY.equalTo(rightView.mas_centerY);
    }];
    UILabel *rightTitleLabel = [[UILabel alloc]init];
    [rightView addSubview:rightTitleLabel];
    rightTitleLabel.text = @"张树剑告";
    rightTitleLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    rightTitleLabel.font = [UIFont systemFontOfSize:12];
    [rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightIcon.mas_right).offset(9);
        make.top.equalTo(rightView.mas_top).offset(5);
        make.right.equalTo(rightView.mas_right);
        make.height.equalTo(@17);
    }];
    UILabel *rightTimeLabel = [[UILabel alloc]init];
    [rightView addSubview:rightTimeLabel];
    rightTimeLabel.text = @"2020.05.07 08:00:23";
    rightTimeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    rightTimeLabel.font = [UIFont systemFontOfSize:10];
    [rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightIcon.mas_right).offset(9);
        make.top.equalTo(rightTitleLabel.mas_bottom);
        make.right.equalTo(rightView.mas_right);
        make.height.equalTo(@14);
    }];
    
    [centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@14);
        make.centerY.equalTo(leftView.mas_centerY);
        make.left.equalTo(leftView.mas_right).offset(11);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E1E1E5"];
    [self.jiaojiebanView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.equalTo(self.jiaojiebanView.mas_left).offset(15);
        make.right.equalTo(self.jiaojiebanView.mas_right).offset(-17);
        make.top.equalTo(leftView.mas_bottom).offset(16);
    }];
    
}
//交接班记录
- (void)jiaojieBanRecord{
    
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
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stationWeihuView.mas_left).offset(16);
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
    
}
//接班
- (void)jiebanMethod {
    
}
//生成运行报告
- (void)CreateReportMethod {
    
}
//
- (void)reportRightMethod {
    
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
    
    
}
//创建视图
-(void)setupDataSubviews
{
    /** 导航栏 **/
    self.navigationView = [[UIView alloc]init];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.navigationView];
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.right.equalTo(self.scrollView.mas_right);
        make.height.equalTo(@(NAVIGATIONBAR_HEIGHT));
        make.top.equalTo(self.scrollView.mas_top);
    }];
    

    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.backgroundColor = [UIColor grayColor];
    [self.navigationView addSubview:leftImage];
    leftImage.layer.cornerRadius =17.f;
    leftImage.layer.masksToBounds = YES;
   
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
        make.width.equalTo(@150);
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar+9);
    }];
    titleLabel.text = @"张颖-今日值班";
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

//查看值班表
- (void)zhibanMethod {
    
    
}


- (void)loginSuccess {
    if (self.currentStationDic.count == 0) {
        [self login];
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
            self.reportListArr = result[@"value"];
            dispatch_group_leave(group);
            NSLog(@"完成1");
        } failure:^(NSURLSessionDataTask *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            dispatch_group_leave(group);
            NSLog(@"完成1");
        }];
        
    });
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.reportTableView]) {
        return self.stationTaskInfoArr.count;
    }else if ([tableView isEqual:self.weihuTableView]) {
        return 2;
    }else if ([tableView isEqual:self.runReportTableView]) {
        return 2;
    }else if ([tableView isEqual:self.tableView]) {
        return 1;
    }
    return 0;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
        
    }
    return _tableView;
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




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.reportTableView]) {
        KG_StationReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_StationReportCell"];
        if (cell == nil) {
            cell = [[KG_StationReportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_StationReportCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dataDic = self.stationTaskInfoArr[indexPath.row];
        cell.dataDic = dataDic;
        
        return cell;
    }else if ([tableView isEqual:self.weihuTableView]) {
        
        KG_RunWeiHuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunWeiHuCell"];
        if (cell == nil) {
            cell = [[KG_RunWeiHuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunWeiHuCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dataDic = self.stationTaskInfoArr[indexPath.row];
        cell.dataDic = dataDic;
        
        return cell;
    }else if ([tableView isEqual:self.runReportTableView]) {
        
        KG_RunReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportCell"];
        if (cell == nil) {
            cell = [[KG_RunReportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dataDic = self.stationTaskInfoArr[indexPath.row];
        cell.dataDic = dataDic;
        
        return cell;
    }else if ([tableView isEqual:self.runReportTableView]) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        [self createUI];
        return cell;
    }
   
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.reportTableView]) {
        return 32;
    }else if ([tableView isEqual:self.weihuTableView]) {
        return 32;
    }else if ([tableView isEqual:self.runReportTableView]) {
        return 80;
    }else if ([tableView isEqual:self.tableView]) {
        return 1000;
    }
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //    NSString *str = self.dataArray[indexPath.row];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //在这里设置一下 不然滚动不了
     self.scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT +120);
}
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
    if(decelerate) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            printf("STOP IT!!\n");
//            [scrollView setContentOffset:scrollView.contentOffset animated:NO];
//        });
    }
}
@end
