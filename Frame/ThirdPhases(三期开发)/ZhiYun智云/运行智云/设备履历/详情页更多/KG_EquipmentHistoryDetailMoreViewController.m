//
//  KG_TecInforViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipmentHistoryDetailMoreViewController.h"
#import "KG_EquipmentHistoryDetailFourthCell.h"
#import "KG_StandardSpecificationViewController.h"
#import "KG_EquipmentHistoryDetailModel.h"

#import "KG_FaultEventRecordViewController.h"
#import "KG_EquipmentAdjustmentRecordViewController.h"
#import "KG_WatchPdfViewController.h"
#import "KG_GaoJingDetailViewController.h"
#import "KG_GaoJingModel.h"

#import "KG_XunShiReportDetailViewController.h"
#import "KG_WeihuDailyReportDetailViewController.h"
#import "KG_XunShiReportDetailViewController.h"


#import "KG_StationFileEnvEventDetailController.h"
#import "KG_GaoJingDetailViewController.h"
#import "KG_GaoJingModel.h"

@interface KG_EquipmentHistoryDetailMoreViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic, strong) NSMutableArray            *dataArray;
@property (nonatomic, strong) NSArray                   *listArray;
@property (nonatomic, strong) UITableView               *tableView;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   KG_EquipmentHistoryDetailModel *dataModel;

@property (nonatomic, assign) int  pageNum;
@property (nonatomic,strong)    KG_GaoJingModel *model;
@end

@implementation KG_EquipmentHistoryDetailMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataModel = [[KG_EquipmentHistoryDetailModel alloc]init];
    self.model = [[KG_GaoJingModel alloc]init];
    self.pageNum =  1;
    [self createNaviTopView];
    [self initViewData];
    
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
    
    
}
- (void)initViewData {
    //    [self.dataArray self.listArray];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.listArr];
    self.dataArray = arr;
    [self createTableView];
}

