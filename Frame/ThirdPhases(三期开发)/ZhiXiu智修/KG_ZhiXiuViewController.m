//
//  KG_ZhiXiuViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/14.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ZhiXiuViewController.h"
#import "KG_HistoryTaskCell.h"
#import "SegmentTapView.h"
#import "RS_ConditionSearchView.h"
#import "KG_ZhiTaiStationModel.h"
#import "KG_ZhiXiuModel.h"
#import "UIViewController+CBPopup.h"
#import "KG_ZhiXiuCell.h"
#import "KG_GaoJingModel.h"
#import "KG_GaoJingDetailViewController.h"
#import "UIViewController+YQSlideMenu.h"
#import "LoginViewController.h"
#import <UIButton+WebCache.h>
#import "KG_ControlGaoJingAlertView.h"
#import "KG_NewScreenViewController.h"
#import "KG_NoDataPromptView.h"
#import "KG_MineViewController.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_ZhiXiuViewController ()<SegmentTapViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray     *dataArray;

@property (nonatomic, strong) SegmentTapView     *segment;          //全部 未确认 已确认

@property (nonatomic, strong) UITableView        *tableView;

@property (nonatomic ,assign) int                pageNum;
@property (nonatomic ,assign) int                pageSize;
@property (nonatomic ,assign) int                currIndex;         //当前点击为哪一个
@property (nonatomic ,assign) BOOL               isOpenSwh;         //是否打开空管设备开关
@property (nonatomic, strong) UIButton           *swh;

@property (nonatomic, strong) UIButton           *rightButton;
@property (nonatomic, strong) UILabel            *titleLabel;
@property (nonatomic, strong) UIView             *navigationView;
@property (nonatomic, strong) UIButton           *histroyBtn;

@property (nonatomic ,strong) NSMutableArray     *paraArr;          //请求的数组

@property(strong,nonatomic)   NSArray            *stationArray;
@property(strong,nonatomic)   UITableView        *stationTabView;

@property (nonatomic, strong) UIButton           *leftIconImage;

@property (nonatomic, copy)   NSString             *removeStartTime;
@property (nonatomic, copy)   NSString             *removeEndTime;

/*筛选相关*/
@property (nonatomic, copy)   NSString             *roomStr;
@property (nonatomic, copy)   NSString             *equipTypeStr;
@property (nonatomic, copy)   NSString             *alarmLevelStr;
@property (nonatomic, copy)   NSString             *alarmStatusStr;
@property (nonatomic, copy)   NSString             *startTime;
@property (nonatomic, copy)   NSString             *endTime;

@property(strong,nonatomic)   NSArray              *roomArray;
@property (nonatomic, assign) BOOL                 isBlock;

@property (nonatomic, assign) BOOL                 isScreenStatus; //是否处在筛选状态下
//
//@property (nonatomic,strong) UIView *noDataView;


@property(strong,nonatomic)   KG_NoDataPromptView  *nodataView;
@end

@implementation KG_ZhiXiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view
    self.isOpenSwh = NO;     //默认开关为关闭状态
    self.isScreenStatus = NO;//一开始进入 不是筛选状态
    self.isBlock = NO;
    [self createNaviTopView];
    [self createSegmentView];
    self.pageNum = 1;
    self.pageSize = 10;
    self.currIndex = 0;
    
    //进入页面请求全部数据
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    //初始化为日
    [self.paraArr removeAllObjects];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    //全部的告警状态数据
    [self queryAllGaoJingData];
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
    
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
    if (self.isBlock) {
        self.isBlock = NO;
        return;
    }
    for (NSDictionary *dd in self.paraArr) {
        if (![safeString(dd[@"content"]) isEqualToString:safeString(currDic[@"code"])]) {
            [self.paraArr removeAllObjects];
            self.pageNum = 1;
            if(self.isOpenSwh) {
                
                NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
                paraDic[@"name"] = @"stationCode";
                paraDic[@"type"] = @"eq";
                paraDic[@"content"] = safeString(currDic[@"code"]);
                [self.paraArr addObject:paraDic];
                
                NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
                paraDic1[@"name"] = @"equipmentGroup";
                paraDic1[@"type"] = @"eq";
                paraDic1[@"content"] = @"equipment";
                [self.paraArr addObject:paraDic1];
                [self queryGaoJingData];
                [self.segment selectIndex:1];
                
            }else {
                NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
                paraDic[@"name"] = @"stationCode";
                paraDic[@"type"] = @"eq";
                paraDic[@"content"] = safeString(currDic[@"code"]);
                [self.paraArr addObject:paraDic];
                [self queryGaoJingData];
                [self.segment selectIndex:1];
            }
         
            break;
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    //     [self.navigationController setNavigationBarHidden:NO];
    [_nodataView removeFromSuperview];
    _nodataView = nil;
    
}

- (void)createSegmentView{
    
    NSArray *array = @[@"全部",@"未确认",@"已确认"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT +8, SCREEN_WIDTH, 44) withDataArray:array withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    
    UIView *swhView = [[UIView alloc]init];
    [self.view addSubview:swhView];
    swhView.backgroundColor = [UIColor colorWithHexString:@"#E6EEF7"];
    [swhView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@49);
        make.top.equalTo(self.segment.mas_bottom);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [swhView addSubview:titleLabel];
    titleLabel.text = @"仅展示空管专用设备";
    titleLabel.textColor = [UIColor colorWithHexString:@"#808EAC"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.font = [UIFont my_font:14];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(swhView.mas_left).offset(15);
        make.top.equalTo(swhView.mas_top);
        make.bottom.equalTo(swhView.mas_bottom);
        make.width.equalTo(@200);
    }];
    
    self.swh = [[UIButton alloc]init];
    [swhView addSubview:self.swh];
    [self.swh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(swhView.mas_right).offset(-17);
        make.centerY.equalTo(swhView.mas_centerY);
        make.width.equalTo(@44);
        make.height.equalTo(@26);
    }];
    [self.swh addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.isOpenSwh){
        [self.swh setImage:[UIImage imageNamed:@"open_swh"] forState:UIControlStateNormal];
    }else {
        [self.swh setImage:[UIImage imageNamed:@"close_swh"] forState:UIControlStateNormal];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom).offset(50);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
  
}
- (void)buttonClick:(UIButton *)button {
    
    if (self.isOpenSwh) {
        self.isOpenSwh = NO;
    }else {
        self.isOpenSwh = YES;
    }
    if(self.isOpenSwh){
        [self.swh setImage:[UIImage imageNamed:@"open_swh"] forState:UIControlStateNormal];
    }else {
        [self.swh setImage:[UIImage imageNamed:@"close_swh"] forState:UIControlStateNormal];
    }
    [self queryOpenSwhData];
    
}

