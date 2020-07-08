//
//  KG_XunShiReportDetailViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/24.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiReportDetailViewController.h"
#import "KG_XunShiReportDetailModel.h"
#import "KG_XunShiReportDataModel.h"
#import "KG_XunShiReportDataModel.h"
#import "KG_XunShiTopView.h"
#import "KG_XunShiHandleView.h"
#import "KG_XunShiResultView.h"
#import "KG_XunShiRadarView.h"
#import "KG_XunShiReportDetailCell.h"
#import "KG_XunShiResultView.h"
#import "KG_XunShiResultCell.h"
#import "KG_XunShiDetailLogCell.h"
@interface KG_XunShiReportDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>



@property (nonatomic ,strong) NSArray *dataArray;
/**  标题栏 */
@property (nonatomic, strong)   UILabel      *titleLabel;
@property (nonatomic, strong)   UIView       *navigationView;
@property (strong, nonatomic)   UIImageView  *topImage1;
@property (strong, nonatomic)   KG_XunShiReportDetailModel *dataModel;
@property (strong, nonatomic)   KG_XunShiReportDataModel *listModel;
@property (strong, nonatomic)   KG_XunShiTopView *xunshiTopView;
@property (strong, nonatomic)   KG_XunShiHandleView *xunShiHandelView;

@property (strong, nonatomic)   taskDetail *radarModel;
@property (strong, nonatomic)   taskDetail *powerModel;
@property (strong, nonatomic)   taskDetail *upsModel;

@property (strong, nonatomic)   KG_XunShiRadarView *radarView;

@property (strong, nonatomic)   KG_XunShiRadarView *powerView;
@property (strong, nonatomic)   KG_XunShiRadarView *upsView;
@property (strong, nonatomic)   UIScrollView *scrollView;
@property (strong, nonatomic)   UITableView *tableView;

@property (strong, nonatomic)   KG_XunShiResultView *resultView;

@property (strong, nonatomic)   NSArray *receiveArr;

@property (strong, nonatomic)   NSArray *logArr;
@property (nonatomic, strong)   UIView       *tableHeadView;

@end

