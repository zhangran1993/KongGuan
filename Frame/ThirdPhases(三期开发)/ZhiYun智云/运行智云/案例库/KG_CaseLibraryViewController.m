//
//  KG_HistoryTaskViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/11.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CaseLibraryViewController.h"
#import "KG_CaseLibraryCell.h"
#import "SegmentTapView.h"
#import "RS_ConditionSearchView.h"
#import "KG_NiControlSearchViewController.h"
#import "KG_XunShiReportDetailViewController.h"
#import "KG_InspectionRecordCell.h"
#import "KG_CaseLibraryPromptViewController.h"
#import "KG_CaseLibraryDetailViewController.h"
@interface KG_CaseLibraryViewController ()<SegmentTapViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SegmentTapView *segment;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic ,assign) int pageNum;
@property (nonatomic ,assign) int pageSize;

@property (nonatomic ,strong) NSMutableArray *paraArr;

@property (nonatomic ,assign) int currIndex;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)  NSArray *topArray;

@property (nonatomic, copy)    NSString *currCode;
@end

@implementation KG_CaseLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 1;
    self.pageSize = 10;
    self.currIndex = 0;
    //初始化为日
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    [self createNaviTopView];
   
    [self queryTopListData];
}

- (void)createSegmentView{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *datDic in self.topArray) {
        [arr addObject:safeString(datDic[@"name"])];
    }
    NSArray *array = arr;
    
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT +8, SCREEN_WIDTH, 44) withDataArray:array withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
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
    self.titleLabel.text = @"案例库";
    
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
    
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.searchBtn.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
    [self.searchBtn setImage:[UIImage imageNamed:@"kg_right_promptIcon"] forState:UIControlStateNormal];
    self.searchBtn.userInteractionEnabled = YES;
    [self.searchBtn addTarget:self action:@selector(promptMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:self.searchBtn];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.navigationView.mas_right).offset(-12);
    }];
    
}

//说明方法
- (void)promptMethod:(UIButton *)button {
    
    KG_CaseLibraryPromptViewController *vc = [[KG_CaseLibraryPromptViewController alloc]init];
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

- (void)selectedIndex:(NSInteger)index{
    NSLog(@"测试");
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
   
    self.pageNum = 1;
    self.currIndex = (int)index;
    if (self.topArray.count) {
        self.currCode = safeString(self.topArray[index][@"code"]);
    }
    [self queryContentData];
    if (index == 0) {
        NSLog(@"1");
      
    }else if (index == 1){
        NSLog(@"2");
      
    }else if (index == 2){
        NSLog(@"3");
       
    }else if (index == 3){
        NSLog(@"4");
       
    }
  
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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

- (void)loadMoreData {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    footView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.dataArray[indexPath.section];
    NSArray *arr = dataDic[@"faultCaseList"];
    return  40+ 60 *arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_CaseLibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_CaseLibraryCell"];
    if (cell == nil) {
        cell = [[KG_CaseLibraryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_CaseLibraryCell"];
        
    }
    cell.didsel = ^(NSDictionary * _Nonnull dataDic) {
        KG_CaseLibraryDetailViewController *vc = [[KG_CaseLibraryDetailViewController alloc]init];
        vc.idStr = safeString(dataDic[@"id"]);
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.dataArray[indexPath.section];
    if (dataDic.count) {
        NSArray *dataArr = dataDic[@"faultCaseList"];
        cell.dataDic = dataDic;
        cell.listArray = dataArr;
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
}


- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


//请求地址：/intelligent/atcDictionary?type_code=faultCaseType
//请求方式：GET
//请求返回:
//{
//    "errCode": 0,
//    "errMsg": "",
//    "value": [{

- (void)queryTopListData{
   
    NSString * FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=faultCaseType"]];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            
            return ;
        }
        
        NSArray *listArr = result[@"value"];

        self.topArray = listArr;
        if (self.topArray.count) {
            self.currCode = safeString([self.topArray firstObject][@"code"]);
        }
        
        [self createSegmentView];
        [self queryContentData];
        
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
      
        return ;
    }];
}


//请求地址：/intelligent/atcDictionary?type_code=powerCaseCategory
//          /intelligent/atcDictionary?type_code=commCaseCategory
///intelligent/atcDictionary?type_code=navigationCaseCategory
///intelligent/atcDictionary?type_code=monitorCaseCategory
//           其中，type_code的取值与上一分类字典接口的code字段对应
//请求方式：GET


- (void)queryContentData{
    //    NSString *FrameRequestURL = @"http://10.33.33.147:8089/intelligent/api/stationList";
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcFaultCase/appCloud/%@",safeString(self.currCode)]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
           
            return ;
        }
        self.dataArray = result[@"value"];
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