- (void)createTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView reloadData];
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
    self.titleLabel.text = safeString(self.titleStr);
    
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

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
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
    
    
    
    
    if([self.titleStr isEqualToString:@"设备故障事件记录"]) {
        //设备故障事件记录
        [self queryEquipmentFailureEventRecordData];
    }else if([self.titleStr isEqualToString:@"设备告警记录"]) {
        //设备告警记录
        [self queryEquipmentAutomaticAlarmListData];
    }else if([self.titleStr isEqualToString:@"设备调整记录"]) {
        //设备调整记录
        [self queryEquipmentAdjustmentData];
    }else if([self.titleStr isEqualToString:@"技术资料"]) {
        //查询技术资料
        [self queryTechnicalInformationData];
    }else if([self.titleStr isEqualToString:@"巡视记录"]) {
        //查询巡视
        [self getDeviceXunshiData];
    }else if([self.titleStr isEqualToString:@"维护记录"]) {
        //查询维护
        [self getDeviceWeihuData];
    }else if([self.titleStr isEqualToString:@"特殊保障记录"]) {
        //查询特殊保障
        [self getDeviceSpecialData];
    }else if([self.titleStr isEqualToString:@"备件库存"]) {
        
    }else if([self.titleStr isEqualToString:@"台站关键环境事件记录"]) {
        //查询技术资料
        [self queryStationEnvEventListData];
    }else if([self.titleStr isEqualToString:@"台站告警记录"]) {
        [self queryStationAlarmListData];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_EquipmentHistoryDetailFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_TechInfoCell"];
    if (cell == nil) {
        cell = [[KG_EquipmentHistoryDetailFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipmentHistoryDetailFourthCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.dataDic = dataDic;
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    if([self.titleStr isEqualToString:@"设备故障事件记录"]) {
        KG_FaultEventRecordViewController *vc = [[KG_FaultEventRecordViewController alloc]init];
        vc.dataDic = dataDic;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.titleStr isEqualToString:@"设备告警记录"]) {
        //设备告警记录
       
        
        KG_GaoJingDetailViewController *vc = [[KG_GaoJingDetailViewController alloc]init];
        KG_GaoJingModel *model = [[KG_GaoJingModel alloc]init];
        [model mj_setKeyValues:dataDic];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }else if([self.titleStr isEqualToString:@"设备调整记录"]) {
        //设备调整记录
        KG_EquipmentAdjustmentRecordViewController *vc = [[KG_EquipmentAdjustmentRecordViewController alloc]init];
        vc.dataDic = dataDic;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.titleStr isEqualToString:@"技术资料"]) {
        //查询技术资料
        KG_WatchPdfViewController *vc = [[KG_WatchPdfViewController alloc]init];
        vc.dataDic = dataDic;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.titleStr isEqualToString:@"巡视记录"]) {
        //查询巡视
        KG_XunShiReportDetailViewController *vc = [[KG_XunShiReportDetailViewController alloc]init];
        vc.dataDic = dataDic;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.titleStr isEqualToString:@"维护记录"]) {
        //查询维护
        KG_WeihuDailyReportDetailViewController *vc = [[KG_WeihuDailyReportDetailViewController alloc]init];
        vc.dataDic = dataDic;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.titleStr isEqualToString:@"特殊保障记录"]) {
        //查询特殊保障
        KG_XunShiReportDetailViewController *vc = [[KG_XunShiReportDetailViewController alloc]init];
        vc.dataDic = dataDic;
        vc.themeTitleStr = @"特殊保障详情";
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.titleStr isEqualToString:@"备件库存"]) {
        
    }else if([self.titleStr isEqualToString:@"台站关键环境事件记录"]) {
        KG_StationFileEnvEventDetailController *vc = [[KG_StationFileEnvEventDetailController alloc]init];
        vc.dataDic = dataDic;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.titleStr isEqualToString:@"台站告警记录"]) {
        KG_GaoJingDetailViewController *vc = [[KG_GaoJingDetailViewController alloc]init];
        [self.model mj_setKeyValues:dataDic];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



//设备档案：设备告警记录，获取某个设备自动告警列表，按页返回：
//请求地址：
///intelligent/keepInRepair/equipmentAuto/{equipmentCode}/{pageNum}/{pageSize}
//     其中，equipmentCode是设备编码
//           pageNum是页码
//           pageSize是每页的数据量
//请求方式：GET
//请求返回：
- (void)queryEquipmentAutomaticAlarmListData{
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/equipmentAuto/%@/%d/%@",safeString(self.code),self.pageNum,safeString(@"20")]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            return ;
        }
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]];
        [self.tableView reloadData];
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
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
        //        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

//设备档案：设备故障事件记录，按页返回：
//请求地址：
///intelligent/keepInRepair/equipmentManual/{equipmentCode}/{pageNum}/{pageSize}
//     其中，equipmentCode是设备编码
//           pageNum是页码
//           pageSize是每页的数据量
//请求方式：GET
//请求返回：
//如：http://192.168.100.173:8089/intelligent/keepInRepair/equipmentManual/HCDVOR6540/1/5
//Equipment failure event record

- (void)queryEquipmentFailureEventRecordData{
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/equipmentManual/%@/%d/%@",safeString(self.code),self.pageNum,safeString(@"20")]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [self.tableView.mj_footer endRefreshing];
        if(code  <= -1){
            return ;
        }
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]];
        [self.tableView reloadData];
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
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
        //        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}


//设备档案：设备调整记录，获取某个设备变更管理列表，按页返回：
//请求地址：
///intelligent/atcChangeManagement/equipmentCloud/{equipmentCode}/{pageNum}/{pageSize}
//     其中，equipmentCode是设备编码
//           pageNum是页码
//           pageSize是每页的数据量
//请求方式：GET