@implementation KG_XunShiReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataModel = [[KG_XunShiReportDetailModel alloc]init];
    self.listModel = [[KG_XunShiReportDataModel alloc]init];
    self.radarModel = [[taskDetail alloc]init];
    self.powerModel = [[taskDetail alloc]init];
    self.upsModel = [[taskDetail alloc]init];
    [self createNaviTopView];
    [self createDataView];
    [self queryReportDetailData];
    [self getTemplateData];
   
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)createDataView{
    self.tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 266)];
    [self.view addSubview:self.tableView];
    [self.tableHeadView addSubview:self.xunshiTopView];
    self.tableView.tableHeaderView = self.tableHeadView;
    
    self.xunshiTopView.layer.cornerRadius = 10;
    self.xunshiTopView.layer.masksToBounds = YES;
    self.xunshiTopView.shouqiMethod = ^{
        UIView *tableHeaderView =self.tableView.tableHeaderView;

        CGRect frame = tableHeaderView.frame;

        [tableHeaderView removeFromSuperview];

        self.tableView.tableHeaderView =nil;

        frame.size.height =128.0+54;// 新高度

        tableHeaderView.frame = frame;

        self.tableView.tableHeaderView = tableHeaderView;

        [self.xunshiTopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tableHeadView.mas_left);
            make.right.equalTo(self.tableHeadView.mas_right);
            make.top.equalTo(self.tableHeadView.mas_top);
            make.height.equalTo(@(128 +54));
        }];
    };
    
    self.xunshiTopView.zhankaiMethod = ^{
        UIView *tableHeaderView =self.tableView.tableHeaderView;
        
        CGRect frame = tableHeaderView.frame;
        
        [tableHeaderView removeFromSuperview];
        
        self.tableView.tableHeaderView =nil;
        
        frame.size.height =266.0;// 新高度
        
        tableHeaderView.frame = frame;
        
        self.tableView.tableHeaderView = tableHeaderView;
        
        [self.xunshiTopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tableHeadView.mas_left);
            make.right.equalTo(self.tableHeadView.mas_right);
            make.top.equalTo(self.tableHeadView.mas_top);
            make.height.equalTo(@(266));
        }];
    };
    
    
    
    [self.xunshiTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableHeadView.mas_left);
        make.right.equalTo(self.tableHeadView.mas_right);
        make.top.equalTo(self.tableHeadView.mas_top);
        make.height.equalTo(@256);
    }];
   
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataModel.task.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    return footView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.dataModel.task.count) {
        return 101;
    }else if (indexPath.section == self.dataModel.task.count + 1) {
        return 280;
    }
    
    NSInteger totalHeight = 0;
  
    taskDetail *model = self.dataModel.task[indexPath.section];
    
    NSInteger firstHeight = 44 ;
    //第一层 model.childrens 44
    //第二层 model.childrens firstobject  44
    NSArray *secondArr = model.childrens;
    NSInteger secondHeight = [secondArr count] *44;
    //第三层
    NSInteger thirdHeight = 0;
    NSInteger fourthHeight = 0;
   
    for (NSDictionary *dic in secondArr) {
        NSArray *thirdArr = dic[@"childrens"];
        thirdHeight += thirdArr.count *30;
        for (NSDictionary *detailArr in thirdArr) {
            NSArray *fourthArr = detailArr[@"childrens"];
            fourthHeight += fourthArr.count *30;
        }
    }
    totalHeight = firstHeight + secondHeight +thirdHeight +fourthHeight;
    NSLog(@"第一层高度：-----------%ld",(long)firstHeight);
    NSLog(@"第2层高度：-----------%ld",(long)secondHeight);
    NSLog(@"第3层高度：-----------%ld",(long)thirdHeight);
    NSLog(@"第4层高度：-----------%ld",(long)fourthHeight);
    return totalHeight;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section <self.dataModel.task.count ) {
        KG_XunShiReportDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiReportDetailCell"];
        if (cell == nil) {
            cell = [[KG_XunShiReportDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiReportDetailCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        taskDetail *model  = self.dataModel.task[indexPath.section];
        
        cell.model = model;
        
        return cell;
    }else if (indexPath.section == self.dataModel.task.count ) {
        KG_XunShiResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiResultCell"];
        if (cell == nil) {
            cell = [[KG_XunShiResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiResultCell"];
        }
        if (safeString(self.dataModel.taskDescription).length) {
            cell.taskDescription = self.dataModel.taskDescription;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.section == self.dataModel.task.count +1 ) {
        KG_XunShiDetailLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiDetailLogCell"];
        
        if (cell == nil) {
            cell = [[KG_XunShiDetailLogCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiDetailLogCell"];
        }
        if (self.receiveArr.count) {
            cell.receiveArr = self.receiveArr;
        }
        if (self.logArr.count) {
            cell.logArr = self.logArr;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
 


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
   

}


- (void)createNaviTopView {
    
    self.topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 224)];
    [self.view addSubview:self.topImage1];
    self.topImage1.contentMode = UIViewContentModeScaleAspectFill;
    self.topImage1.image  =[UIImage imageNamed:@"zhiwei_topBgImage"];
    
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
    self.titleLabel.text = @"巡视报告详情";
    
    /** 返回按钮 **/
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.navigationView.mas_left);
    }];
    
    /** 更多按钮 **/
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:[UIImage imageNamed:@"white_more"] forState:UIControlStateNormal];
    [self.navigationView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.right.equalTo(self.navigationView.mas_right).offset(-13);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = IMAGE(@"back_icon");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    
    
}

/** 标题栏 **/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)moreAction {
    if (_xunShiHandelView== nil) {
        [JSHmainWindow addSubview:self.xunShiHandelView];
        self.xunShiHandelView.didsel = ^(NSString * _Nonnull dataStr) {
            if ([dataStr isEqualToString:@"提交任务"]) {
                NSLog(@"提交任务");
            }else {
                NSLog(@"修改任务");
            }
        };
        [self.xunShiHandelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    
    if (self.xunShiHandelView.hidden) {
        self.xunShiHandelView.hidden = NO;
    }
    
    
}

- (void)queryReportDetailData {
    NSString *rId = self.dataDic[@"id"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/getTourInfoById/%@",rId]];
    
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [self.dataModel mj_setKeyValues:result[@"value"]];
        [self.listModel mj_setKeyValues:result[@"value"]];
    
        for (taskDetail *detailModel in self.dataModel.task) {
            if ([detailModel.engineRoomName isEqualToString:@"雷达机房"]) {
                self.radarModel = detailModel;
            }else if ([detailModel.engineRoomName isEqualToString:@"电池间"]) {
                self.powerModel = detailModel;
            }else if ([detailModel.engineRoomName isEqualToString:@"UPS机房"]) {
                self.upsModel = detailModel;
            }
        }
        
        [self getTaskFaBuTiJiaoData];
        [self getReceviceData];
        [self getLogData];
        [self refreshData];
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}

//
//获取某个台站某种任务类型下的模板列表：
//请求地址：/intelligent/atcSafeguard/templateList/{stationCode}/{typeCode}/{patrolCode}
//         其中，stationCode是台站编码，
//typeCode是任务大类型编码：
//一键巡视oneTouchTour
//                    例行维护routineMaintenance
//                    特殊保障分为特殊维护specialSafeguard和特殊巡视specialTour
//patrolCode是任务小类型编码，根据任务大类型从字典中获取。

//一键巡视
- (void)getTemplateData {
    NSString *rId = self.dataDic[@"stationCode"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/templateList/%@/%@/%@",rId,@"oneTouchTour",@"normalInspection"]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
       
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
      
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}
//获取任务的发布和提交详情接口：
//请求地址：/intelligent/atcSafeguard/getOperationInfo/{recodeId}
//     其中，recodeId是任务的id
//请求方式：GET
//请求返回：
//如：/intelligent/atcSafeguard/getOperationInfo/2b32230c3e084d70962c2e4440327776
//返回：
- (void)getTaskFaBuTiJiaoData {
    NSString *rId = self.dataDic[@"id"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/getOperationInfo/%@",rId]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
         self.xunshiTopView.dic = result[@"value"];
               
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
      
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}
- (KG_XunShiTopView *)xunshiTopView {
    if (!_xunshiTopView) {
        _xunshiTopView = [[KG_XunShiTopView alloc]init];
        
    }
    return _xunshiTopView;
}

- (void)refreshData {
    self.xunshiTopView.model = self.dataModel;
    self.xunshiTopView.dataDic =self.dataDic;
//    self.radarView.detailModel = self.radarModel;
//    self.powerView.detailModel = self.powerModel;
//    self.upsView.detailModel = self.upsModel;
    //44 +
//    NSInteger scrollHeight = 0;
//    NSInteger totalHeight = 0;
//
//    for(taskDetail *model in self.dataModel.task){
//
//        NSInteger firstHeight = model.childrens.count * 44 ;
//        //第一层 model.childrens 44
//        //第二层 model.childrens firstobject  44
//        NSArray *secondArr = [model.childrens firstObject][@"childrens"];
//        NSInteger secondHeight = [secondArr count] *44;
//        //第三层
//        NSInteger thirdHeight = 0;
//        NSInteger fourthHeight = 0;
//        for (NSDictionary *dic in secondArr) {
//            NSArray *thirdArr = dic[@"childrens"];
//            thirdHeight += thirdArr.count *30;
//            for (NSDictionary *detailArr in thirdArr) {
//                NSArray *fourthArr = detailArr[@"childrens"];
//                fourthHeight += fourthArr.count *30;
//            }
//        }
//        totalHeight = firstHeight + secondHeight +thirdHeight +fourthHeight;
//
//        scrollHeight += totalHeight;
//    }
   [self.tableView reloadData];
   
}

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}


//展开
- (void)zhankaiMethod:(UIButton *)button {
    
   
}




//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY年MM月dd日HH时mm分"] stringFromDate:date];
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
- (NSString *)getTaskImage:(NSString *)status {
    NSString *ss = @"yiwancheng_icon";
    if ([status isEqualToString:@"0"]) {
        ss = @"daizhixing_icon";
    }else if ([status isEqualToString:@"1"]) {
        ss = @"jinxingzhong_icon";
    }else if ([status isEqualToString:@"2"]) {
        ss = @"yiwancheng_icon";
    }else if ([status isEqualToString:@"3"]) {
        ss = @"yuqiweiwancheng_icon";
    }else if ([status isEqualToString:@"4"]) {
        ss = @"yuqiyiwancheng_icon";
    }else if ([status isEqualToString:@"5"]) {
        ss = @"dailingqu_icon";
    }else if ([status isEqualToString:@"6"]) {
        ss = @"daizhipai_icon";
    }
    return ss;
    
}
- (KG_XunShiHandleView *)xunShiHandelView {
    if (!_xunShiHandelView) {
        _xunShiHandelView = [[KG_XunShiHandleView alloc]init];
      
    }
    return _xunShiHandelView;
}
//获得回复
- (void)getReceviceData {
    
//    http://192.168.100.173:8089/intelligent/atcPatrolDialog/67900de54fe34afda50bde26e2b40b0a
    NSString *rId = self.dataDic[@"id"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolDialog/%@",rId]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.receiveArr = result[@"value"];
        [self.tableView reloadData];
        
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
}


//获得日志
- (void)getLogData {
    
//    http://192.168.100.173:8089/intelligent/atcPatrolDialog/67900de54fe34afda50bde26e2b40b0a
    NSString *rId = self.dataDic[@"id"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/getAtcPatrolLog/%@/%@/%@",rId,@"1",@"100"]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
       
        if (isSafeDictionary(result[@"value"])) {
            if (isSafeArray(result[@"value"][@"records"])) {
                self.logArr = result[@"value"][@"records"];
            }
           
        }
        [self.tableView reloadData];
        
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
}

@end