//查询在打开空管专用设备下，打开开关的网络请求
- (void)queryOpenSwhData {
    [self.dataArray removeAllObjects];
    [self.paraArr removeAllObjects];
    self.pageNum = 1;
   
    //如果是关闭
    if (self.isOpenSwh == NO) {
        if (self.currIndex == 0) {
            NSLog(@"1");
            [self queryAllGaoJingData];
        }else if (self.currIndex == 1){
            self.isScreenStatus = NO; //未确认不带筛选条件
            [self queryUnConfirmData];//未确认
            
        }else if (self.currIndex == 2){
            self.isScreenStatus = NO; //未确认不带筛选条件
            NSLog(@"3");
            [self queryHaveConfirmData];
        }
        
    }else {
        if (self.currIndex == 0) {
            NSLog(@"1");
            
            [self queryOpenSwhAllGaoJingData];
        }else if (self.currIndex == 1){
            NSLog(@"2");
            self.isScreenStatus = NO;
            [self queryOpenSwhUnConfirmData];
        }else if (self.currIndex == 2){
            NSLog(@"3");
            self.isScreenStatus = NO;
            [self queryOpenSwhHaveConfirmData];
            
        }
        
    }
    
}

//获取某个台站下全部自动告警事件：
//请求地址：/{pageNum}/{pageSize}
//       其中，pageNum是页码，pageSize是每页的数据量
//请求方式：POST

- (void)queryGaoJingData {
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.dataArray removeAllObjects];
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
       
        [self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];
}


- (void)queryMoreGaoJingData {
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
        
        //        if(self.dataArray.count) {
        //            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //        }
        [self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
- (void)queryStationData {
    //    获取某个台站下的机房列表：
    //    请求地址：/intelligent/atcStation/engineRoomList/{stationCode}
    //              其中，stationCode是台站编码
    NSString *stationCode = @"";
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    if (currDic.count) {
        stationCode = safeString(currDic[@"code"]);
    }
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcStation/engineRoomList/%@",stationCode]];
    [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
        self.stationArray = [KG_ZhiXiuModel mj_objectArrayWithKeyValuesArray:result[@"value"]];
        
        [self getStationList];
        
        
        NSLog(@"");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else {
            [FrameBaseRequest showMessage:@"网络链接失败"];
        }
    }];
    
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
    self.titleLabel.text = @"告警管理";
    
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
    
    
    self.histroyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.histroyBtn.titleLabel.font = FontSize(12);
    
    
    [self.histroyBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.histroyBtn setImage:[UIImage imageNamed:@"screen_icon"] forState:UIControlStateNormal];
    self.histroyBtn.frame = CGRectMake(0,0,81,22);
    [self.view addSubview:self.histroyBtn];
    [self.histroyBtn addTarget:self action:@selector(screenAction) forControlEvents:UIControlEventTouchUpInside];
    [self.histroyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.right.equalTo(self.histroyBtn.mas_left).offset(-6);
    }];
    [self.leftIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationView.mas_left).offset(16);
        make.width.height.equalTo(@34);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    //单台站不可点击
    self.rightButton.userInteractionEnabled = NO;
    
    
}