- (void)queryEquipmentAdjustmentData{
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcChangeManagement/equipmentCloud/%@/%d/%@",safeString(self.code),self.pageNum,safeString(@"20")]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [self.tableView.mj_footer endRefreshing];
        if(code  <= -1){
            return ;
        }
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]];
        [self.tableView reloadData];
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
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
        //        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
//
//设备档案：按页获取设备相关的技术资料接口
//请求地址：/intelligent/atcTechnicalInfomation/equipment/{code}/{pageNum}/{pageSize}



- (void)queryTechnicalInformationData{
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcTechnicalInfomation/equipment/%@/%d/%@",safeString(self.code),self.pageNum,safeString(@"20")]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [self.tableView.mj_footer endRefreshing];
        if(code  <= -1){
            return ;
        }
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]];
        [self.tableView reloadData];
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
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
        //        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
//
//设备档案：获取设备相关的常规/维护/特殊保障接口，按页返回：
//请求地址：/intelligent/atcPatrolRecode/equipment/{pageNum}/{pageSize}
//请求Body：
//[{
//                 "name": "equipmentCode",
//                 "type": "eq",
//                 "content": "XXX"          //设备编码，必填
//            },
//{
//                 "name": "typeCode",
//                 "type": "eq",
//                 "content": "XXX"          //任务类型编码，必填
//                                   //常规巡视取oneTouchTour
//                                   //维护巡视取routineMaintenance
//                                   //特殊保障取specialSecurity
//            }]
- (void)getDeviceXunshiData{
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/equipment/%d/%@",self.pageNum,safeString(@"20")]];
    NSMutableArray *paramArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = @"equipmentCode";
    params[@"type"] = @"eq";
    params[@"content"] = safeString(self.code);
    
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    params1[@"name"] = @"typeCode";
    params1[@"type"] = @"eq";
    params1[@"content"] = safeString(@"oneTouchTour");
    
    [paramArr addObject:params];
    [paramArr addObject:params1];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [self.tableView.mj_footer endRefreshing];
        if(code != 0){
            
            return ;
        }
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]];
        [self.tableView reloadData];
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
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

//查询维护
- (void)getDeviceWeihuData{
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/equipment/%d/%@",self.pageNum,safeString(@"20")]];
    NSMutableArray *paramArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = @"equipmentCode";
    params[@"type"] = @"eq";
    params[@"content"] = safeString(self.code);
    
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    params1[@"name"] = @"typeCode";
    params1[@"type"] = @"eq";
    params1[@"content"] = safeString(@"routineMaintenance");
    
    [paramArr addObject:params];
    [paramArr addObject:params1];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [self.tableView.mj_footer endRefreshing];
        if(code != 0){
            
            return ;
        }
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]];
        [self.tableView reloadData];
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
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

//查询特殊保障
- (void)getDeviceSpecialData{
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/equipment/%d/%@",self.pageNum,safeString(@"20")]];
    NSMutableArray *paramArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = @"equipmentCode";
    params[@"type"] = @"eq";
    params[@"content"] = safeString(self.code);
    
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    params1[@"name"] = @"typeCode";
    params1[@"type"] = @"eq";
    params1[@"content"] = safeString(@"specialSecurity");
    
    [paramArr addObject:params];
    [paramArr addObject:params1];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [self.tableView.mj_footer endRefreshing];
        if(code != 0){
            
            return ;
        }
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]];
        [self.tableView reloadData];
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
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

//台站档案：关键环境事件记录，按页返回：
- (void)queryStationEnvEventListData{
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/stationManual/%@/%d/%@",safeString(self.code),self.pageNum,safeString(@"20")]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            return ;
        }
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]];
        [self.tableView reloadData];
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
               
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
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
        //        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}


- (void)queryStationAlarmListData{
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/stationAuto/%@/%d/%@",safeString(self.code),self.pageNum,safeString(@"20")]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            return ;
        }
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]];
        [self.tableView reloadData];
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
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
        //        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

@end
