//
//  KG_HistoryTaskViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/11.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_InspectionRecordsViewController.h"
#import "KG_HistoryTaskCell.h"
#import "SegmentTapView.h"
#import "RS_ConditionSearchView.h"
#import "KG_NiControlSearchViewController.h"
#import "KG_XunShiReportDetailViewController.h"
#import "KG_InspectionRecordCell.h"
#import "KG_HistoryScreenViewController.h"
#import "KG_AssignView.h"
#import "KG_AddressbookViewController.h"
#import "KG_OnsiteInspectionView.h"
@interface KG_InspectionRecordsViewController ()<SegmentTapViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SegmentTapView *segment;
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic ,assign) int pageNum;
@property (nonatomic ,assign) int pageSize;

@property (nonatomic ,strong) NSMutableArray *paraArr;

@property (nonatomic ,assign) int currIndex;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIButton                *rightButton;

@property (nonatomic, strong)  KG_AssignView            *alertPersonView;

@property (nonatomic, copy)     NSString                *taskStr;
@property (nonatomic, copy)     NSString                *roomStr;
@property (nonatomic, copy)     NSString                *taskStatusStr;
@property (nonatomic, copy)     NSString                *startTime;
@property (nonatomic, copy)     NSString                *endTime;
@property (nonatomic, strong)   NSArray                 *roomArray;

@property (nonatomic, copy)     NSString                *searchString;

@property (nonatomic ,assign)   BOOL                    isScreenStatus;


@property (nonatomic ,strong)   NSDictionary            *alertInfo;
@property (nonatomic, strong)   KG_OnsiteInspectionView *alertView;
@end

@implementation KG_InspectionRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 1;
    self.pageSize = 10;
    self.currIndex = 0;
    self.isScreenStatus = NO;//刚开始不是筛选状态
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshZhiWeiData) name:@"refreshZhiWeiData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAddressBook) name:@"pushToAddressBook" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressBookSelPerson:) name:@"addressBookSelPerson" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshYunxingData) name:@"refreshYunxingData" object:nil];
       
    
    //初始化为日
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    [self createNaviTopView];
    [self createSegmentView];
    [self loadData];
}
- (void)createSegmentView{
    NSArray *array = @[@"全部",@"常规巡视",@"例行维护",@"特殊保障"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT +8, SCREEN_WIDTH, 44) withDataArray:array withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
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
    
   
  
}

- (void)refreshYunxingData {
    
    if (self.currIndex == 0) {
        NSLog(@"1");
        [self loadData];
    }else if (self.currIndex == 1){
        NSLog(@"2");
        [self getXunShiHistoryData];
    }else if (self.currIndex == 2){
        NSLog(@"3");
        [self getWeiHuHistoryData];
    }else if (self.currIndex == 3){
        NSLog(@"4");
        [self getBaoZhangHistoryData];
    }
      
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    [self.navigationController setNavigationBarHidden:YES];
    
}
- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [self createImageWithColor:[UIColor whiteColor]];
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
    self.titleLabel.text = @"巡视维护记录";
    
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
    leftImage.image = IMAGE(@"back_black");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    
    self.rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.rightButton.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
    [self.rightButton setImage:[UIImage imageNamed:@"history_screen_image"] forState:UIControlStateNormal];
    //    [self.rightButton addTarget:self action:@selector(yiduAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.userInteractionEnabled = YES;
    [self.navigationView addSubview:self.rightButton];
    [self.rightButton addTarget:self action:@selector(screenMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.navigationView.mas_right).offset(-20);
    }];
    
    
    
}