- (void)screenAction{
    
    KG_NewScreenViewController *vc = [[KG_NewScreenViewController alloc]init];
    if(self.roomStr.length >0) {
        vc.roomStr = self.roomStr;
    }
    if(self.alarmLevelStr.length >0) {
        vc.alarmLevelStr = self.alarmLevelStr;
    }
    
    if(self.startTime.length >0) {
        vc.startTime = self.startTime;
    }
    
    if(self.endTime.length >0) {
        vc.endTime = self.endTime;
    }
    if(self.equipTypeStr.length >0) {
        vc.equipTypeStr = self.equipTypeStr;
    }
    
    
    

    vc.confirmBlockMethod = ^(NSString * _Nonnull roomStr, NSString * _Nonnull equipTypeStr, NSString * _Nonnull alarmLevelStr, NSString * _Nonnull alarmStausStr, NSString * _Nonnull startTimeStr, NSString * _Nonnull endTimeStr, NSArray * _Nonnull roomArray) {
        
        self.roomStr = roomStr;
        self.equipTypeStr =equipTypeStr;
        self.alarmLevelStr = alarmLevelStr;
        self.alarmStatusStr = alarmStausStr;
        self.startTime = startTimeStr;
        self.endTime = endTimeStr;
        self.roomArray = roomArray;
        self.isBlock = YES;
        if(roomStr.length == 0 && equipTypeStr.length == 0 && alarmLevelStr.length == 0
           &&alarmStausStr.length == 0  && startTimeStr.length == 0 && endTimeStr.length == 0) {
            self.isScreenStatus = NO;
            [self.histroyBtn setImage:[UIImage imageNamed:@"screen_icon"] forState:UIControlStateNormal];
            return ;
        }
        [self.histroyBtn setImage:[UIImage imageNamed:@"screen_blueImage"] forState:UIControlStateNormal];
        
        self.isScreenStatus = YES;
        [self screenMethodData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)loadmoreScreenData {
    [self.paraArr removeAllObjects];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    NSString *roomString = @"";
    for (NSDictionary *dataDic in self.roomArray) {
        if ([safeString(dataDic[@"alias"]) isEqualToString:self.roomStr]) {
            roomString = safeString(dataDic[@"code"]);
            break;
        }
    }
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"engineRoomCode";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = safeString(roomString);
    if (roomString.length) {
        [self.paraArr addObject:paraDic1];
    }
    
    
    NSString *alarmStatusCode = @"";
    if ([self.alarmStatusStr isEqualToString:@"未确认"]) {
        alarmStatusCode = @"unconfirmed";
    }else if ([self.alarmStatusStr isEqualToString:@"已确认"]) {
        alarmStatusCode = @"confirmed";
    }else if ([self.alarmStatusStr isEqualToString:@"已解决"]) {
        alarmStatusCode = @"completed";
    }else if ([self.alarmStatusStr isEqualToString:@"已解除"]) {
        alarmStatusCode = @"removed";
    }
    
    NSMutableDictionary *paraDic2 = [NSMutableDictionary dictionary];
    paraDic2[@"name"] = @"alarmStatus";
    paraDic2[@"type"] = @"eq";
    paraDic2[@"content"] = safeString(alarmStatusCode);
    
    if (alarmStatusCode.length) {
        [self.paraArr addObject:paraDic2];
    }
    
    
    NSString *equipCode = @"";
    if ([self.equipTypeStr isEqualToString:@"安防"]) {
        equipCode = @"security";
    }else if ([self.equipTypeStr isEqualToString:@"环境"]) {
        equipCode = @"environmental";
    }else if ([self.equipTypeStr isEqualToString:@"动力"]) {
        equipCode = @"power";
    }else if ([self.equipTypeStr isEqualToString:@"设备"]) {
        equipCode = @"equipment";
    }
    NSMutableDictionary *paraDic3 = [NSMutableDictionary dictionary];
    paraDic3[@"name"] = @"equipmentGroup";
    paraDic3[@"type"] = @"eq";
    paraDic3[@"content"] = safeString(equipCode);
    if (equipCode.length) {
        [self.paraArr addObject:paraDic3];
    }
    
    NSString *alarmLevelCode = @"";
    if ([self.alarmLevelStr isEqualToString:@"紧急"]) {
        alarmLevelCode = @"1";
    }else if ([self.alarmLevelStr isEqualToString:@"重要"]) {
        alarmLevelCode = @"2";
    }else if ([self.alarmLevelStr isEqualToString:@"次要"]) {
        alarmLevelCode = @"3";
    }else if ([self.alarmLevelStr isEqualToString:@"提示"]) {
        alarmLevelCode = @"4";
    }else if ([self.alarmLevelStr isEqualToString:@"正常"]) {
        alarmLevelCode = @"5";
    }
    
    NSMutableDictionary *paraDic4 = [NSMutableDictionary dictionary];
    paraDic4[@"name"] = @"alarmLevel";
    paraDic4[@"type"] = @"eq";
    paraDic4[@"content"] = safeString(alarmLevelCode);
    if (alarmLevelCode.length) {
        [self.paraArr addObject:paraDic4];
    }
    
    
    NSMutableDictionary *paraDic5 = [NSMutableDictionary dictionary];
    paraDic5[@"name"] = @"startTime";
    paraDic5[@"type"] = @"eq";
    paraDic5[@"content"] = safeString(self.startTime);
    if (safeString(self.startTime).length) {
        [self.paraArr addObject:paraDic5];
    }
    
    NSMutableDictionary *paraDic6 = [NSMutableDictionary dictionary];
    paraDic6[@"name"] = @"endTime";
    paraDic6[@"type"] = @"eq";
    paraDic6[@"content"] = safeString(self.endTime);
    
    if (safeString(self.endTime).length) {
        [self.paraArr addObject:paraDic6];
    }
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
       
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
        
        [self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];

}

//获取某个台站下筛选自动告警事件：
//请求地址：/intelligent/keepInRepair/searchAlarmInfo/{pageNum}/{pageSize}
//       其中，pageNum是页码，pageSize是每页的数据量
//请求方式：POST
//筛选数据方法
- (void)screenMethodData {
    [self.segment selectIndex:1];
    [self.dataArray removeAllObjects];
    [self.paraArr removeAllObjects];
    self.pageNum = 1;
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    NSString *roomString = @"";
    for (NSDictionary *dataDic in self.roomArray) {
        if ([safeString(dataDic[@"alias"]) isEqualToString:self.roomStr]) {
            roomString = safeString(dataDic[@"code"]);
            break;
        }
    }
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"engineRoomCode";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = safeString(roomString);
    if (roomString.length) {
        [self.paraArr addObject:paraDic1];
    }
    
    
    NSString *alarmStatusCode = @"";
    if ([self.alarmStatusStr isEqualToString:@"未确认"]) {
        alarmStatusCode = @"unconfirmed";
    }else if ([self.alarmStatusStr isEqualToString:@"已确认"]) {
        alarmStatusCode = @"confirmed";
    }else if ([self.alarmStatusStr isEqualToString:@"已解决"]) {
        alarmStatusCode = @"completed";
    }else if ([self.alarmStatusStr isEqualToString:@"已解除"]) {
        alarmStatusCode = @"removed";
    }
    
    NSMutableDictionary *paraDic2 = [NSMutableDictionary dictionary];
    paraDic2[@"name"] = @"alarmStatus";
    paraDic2[@"type"] = @"eq";
    paraDic2[@"content"] = safeString(alarmStatusCode);
    
    if (alarmStatusCode.length) {
        [self.paraArr addObject:paraDic2];
    }
    
    
    NSString *equipCode = @"";
    if ([self.equipTypeStr isEqualToString:@"安防"]) {
        equipCode = @"security";
    }else if ([self.equipTypeStr isEqualToString:@"环境"]) {
        equipCode = @"environmental";
    }else if ([self.equipTypeStr isEqualToString:@"动力"]) {
        equipCode = @"power";
    }else if ([self.equipTypeStr isEqualToString:@"设备"]) {
        equipCode = @"equipment";
    }
    NSMutableDictionary *paraDic3 = [NSMutableDictionary dictionary];
    paraDic3[@"name"] = @"equipmentGroup";
    paraDic3[@"type"] = @"eq";
    paraDic3[@"content"] = safeString(equipCode);
    if (equipCode.length) {
        [self.paraArr addObject:paraDic3];
    }
    
    NSString *alarmLevelCode = @"";
    if ([self.alarmLevelStr isEqualToString:@"紧急"]) {
        alarmLevelCode = @"1";
    }else if ([self.alarmLevelStr isEqualToString:@"重要"]) {
        alarmLevelCode = @"2";
    }else if ([self.alarmLevelStr isEqualToString:@"次要"]) {
        alarmLevelCode = @"3";
    }else if ([self.alarmLevelStr isEqualToString:@"提示"]) {
        alarmLevelCode = @"4";
    }else if ([self.alarmLevelStr isEqualToString:@"正常"]) {
        alarmLevelCode = @"5";
    }
    
    NSMutableDictionary *paraDic4 = [NSMutableDictionary dictionary];
    paraDic4[@"name"] = @"alarmLevel";
    paraDic4[@"type"] = @"eq";
    paraDic4[@"content"] = safeString(alarmLevelCode);
    if (alarmLevelCode.length) {
        [self.paraArr addObject:paraDic4];
    }
    
    
    NSMutableDictionary *paraDic5 = [NSMutableDictionary dictionary];
    paraDic5[@"name"] = @"startTime";
    paraDic5[@"type"] = @"eq";
    paraDic5[@"content"] = safeString(self.startTime);
    if (safeString(self.startTime).length) {
        [self.paraArr addObject:paraDic5];
    }
    
    NSMutableDictionary *paraDic6 = [NSMutableDictionary dictionary];
    paraDic6[@"name"] = @"endTime";
    paraDic6[@"type"] = @"eq";
    paraDic6[@"content"] = safeString(self.endTime);
    
    if (safeString(self.endTime).length) {
        [self.paraArr addObject:paraDic6];
    }
    //查询全部
    [self queryScreenAllGaoJingData];
    
    
}
//查询筛选的全局数据
- (void)queryScreenAllGaoJingData {
    
    self.pageNum = 1;
    //进入页面请求全部数据
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    //初始化为日
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.dataArray removeAllObjects];
        
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];
    
}
- (void)rightAction {
    [self stationAction];
}


