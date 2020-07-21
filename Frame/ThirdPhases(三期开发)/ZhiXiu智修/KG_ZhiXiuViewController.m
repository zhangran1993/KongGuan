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
@interface KG_ZhiXiuViewController ()<SegmentTapViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SegmentTapView *segment;
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic ,assign) int pageNum;
@property (nonatomic ,assign) int pageSize;
@property (nonatomic ,assign) int currIndex;
@property (nonatomic ,assign) BOOL isOpenSwh;

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *swh;



@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;

@property (nonatomic ,strong) NSMutableArray *paraArr;

@property(strong,nonatomic)   NSArray *stationArray;
@property(strong,nonatomic)   UITableView *stationTabView;

@property (nonatomic, strong)  UIButton    *leftIconImage;

@end

@implementation KG_ZhiXiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view
    self.isOpenSwh = NO;
    
    [self createNaviTopView];
    [self createSegmentView];
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
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
    [self.paraArr removeAllObjects];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    [self queryGaoJingData];
    
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
//     [self.navigationController setNavigationBarHidden:NO];
    
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
        make.top.equalTo(self.segment.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    swhView.hidden = YES;
    
    
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
    
}
//获取某个台站下全部自动告警事件：
//请求地址：/{pageNum}/{pageSize}
//       其中，pageNum是页码，pageSize是每页的数据量
//请求方式：POST

- (void)queryGaoJingData {
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/searchAlarmInfo/%d/%d",WebNewHost,self.pageNum,self.pageSize];
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
   
    
    UIButton *histroyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    histroyBtn.titleLabel.font = FontSize(12);
    
    
    [histroyBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [histroyBtn setImage:[UIImage imageNamed:@"screen_more"] forState:UIControlStateNormal];
    histroyBtn.frame = CGRectMake(0,0,81,22);
    [self.view addSubview:histroyBtn];
    [histroyBtn addTarget:self action:@selector(screenAction) forControlEvents:UIControlEventTouchUpInside];
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
    
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#D0CFCF"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"黄城导航台" forState:UIControlStateNormal];
    self.rightButton.frame = CGRectMake(0,0,81,22);
    [self.rightButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
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
    
    
}



- (void)screenAction{
    
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
        
        
       KG_GaoJingModel *model = self.dataArray[indexPath.section];
       
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
             
//            if (![userDefaults objectForKey:@"firstZhiXiu"]) {
//                [userDefaults setObject:@"1" forKey:@"firstZhiXiu"];
//                [userDefaults synchronize];
//                cell.showLeftSrcollView = @"1";
//
//
//            }
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
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//筛选方法
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
    //全部
    if (self.currIndex == 0) {
        [self queryMoreGaoJingData];
    }else if (self.currIndex == 1) {
        //未确认
        [self queryMoreGaoJingData];
    }else if (self.currIndex == 2) {
        //已确认
        [self loadMoreConfirmData];
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


- (void)selectedIndex:(NSInteger)index{
    NSLog(@"测试");
    [self.dataArray removeAllObjects];
    [self.paraArr removeAllObjects];
    self.pageNum = 1;
    self.currIndex = (int)index;
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
       
    if (index == 0) {
        NSLog(@"1");
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        paraDic[@"name"] = @"stationCode";
        paraDic[@"type"] = @"eq";
        paraDic[@"content"] = safeString(currDic[@"code"]);
        [self.paraArr addObject:paraDic];
        [self queryGaoJingData];
    }else if (index == 1){
        NSLog(@"2");
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
        [self queryGaoJingData];
    }else if (index == 2){
        NSLog(@"3");
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        paraDic[@"name"] = @"stationCode";
        paraDic[@"type"] = @"eq";
        paraDic[@"content"] = safeString(currDic[@"code"]);
        [self.paraArr addObject:paraDic];
        [self queryConfirmData];
        
      
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
                [self setupRowActionView:remarkContentView];
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
                [self setupRowActionView:remarkContentView];
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
            [self setupRowActionView:remarkContentView];
        }
    }
}

- (void)setupRowActionView:(UIView *)rowActionView {
    // 切割圆角
//    [rowActionView cl_setCornerAllRadiusWithRadiu:20];
    // 改变父 View 的frame，这句话是因为我在 contentView 里加了另一个 View，为了使划出的按钮能与其达到同一高度
    CGRect frame = rowActionView.frame;
//    frame.origin.y += (7);
    frame.size.height = (36);
    frame.size.width = (36);
    rowActionView.frame = frame;
    // 拿到按钮,设置
    UIButton *hang = rowActionView.subviews.firstObject;
    [hang setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    [hang setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [hang setTitle:@"挂起" forState:UIControlStateNormal];
    
    UIButton *lift = rowActionView.subviews[1];
    [lift setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    [lift setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [lift setTitle:@"解除" forState:UIControlStateNormal];
    
    UIButton *confirm = rowActionView.subviews[2];
    [confirm setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    [confirm setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [confirm setTitle:@"确认" forState:UIControlStateNormal];
}


//
//- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//    dispatch_async(dispatch_get_main_queue(), ^{
//          [self setupSlideBtnWithEditingIndexPath:indexPath];
//      });
//}


//
//- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    //title不设为nil 而是空字符串 理由为啥 ？   自己实践 跑到ios11以下的机器上就知道为啥了
//    UITableViewRowAction *hang = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"        " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        
//        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
//    }];
//    UITableViewRowAction *lift = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"        " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        
//        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
//    }];
//    UITableViewRowAction *confirm = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"        " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        
//        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
//    }];
//    return @[hang,lift,confirm];
//}

@end
