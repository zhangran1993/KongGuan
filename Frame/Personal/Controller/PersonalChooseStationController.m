//
//  PersonalChooseStationController.m
//  Frame
//
//  Created by hibayWill on 2018/3/16.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//



#import "PersonalChooseStationController.h"
#import "ChooseStationCell.h"
#import "StationItems.h"


#import "FrameBaseRequest.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "HSIEmptyDataSetView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface PersonalChooseStationController ()<EmptyDataSetDelegate,UITableViewDelegate,UITableViewDataSource>

/** 存放数据模型的数组 */
@property (strong, nonatomic) NSMutableArray<StationItems *> * stations;
/** 用于加载下一页的参数(页码) */
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign)  double hasMore;

@property (strong, nonatomic) UITableView *tableView;



@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;
@end

@implementation PersonalChooseStationController

#pragma mark - 全局常量
static NSString * const FrameCellID = @"ChooseStation";


#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviTopView];
    //初始化tableview
    [self.view addSubview:self.tableView];
    [self setupTable];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.tableView reloadData];
    
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
   
    self.navigationItem.title = @"所属台站";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNotificationAction) name:kNetworkStatusNotification object:nil];
     [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
   
}
-(void)viewWillDisappear:(BOOL)animated{
}

-(void)viewDidDisappear:(BOOL)animated{
    //NSLog(@"viewDidDisappear");
    
}
-(void)viewAppear:(BOOL)animated{
    
    
}

#pragma mark - private methods 私有方法
-(void)backBtn{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}
-(void)backAction {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation2"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
    }
    return _tableView;
}

#pragma mark - private methods 私有方法

- (void)setupTable{
    //self.tableView.rowHeight = 85.5;
    // 注册重用Cell
    self.tableView.backgroundColor = BGColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseStationCell class]) bundle:nil] forCellReuseIdentifier:FrameCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.view.backgroundColor = [UIColor whiteColor];
//    // 头部刷新控件
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    [self.tableView.mj_header beginRefreshing];
//    
    // 尾部刷新控件
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


/**
 监听网络
 */
- (void)resetNotificationAction {
    if (!IsNetwork) {
        self.stations = nil;
        [self.tableView reloadData];
    } else {
        [self loadData];
    }
}


#pragma mark --EmptyDataSetDelegate
- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (!IsNetwork) {
        return [UIImage imageNamed:@"error_net"];
    } else {
        return [UIImage imageNamed:@"error_date"];
    }
}

- (nullable NSAttributedString *)tipsForEmptyDataSet:(UIScrollView *)scrollView{
    if (!IsNetwork) {
        NSAttributedString *tips = [[NSAttributedString alloc] initWithString:scrollViewNoNetworkText];
        return tips;
    } else {
        NSAttributedString *tips = [[NSAttributedString alloc] initWithString:scrollViewNoDataText];
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

#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */
- (void)loadData{
    self.pageNum = 1;
    self.pageSize = 30;
    _hasMore = true;
    [self loadMoreData];
}

/**
 *  加载更多数据
 */
- (void)loadMoreData{
    if(!_hasMore){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        //self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        return ;
    }
    // 请求参数（根据接口文档编写）
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/api/allStationList"];
    //params[@"mid"] = mid;
    //FrameRequestURL = [FrameRequestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params  success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            self.tableView.emptyDataSetDelegate = self;
            [self.tableView reloadData];
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.tableView.emptyDataSetDelegate = self;
        //self.stations = [[StationItems class] mj_objectArrayWithKeyValuesArray:[result objectForKey:@"value"]  ];
        
        if(self.pageNum == 1){
            self.stations = [[StationItems class] mj_objectArrayWithKeyValuesArray:[result objectForKey:@"value"]  ];
            if(self.stations.count == self.pageSize){
                self.pageNum ++;
                _hasMore = true;
            }else{
                _hasMore = false;
            }
        }else{
            NSArray *array = [StationItems mj_objectArrayWithKeyValuesArray:[result objectForKey:@"value"] ];
            [self.stations addObjectsFromArray:array];
            if(array.count == self.pageSize){
                self.pageNum ++;
                _hasMore = true;
            }else{
                _hasMore = false;
            }
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if(self.stations.count > 0){
            //self.tableView.mj_footer.state = MJRefreshStateNoMoreData;//;
        }else{
           // self.tableView.mj_footer.state = MJRefreshStateNoData;//MJRefreshStateNoMoreData;
        }
    } failure:^(NSURLSessionDataTask *error)  {
        self.tableView.emptyDataSetDelegate = self;
        [self.tableView reloadData];
        FrameLog(@"请求失败，返回数据 : %@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        //self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//            [FrameBaseRequest logout];
//            UIViewController *viewCtl = self.navigationController.viewControllers[0];
//            [self.navigationController popToViewController:viewCtl animated:YES];
//            return;
//        }else if(responses.statusCode == 502){
//            
//        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
    
    
    
}

#pragma mark - UITableviewDatasource 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChooseStationCell *cell = [tableView dequeueReusableCellWithIdentifier:FrameCellID];
    cell.selectionStyle = 0;
    [cell prepareForReuse];
    [cell.contentView setFrame:CGRectMake(0, 0, self.view.frame.size.width, cell.bounds.size.height)];
    
    cell.station = self.stations[indexPath.row];
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return FrameWidth(80);
}
-(CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

#pragma mark - UITableviewDelegate 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath%@",self.stations[indexPath.row].alias);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary  *thisStation2 = @{
                                    @"name":self.stations[indexPath.row].alias,
                                    @"alias":self.stations[indexPath.row].alias,
                                    @"code":self.stations[indexPath.row].code,
                                    @"airport":self.stations[indexPath.row].airport,
                                    @"picture":self.stations[indexPath.row].picture,
                                    @"address":self.stations[indexPath.row].address,
                                    @"isShow":@"0"
                                    };
    
    
    [userDefaults setObject:thisStation2 forKey:@"station"];
    [userDefaults setObject:self.stations[indexPath.row].code forKey:@"station_code"];
     [[NSUserDefaults standardUserDefaults] synchronize];
    [self backAction];
     */
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor clearColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor clearColor];
    topImage.image = [self createImageWithColor:[UIColor clearColor]];
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
    self.titleLabel.text = @"所属台站";
    
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

@end