- (void)backButtonClick:(UIButton *)button {
    [self leftCenterButtonClick];
    //    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    
}
/**
 弹出个人中心
 */
- (void)leftCenterButtonClick {
    
//    KG_MineViewController  *vc = [[KG_MineViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyingHeadNotification" object:self];
//    [self.slideMenuController showMenu];
    KG_MineViewController  *vc = [[KG_MineViewController alloc]init];
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;            //改变视图控制器出现的方式
    transition.subtype = kCATransitionFromLeft;     //出现的位置
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:vc animated:NO];
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
-(void)stationAction {
    
    NSArray *array = [UserManager shareUserManager].stationList;
    
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *stationDic in array) {
        [list addObject:stationDic[@"station"]];
    }
    self.stationArray = [KG_ZhiTaiStationModel mj_objectArrayWithKeyValuesArray:list];
    [self getStationList];
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
    }else {
        
        
        //        KG_GaoJingModel *model = self.dataArray[indexPath.section];
        
        return  141;
    }
    
    return FrameWidth(210);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(tableView == self.tableView){
        return self.dataArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.stationTabView){
        return self.stationArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.2 去缓存池中取Cell
    if(tableView == self.stationTabView){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        KG_ZhiXiuModel *model = self.stationArray[indexPath.row];
        cell.textLabel.text = safeString(model.name) ;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.font = [UIFont my_font:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        
        return cell;
        
    }else {
        KG_ZhiXiuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_ZhiXiuCell"];
        if (cell == nil) {
            cell = [[KG_ZhiXiuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_ZhiXiuCell"];
            
        }
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        KG_GaoJingModel *model = self.dataArray[indexPath.section];
        cell.model = model;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if(self.dataArray.count >1 &&indexPath.section == 1) {
            
            if (![userDefaults objectForKey:@"firstZhiXiu"]) {
                [userDefaults setObject:@"1" forKey:@"firstZhiXiu"];
                [userDefaults synchronize];
                cell.showLeftSrcollView = @"1";
                
            }else {
                cell.showLeftSrcollView = @"0";
            }
        }else {
            cell.showLeftSrcollView = @"0";
        }
        return cell;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.stationTabView isEqual:tableView]) {
        KG_ZhiTaiStationModel *model = self.stationArray[indexPath.section];
        NSLog(@"1");
        [UserManager shareUserManager].currentStationDic = [model mj_keyValues];
        [self.rightButton setTitle:safeString(model.name) forState:UIControlStateNormal];
        [[UserManager shareUserManager] saveStationData:[model mj_keyValues]];
        [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
        
    }else {
        KG_GaoJingModel *model = self.dataArray[indexPath.section];
        KG_GaoJingDetailViewController *vc = [[KG_GaoJingDetailViewController alloc]init];
        vc.model = model;
        vc.refreshData = ^{
            [self queryGaoJingData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//筛选方法2
- (void)screenMethod {
    NSArray *array = @[@{@"sectionName": @"内容",
                         @"sectionType": @(RS_ConditionSearchSectionTypeNormal),
                         @"allowMutiSelect": @(YES),
                         @"allowPackUp": @(YES),
                         @"itemArrM": @[@{@"itemName":@"开始时间"},
                                        @{@"itemName":@"结束时间"}]},
                       @{@"sectionName":@"起始时间",
                         @"sectionType":@(RS_ConditionSearchSectionTypeInterval),
                         @"allowMutiSelect":@(NO),
                         @"allowPackUp":@(NO),
                         @"intervalStart":@"",
                         @"intervalEnd":@"",
                         @"intervalIsInput":@(NO),
                         @"itemArrM":
                             @[@{@"itemName":@"开始时间"},
                               @{@"itemName":@"结束时间"}]}];
    
    RS_ConditionSearchView *searchView = [[RS_ConditionSearchView alloc] initWithCondition:array];
    
    //          searchView.conditionDataArr = array;
    [searchView show];
    
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

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
        // 上拉加载
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableView;
}


- (void)loadMoreData {
    self.pageNum ++;
    
    
    
    if (self.isScreenStatus && self.currIndex == 0) {
        [self loadmoreScreenData];
    }
    
    if (self.isOpenSwh == NO) {
        if(self.currIndex == 0) {
            //全部的数据  更多
            [self queryAllMoreGaojingData];
        }else if (self.currIndex == 1) {
            //未确认 更多
            [self queryMoreUnConfirmData];
        }else if (self.currIndex == 2) {
            //已确认 更多
            [self queryMoreConfirmData];
        }
        
    }else {
        if (self.currIndex == 0) {
            NSLog(@"1");
            
            [self queryOpenSwhAllMoreGaojingData];
        }else if (self.currIndex == 1){
            NSLog(@"2");
            
            [self queryOpenSwhMoreUnConfirmData];
        }else if (self.currIndex == 2){
            NSLog(@"3");
            
            [self queryOpenSwhMoreConfirmData];
            
        }
        
    }

  
}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)paraArr {
    if (!_paraArr) {
        _paraArr = [[NSMutableArray alloc] init];
    }
    
    return _paraArr;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
        return headView;
    }
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}

- (void)selectedIndex:(NSInteger)index{
    NSLog(@"测试");
    [self.dataArray removeAllObjects];
    [self.paraArr removeAllObjects];
    self.pageNum = 1;
    self.currIndex = (int)index;
   
    if(index == 1 || index == 2) {
        self.isScreenStatus = NO;
        self.roomStr = nil;
        self.alarmLevelStr = nil;
        self.startTime = nil;
        self.endTime = nil;
        self.equipTypeStr = nil;
        
        [self.histroyBtn setImage:[UIImage imageNamed:@"screen_icon"] forState:UIControlStateNormal];
    }
    if (self.isScreenStatus && self.currIndex == 0) {
        [self screenMethodData];
    }
    
    
    //如果是关闭
    if (self.isOpenSwh == NO) {
        if (index == 0) {
            NSLog(@"1");
            [self queryAllGaoJingData];
        }else if (index == 1){
            self.isScreenStatus = NO; //未确认不带筛选条件
            [self queryUnConfirmData];//未确认
         
        }else if (index == 2){
            self.isScreenStatus = NO; //未确认不带筛选条件
            NSLog(@"3");
            [self queryHaveConfirmData];
        }
        
    }else {
        if (self.currIndex == 0) {
            NSLog(@"1");
            
            [self queryOpenSwhAllGaoJingData];
        }else if (self.currIndex == 1){
            NSLog(@"2");
            
            [self queryOpenSwhUnConfirmData];
        }else if (self.currIndex == 2){
            NSLog(@"3");
            
            [self queryOpenSwhHaveConfirmData];
            
        }
    }
}

- (void)queryConfirmData {
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/notUnconfirmed/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
        
        //        if(self.dataArray.count) {
        //            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //        }
        [self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
//
- (void)loadMoreConfirmData {
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/notUnconfirmed/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
        
        //        if(self.dataArray.count) {
        //            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //        }
        [self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
}
//MARK: 设置左滑按钮的样式
- (void)setupSlideBtnWithEditingIndexPath:(NSIndexPath *)editingIndexPath {
    
    // 判断系统是否是 iOS13 及以上版本
    if (@available(iOS 13.0, *)) {
        for (UIView *subView in self.tableView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"_UITableViewCellSwipeContainerView")] && [subView.subviews count] >= 1) {
                // 修改图片
                UIView *remarkContentView = subView.subviews.firstObject;
                [self setupRowActionView:remarkContentView withIndex:editingIndexPath];
            }
        }
        return;
    }
    
    // 判断系统是否是 iOS11 及以上版本
    if (@available(iOS 11.0, *)) {
        for (UIView *subView in self.tableView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subView.subviews count] >= 1) {
                // 修改图片
               
                UIView *remarkContentView = subView;
                [self setupRowActionView:remarkContentView withIndex:editingIndexPath];
            }
        }
        return;
    }
    
    // iOS11 以下的版本
    KG_ZhiXiuCell *cell = [self.tableView cellForRowAtIndexPath:editingIndexPath];
    for (UIView *subView in cell.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] && [subView.subviews count] >= 1) {
            // 修改图片
            UIView *remarkContentView = subView;
            [self setupRowActionView:remarkContentView withIndex:editingIndexPath];
        }
    }
}

- (void)setupRowActionView:(UIView *)rowActionView withIndex:(NSIndexPath *)editingIndexPath {
    
    // 切割圆角
    //    [rowActionView cl_setCornerAllRadiusWithRadiu:20];
    // 改变父 View 的frame，这句话是因为我在 contentView 里加了另一个 View，为了使划出的按钮能与其达到同一高度
    CGRect frame = rowActionView.frame;
    //    frame.origin.y += (7);
    frame.size.height = (141);
    //    frame.size.width = (180);
    rowActionView.frame = frame;
    // 拿到按钮,设置
    UIButton *hang = rowActionView.subviews.firstObject;
    hang.tag = editingIndexPath.section;
    [hang setBackgroundColor:[UIColor colorWithHexString:@"#F6F7F9"]];
    [hang setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateHighlighted];
    [hang setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateSelected];
    [hang setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateNormal];
    [hang setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateDisabled];
    [hang setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateFocused];
    [hang setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateReserved];
    [hang setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateApplication];
    
    
    
    
    UIView *hangBgView = [[UIView alloc]init];
    hangBgView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [hang addSubview:hangBgView];
    hangBgView.layer.cornerRadius = 20.f;
    hangBgView.layer.masksToBounds = YES;
    
    [hang addTarget:self action:@selector(hangMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [hangBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hang.mas_left).offset(14);
        make.centerY.equalTo(hang.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    
    UILabel *hangLabel = [[UILabel alloc]init];
    [hangBgView addSubview:hangLabel];
    hangLabel.text = @"确认";
    hangLabel.textAlignment = NSTextAlignmentCenter;
    hangLabel.font = [UIFont systemFontOfSize:12];
    hangLabel.font = [UIFont my_font:12];
    hangLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [hangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(hangBgView.mas_centerX);
        make.centerY.equalTo(hangBgView.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
   
    
    
    
    UIButton *lift = rowActionView.subviews[1];
    lift.tag = editingIndexPath.section;
    [lift addTarget:self action:@selector(liftMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lift setBackgroundColor:[UIColor colorWithHexString:@"#F6F7F9"]];
    [lift setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateHighlighted];
    [lift setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateSelected];
    [lift setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateNormal];
    [lift setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateDisabled];
    [lift setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateFocused];
    [lift setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateReserved];
    [lift setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateApplication];
    
    
    
    
    
    
    
    UIView *liftBgView = [[UIView alloc]init];
    liftBgView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [lift addSubview:liftBgView];
    liftBgView.layer.cornerRadius = 20.f;
    liftBgView.layer.masksToBounds = YES;
    [liftBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lift.mas_left).offset(14);
        make.centerY.equalTo(lift.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    UILabel *liftLabel = [[UILabel alloc]init];
    [liftBgView addSubview:liftLabel];
    liftLabel.text = @"解除";
    liftLabel.textAlignment = NSTextAlignmentCenter;
    liftLabel.font = [UIFont systemFontOfSize:12];
    liftLabel.font = [UIFont my_font:12];
    liftLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [liftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(liftBgView.mas_centerX);
        make.centerY.equalTo(liftBgView.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    
    UIButton *confirm = rowActionView.subviews[2];
    confirm.tag = editingIndexPath.section;
    [confirm addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [confirm setBackgroundColor:[UIColor colorWithHexString:@"#F6F7F9"]];
    [confirm setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateHighlighted];
    [confirm setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateSelected];
    [confirm setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateNormal];
    [confirm setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateDisabled];
    [confirm setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateFocused];
    [confirm setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateReserved];
    [confirm setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]] forState:UIControlStateApplication];
    
    
    UIView *confirmBgView = [[UIView alloc]init];
    confirmBgView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [confirm addSubview:confirmBgView];
    confirmBgView.layer.cornerRadius = 20.f;
    confirmBgView.layer.masksToBounds = YES;
    [confirmBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirm.mas_left).offset(14);
        make.centerY.equalTo(confirm.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    UILabel *confirmLabel = [[UILabel alloc]init];
    [confirmBgView addSubview:confirmLabel];
    confirmLabel.text = @"挂起";
    confirmLabel.textAlignment = NSTextAlignmentCenter;
    confirmLabel.font = [UIFont systemFontOfSize:12];
    confirmLabel.font = [UIFont my_font:12];
    confirmLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(confirmBgView.mas_centerX);
        make.centerY.equalTo(confirmBgView.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
}

//确认
- (void)hangMethod:(UIButton *)button {
    
    KG_GaoJingModel *model = self.dataArray[button.tag];
    if ([safeString(model.status) isEqualToString:@"已解除"]) {
        [FrameBaseRequest showMessage:@"该告警状态为:已解除,不能确认"];
        return;
    }
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"id"] = safeString(model.id);
    paramDic[@"status"] = @"confirmed";
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/handleAlarmStatus",WebNewHost];
    
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [FrameBaseRequest showMessage:@"确认操作成功"];
        [self queryRefreshData];
        
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
        }
        return ;
    }];
    
    
}
//解除
- (void)liftMethod:(UIButton *)button {
    
    KG_GaoJingModel *model = self.dataArray[button.tag];
    
    
    
    if ([safeString(model.status) isEqualToString:@"已解除"]) {
        [FrameBaseRequest showMessage:@"该告警状态为:已解除,不能解除"];
        return;
    }
    KG_ControlGaoJingAlertView *view = [[KG_ControlGaoJingAlertView alloc]init];
    [JSHmainWindow addSubview:view];
    view.selTime = ^(NSString * _Nonnull timeStr, int index) {
        
        if (index == 0) {
            self.removeStartTime = timeStr;
        }else {
            self.removeEndTime = timeStr;
        }
    };
    view.sureMethod = ^{
        
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        paramDic[@"id"] = safeString(model.id);
        paramDic[@"status"] = @"removed";
        NSString *startStr = safeString(self.removeStartTime);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ssZ"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
        NSDate *startDate = [dateFormatter dateFromString:startStr];
        
        NSString *endStr= safeString(self.removeEndTime);
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-ddTHH:mm:ssZ"];
        [dateFormatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
        NSDate *endDate = [dateFormatter1 dateFromString:endStr];
        
        paramDic[@"suppressStartTime"] = startDate ;
        paramDic[@"suppressEndTime"] = endDate;
        
        
        //JAVA中Date数据类型格式
        NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/handleAlarmStatus",WebNewHost];
        [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
        
        [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            [MBProgressHUD hideHUD];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                
                return ;
            }
            [FrameBaseRequest showMessage:@"解除成功"];
            [self queryRefreshData];
            
        } failure:^(NSError *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            [MBProgressHUD hideHUD];
            if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
                [FrameBaseRequest logout];
                LoginViewController *login = [[LoginViewController alloc] init];
                [self.slideMenuController showViewController:login];
                return;
            }
            return ;
        }];
    };
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
        make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
        make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
    }];
    
    
}
//挂起
- (void)confirmMethod:(UIButton *)button {
    
    KG_GaoJingModel *model = self.dataArray[button.tag];
    if ([safeString(model.status) isEqualToString:@"已解除"]) {
        [FrameBaseRequest showMessage:@"该告警状态为:已解除,不能挂起"];
        return;
    }
    if ([safeString(model.status) isEqualToString:@"已解决"]) {
        [FrameBaseRequest showMessage:@"该告警状态为:已解决,不能挂起"];
        return;
    }
    
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"id"] = safeString(model.id);
    paramDic[@"status"] = @"";
    paramDic[@"hangUp"] = @"true";
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/handleAlarmStatus",WebNewHost];
    
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [FrameBaseRequest showMessage:@"挂起操作成功"];
        [self queryRefreshData];
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
        }
        return ;
    }];
}


- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupSlideBtnWithEditingIndexPath:indexPath];
    });
}
- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //title不设为nil 而是空字符串 理由为啥 ？   自己实践 跑到ios11以下的机器上就知道为啥了
    UITableViewRowAction *hang = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"        " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
    }];
    UITableViewRowAction *lift = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"        " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
    }];
    UITableViewRowAction *confirm = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"        " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
    }];
    return @[hang,lift,confirm];
}
//获取某个台站下全部自动告警事件：
//请求地址：/{pageNum}/{pageSize}
//       其中，pageNum是页码，pageSize是每页的数据量
//请求方式：POST

- (void)queryNoHudGaoJingData {
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.dataArray removeAllObjects];
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
//        if (self.dataArray.count == 0) {
//            [self.view addSubview:self.noDataView];
//            [self.view bringSubviewToFront:self.noDataView];
//        }
        [self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
        }
        return ;
    }];
}

- (void)addScreenDic {
    NSString *roomString = @"";
    for (NSDictionary *dataDic in self.roomArray) {
        if ([safeString(dataDic[@"alias"]) isEqualToString:self.roomStr]) {
            roomString = safeString(dataDic[@"code"]);
            break;
        }
    }
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"engineRoomCode";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = safeString(roomString);
    if (safeString(roomString).length) {
        [self.paraArr addObject:paraDic1];
    }
    
    
    NSString *alarmStatusCode = @"";
    if ([self.alarmStatusStr isEqualToString:@"未确认"]) {
        alarmStatusCode = @"unconfirmed";
    }else if ([self.alarmStatusStr isEqualToString:@"已确认"]) {
        alarmStatusCode = @"confirmed";
    }else if ([self.alarmStatusStr isEqualToString:@"已解决"]) {
        alarmStatusCode = @"completed";
    }else if ([self.alarmStatusStr isEqualToString:@"已解除"]) {
        alarmStatusCode = @"removed";
    }
    
    NSMutableDictionary *paraDic2 = [NSMutableDictionary dictionary];
    paraDic2[@"name"] = @"alarmStatus";
    paraDic2[@"type"] = @"eq";
    paraDic2[@"content"] = safeString(alarmStatusCode);
    if (safeString(alarmStatusCode).length) {
        [self.paraArr addObject:paraDic2];
    }
    
    
    NSString *equipCode = @"";
    if ([self.equipTypeStr isEqualToString:@"安防"]) {
        equipCode = @"security";
    }else if ([self.equipTypeStr isEqualToString:@"环境"]) {
        equipCode = @"environmental";
    }else if ([self.equipTypeStr isEqualToString:@"动力"]) {
        equipCode = @"power";
    }else if ([self.equipTypeStr isEqualToString:@"设备"]) {
        equipCode = @"equipment";
    }
    NSMutableDictionary *paraDic3 = [NSMutableDictionary dictionary];
    paraDic3[@"name"] = @"equipmentGroup";
    paraDic3[@"type"] = @"eq";
    paraDic3[@"content"] = safeString(equipCode);
    if (safeString(equipCode).length) {
        [self.paraArr addObject:paraDic3];
    }
    
    
    NSString *alarmLevelCode = @"";
    if ([self.alarmLevelStr isEqualToString:@"紧急"]) {
        alarmLevelCode = @"1";
    }else if ([self.alarmLevelStr isEqualToString:@"重要"]) {
        alarmLevelCode = @"2";
    }else if ([self.alarmLevelStr isEqualToString:@"次要"]) {
        alarmLevelCode = @"3";
    }else if ([self.alarmLevelStr isEqualToString:@"提示"]) {
        alarmLevelCode = @"4";
    }else if ([self.alarmLevelStr isEqualToString:@"正常"]) {
        alarmLevelCode = @"5";
    }
    
    NSMutableDictionary *paraDic4 = [NSMutableDictionary dictionary];
    paraDic4[@"name"] = @"alarmLevel";
    paraDic4[@"type"] = @"eq";
    paraDic4[@"content"] = safeString(alarmLevelCode);
    if (safeString(alarmLevelCode).length) {
        [self.paraArr addObject:paraDic4];
    }
    
    
    NSMutableDictionary *paraDic5 = [NSMutableDictionary dictionary];
    paraDic5[@"name"] = @"startTime";
    paraDic5[@"type"] = @"eq";
    paraDic5[@"content"] = safeString(self.startTime);
    if (safeString(self.startTime).length) {
        [self.paraArr addObject:paraDic5];
    }
    NSMutableDictionary *paraDic6 = [NSMutableDictionary dictionary];
    paraDic6[@"name"] = @"endTime";
    paraDic6[@"type"] = @"eq";
    paraDic6[@"content"] = safeString(self.endTime);
    if (safeString(self.endTime).length) {
        [self.paraArr addObject:paraDic6];
    }
   
}