- (void)pushToAddressBook {
    
    [UserManager shareUserManager].isSelContact = YES;
    self.alertPersonView.hidden = YES;
    
    KG_AddressbookViewController *vc = [[KG_AddressbookViewController alloc]init];
    vc.sureBlockMethod = ^(NSString * _Nonnull nameID, NSString * _Nonnull nameStr) {
        self.alertPersonView.hidden = NO;
        self.alertPersonView.name = nameStr;
        self.alertPersonView.nameID = nameID;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addressBookSelPerson:(NSNotification *)notification {
    NSDictionary *dataDic = notification.userInfo;
    if (dataDic.count) {
        self.alertPersonView.hidden = NO;
        self.alertPersonView.name = safeString(dataDic[@"nameStr"]);
        self.alertPersonView.nameID = safeString(dataDic[@"nameID"]);
    }
}

//刷新智维页面数据
- (void)refreshZhiWeiData {
    
    [self refreshData];
}

- (void)backButtonClick:(UIButton *)button {
    [_alertPersonView removeFromSuperview];
    _alertPersonView = nil;
    [self.navigationController popViewControllerAnimated:YES];
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

//搜索方法
- (void)serachMethod {
    KG_NiControlSearchViewController *vc = [[KG_NiControlSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectedIndex:(NSInteger)index{
    NSLog(@"测试");
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [self.dataArray removeAllObjects];
    self.pageNum = 1;
    self.currIndex = (int)index;
    
    if (index == 1 || index == 2 || index == 3) {
        self.isScreenStatus = NO;
        self.roomStr = nil;
        self.taskStr = nil;
        self.taskStatusStr = nil;
        self.startTime = nil;
        self.endTime = nil;
        [self.rightButton setImage:[UIImage imageNamed:@"screen_icon"] forState:UIControlStateNormal];
    }
    if (index == 0) {
        NSLog(@"1");
        [self loadData];
    }else if (index == 1){
        NSLog(@"2");
        self.isScreenStatus = NO;
        [self getXunShiHistoryData];
    }else if (index == 2){
        NSLog(@"3");
        self.isScreenStatus = NO;
        [self getWeiHuHistoryData];
    }else if (index == 3){
        NSLog(@"4");
        self.isScreenStatus = NO;
        [self getBaoZhangHistoryData];
    }
  
}




- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        _tableView.tableHeaderView = headView;
        headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        // 上拉加载
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableView;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    if (dataDic.count) {
        
        NSArray *biaoqianArr = dataDic[@"atcSpecialTagList"];
        if (biaoqianArr.count ) {
            return 128;
        }
    }
    return  108;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_InspectionRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_InspectionRecordCell"];
    if (cell == nil) {
        cell = [[KG_InspectionRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_InspectionRecordCell"];
        
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    
    cell.dataDic = dataDic;
    cell.currIndex = self.currIndex;
    cell.taskMethod = ^(NSDictionary * _Nonnull dic) {
        BOOL islingDao = NO;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"role"]){
            NSArray *arr = [userDefaults objectForKey:@"role"];
            if (arr.count) {
                for (NSString *str in arr) {
                    if ([safeString(str) isEqualToString:@"领导"]) {
                        islingDao = YES;
                        break;
                    }
                }
            }
        }
        if (islingDao) {
            [self showSelContactAlertView:dic];
        }else {
            [self getTask:dic];
        }
    };
    return cell;
}
//指派任务
- (void)showSelContactAlertView:(NSDictionary *)dic {
    
    NSDictionary *dDic = dic;
    
    self.alertPersonView = [[KG_AssignView alloc]init];
    [JSHmainWindow addSubview:self.alertPersonView];
    self.alertPersonView.dataDic = dDic;
    self.alertPersonView.confirmBlockMethod = ^(NSDictionary * _Nonnull dataDic, NSString * _Nonnull name, NSString * _Nonnull nameID) {
        
        [self assignData:dataDic name:name withNameID:nameID];
        
    };
    [self.alertPersonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
        make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
        make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
    }];
}

//任务移交接口：
//请求地址：/intelligent/atcSafeguard/updateAtcPatrolRecode
//请求方式：POST
//请求Body：
//{
//    "id": "XXX",                 //任务Id，必填
//    "patrolName": "XXX"         //任务执行负责人Id，必填
////任务移交时修改这个字段为新的任务执行负责人Id即可
//}
- (void)assignData:(NSDictionary *)dataDic name:(NSString *)name withNameID:(NSString *)nameID{
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/updateAtcPatrolRecode"]];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"id"] = safeString(dataDic[@"id"]);
    paramDic[@"patrolName"] = safeString(nameID);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        
        NSLog(@"请求成功");
        
        [FrameBaseRequest showMessage:@"指派成功"];
        [_alertPersonView removeFromSuperview];
        _alertPersonView = nil;
        [self.dataArray removeAllObjects];
        self.pageNum = 1;
        
        if (self.currIndex == 0) {
            NSLog(@"1");
            [self loadData];
        }else if (self.currIndex == 1){
            NSLog(@"2");
            [self getXunShiHistoryData];
        }else if (self.currIndex == 2){
            NSLog(@"3");
            [self getWeiHuHistoryData];
        }else if (self.currIndex == 3){
            NSLog(@"4");
            [self getBaoZhangHistoryData];
        }
        
        
    }  failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"请求失败 原因：%@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
}


- (void)getTask:(NSDictionary *)dataDic {
    NSString *userID = [UserManager shareUserManager].userID ;
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcSafeguard/updateAtcPatrolRecode",WebNewHost];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
     paramDic[@"id"] = safeString(dataDic[@"id"]);
        paramDic[@"patrolName"] = safeString(userID);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];  [FrameBaseRequest showMessage:@"领取失败"];
            return ;
        }
       [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshZhiWeiData" object:self];
       [FrameBaseRequest showMessage:@"领取成功"];
        
        
        [self.dataArray removeAllObjects];
        self.pageNum = 1;
      
        if (self.currIndex == 0) {
            NSLog(@"1");
            [self loadData];
        }else if (self.currIndex == 1){
            NSLog(@"2");
            [self getXunShiHistoryData];
        }else if (self.currIndex == 2){
            NSLog(@"3");
            [self getWeiHuHistoryData];
        }else if (self.currIndex == 3){
            NSLog(@"4");
            [self getBaoZhangHistoryData];
        }
         
        
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [FrameBaseRequest showMessage:@"领取失败"];
       [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    
    self.alertInfo = dataDic;
    if ([safeString(dataDic[@"status"]) isEqualToString:@"5"]) {
        
        if ([CommonExtension isLingDao]) {
            [FrameBaseRequest showMessage:@"请先指派任务"];
            return;
        }
        [FrameBaseRequest showMessage:@"请先领取任务"];
        return;
    }
    
    if ([safeString(self.alertInfo[@"patrolCode"]) isEqualToString:@"fieldInspection"]) {
        //            normalInspection一键巡视
        _alertView = nil;
        [_alertView removeFromSuperview];
        self.alertView.hidden = NO;
        return;
    }else {
        KG_XunShiReportDetailViewController *vc = [[KG_XunShiReportDetailViewController alloc]init];
        vc.dataDic = dataDic;
        [self.navigationController pushViewController:vc animated:YES];
        //    NSString *str = self.dataArray[indexPath.row];
    }
}


- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


- (void)loadMoreData {
    
    
    
    
    self.pageNum ++;
    
    if (self.isScreenStatus && self.currIndex == 0) {
        [self loadScreenMoreHistoryData];
        return;
    }
    
    
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    //全部
    if (self.currIndex == 0) {
        [self loadAllMoreData];
    }else if (self.currIndex == 1) {
        //巡视
        [self loadXunShiMoreData];
    }else if (self.currIndex == 2) {
        //维护
        [self loadWeiHuMoreData];
    }else if (self.currIndex == 3) {
        //保障
        [self loadBaoZhangMoreData];
    }
    
    
}
//获取某个台站下的历史任务接口（全部）：
//请求地址：/intelligent/atcPatrolRecode/app/all/{pageNum}/{pageSize}
//          其中，pageNum是页码，pageSize是每页的最大条数
//请求方式：POST
//请求Body：
//[{
//"name": "stationCode",
//       "type": "eq",
//       "content": "XXX"       //台站编码，如：HCDHT
// }]
//请求返回：
- (void)loadData {
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcPatrolRecode/app/all/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
        [self.tableView reloadData];
        if(self.dataArray.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

- (NSMutableArray *)paraArr {
    if (!_paraArr) {
        _paraArr = [[NSMutableArray alloc] init];
    }
    
    return _paraArr;
}
//获取选择台站下的常规巡视历史任务列表接口：
//请求地址：/intelligent/atcPatrolRecode/app/oneTouchTour/{pageNum}/{pageSize}
//          其中，pageNum是页码，pageSize是每页的最大条数
//请求方式：POST
//请求Body：
//[{
//"name": "stationCode",
//       "type": "eq",
//       "content": "XXX"       //台站编码，如：HCDHT
// }]
//一键巡视
- (void)getXunShiHistoryData {
    
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcPatrolRecode/app/oneTouchTour/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        [MBProgressHUD hideHUD];
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
         
        [self.tableView reloadData];
        if(self.dataArray.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
//例行维护
- (void)getWeiHuHistoryData {
    
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcPatrolRecode/app/routineMaintenance/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
       
        [self.tableView reloadData];
        if(self.dataArray.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
//特殊保障
- (void)getBaoZhangHistoryData {
    
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcPatrolRecode/app/specialSecurity/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
        [self.tableView reloadData];
        if(self.dataArray.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
//全部更多
- (void)loadAllMoreData{
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcPatrolRecode/app/all/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
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
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
//巡视
- (void)loadXunShiMoreData{
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcPatrolRecode/app/oneTouchTour/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
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
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
//维护
- (void)loadWeiHuMoreData{
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcPatrolRecode/app/routineMaintenance/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
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
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
//保障
- (void)loadBaoZhangMoreData{
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcPatrolRecode/app/specialSecurity/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
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
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}


- (void)refreshData {
    
    self.pageNum = 1;
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcPatrolRecode/app/all/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
        [self.tableView reloadData];
        if(self.dataArray.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

//筛选
- (void)screenMethod:(UIButton *)button {
    
    KG_HistoryScreenViewController *vc = [[KG_HistoryScreenViewController alloc]init];
    
    if(self.roomStr.length >0) {
        vc.roomStr = self.roomStr;
    }
    if(self.taskStr.length >0) {
        vc.taskStr = self.taskStr;
    }
    if(self.taskStatusStr.length >0) {
        vc.taskStatusStr = self.taskStatusStr;
    }
    if(self.startTime.length >0) {
        vc.startTime = self.startTime;
    }
    if(self.endTime.length >0) {
        vc.endTime = self.endTime;
    }
    
    vc.confirmBlockMethod = ^(NSString * _Nonnull taskStr, NSString * _Nonnull roomStr, NSString * _Nonnull taskStausStr, NSString * _Nonnull startTimeStr, NSString * _Nonnull endTimeStr, NSArray * _Nonnull roomArray) {
        
        self.roomStr = roomStr;
        self.taskStr = taskStr;
        self.taskStatusStr = taskStausStr;
        
        self.startTime = startTimeStr;
        self.endTime = endTimeStr;
        self.roomArray = roomArray;
        
        if(roomStr.length == 0 && taskStr.length == 0 && taskStausStr.length == 0
           && startTimeStr.length == 0 && endTimeStr.length == 0) {
            self.isScreenStatus = NO;
            [self.rightButton setImage:[UIImage imageNamed:@"screen_icon"] forState:UIControlStateNormal];
            return ;
        }
      
       [self.rightButton setImage:[UIImage imageNamed:@"screen_blueImage"] forState:UIControlStateNormal];
      
        
        self.isScreenStatus = YES;
        
        [self screenHistoryData];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)loadScreenMoreHistoryData {
    
    NSDictionary *currentDic = [UserManager shareUserManager].currentStationDic;
    if (currentDic.count == 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"station"]){
            currentDic = [userDefaults objectForKey:@"station"];
        }else {
            NSArray *stationArr = [UserManager shareUserManager].stationList;
            
            if (stationArr.count >0) {
                currentDic = [stationArr firstObject][@"station"];
            }
        }
    }
    NSString *engineCode = @"";
    for (NSDictionary *roomDic in self.roomArray) {
        if ([self.roomStr isEqualToString:safeString(roomDic[@"alias"])]) {
            engineCode = safeString(roomDic[@"code"]);
            break;
        }
    }
   
    
    //    常规巡视取oneTouchTour；
    //    例行维护取routineMaintenance；
    //    特殊保障取specialSecurity；
    //    全部取all
    NSString *type = @"all";
    if ([self.taskStr isEqualToString:@"一键巡视"]) {
        type = @"oneTouchTour";
    }else if ([self.taskStr isEqualToString:@"维护任务"]) {
        type = @"routineMaintenance";
    }else if ([self.taskStr isEqualToString:@"特殊保障"]) {
        type = @"specialSecurity";
    }else {
        type = @"all";
    }
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/appSearch/%@/%d/%d",safeString(type),self.pageNum,self.pageSize]];
    NSMutableArray *paramArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = @"stationCode";
    params[@"type"] = @"eq";
    params[@"content"] = safeString(currentDic[@"code"]);
    
    //机房编码
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    params1[@"name"] = @"engineRoomCode";
    params1[@"type"] = @"eq";
    params1[@"content"] = safeString(engineCode);
    //开始时间，如："2020-04-01"
    NSMutableDictionary *params2 = [NSMutableDictionary dictionary];
    params2[@"name"] = @"startTime";
    params2[@"type"] = @"eq";
    params2[@"content"] = safeString(self.startTime);
    //结束时间，如："2020-04-13"
    NSMutableDictionary *params3 = [NSMutableDictionary dictionary];
    params3[@"name"] = @"endTime";
    params3[@"type"] = @"eq";
    params3[@"content"] = safeString(self.endTime);
    //任务状态编码，取值0~5
    
    NSString *statusCode = @"0";
    statusCode = [self getTaskStatus:self.taskStatusStr];
    
    [paramArr addObject:params];
    [paramArr addObject:params1];
    [paramArr addObject:params2];
    [paramArr addObject:params3];
    if(statusCode.length) {
        NSMutableDictionary *params4 = [NSMutableDictionary dictionary];
        params4[@"name"] = @"status";
        params4[@"type"] = @"eq";
        params4[@"content"] = safeString(statusCode);
        [paramArr addObject:params4];
    }
    
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramArr success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
      
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
       
        NSMutableString *parStr = [NSMutableString string];
        if (self.taskStr.length >0) {
            [parStr appendString:safeString(self.taskStr)];
        }
        
        NSString *engineCode = @"";
        for (NSDictionary *roomDic in self.roomArray) {
            if ([self.roomStr isEqualToString:safeString(roomDic[@"alias"])]) {
                engineCode = safeString(roomDic[@"code"]);
                break;
            }
        }
        
        if (self.roomStr.length >0) {
            [parStr appendString:safeString(self.roomStr)];
        }
        
        NSString *statusCode = @"0";
        statusCode = [self getTaskStatus:self.taskStatusStr];
        
        if (statusCode.length >0) {
            [parStr appendString:safeString(statusCode)];
        }
        
        if(safeString(self.startTime).length >0 && safeString(self.endTime).length >0) {
            [parStr appendString:safeString(self.startTime)];
            [parStr appendString:safeString(self.endTime)];
            
        }
        //        self.screenResultLabel.text = [NSString stringWithFormat:@"%@",safeString(parStr)];
        
        [self.tableView reloadData];
       
        NSLog(@"请求成功");
        
    }  failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"请求失败 原因：%@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
}

//筛选页面数据
- (void)screenHistoryData {
    
    [self.segment selectIndex:0];
    NSDictionary *currentDic = [UserManager shareUserManager].currentStationDic;
    if (currentDic.count == 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"station"]){
            currentDic = [userDefaults objectForKey:@"station"];
        }else {
            NSArray *stationArr = [UserManager shareUserManager].stationList;
            
            if (stationArr.count >0) {
                currentDic = [stationArr firstObject][@"station"];
            }
        }
    }
    NSString *engineCode = @"";
    for (NSDictionary *roomDic in self.roomArray) {
        if ([self.roomStr isEqualToString:safeString(roomDic[@"alias"])]) {
            engineCode = safeString(roomDic[@"code"]);
            break;
        }
    }
    self.pageNum = 1;
    
    //    常规巡视取oneTouchTour；
    //    例行维护取routineMaintenance；
    //    特殊保障取specialSecurity；
    //    全部取all
    NSString *type = @"all";
    if ([self.taskStr isEqualToString:@"一键巡视"]) {
        type = @"oneTouchTour";
    }else if ([self.taskStr isEqualToString:@"维护任务"]) {
        type = @"routineMaintenance";
    }else if ([self.taskStr isEqualToString:@"特殊保障"]) {
        type = @"specialSecurity";
    }else {
        type = @"all";
    }
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/appSearch/%@/%d/%d",safeString(type),self.pageNum,self.pageSize]];
    NSMutableArray *paramArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = @"stationCode";
    params[@"type"] = @"eq";
    params[@"content"] = safeString(currentDic[@"code"]);
    
    //机房编码
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    params1[@"name"] = @"engineRoomCode";
    params1[@"type"] = @"eq";
    params1[@"content"] = safeString(engineCode);
    //开始时间，如："2020-04-01"
    NSMutableDictionary *params2 = [NSMutableDictionary dictionary];
    params2[@"name"] = @"startTime";
    params2[@"type"] = @"eq";
    params2[@"content"] = safeString(self.startTime);
    //结束时间，如："2020-04-13"
    NSMutableDictionary *params3 = [NSMutableDictionary dictionary];
    params3[@"name"] = @"endTime";
    params3[@"type"] = @"eq";
    params3[@"content"] = safeString(self.endTime);
    //任务状态编码，取值0~5
    
    NSString *statusCode = @"0";
    statusCode = [self getTaskStatus:self.taskStatusStr];
    
    [paramArr addObject:params];
    [paramArr addObject:params1];
    [paramArr addObject:params2];
    [paramArr addObject:params3];
    if(statusCode.length) {
        NSMutableDictionary *params4 = [NSMutableDictionary dictionary];
        params4[@"name"] = @"status";
        params4[@"type"] = @"eq";
        params4[@"content"] = safeString(statusCode);
        [paramArr addObject:params4];
    }
    
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramArr success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
//        self.tableView.tableHeaderView = self.screenResultView;
        
        
        
        NSMutableString *parStr = [NSMutableString string];
        if (self.taskStr.length >0) {
            [parStr appendString:safeString(self.taskStr)];
        }
        
        NSString *engineCode = @"";
        for (NSDictionary *roomDic in self.roomArray) {
            if ([self.roomStr isEqualToString:safeString(roomDic[@"alias"])]) {
                engineCode = safeString(roomDic[@"code"]);
                break;
            }
        }
        
        if (self.roomStr.length >0) {
            [parStr appendString:safeString(self.roomStr)];
        }
        
        NSString *statusCode = @"0";
        statusCode = [self getTaskStatus:self.taskStatusStr];
        
        if (statusCode.length >0) {
            [parStr appendString:safeString(statusCode)];
        }
        
        if(safeString(self.startTime).length >0 && safeString(self.endTime).length >0) {
            [parStr appendString:safeString(self.startTime)];
            [parStr appendString:safeString(self.endTime)];
            
        }
//        self.screenResultLabel.text = [NSString stringWithFormat:@"%@",safeString(parStr)];
        
       
        
        [self.tableView reloadData];
        if(self.dataArray.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        NSLog(@"请求成功");
        
    }  failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"请求失败 原因：%@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
}


- (NSString *)getTaskStatus :(NSString *)status {
    NSString *ss = @"";
    if ([status isEqualToString:@"待执行"]) {
        ss = @"0";
    }else if ([status isEqualToString:@"进行中"]) {
        ss = @"1";
    }else if ([status isEqualToString:@"已完成"]) {
        ss = @"2";
    }else if ([status isEqualToString:@"逾期未完成"]) {
        ss = @"3";
    }else if ([status isEqualToString:@"逾期完成"]) {
        ss = @"4";
    }else if ([status isEqualToString:@"待领取"]) {
        ss = @"5";
      
    }else if ([status isEqualToString:@"待领取/指派"]) {
        ss = @"5";
    }
    return ss;
    
}

- (KG_OnsiteInspectionView *)alertView {
    
    if (!_alertView) {
        _alertView = [[KG_OnsiteInspectionView alloc]initWithCondition:self.alertInfo];
        [JSHmainWindow addSubview:_alertView];
        [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];
        
    }
    return _alertView;
    
}
@end
