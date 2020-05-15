//
//  RankController.m
//  Frame
//
//  Created by Apple on 2018/12/5.
//  Copyright © 2018 hibaysoft. All rights reserved.
//


#import "RankController.h"
#import "FrameBaseRequest.h"
#import "StationItems.h"
#import "StationRankCell.h"
#import <MJExtension.h>
#import <Foundation/Foundation.h>
#import "UIView+LX_Frame.h"
#import <MJRefresh.h>
#import <MJExtension.h>

#import "HSIEmptyDataSetView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "KG_OverAlertView.h"
#import "KG_OverAlertCenterView.h"

@interface RankController ()<UITableViewDelegate,UITableViewDataSource,EmptyDataSetDelegate>{
}

@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;
@property(strong,nonatomic)UITableView *stationTabView;
@property NSMutableArray *stationList;

@property (nonatomic, strong) KG_OverAlertView *overAlertView;
@property (nonatomic, strong) KG_OverAlertCenterView *overAlertCenterView;
@property(strong,nonatomic) NSString *typeString;
@property(strong,nonatomic) UIButton *rightButon;
@end

@implementation RankController

//static NSString * const reuseIdentifier = @"Cell";

static NSString * const FrameCellID = @"PatrolHistory";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewData];
    [self backBtn];
    
    [self loadBgView];
    [self setExplainBtn ];
    
    //[self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNotificationAction) name:kNetworkStatusNotification object:nil];
    
   
}
- (void)initViewData{
    
    self.typeString = @"comprehensiveScoringMethod";
}
//右侧点击方法
- (void)rightButon:(UIButton *)button {
   
    if (self.overAlertView.isHidden) {
        self.overAlertView.hidden = NO;
    }
    
   
    
   
}
-(void)loadBgView{//设置台站列表内容
    self.title = @"台站健康度排行榜";
    //背景色
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    
    self.stationTabView = [[UITableView alloc] initWithFrame:CGRectMake(16,140+NAVIGATIONBAR_HEIGHT -64 , WIDTH_SCREEN-32 , SCREEN_HEIGHT-(140+NAVIGATIONBAR_HEIGHT -64)- kDefectHeight)];
    self.stationTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.stationTabView.tableFooterView.frame = CGRectMake(0, 0, WIDTH_SCREEN -4 , FrameWidth(30));
    self.stationTabView.showsVerticalScrollIndicator = NO;
    self.stationTabView.layer.cornerRadius = 10;
    self.stationTabView.layer.masksToBounds = YES;
    self.stationTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.stationTabView];
    self.stationTabView.dataSource = self;
    self.stationTabView.delegate = self;
    self.stationTabView.estimatedRowHeight = 0;
    self.stationTabView.estimatedSectionHeaderHeight = 0;
    self.stationTabView.estimatedSectionFooterHeight = 0;
    
    self.stationTabView.separatorStyle = NO;
    // 注册重用Cell
    [self.stationTabView registerNib:[UINib nibWithNibName:NSStringFromClass([StationRankCell class]) bundle:nil] forCellReuseIdentifier:FrameCellID];//cell的class
    // 头部刷新控件
    self.stationTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.stationTabView.mj_header beginRefreshing];
    
    // 尾部刷新控件
    //self.stationTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    return ;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.overAlertView.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

-(void)loadData{
    [self loadMoreData];
    
}