- (KG_NoDataPromptView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[KG_NoDataPromptView alloc]init];
        [JSHmainWindow addSubview:_nodataView];
//        [self.view bringSubviewToFront:_nodataView];
        _nodataView.noDataLabel.text = @"当前暂无数据";
        
        [_nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top).offset(NAVIGATIONBAR_HEIGHT +50 +44);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom).offset(-TABBAR_HEIGHT);
        }];
    }
    return _nodataView;
}



//全部的数据 pagenum = 1
- (void)queryAllGaoJingData {
    [self.paraArr removeAllObjects];
    self.pageNum = 1;
    //进入页面请求全部数据
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    //初始化为日
    [self.paraArr removeAllObjects];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.dataArray removeAllObjects];
        
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];
}

//全部 更多
- (void)queryAllMoreGaojingData {
  
    //进入页面请求全部数据
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    //初始化为日
    [self.paraArr removeAllObjects];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
       
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }[self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];
}

//未确认
- (void)queryUnConfirmData {
    [self.paraArr removeAllObjects];
    self.pageNum = 1;
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"alarmStatus";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = @"unconfirmed";
    [self.paraArr addObject:paraDic1];
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.dataArray removeAllObjects];
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }[self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];
}

//未确认 更多
- (void)queryMoreUnConfirmData {
    
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"alarmStatus";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = @"unconfirmed";
    [self.paraArr addObject:paraDic1];
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }[self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];
}

