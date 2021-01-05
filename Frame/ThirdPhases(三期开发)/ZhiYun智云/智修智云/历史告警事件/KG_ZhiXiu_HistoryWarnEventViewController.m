//
//  KG_ZhiXiuViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/14.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ZhiXiu_HistoryWarnEventViewController.h"
#import "KG_HistoryTaskCell.h"
#import "KG_ZhiXiuModel.h"
#import "UIViewController+CBPopup.h"
#import "KG_GaoJingModel.h"
#import "KG_GaoJingDetailViewController.h"
#import "UIViewController+YQSlideMenu.h"
#import "LoginViewController.h"
#import <UIButton+WebCache.h>
#import "KG_ControlGaoJingAlertView.h"
#import "KG_HistoryWarnEventScreenViewController.h"
#import "KG_HistoryWarnEventCell.h"
#import "KG_HistoryWarnEventViewController.h"
#import "KG_GaoJingDetailViewController.h"
#import "KG_GaoJingModel.h"
#import "KG_NoDataPromptView.h"

@interface KG_ZhiXiu_HistoryWarnEventViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray     *dataArray;

@property (nonatomic, strong) UITableView        *tableView;

@property (nonatomic ,assign) int                pageNum;
@property (nonatomic ,assign) int                pageSize;
@property (nonatomic ,assign) int                currIndex;

@property (nonatomic, strong) UILabel            *titleLabel;
@property (nonatomic, strong) UIView             *navigationView;

@property (nonatomic ,strong) NSMutableArray     *paraArr;

@property(strong,nonatomic)   NSArray            *stationArray;
@property(strong,nonatomic)   UITableView        *stationTabView;

@property (nonatomic, strong) UIButton           *leftIconImage;

@property (nonatomic, copy)   NSString             *removeStartTime;
@property (nonatomic, copy)   NSString             *removeEndTime;

@property (nonatomic, copy)   NSString             *roomStr;
@property (nonatomic, copy)   NSString             *equipTypeStr;
@property (nonatomic, copy)   NSString             *kongguanTypeStr;
@property (nonatomic, copy)   NSString             *alarmLevelStr;
@property (nonatomic, copy)   NSString             *alarmStatusStr;
@property (nonatomic, copy)   NSString             *startTime;
@property (nonatomic, copy)   NSString             *endTime;

@property(strong,nonatomic)   NSArray              *roomArray;
@property(strong,nonatomic)   NSArray              *kongArray;


@property(strong,nonatomic)   KG_NoDataPromptView  *nodataView;

@end