- (void)getHealthStationData {
//    请求地址：/intelligent/atcStationHealth/health/{stationCode}/{type}
//         其中，stationCode是台站编码
//               type是健康度计算类型：
//                         comprehensiveScoringMethod：综合评分法
//                         syntheticalIndexMethod：综合指数法
//    greyCorrelativeAnalysis：灰色关联分析法
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
//    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcStationHealth/health/%@" ,self.typeString]];
//     NSString *  FrameRequestURL = [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/atcStationHealth/health/%@",self.typeString];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcStationHealth/health/%@",self.typeString]];
    FrameRequestURL = [FrameRequestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params  success:^(id result) {
        
        self.stationTabView.emptyDataSetDelegate = self;
//        NSInteger code = [[result objectForKey:@"errCode"] intValue];
//
//        if(code  <= -1){
//            [self.stationTabView reloadData];
//            [FrameBaseRequest showMessage:result[@"errMsg"]];
//            return ;
//        }
        self.StationItem = [[StationItems class] mj_objectArrayWithKeyValuesArray:result];
        
        [self.stationTabView reloadData];
        [self.stationTabView.mj_header endRefreshing];
        [self.stationTabView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *error)  {
        [self.stationTabView.mj_header endRefreshing];
        [self.stationTabView.mj_footer endRefreshing];
        self.stationTabView.emptyDataSetDelegate = self;
        [self.stationTabView reloadData];
        //self.stationTabView.mj_footer.state = MJRefreshStateNoMoreData;
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
      
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

/**
 *  加载更多数据
 */
- (void)loadMoreData{//获取台站数据
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
//    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcStationHealth/health/%@" ,self.typeString]];
//    NSString *  FrameRequestURL = [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/atcStationHealth/health/%@",self.typeString];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcStationHealth/health/%@",self.typeString]];
    FrameRequestURL = [FrameRequestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params  success:^(id result) {
        
        self.stationTabView.emptyDataSetDelegate = self;
//        NSInteger code = [[result objectForKey:@"errCode"] intValue];
//
//        if(code  <= -1){
//            [self.stationTabView reloadData];
//            [FrameBaseRequest showMessage:result[@"errMsg"]];
//            return ;
//        }
        self.StationItem = [[StationItems class] mj_objectArrayWithKeyValuesArray:result];
        
        [self.stationTabView reloadData];
        [self.stationTabView.mj_header endRefreshing];
        [self.stationTabView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *error)  {
        [self.stationTabView.mj_header endRefreshing];
        [self.stationTabView.mj_footer endRefreshing];
        self.stationTabView.emptyDataSetDelegate = self;
        [self.stationTabView reloadData];
        //self.stationTabView.mj_footer.state = MJRefreshStateNoMoreData;
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
       
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
    
}

#pragma mark - UITableviewDatasource 数据源方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.StationItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        StationRankCell *cell = [tableView dequeueReusableCellWithIdentifier:FrameCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        StationItems *item = self.StationItem[indexPath.row];
        item.num = (int)indexPath.row + 1;
        cell.StationItem = item;
        return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    StationItems * item = self.StationItem[indexPath.row];
    NSLog(@"itemitemitemitem %@",item.stationCode);
    if([getAllStation indexOfObject:item.stationCode] != NSNotFound){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@{
                                  @"name":item.stationName,
                                  @"alias":item.stationName,
                                  @"code":item.stationCode,
                                  @"airport":item.airPort,
                                  @"isShow":@"0"
                                  } forKey:@"station"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController.tabBarController setSelectedIndex:2];
        [self.navigationController popToRootViewControllerAnimated:true];
        
    }else{
        [FrameBaseRequest showMessage:@"您没有当前台站的权限"];
    }
    
    
    
    
}

#pragma mark - UITableviewDatasource 数据源方法

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.stationTabView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithHexString:kCellHighlightColor];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.stationTabView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    }
}


#pragma mark --EmptyDataSetDelegate
/**
 监听网络
 */
- (void)resetNotificationAction {
    if (!IsNetwork) {
        self.StationItem = nil;
        [self.stationTabView reloadData];
    } else {
        [self loadData];
    }
}

- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (!IsNetwork) {
        return [UIImage imageNamed:@"error_net"];
    } else {
        return [UIImage imageNamed:@"error_mess"];
    }
}

- (nullable NSAttributedString *)tipsForEmptyDataSet:(UIScrollView *)scrollView{
    if (!IsNetwork) {
        NSAttributedString *tips = [[NSAttributedString alloc] initWithString:scrollViewNoNetworkText];
        return tips;
    } else {
        NSAttributedString *tips = [[NSAttributedString alloc] initWithString:@"暂无消息"];
        return tips;
    }
}

- (nullable NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    if (!IsNetwork) {
        NSAttributedString *buttonTitle =  [[NSAttributedString alloc] initWithString:scrollViewButtonText];
        return buttonTitle;
    } else {
        NSAttributedString *buttonTitle = nil;
        return buttonTitle;
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    [self loadData];
}


/*返回 */
-(void)backBtn{
    //    health_bgimage@2x
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 297)];
    bgImage.image = [UIImage imageNamed:@"health_bgimage"];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImage];
   
    
 
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame: CGRectMake(16,NAVIGATIONBAR_HEIGHT -64,60 ,60)];
    [backBtn setImage:[UIImage imageNamed:@"backwhite"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    
    self.rightButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    self.rightButon.frame = CGRectMake(0,0,80,FrameWidth(40));
  
    [self.rightButon addTarget:self action:@selector(rightButon:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButon setTitle:@"综合分析法" forState:UIControlStateNormal];
    [self.rightButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.rightButon];
   
    
    UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 7, 10)];
    rightImage.image = [UIImage imageNamed:@"right_arrow"];
    [self.view addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backBtn.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    [self.rightButon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backBtn.mas_centerY);
        make.right.equalTo(rightImage.mas_left).offset(-1);
    }];
       
}