//已确认
- (void)queryHaveConfirmData {
    [self.paraArr removeAllObjects];
    self.pageNum = 1;
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/notUnconfirmed/%d/%d",WebNewHost,self.pageNum,self.pageSize];
      WS(weakSelf);
      [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
          NSInteger code = [[result objectForKey:@"errCode"] intValue];
          if(code  <= -1){
              [FrameBaseRequest showMessage:result[@"errMsg"]];
              
              return ;
          }
          [self.dataArray removeAllObjects];
          [self.tableView.mj_footer endRefreshing];
          NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
          [self.dataArray addObjectsFromArray:arr] ;
          if (self.dataArray.count == 0) {
              [self.nodataView showView];
          }else {
              [self.nodataView hideView];
          }
          int pages = [result[@"value"][@"pages"] intValue];
          
          if (self.pageNum >= pages) {
              [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
              
          }else {
              if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                  [weakSelf.tableView.mj_footer resetNoMoreData];
              }
          }
          
          
          //        if(self.dataArray.count) {
          //            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
          //        }
          [self.tableView reloadData];
      } failure:^(NSError *error)  {
          FrameLog(@"请求失败，返回数据 : %@",error);
          if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
              [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
              [FrameBaseRequest logout];
              LoginViewController *login = [[LoginViewController alloc] init];
              [self.slideMenuController showViewController:login];
              return;
          }
          [FrameBaseRequest showMessage:@"网络链接失败"];
          return ;
      }];
}


