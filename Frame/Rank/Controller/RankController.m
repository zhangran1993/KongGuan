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

@interface RankController ()<UITableViewDelegate,UITableViewDataSource,EmptyDataSetDelegate>{
}

@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;
@property(strong,nonatomic)UITableView *stationTabView;
@property NSMutableArray *stationList;



@end

@implementation RankController

//static NSString * const reuseIdentifier = @"Cell";

static NSString * const FrameCellID = @"PatrolHistory";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBtn];
    [self loadBgView];
    [self setExplainBtn ];
    //[self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNotificationAction) name:kNetworkStatusNotification object:nil];
    
    
}
-(void)loadBgView{//设置台站列表内容
    self.title = @"台站健康度排行榜";
    //背景色
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    
    self.stationTabView = [[UITableView alloc] initWithFrame:CGRectMake(0,0 , WIDTH_SCREEN , View_Height-ZNAVViewH)];
    self.stationTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.stationTabView.tableFooterView.frame = CGRectMake(0, 0, WIDTH_SCREEN -4 , FrameWidth(30));
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
}
-(void)viewWillDisappear:(BOOL)animated{
    
}

-(void)loadData{
    [self loadMoreData];
}

/**
 *  加载更多数据
 */
- (void)loadMoreData{//获取台站数据
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/getHealthList"]];
    
    FrameRequestURL = [FrameRequestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params  success:^(id result) {
        
        self.stationTabView.emptyDataSetDelegate = self;
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        
        if(code  <= -1){
            [self.stationTabView reloadData];
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.StationItem = [[StationItems class] mj_objectArrayWithKeyValuesArray:result[@"value"] ];
        
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
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            return;
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
    
}

#pragma mark - UITableviewDatasource 数据源方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return FrameWidth(90);
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
        [self.navigationController.tabBarController setSelectedIndex:0];
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
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
}
-(void)backAction {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation2"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController popViewControllerAnimated:YES];
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
        UIButton * healthBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(500), FrameWidth(520),FrameWidth(120), FrameWidth(110))];
    
        [healthBtn setBackgroundImage:[UIImage imageNamed:@"home_explain_biao"] forState:UIControlStateNormal];
        [healthBtn addTarget:self action:@selector(explainBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:healthBtn];
}
-(void)explainBtnClick{
    NSLog(@"explainBtnClick   explain_all");
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor clearColor];
    
    vc.view.frame = CGRectMake(FrameWidth(70), FrameWidth(225), FrameWidth(505), FrameWidth(780));
    vc.view.layer.cornerRadius = 9.0;
    vc.view.layer.masksToBounds = YES;
    UIImageView * explanAll = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"explain_all"]];
    explanAll.frame = CGRectMake(0, 0,  FrameWidth(505), FrameWidth(660));
    [vc.view addSubview:explanAll];
    //UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(252), FrameWidth(660), 1, FrameWidth(50))];
    //lineView.backgroundColor = [UIColor whiteColor];
   // [vc.view addSubview:lineView];
    
    UIButton * healthBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(220), FrameWidth(660),FrameWidth(60), FrameWidth(115))];

    [healthBtn setBackgroundImage:[UIImage imageNamed:@"explain_close"] forState:UIControlStateNormal];
    [healthBtn addTarget:self action:@selector(closeExplain) forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:healthBtn];
    
    
    
    
    [self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentCenter overlayDismissed:nil];
}

-(void)closeExplain{
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
    
}


@end