-(void)backAction {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation2"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)closeFrame{
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
    
}

//台站解说
-(void)setExplainBtn{
    //healthWindow = [[UIWindow alloc]initWithFrame:CGRectMake(FrameWidth(520), FrameWidth(560), FrameWidth(120), FrameWidth(120))];
    UIButton * healthBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 58-20, SCREEN_HEIGHT/2 +50,58, 61)];
    
    [healthBtn setBackgroundImage:[UIImage imageNamed:@"station_rank"] forState:UIControlStateNormal];
    [healthBtn addTarget:self action:@selector(explainBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:healthBtn];
}
-(void)explainBtnClick{
    NSLog(@"explainBtnClick   explain_all");
    if (self.overAlertCenterView.isHidden) {
          self.overAlertCenterView.hidden = NO;
      }
  
    
//    UIViewController *vc = [UIViewController new];
//    vc.view.backgroundColor = [UIColor clearColor];
//    
//    vc.view.frame = CGRectMake(FrameWidth(70), FrameWidth(225), FrameWidth(505), FrameWidth(780));
//    vc.view.layer.cornerRadius = 9.0;
//    vc.view.layer.masksToBounds = YES;
//    UIImageView * explanAll = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"explain_all"]];
//    explanAll.frame = CGRectMake(0, 0,  FrameWidth(505), FrameWidth(660));
//    [vc.view addSubview:explanAll];
    //UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(252), FrameWidth(660), 1, FrameWidth(50))];
    //lineView.backgroundColor = [UIColor whiteColor];
   // [vc.view addSubview:lineView];
    
//    UIButton * healthBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(220), FrameWidth(660),FrameWidth(60), FrameWidth(115))];
//
//    [healthBtn setBackgroundImage:[UIImage imageNamed:@"explain_close"] forState:UIControlStateNormal];
//    [healthBtn addTarget:self action:@selector(closeExplain) forControlEvents:UIControlEventTouchUpInside];
//    [vc.view addSubview:healthBtn];
//
//
//
//
//    [self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentCenter overlayDismissed:nil];
}

-(void)closeExplain{
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
    
}

- (KG_OverAlertView *)overAlertView {
    if (!_overAlertView) {
        _overAlertView = [[KG_OverAlertView alloc]init];
        [JSHmainWindow addSubview:self.overAlertView];
        [self.overAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.left.equalTo(self.view);
          
        }];
        _overAlertView.didsel = ^(NSString * _Nonnull selString) {
            self.typeString = selString;
            if ([self.typeString isEqualToString:@"comprehensiveScoringMethod"]) {
                [self.rightButon setTitle:[NSString stringWithFormat:@"综合分析法"] forState:UIControlStateNormal];
            }else if ([self.typeString isEqualToString:@"syntheticalIndexMethod"]) {
                [self.rightButon setTitle:[NSString stringWithFormat:@"综合指数法"] forState:UIControlStateNormal];
            }else if ([self.typeString isEqualToString:@"greyCorrelativeAnalysis"]) {
                [self.rightButon setTitle:[NSString stringWithFormat:@"灰色关联分析法"] forState:UIControlStateNormal];
            }
            [self loadMoreData];
        };
     
    }
    return _overAlertView;
}

- (KG_OverAlertCenterView *)overAlertCenterView {
    
    if (!_overAlertCenterView) {
        _overAlertCenterView = [[KG_OverAlertCenterView alloc]init];
        [self.view addSubview:self.overAlertCenterView];
        [self.overAlertCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.left.equalTo(self.view);
          
        }];
        
    }
    return _overAlertCenterView;
}
@end