//已确认更多
- (void)queryMoreConfirmData {
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/notUnconfirmed/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
        
        //        if(self.dataArray.count) {
        //            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //        }
        [self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

#pragma mark ------ 打开了空管开关
//打开空管设备开关下的请求
//全部的数据 pagenum = 1
- (void)queryOpenSwhAllGaoJingData {
    [self.paraArr removeAllObjects];
    self.pageNum = 1;
    //进入页面请求全部数据
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    //初始化为日
    [self.paraArr removeAllObjects];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"equipmentGroup";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = @"equipment";
    [self.paraArr addObject:paraDic1];
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.dataArray removeAllObjects];
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }[self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];
}

//全部 更多
- (void)queryOpenSwhAllMoreGaojingData {
  
    //进入页面请求全部数据
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    //初始化为日
    [self.paraArr removeAllObjects];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"equipmentGroup";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = @"equipment";
    [self.paraArr addObject:paraDic1];
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
       
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }[self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];
}

//未确认
- (void)queryOpenSwhUnConfirmData {
    [self.paraArr removeAllObjects];
    self.pageNum = 1;
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"alarmStatus";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = @"unconfirmed";
    [self.paraArr addObject:paraDic1];
    
    NSMutableDictionary *paraDic2 = [NSMutableDictionary dictionary];
    paraDic2[@"name"] = @"equipmentGroup";
    paraDic2[@"type"] = @"eq";
    paraDic2[@"content"] = @"equipment";
    [self.paraArr addObject:paraDic2];
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.dataArray removeAllObjects];
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }[self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];
}

//未确认 更多
- (void)queryOpenSwhMoreUnConfirmData {
    
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"alarmStatus";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = @"unconfirmed";
    [self.paraArr addObject:paraDic1];
    NSMutableDictionary *paraDic2 = [NSMutableDictionary dictionary];
    paraDic2[@"name"] = @"equipmentGroup";
    paraDic2[@"type"] = @"eq";
    paraDic2[@"content"] = @"equipment";
    [self.paraArr addObject:paraDic2];
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }[self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];
}

//已确认
- (void)queryOpenSwhHaveConfirmData {
    [self.paraArr removeAllObjects];
    self.pageNum = 1;
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"equipmentGroup";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = @"equipment";
    [self.paraArr addObject:paraDic1];
    
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/notUnconfirmed/%d/%d",WebNewHost,self.pageNum,self.pageSize];
      WS(weakSelf);
      [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
          NSInteger code = [[result objectForKey:@"errCode"] intValue];
          if(code  <= -1){
              [FrameBaseRequest showMessage:result[@"errMsg"]];
              
              return ;
          }
          [self.dataArray removeAllObjects];
          [self.tableView.mj_footer endRefreshing];
          NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
          [self.dataArray addObjectsFromArray:arr] ;
          if (self.dataArray.count == 0) {
              [self.nodataView showView];
          }else {
              [self.nodataView hideView];
          }
          int pages = [result[@"value"][@"pages"] intValue];
          
          if (self.pageNum >= pages) {
              [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
              
          }else {
              if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                  [weakSelf.tableView.mj_footer resetNoMoreData];
              }
          }
          
          
          //        if(self.dataArray.count) {
          //            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
          //        }
          [self.tableView reloadData];
      } failure:^(NSError *error)  {
          FrameLog(@"请求失败，返回数据 : %@",error);
          if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
              [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
              [FrameBaseRequest logout];
              LoginViewController *login = [[LoginViewController alloc] init];
              [self.slideMenuController showViewController:login];
              return;
          }
          [FrameBaseRequest showMessage:@"网络链接失败"];
          return ;
      }];
}

//已确认更多
- (void)queryOpenSwhMoreConfirmData {
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/notUnconfirmed/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"equipmentGroup";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = @"equipment";
    [self.paraArr addObject:paraDic1];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
        
        //        if(self.dataArray.count) {
        //            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //        }
        [self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

//查询全部
- (void)queryScreenMoreAllGaoJingData {
    
    //进入页面请求全部数据
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    //初始化为日
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
       
        NSArray *arr = [KG_GaoJingModel mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
        [self.dataArray addObjectsFromArray:arr] ;
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];
}

- (void)queryRefreshData {
    //如果是关闭
    if (self.isOpenSwh == NO) {
        if (self.currIndex == 0) {
            NSLog(@"1");
            [self queryAllGaoJingData];
        }else if (self.currIndex == 1){
            self.isScreenStatus = NO; //未确认不带筛选条件
            [self queryUnConfirmData];//未确认
        }else if (self.currIndex == 2){
            self.isScreenStatus = NO; //未确认不带筛选条件
            NSLog(@"3");
            [self queryHaveConfirmData];
        }
    }else {
        if (self.currIndex == 0) {
            NSLog(@"1");
            [self queryOpenSwhAllGaoJingData];
        }else if (self.currIndex == 1){
            NSLog(@"2");
            self.isScreenStatus = NO;
            [self queryOpenSwhUnConfirmData];
        }else if (self.currIndex == 2){
            NSLog(@"3");
            self.isScreenStatus = NO;
            [self queryOpenSwhHaveConfirmData];
        }
    }
}

//- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos){// delete action
//    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"" handler:^(UIContextualAction * _Nonnull action,__kindof UIView * _Nonnull sourceView,void (^ _Nonnull completionHandler)(BOOL)) {
//        [tableView setEditing:NO animated:YES];// 这句很重要，退出编辑模式，隐藏左滑菜单
//
//    }];
//
//
//
//
//
//    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
//    actions.performsFirstActionWithFullSwipe = NO;
//    return actions;
//}

@end