@implementation KG_ZhiXiu_HistoryWarnEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view
    
    [self createNaviTopView];
    
    self.pageNum = 1;
    self.pageSize = 10;
    self.currIndex = 0;
    [self createTopView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(105);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self queryData];
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

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    //     [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)createTopView {
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    topView.layer.cornerRadius = 10.f;
    topView.layer.masksToBounds = YES;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT);
        make.height.equalTo(@120);
    }];
    
    UIImageView *speakIcon = [[UIImageView alloc]init];
    [topView addSubview:speakIcon];
    speakIcon.image = [UIImage imageNamed:@"speaker_icon"];
    [speakIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(16);
        make.width.equalTo(@22);
        make.height.equalTo(@18);
        make.top.equalTo(topView.mas_top).offset(20);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [topView addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.font = [UIFont my_font:12];
    titleLabel.text = @"这里仅展示与该告警事件有关的历史告警事件，您可以切换到该台站或者所有台站查看更多信息。";
    titleLabel.numberOfLines = 2;
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(speakIcon.mas_centerY);
        make.left.equalTo(speakIcon.mas_right).offset(8);
        make.right.equalTo(topView.mas_right).offset(-15);
        
    }];
    
    UIButton *botBtn = [[UIButton alloc]init];
    [topView addSubview:botBtn];
    [botBtn setBackgroundColor:[UIColor colorWithRed:50.f/255.f green:97.f/255.f blue:206.f/255.f alpha:1]];
    [botBtn setTitle:@"本台站" forState:UIControlStateNormal];
    botBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [botBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [botBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-20);
        make.top.equalTo(topView.mas_top).offset(56);
        make.height.equalTo(@28);
        make.width.equalTo(@80);
    }];
    [botBtn addTarget:self action:@selector(botMethod:) forControlEvents:UIControlEventTouchUpInside];
    botBtn.layer.cornerRadius = 4.f;
    botBtn.layer.masksToBounds = YES;
    
    
}
- (void)botMethod:(UIButton *)btn {
    
    KG_HistoryWarnEventViewController *vc = [[KG_HistoryWarnEventViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
    self.titleLabel.text = @"历史告警事件";
    
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
    
    
    UIButton *histroyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    histroyBtn.titleLabel.font = FontSize(12);
    
    
    [histroyBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [histroyBtn setImage:[UIImage imageNamed:@"screen_icon"] forState:UIControlStateNormal];
    histroyBtn.frame = CGRectMake(0,0,81,22);
    [self.view addSubview:histroyBtn];
    [histroyBtn addTarget:self action:@selector(screenAction) forControlEvents:UIControlEventTouchUpInside];
    [histroyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@24);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.height.equalTo(@24);
        make.right.equalTo(self.view.mas_right).offset(-16);
    }];
    
    
    
}



- (void)screenAction{
    
    KG_HistoryWarnEventScreenViewController *vc = [[KG_HistoryWarnEventScreenViewController alloc]init];
    vc.roomStr = self.roomStr;
    vc.alarmLevelStr = self.alarmLevelStr;
    vc.alarmStatusStr = self.alarmStatusStr;
    vc.startTime = self.startTime;
    vc.endTime = self.endTime;
    vc.equipTypeStr = self.equipTypeStr;
    vc.kongguanTypeStr = self.kongguanTypeStr;
    vc.confirmBlockMethod = ^(NSString * _Nonnull roomStr, NSString * _Nonnull equipTypeStr, NSString * _Nonnull kongguanTypeStr, NSString * _Nonnull alarmLevelStr, NSString * _Nonnull alarmStausStr, NSString * _Nonnull startTimeStr, NSString * _Nonnull endTimeStr, NSArray * _Nonnull roomArray, NSArray * _Nonnull kongArray) {
        
    
        
        
        self.roomStr = roomStr;
        self.equipTypeStr =equipTypeStr;
        self.kongguanTypeStr = kongguanTypeStr;
        self.alarmLevelStr = alarmLevelStr;
        self.alarmStatusStr = alarmStausStr;
        self.startTime = startTimeStr;
        self.endTime = endTimeStr;
        self.roomArray = roomArray;
        self.kongArray = kongArray;
        //筛选数据
        [self screenMethodData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)backButtonClick:(UIButton *)button {
    
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
    
    KG_HistoryWarnEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_HistoryWarnEventCell"];
    if (cell == nil) {
        cell = [[KG_HistoryWarnEventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_HistoryWarnEventCell"];
        
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataArray[indexPath.section];
    
    KG_GaoJingModel *model = [[KG_GaoJingModel alloc]init];
    [model mj_setKeyValues:dic];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDic = self.dataArray[indexPath.section];
    KG_GaoJingDetailViewController *vc = [[KG_GaoJingDetailViewController alloc]init];
    vc.refreshData = ^{
        [self queryData];
    };
    KG_GaoJingModel *model = [[KG_GaoJingModel alloc]init];
    [model mj_setKeyValues:dataDic];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
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
//加载更多
- (void)loadMoreData {
    self.pageNum ++;
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/searchAlarmInfo/%d/%d",self.pageNum,self.pageSize]];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    //初始化为日
    [self.paraArr removeAllObjects];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        [weakSelf.tableView.mj_footer endRefreshing];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        
        NSLog(@"resultresult %@",result);
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]];
        [self.tableView reloadData];
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
        
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
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
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}

//
//历史告警事件：获取某个台站下的告警事件（我的台站-智云）
//请求地址：/intelligent/keepInRepair/searchAlarmInfo/{pageNum}/{pageSize}
//       其中，pageNum是页码，pageSize是每页的数据量
//请求方式：POST
//请求内容：
// [{
//     "name": "stationCode",
//     "type": "eq",
//     "content": "XXX"        //台站编码
//}]
//请求返回：
- (void)queryData {
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/searchAlarmInfo/%d/%d",self.pageNum,self.pageSize]];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    //初始化为日
    [self.paraArr removeAllObjects];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        [self.dataArray removeAllObjects];
        NSLog(@"resultresult %@",result);
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]];
        [self.tableView reloadData];
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
        
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
    
}
//历史告警事件：筛选历史告警事件（我的台站-智云）
//请求地址：/intelligent/keepInRepair/searchAlarmInfo/{pageNum}/{pageSize}
//       其中，pageNum是页码，pageSize是每页的数据量
//请求方式：POST
//请求内容：
// [{
//     "name": "stationCode",
//     "type": "eq",
//     "content": "XXX"        //台站编码
//},
//{
//     "name": "engineRoomCode",
//     "type": "eq",
//     "content": "XXX" //机房编码，从台站下机房列表接口获取code字段
//},
//{
//     "name": "alarmStatus",
//     "type": "eq",
//     "content": "XXX" //告警状态编码，从告警状态字典值接口获取code字段
//               //未确认: unconfirmed
//               //已确认: confirmed
//               //已解决: completed
//               //已解除: removed
//               //已挂起：hangUp，告警状态字典中没有，前台选择时传入
//},
//{
//     "name": "equipmentGroup",
//     "type": "eq",
//     "content": "XXX"//设备类型编码，从设备类型列表接口获取code字段
//},
//{
//     "name": "equipmentCategory",
//     "type": "eq",
//     "content": "XXX"//设备分类编码，从设备分类字典接口获取code字段
//},
//{
//     "name": "alarmLevel",
//     "type": "eq",
//     "content": "XXX"//告警等级编码，从告警等级字典值接口获取code字段
//},
//{
//     "name": "startTime",
//     "type": "eq",
//     "content": "XXX"  //开始时间，如：2020-03-01 00:00:00
//},
//{
//     "name": "endTime",
//     "type": "eq",
//     "content": "XXX"  //结束时间，如：2020-04-01 23:59:59
//}]
//
//其中，如上列表中的内容可以自由组合，如：
//[{
//     "name": "stationCode",
//     "type": "eq",
//     "content": "JDJCNCDHT"
//},
//{
//     "name": "equipmentGroup",
//     "type": "eq",
//     "content": "power"
//},
//{
//     "name": "startTime",
//     "type": "eq",
//     "content": "2020-08-15 11:30:00"
//},
//{
//     "name": "endTime",
//     "type": "eq",
//     "content": "2020-09-04 16:30:40"
//}]
//请求返回：

- (void)screenMethodData {
   
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
    NSMutableDictionary *paraDic7 = [NSMutableDictionary dictionary];
    paraDic7[@"name"] = @"equipmentCategory";
    paraDic7[@"type"] = @"eq";
    
    
    NSString *kongString = @"";
    for (NSDictionary *dataDic in self.kongArray) {
        if ([safeString(dataDic[@"name"]) isEqualToString:self.kongguanTypeStr]) {
            kongString = safeString(dataDic[@"code"]);
            break;
        }
    }
    paraDic7[@"content"] = safeString(kongString);
    if (kongString.length) {
        [self.paraArr addObject:paraDic7];
    }
    
    NSLog(@"1");
    [self queryScreenData];
}

- (void)queryScreenData {
    
//    历史告警事件：筛选历史告警事件（我的台站-智云）
//    请求地址：/intelligent/keepInRepair/searchAlarmInfo/{pageNum}/{pageSize}
//           其中，pageNum是页码，pageSize是每页的数据量
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/searchAlarmInfo/%d/%d",self.pageNum,self.pageSize]];

    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        [self.dataArray removeAllObjects];
        NSLog(@"resultresult %@",result);
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]];
        [self.tableView reloadData];
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
        
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
    
}

- (KG_NoDataPromptView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[KG_NoDataPromptView alloc]init];
        [self.view addSubview:_nodataView];
        [self.view bringSubviewToFront:_nodataView];
        _nodataView.noDataLabel.text = @"当前暂无数据";
        [_nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top).offset(NAVIGATIONBAR_HEIGHT + 102);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];
       
    }
    return _nodataView;
}
@end
