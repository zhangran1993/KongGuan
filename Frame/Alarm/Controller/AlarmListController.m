//
//  AlarmListController.m
//  Frame
//
//  Created by hibayWill on 2018/4/4.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "AlarmListController.h"
#import "AlarmItems.h"
#import "StationItems.h"
#import "AlarmListCell.h"
#import "PGDatePickManager.h"
#import "AlarmDetailController.h"
#import "LoginViewController.h"
#import "UIColor+Extension.h"

#import "FrameBaseRequest.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "HSIEmptyDataSetView.h"
#import "UIScrollView+EmptyDataSet.h"
@interface AlarmListController ()<UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate,EmptyDataSetDelegate>

/** 存放数据模型的数组 */
@property(strong,nonatomic)UILabel *dateLabel;
@property(strong,nonatomic)UIButton *leftBtn;
@property(strong,nonatomic)UIButton *rightBtn;
@property(strong,nonatomic)UILabel *leftLabel;
@property(strong,nonatomic)UILabel *rightLabel;
@property(strong,nonatomic)UIButton *allBtn;
@property(strong,nonatomic)UIButton *powerBtn;
@property(strong,nonatomic)UIButton *envirBtn;



@property(strong,nonatomic)UIButton *statusBtn;
@property(strong,nonatomic)UIButton *roomBtn;
@property(strong,nonatomic)UIButton *levelBtn;
@property(strong,nonatomic)UIButton *startDate;
@property(strong,nonatomic)UIButton *endDate;

@property NSDate *NstartDate;
@property NSDate *NendDate;


@property(strong,nonatomic)UIButton *leftButon;

@property(strong,nonatomic)UITableView *filterTabView;
@property(strong,nonatomic)UITableView *stationTabView;
@property(strong,nonatomic)UITableView *onetableview;

@property(strong,nonatomic)PGDatePicker *startDatePicker;
@property(strong,nonatomic)PGDatePicker *endDatePicker;
@property(strong,nonatomic)UIViewController *vc;
@property NSString* roomSelect;
@property NSString* statusSelect;
@property NSString* levelSelect;
@property NSUInteger newHeight1;
@property NSUInteger newHeight2;
@property NSUInteger newHeight3;
@property NSUInteger newHeight4;
@property NSMutableArray *alarmStatus;
@property NSMutableArray *alarmLevel;
@property NSMutableArray *roomList;
@property NSMutableArray *ALLtags;
@property NSMutableArray *typetags;
@property NSMutableArray *levelTags;
@property BOOL isRefresh;

@property (strong, nonatomic) NSMutableArray<AlarmItems *> * AlarmItem;
@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;

/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger pageSize;
@property   double hasMore;

@end

@implementation AlarmListController

#pragma mark - 全局常量
//
//static NSString * const FrameCellID = @"AlarmListCell";


#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(20),NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    NSLog(@"viewDidLoad");
    _confirme_status = @"unconfirmed";
    _isRefresh = TRUE;
    [super viewDidLoad];
    self.navigationItem.title = @"告警管理";
    
    self.roomBtn = [UIButton new];
    self.levelBtn = [UIButton new];
    
   
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    UIView * oneView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, FrameWidth(156))];
    oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneView];
    //添加按钮
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,WIDTH_SCREEN/2, FrameWidth(84))];
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_SCREEN/2, 0,WIDTH_SCREEN/2, FrameWidth(84))];
    [_leftBtn setBackgroundImage:[UIImage imageNamed:@"personal_gray_bg"] forState:UIControlStateSelected];
    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"personal_gray_bg"] forState:UIControlStateSelected];
    [_leftBtn setTitle:@"未确认" forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = FontSize(16);
    [_leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
    _leftBtn.selected = true;
    
    [_rightBtn setTitle:@"已确认" forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = FontSize(16);
    [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
    [_rightBtn addTarget:self  action:@selector(setConfirme:) forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn addTarget:self  action:@selector(setConfirme:) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:_rightBtn];
    [oneView addSubview:_leftBtn];
    
    _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, FrameWidth(85),WIDTH_SCREEN/2, 1)];
    _leftLabel.backgroundColor = navigationColor;
    [oneView addSubview:_leftLabel];
    
    _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_SCREEN/2, FrameWidth(85),WIDTH_SCREEN/2, 1)];
    _rightLabel.backgroundColor = BGColor;//[UIColor whiteColor];
    [oneView addSubview:_rightLabel];
    
    
    _allBtn = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(27), FrameWidth(95),FrameWidth(180), FrameWidth(45))];
    [_allBtn setBackgroundColor:BGColor];
    [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
    _allBtn.titleLabel.font = FontSize(15);
    [_allBtn setTitleColor:navigationColor forState:UIControlStateSelected];
    _allBtn.selected = YES;
    [_allBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
    _allBtn.layer.cornerRadius = 4;
    [oneView addSubview:_allBtn];
    
    _powerBtn = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(230), FrameWidth(95),FrameWidth(180), FrameWidth(45))];
    [_powerBtn setBackgroundColor:BGColor];
    [_powerBtn setTitle:@"动力" forState:UIControlStateNormal];
    [_powerBtn setTitleColor:navigationColor forState:UIControlStateSelected];
    _powerBtn.titleLabel.font = FontSize(15);
    [_powerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
    _powerBtn.layer.cornerRadius = 4;
    [oneView addSubview:_powerBtn];
    
    _envirBtn = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(436), FrameWidth(95),FrameWidth(180), FrameWidth(45))];
    [_envirBtn setBackgroundColor:BGColor];
    [_envirBtn setTitle:@"环境" forState:UIControlStateNormal];
    [_envirBtn setTitleColor:navigationColor forState:UIControlStateSelected];
    _envirBtn.titleLabel.font = FontSize(15);
    [_envirBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
    _envirBtn.layer.cornerRadius = 4;
    
    
    [_allBtn addTarget:self  action:@selector(setType:) forControlEvents:UIControlEventTouchUpInside];
    [_powerBtn addTarget:self  action:@selector(setType:) forControlEvents:UIControlEventTouchUpInside];
    [_envirBtn addTarget:self  action:@selector(setType:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [oneView addSubview:_envirBtn];
    
    self.onetableview = [[UITableView alloc] initWithFrame:CGRectMake(0, FrameWidth(157), WIDTH_SCREEN, HEIGHT_SCREEN - FrameWidth(336))];//FrameWidth(800)
    self.onetableview.dataSource = self;
    self.onetableview.delegate = self;
//    self.onetableview.emptyDataSetDelegate = self;
    self.onetableview.separatorStyle = NO;
    if (@available(iOS 11.0, *)) {
        self.onetableview.estimatedRowHeight = 0;
        self.onetableview.estimatedSectionFooterHeight = 0;
        self.onetableview.estimatedSectionHeaderHeight = 0;
        self.onetableview.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    }
    self.onetableview.backgroundColor = BGColor;
    self.onetableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.onetableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, FrameWidth(30))];
    self.onetableview.separatorStyle = UITableViewCellSelectionStyleNone;
    self.onetableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, FrameWidth(30))];
    [self.view addSubview:self.onetableview];
    
    // 头部刷新控件
    self.onetableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    // 尾部刷新控件
    self.onetableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //添加刷新的通知
    [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(gotoBottomApevent:) name:@"alarmBottomapevent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNotificationAction) name:kNetworkStatusNotification object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)getNowStation{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"station"]){
        NSDictionary * station = [userDefaults objectForKey:@"station"];
        _station_name = [station[@"alias"] copy];//
        _station_code = [station[@"code"] copy];//
        if([getAllStation indexOfObject:_station_code] != NSNotFound){
            
        }else{
            [userDefaults removeObjectForKey:@"station"];
            [FrameBaseRequest showMessage:@"您没有当前台站的权限"];
            [self.tabBarController setSelectedIndex:2];
            return ;
        }
        
        
        NSLog(@"_station_code_station_code_station_code_station_code     %@",_station_code);
        _isRefresh = true;
        if(_isRefresh){//需要刷新
            _isRefresh = false;
            
            [self stationBtn];
            [self loadData];
        }else{
            return ;
        }
        
        //[self.onetableview.mj_header beginRefreshing];
        //[self.AlarmItem removeAllObjects];
        //[self.onetableview reloadData];
    }else{
        [FrameBaseRequest showMessage:@"请选择台站"];
        [self.tabBarController setSelectedIndex:2];
        return ;
    }
}

/**
 监听网络
 */
- (void)resetNotificationAction {
    if (!IsNetwork) {
        self.AlarmItem = nil;
        [self.onetableview reloadData];
    } else {
        [self loadData];
    }
}



#pragma mark - private methods 私有方法

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)gotoBottomApevent:(NSNotification *)notification{
    NSLog(@"alarmlist通知过来的 - dic = %@",notification.object);
    _isRefresh = true ;
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self getNowStation];
    //[self.navigationController setNavigationBarHidden:NO];
    //[self showNavigation];
}

//展示navigation背景色
-(void)showNavigation{
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */




-(void)viewWillDisappear:(BOOL)animated{
    //不用移除
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    
}
-(void)viewAppear:(BOOL)animated{
    
    
}

-(void)loadData{
    
    _pageNum = 1;
    _pageSize = 30;
    _hasMore = true;
    [self loadMoreData];
}

-(void)setConfirme:(UIButton *)btn{
    
    NSLog(@"_confirme_status   %@",_confirme_status);
    if(btn == _leftBtn ){
        _confirme_status = @"unconfirmed";
        _leftBtn.selected = YES;
        _rightBtn.selected = NO;
        _leftLabel.backgroundColor = navigationColor;
        _rightLabel.backgroundColor = BGColor;
    }else if(btn == _rightBtn){
        _confirme_status = @"isconfirmed";
        _leftBtn.selected = NO;
        _rightBtn.selected = YES;
        _rightLabel.backgroundColor = navigationColor;
        _leftLabel.backgroundColor = BGColor;
    }
    //筛选刷新
    [self loadData];
    //[self.onetableview.mj_header beginRefreshing];
}

-(void)setType:(UIButton *)btn{
    if(_powerBtn == btn){
        _powerBtn.selected = YES;
        _allBtn.selected = NO;
        _envirBtn.selected = NO;
        _group = @"power";
    }
    if(_allBtn == btn){
        _powerBtn.selected = NO;
        _allBtn.selected = YES;
        _envirBtn.selected = NO;
        _group = nil;
    }
    if(_envirBtn == btn){
        _powerBtn.selected = NO;
        _allBtn.selected = NO;
        _envirBtn.selected = YES;
        _group = @"environmental";
    }
    //选择类型刷新
    [self loadData];
    //[self.onetableview.mj_header beginRefreshing];
}




/**
 *  加载更多数据
 */
- (void)loadMoreData{
    if(!_hasMore){
        [self.onetableview.mj_header endRefreshing];
        [self.onetableview.mj_footer endRefreshing];
        //self.onetableview.mj_footer.state = MJRefreshStateNoMoreData;
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"station_code"] = _station_code;
    params[@"confirme_status"] = _confirme_status;
    
    if([_confirme_status isEqualToString:@"isconfirmed"]){//如果是未确认则不必加告警状态
        
        params[@"status"] = _status;
    }
    
    params[@"engine_room_code"] = _engine_room_code;
    params[@"group"] = _group;
    params[@"level"] = _level;
    params[@"start_time"] = _start_time;
    params[@"end_time"] = _end_time;
    params[@"hangup_status"] = _hangup_status;
    
    
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/alarmInfoList/%ld/%ld",(long)_pageNum,(long)_pageSize]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            self.onetableview.emptyDataSetDelegate = self;
            [self.onetableview reloadData];
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if(result[@"value"][@"powerCount"]){
            [_powerBtn setTitle:[NSString stringWithFormat:@"动力%@",result[@"value"][@"powerCount"]] forState:UIControlStateNormal];
        }else{
            [_powerBtn setTitle:[NSString stringWithFormat:@"动力%@",@"0"] forState:UIControlStateNormal];
        }
        
        if(result[@"value"][@"environmentalCount"]){
            [_envirBtn setTitle:[NSString stringWithFormat:@"环境%@",result[@"value"][@"environmentalCount"]] forState:UIControlStateNormal];
        }else{
            
            [_envirBtn setTitle:[NSString stringWithFormat:@"环境%@",@"0"] forState:UIControlStateNormal];
        }
        
        
        if(_pageNum == 1){
            self.AlarmItem = [[AlarmItems class] mj_objectArrayWithKeyValuesArray:result[@"value"][@"alarmInfoList"][@"records"]];
            if(self.AlarmItem.count < self.pageSize){
                _hasMore = false;
            }else{
                _pageNum ++;
            }
        }else{
            NSArray *array = [AlarmItems mj_objectArrayWithKeyValuesArray:result[@"value"][@"alarmInfoList"][@"records"]];
            if(array.count < self.pageSize){
                _hasMore = false;
            }else{
                _pageNum ++;
            }
            [self.AlarmItem addObjectsFromArray:array];
        }
        
        self.onetableview.emptyDataSetDelegate = self;
        [self.onetableview reloadData];
        [self.onetableview.mj_header endRefreshing];
        [self.onetableview.mj_footer endRefreshing];
        if(self.AlarmItem.count > 0){
            // self.onetableview.mj_footer.state = MJRefreshStateNoMoreData;//;
        }else{
            //self.onetableview.mj_footer.state = MJRefreshStateNoData;//MJRefreshStateNoMoreData;
        }
        
        
        //self.AlarmItem = [[[AlarmItems class] mj_objectArrayWithKeyValuesArray:result[@"value"][@"alarmInfoList"][@"records"]] copy];
        
        // [self.onetableview reloadData];
        
        //[self getStationList];
        
    } failure:^(NSURLSessionDataTask *error)  {
        self.onetableview.emptyDataSetDelegate = self;
        [self.onetableview reloadData];
        [self.onetableview.mj_header endRefreshing];
        [self.onetableview.mj_footer endRefreshing];
        //self.onetableview.mj_footer.state = MJRefreshStateNoMoreData;
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//            [FrameBaseRequest logout];
//            
//            LoginViewController *login = [[LoginViewController alloc] init];
//            [self.navigationController pushViewController:login animated:YES];
//            return;
//        }else if(responses.statusCode == 502){
//            
//        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
    return ;
    
}

#pragma mark - UITableviewDatasource 数据源方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.onetableview){
        
        return FrameWidth(210);
    }else if(tableView == self.stationTabView){
        
        return FrameWidth(56);
    }else{//如果是筛选的列表，则判断高度决定cell高度
        NSInteger HEIGHT = _newHeight1+_newHeight2+_newHeight3+_newHeight4;
        if(HEIGHT > FrameWidth(1075)){
            return HEIGHT;
        }
        return  FrameWidth(1075);
    }
    return FrameWidth(210);
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.onetableview){
        return self.AlarmItem.count;
    }else if(tableView == self.stationTabView){
        return self.StationItem.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.2 去缓存池中取Cell
    if(tableView == self.stationTabView){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        
        StationItems *item = self.StationItem[indexPath.row];
        if([item.category isEqualToString:@"title"]){
            if(indexPath.row !=0){
                UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FrameWidth(300), 1)];
                line.image = [UIImage imageNamed:@"personal_gray_bg"];
                [cell addSubview:line];
            }
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(55), 0, FrameWidth(300), FrameWidth(54))];
            titleLabel.text = item.alias;
            titleLabel.font = FontSize(15);
            [cell addSubview:titleLabel];
        }else{
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(80), 0, FrameWidth(220), FrameWidth(54))];
            titleLabel.text = item.alias;
            titleLabel.font =  FontSize(15);
            [cell addSubview:titleLabel];
            
            UIImageView *dot = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(55), FrameWidth(20), FrameWidth(12), FrameWidth(12))];
            dot.image = [UIImage imageNamed:@"station_dian"];
            [cell addSubview:dot];
            
        }
        
        return cell;
    }
    
    if(tableView == self.onetableview){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        AlarmItems *group = self.AlarmItem[indexPath.row];
        //线
        UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, WIDTH_SCREEN, FrameWidth(10))];
        bgLabel.backgroundColor = BGColor;
        [cell addSubview:bgLabel];
        
        //名称
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(30), FrameWidth(5), FrameWidth(300), FrameWidth(90))];
        nameLabel.text = [NSString stringWithFormat:@"%@-%@",group.stationName,group.engineRoomName ];
        nameLabel.font = FontSize(17);
        nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        nameLabel.numberOfLines = 2;
        //CGSize size = [nameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:nameLabel.font,NSFontAttributeName,nil]];
        //nameLabel.textColor = [UIColor grayColor];
        //[nameLabel setFrame:CGRectMake(FrameWidth(30), FrameWidth(40), size.width, FrameWidth(30))];
        //CGRectMake(FrameWidth(30), 0, size.width, FrameWidth(30))];
        [cell addSubview:nameLabel];
        
        //等级nameLabel.frame.
        UIImageView *levelImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(300),  FrameWidth(33), FrameWidth(60), FrameWidth(30))];
        levelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"alarm_level%@",group.level]];
        [nameLabel addSubview:levelImg];
        //日期
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(390), FrameWidth(40), FrameWidth(230), FrameWidth(30))];
        dateLabel.text = [FrameBaseRequest getDateByTimesp: group.createTime  dateType:@"YYYY-MM-dd HH:mm"] ;//;
        dateLabel.textAlignment = NSTextAlignmentRight;
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = FontSize(14);
        [cell addSubview:dateLabel];
        //线
        UILabel *lineLabel2  = [[UILabel alloc] initWithFrame:CGRectMake(0,FrameWidth(90), WIDTH_SCREEN, 1)];
        lineLabel2.backgroundColor = BGColor;
        [cell addSubview:lineLabel2];
        //机器
        UIImageView *machineImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(30), FrameWidth(120), FrameWidth(30), FrameWidth(30))];
        machineImg.image = [UIImage imageNamed:@"alarm_machine"];
        [cell addSubview:machineImg];
        UILabel *machineLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(75), FrameWidth(120), FrameWidth(400), FrameWidth(30))];
        machineLabel.text = group.equipmentName;
        machineLabel.font = FontSize(15);
        machineLabel.textColor = [UIColor grayColor];
        [cell addSubview:machineLabel];
        //动力
        UIImageView *powerImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(30), FrameWidth(160), FrameWidth(30), FrameWidth(30))];
        powerImg.image = [UIImage imageNamed:@"alarm_power"];
        [cell addSubview:powerImg];
        UILabel *powerLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(75), FrameWidth(160), FrameWidth(300), FrameWidth(30))];
        powerLabel.text = group.measureTagName;//[NSString stringWithFormat:@"%@%@",group.measureTagName,group.measureTagCode ];
        powerLabel.font = FontSize(15);
        powerLabel.textColor = [UIColor grayColor];
        [cell addSubview:powerLabel];
        
        UILabel *powerLevel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(370), FrameWidth(150), FrameWidth(70), FrameWidth(30))];
        powerLevel.text = group.realTimeValueAlias;
        powerLevel.textAlignment = NSTextAlignmentCenter;
        powerLevel.font = FontSize(15);
        powerLevel.textColor = [UIColor grayColor];
        [cell addSubview:powerLevel];
        
        UIImageView *powerTypeImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(460), FrameWidth(155), FrameWidth(15), FrameWidth(20))];
        if([group.type isEqualToString:@"topLimit"]){
            powerTypeImg.image = [UIImage imageNamed:@"alarm_power_up"];
        }else if([group.type isEqualToString:@"bottomLimit"]){
            powerTypeImg.image = [UIImage imageNamed:@"alarm_power_down"];
        }else{
            
        }
        [cell addSubview:powerTypeImg];
        
        
        //状态
        UIButton *statusBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(523), FrameWidth(130), FrameWidth(75), FrameWidth(35))];
        statusBtn.layer.borderWidth = 0.5;
        //statusBtn.titleLabel.textColor = FrameColor(64,159,243);
        [statusBtn setTitleColor: FrameColor(100,100,100) forState:UIControlStateNormal];
        statusBtn.layer.borderColor = FrameColor(140,140,140).CGColor;
        [statusBtn setBackgroundColor:FrameColor(242,242,242)];
        statusBtn.layer.cornerRadius=3;
        statusBtn.titleLabel.font = FontSize(12);
        NSString *statusString = @"已挂起";
        if([group.status isEqualToString: @"unconfirmed"]){
            [statusBtn setTitleColor: FrameColor(64,159,243) forState:UIControlStateNormal];
            statusBtn.layer.borderColor = FrameColor(106,177,241).CGColor;
            [statusBtn setBackgroundColor:FrameColor(239,247,255)];
            statusString = @"待确认";
        }
        if([group.status isEqualToString: @"confirmed"]){
            [statusBtn setTitleColor: FrameColor(64,159,243) forState:UIControlStateNormal];
            statusBtn.layer.borderColor = FrameColor(106,177,241).CGColor;
            [statusBtn setBackgroundColor:FrameColor(239,247,255)];
            statusString = @"处理中";
        }
        if([group.status isEqualToString: @"completed"]||[group.status isEqualToString: @"r-completed"]){
            statusString = @"已解决";
        }
        if([group.status isEqualToString: @"removed"]){
            statusString = @"已解除";
        }
        
        if(group.hangupStatus == true ){
            statusString = @"已挂起";
        }
        [statusBtn setTitle:statusString forState:UIControlStateNormal];
        //[statusBtn setBackgroundImage:[UIImage imageNamed:statusImg] forState:UIControlStateNormal];
        [cell addSubview:statusBtn];
        return cell;
    }
    
    if(tableView == self.filterTabView){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        //cell.backgroundColor = [UIColor cyanColor];
        
        _newHeight1 = [self setFilterBtn:cell objects:_roomList title:@"告警机房"];
        if(_newHeight1 > 0){
            _newHeight2 = [self setFilterBtn:cell objects:_alarmLevel title:@"告警等级"];
            if(_newHeight2 > 0){
                _newHeight3 = [self setFilterBtn:cell objects:_alarmStatus title:@"告警状态"];
            }
        }
        return cell;
        
    }
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 1.3 若取不到便创建一个带重用标识的Cell
    if (cell == nil) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    if(tableView == self.filterTabView){ return ;}
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    if(tableView == self.stationTabView){
        
        if(self.StationItem[indexPath.row].code ==nil){
            return ;
        }
        _station_code = self.StationItem[indexPath.row].code;
        _station_name = self.StationItem[indexPath.row].alias;
        //去除已选信息
        _roomSelect = nil;
        _levelSelect = nil;
        _statusSelect = nil;
        _start_time = nil;
        _end_time = nil;
        _hangup_status = nil;
        _group = nil;
        
        _engine_room_code = nil;
        _hangup_status = nil;
        _status = nil;
        _powerBtn.selected = NO;
        _allBtn.selected = YES;
        _envirBtn.selected = NO;
        _level = nil;
        _start_time = nil;
        _end_time = nil;
        NSDictionary  *thisStation2 = @{
                                        @"name":_station_name,
                                        @"alias":_station_name,
                                        @"code":_station_code,
                                        @"airport":self.StationItem[indexPath.row].airport,
                                        @"picture":self.StationItem[indexPath.row].picture,
                                        @"address":self.StationItem[indexPath.row].address,
                                        @"isShow":@"1"
                                        };
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:thisStation2 forKey:@"station"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self stationBtn];
        //选择台站全刷新
        [self loadData];
        //[self.onetableview.mj_header beginRefreshing];
        [self closeFrame];
        
        
        return ;
        
    }
    
    AlarmItems *group = self.AlarmItem[indexPath.row];
    
    if([group.level isEqualToString:@"4"]){
        UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"4级告警无需处理" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/login"];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"alarmInfoId"] = group.id;
            params[@"content"] = @"确认处理完成";
            params[@"content"] = @"completed";
            [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
                NSInteger code = [[result objectForKey:@"errCode"] intValue];
                if(code != 0){
                    [FrameBaseRequest showMessage:[result objectForKey:@"errMsg"]];
                    return ;
                }
                [self loadData];
                //[self.onetableview.mj_header beginRefreshing];
            }  failure:^(NSError *error) {
                NSLog(@"请求失败 原因：%@",error);
//                if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
//                    [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//                    [FrameBaseRequest logout];
//
//                    LoginViewController *login = [[LoginViewController alloc] init];
//                    [self.navigationController pushViewController:login animated:YES];
//                    return;
//                }
                [FrameBaseRequest showMessage:@"网络链接失败"];
                return ;
            } ];
            
            return ;
        }]];
        [self presentViewController:alertContor animated:NO completion:nil];
        
        return ;
    }else{
        AlarmDetailController  *AlarmDetail = [[AlarmDetailController alloc] init];
        AlarmDetail.id = group.id;
        AlarmDetail.station_code = _station_code;
        AlarmDetail.alarmInfo = group;
        [self.navigationController pushViewController:AlarmDetail animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _onetableview || tableView == self.stationTabView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithHexString:kCellHighlightColor];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _onetableview || tableView == self.stationTabView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    }
}

/*台站列表*/
-(void)stationBtn{
    _leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _leftButon.titleLabel.font = FontSize(15);
    [_leftButon setTitle:_station_name forState:UIControlStateNormal];
    CGSize size = [_leftButon.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_leftButon.titleLabel.font,NSFontAttributeName,nil]];
    _leftButon.frame = CGRectMake(0,0,size.width,40);
    //[leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, 17, 0, -17)];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [_leftButon addTarget:self action:@selector(stationAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:_leftButon];
    
    UIButton *leftButon1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FrameWidth(20), FrameWidth(30))];
    [leftButon1 setImage:[UIImage imageNamed:@"station_pulldown"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton1 = [[UIBarButtonItem alloc]initWithCustomView:leftButon1];
    self.navigationItem.leftBarButtonItems = @[ fixedButton,leftBarButton1];
    
    
    UIButton *rightButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightButon setTitle:@"筛选" forState:UIControlStateNormal];
    rightButon.titleLabel.font = FontSize(15);
    rightButon.frame = CGRectMake(0,0,FrameWidth(70),FrameWidth(40));
    //[rightButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    //[rightButon setContentEdgeInsets:UIEdgeInsetsMake(0, - 17, 0, 17)];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [rightButon addTarget:self action:@selector(loadFilterInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButon];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

-(void)stationAction {
    //[self getStationList];
   // if(self.StationItem){
   //     [self getStationList];
   // }else{
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/api/allStationList"];
        NSLog(@"FrameRequestURL %@",FrameRequestURL);
        [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                return ;
            }
            NSMutableArray<StationItems *> * SItem = [[StationItems class] mj_objectArrayWithKeyValuesArray:[result objectForKey:@"value"] ];
            NSMutableArray<StationItems *> * radar = [[StationItems class] mj_objectArrayWithKeyValuesArray:@[@{@"category":@"title",@"alias":@"雷达台站"}]];
            NSMutableArray<StationItems *> * navigation = [[StationItems class] mj_objectArrayWithKeyValuesArray:@[@{@"category":@"title",@"alias":@"导航台站"}]];
            NSMutableArray<StationItems *> * local = [[StationItems class] mj_objectArrayWithKeyValuesArray:@[@{@"category":@"title",@"alias":@"本场"}]];
            NSMutableArray<StationItems *> * shelter = [[StationItems class] mj_objectArrayWithKeyValuesArray:@[@{@"category":@"title",@"alias":@"方舱"}]];
            //[navigation addObject:radar];
            
            for(StationItems *item in SItem){
                
                if([item.category isEqualToString:@"navigation"]){
                    [navigation addObject:item];
                }else if([item.category isEqualToString:@"radar"]){
                    [radar addObject:item];
                }else if([item.category isEqualToString:@"local"]){
                    [local addObject:item];
                }else if([item.category isEqualToString:@"shelter"]){
                    [shelter addObject:item];
                }
            }
            [radar addObjectsFromArray:navigation];
            [radar addObjectsFromArray:local];
            [radar addObjectsFromArray:shelter];
            
            self.StationItem = [radar mutableCopy];
            //NSLog(@"self.StationItemself.StationItem %@", self.StationItem);
            [self getStationList];
            
        } failure:^(NSURLSessionDataTask *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//            if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//                [FrameBaseRequest logout];
//
//                LoginViewController *login = [[LoginViewController alloc] init];
//                [self.navigationController pushViewController:login animated:YES];
//                return;
//            }else if(responses.statusCode == 502){
//
//            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
            
        }];
   // }
    
}


-(void)getStationList{
    float moreheight = FrameWidth(900);
    if(HEIGHT_SCREEN == 812){
        moreheight = -FrameWidth(1100);
    }
    
    UIViewController *vc = [UIViewController new];
    
    vc.view.frame = CGRectMake(0, FrameWidth(128), FrameWidth(320),  moreheight);
    //_vc.view.layer.cornerRadius = 4.0;
    vc.view.layer.masksToBounds = YES;
    UIImageView * xialaImage = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(20),0, FrameWidth(300),  FrameWidth(20))];
    xialaImage.image = [UIImage imageNamed:@"station_pulldown_left"];
    [vc.view addSubview:xialaImage];
    
    float tabelHeight = self.StationItem.count * FrameWidth(56);
    if(tabelHeight > FrameWidth(400)){
        tabelHeight = FrameWidth(400);
    }
    
    UIView *alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, tabelHeight, FrameWidth(300),  FrameWidth(1000))];
    alphaView.userInteractionEnabled = YES;
    UITapGestureRecognizer *viewTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeFrame)];
    [alphaView addGestureRecognizer:viewTapGesture];
    [viewTapGesture setNumberOfTapsRequired:1];
    [vc.view addSubview:alphaView];
    
    //设置滚动
    self.stationTabView = [[UITableView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(20), FrameWidth(300) ,tabelHeight)];
    self.stationTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [vc.view addSubview:self.stationTabView];
    self.stationTabView.dataSource = self;
    self.stationTabView.delegate = self;
    self.stationTabView.separatorStyle = NO;
    [self.stationTabView reloadData];
    
    
    [self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromLeft aligment:CBPopupViewAligmentLeft overlayDismissed:nil];
    
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



-(void)closeFrame{//消失
    
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
}
-(void)loadFilterInfo{
    //此处必须重新请求
    if(_roomList.count > 0 && [_station_code isEqualToString:_roomList[0][@"stationCode"]] ){
        
        [self filterAction];
    }else{
        NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/alarmSelect/%@",_station_code]];
        NSLog(@"FrameRequestURL %@",FrameRequestURL);
        [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                return ;
            }
            _alarmLevel = [result[@"value"][@"alarmLevel"] copy];
            _roomList = [result[@"value"][@"roomList"] copy];
            _alarmStatus = [[NSMutableArray arrayWithObjects:
                             @{@"code":@"removed",@"name":@"已解除"},@{@"code":@"confirmed",@"name":@"处理中"},@{@"code":@"completed",@"name":@"已解决"},@{@"code":@"hangup",@"name":@"挂起"},nil] copy];
            
            
            [self filterAction];
            
        } failure:^(NSURLSessionDataTask *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//            if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//                [FrameBaseRequest logout];
//
//                LoginViewController *login = [[LoginViewController alloc] init];
//                [self.navigationController pushViewController:login animated:YES];
//                return;
//            }else if(responses.statusCode == 502){
//
//            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        }];
    }
    
}

- (void)filterAction {
    _newHeight1=0;
    _newHeight2=0;
    _newHeight3=0;
    _newHeight4=0;
    _ALLtags = [[NSMutableArray alloc]init];
    _typetags = [[NSMutableArray alloc]init];
    _levelTags = [[NSMutableArray alloc]init];
    _vc = [UIViewController new];
    _vc.view.backgroundColor = [UIColor whiteColor];
    
    _vc.view.frame = CGRectMake( FrameWidth(120) , 0,FrameWidth(520), HEIGHT_SCREEN);
    //_vc.view.layer.cornerRadius = 4.0;
    _vc.view.layer.masksToBounds = YES;
    //设置滚动
    self.filterTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, FrameWidth(25), WIDTH_SCREEN -4 , FrameWidth(1050))];
    self.filterTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_vc.view addSubview:self.filterTabView];
    self.filterTabView.dataSource = self;
    self.filterTabView.delegate = self;
    self.filterTabView.separatorStyle = NO;
    [self.filterTabView reloadData];
    
    //设置重置和提交
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [resetBtn setFrame:CGRectMake(0,HEIGHT_SCREEN - FrameWidth(61),
                                  FrameWidth(260),
                                  FrameWidth(61))];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    resetBtn.backgroundColor = [UIColor colorWithRed:85/255.0 green:185/255.0 blue:250/255.0 alpha:1];
    [resetBtn setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:85/255.0 green:185/255.0 blue:250/255.0 alpha:1]] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetBtn.titleLabel setFont:FontSize(15)];
    [resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_vc.view addSubview:resetBtn];
    
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [completeBtn setFrame:CGRectMake(FrameWidth(260),HEIGHT_SCREEN - FrameWidth(61), FrameWidth(260), FrameWidth(61))];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    completeBtn.backgroundColor = [UIColor colorWithRed:30/255.0 green:160/255.0 blue:240/255.0 alpha:1];
    [completeBtn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeBtn.titleLabel setFont:FontSize(15)];
    [completeBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_vc.view addSubview:completeBtn];
    
    
    [self cb_presentPopupViewController:_vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentRight overlayDismissed:nil];
    //[self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentTop overlayDismissed:nil];
    
}


/**
 颜色转图片
 
 @param color 颜色
 @return 图片
 */
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


-(void)resetAction{
    [self.levelBtn setSelected:false];
    [self.statusBtn setSelected:false];
    [self.roomBtn setSelected:false];
    [_endDate setTitle:@"结束日期" forState:UIControlStateNormal];
    [_startDate setTitle:@"开始日期" forState:UIControlStateNormal];
}
-(void)submitAction{
    if(self.levelBtn.tag > 0 &&self.levelBtn.isSelected){
        _levelSelect = _alarmLevel[self.levelBtn.tag-50][@"code"];
    }else{
        _levelSelect = nil;
    }
    if(self.roomBtn.tag > 0&&self.roomBtn.isSelected){
        _roomSelect = _roomList[self.roomBtn.tag-1][@"code"];
    }else{
        _roomSelect = nil;
    }
    if(self.statusBtn.tag > 0&&self.statusBtn.isSelected){
        _statusSelect = _alarmStatus[self.statusBtn.tag-100][@"code"];
    }else{
        _statusSelect = nil;
    }
    
    _engine_room_code = _roomSelect;
    if([_statusSelect isEqualToString:@"hangup"]){
        _hangup_status = @"true";
        _status = nil;
    }else{
        _hangup_status = nil;
        _status = _statusSelect;
    }
    
    _level = _levelSelect;
    _start_time = ![_startDate.titleLabel.text isEqualToString:@"开始日期"]?_startDate.titleLabel.text:nil;
    _end_time = ![_endDate.titleLabel.text isEqualToString:@"结束日期"]?_endDate.titleLabel.text:nil;
    [self closeFrame];
    [self loadData];
}

-(CGFloat) setFilterBtn :(UITableViewCell *)vc objects:(NSArray *)objects title:(NSString *)title  {
    CGFloat Thisheight = FrameWidth(10)+_newHeight1+_newHeight2+_newHeight3;
    
    //设置标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( FrameWidth(30),Thisheight, FrameWidth(300) , FrameWidth(90))];
    titleLabel.text = title;
    //titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.textColor = [UIColor grayColor];
    [titleLabel setFont:FontSize(17)];
    [vc addSubview:titleLabel];
    
    //设置按钮
    const NSInteger countPerRow = 3;
    NSInteger rowCount = (objects.count + (countPerRow - 1)) / countPerRow;
    CGFloat horizontalPadding = FrameWidth(10);
    CGFloat verticalPadding = FrameWidth(13);
    
    UIView *containerView = [UIView new];
    
        containerView.frame = CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height, FrameWidth(470), rowCount*FrameWidth(70));
        containerView.center = CGPointMake(0.5* FrameWidth(520), containerView.frame.size.height/2+titleLabel.frame.origin.y+titleLabel.frame.size.height);
    [self.view addSubview:containerView];
    
    CGFloat buttonWidth = (containerView.bounds.size.width - horizontalPadding * (countPerRow - 1)) / countPerRow;
    //CGFloat buttonHeight = (containerView.bounds.size.height - verticalPadding * rowCount) / rowCount;
    NSMutableArray *heights = [NSMutableArray new];
    for (int i=0; i<objects.count; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping ;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if(objects[i][@"alias"] != nil){
            [button setTitle:[NSString stringWithFormat:@"%@",objects[i][@"alias"]] forState:UIControlStateNormal];
        }else{
            [button setTitle:[NSString stringWithFormat:@"%@",objects[i][@"name"]] forState:UIControlStateNormal];
        }
        
        CGFloat buttonHeight =  [CommonExtension heightForString:button.titleLabel.text fontSize:FontSize(14) andWidth:buttonWidth] +FrameWidth(20);
        if(heights.count <=  (i / countPerRow)){
            [heights addObject:[NSString stringWithFormat:@"%f",buttonHeight]];
        }else if([heights[i / countPerRow] floatValue] < buttonHeight){
            heights[i / countPerRow] = [NSString stringWithFormat:@"%f",buttonHeight];
        }
        float buttony = 0;
        for (int a=0; a<heights.count-1; ++a) {
            buttony += ([heights[a] floatValue] + verticalPadding);
        }
        [button setFrame:CGRectMake((buttonWidth + horizontalPadding) * (i % countPerRow),
                                    buttony,
                                    buttonWidth,
                                    buttonHeight)];
        [containerView setFrameHeight:button.originY + button.frameHeight + FrameWidth(20)];
        
        
        if(_newHeight1 == 0){
            button.tag = i+1;
            if([_roomSelect isEqualToString:objects[i][@"code"] ]){
                [button setSelected:YES];
                self.roomBtn = button;
            }
            
            [_ALLtags addObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
        }
        if(_newHeight1 > 0&&_newHeight2 == 0){
            button.tag =i+50;
            if([_levelSelect isEqualToString:objects[i][@"code"] ]){
                [button setSelected:YES];
                
                self.levelBtn = button;
            }
            [_levelTags addObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
        }
        if(_newHeight1 > 0&&_newHeight2 > 0&&_newHeight3 == 0){
            button.tag = i+100;
            if([_statusSelect isEqualToString:objects[i][@"code"] ]){
                [button setSelected:YES];
                
                self.statusBtn  = button;
            }
            [_typetags addObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
        }
        //button.backgroundColor = QianGray;
        [button setBackgroundImage:[UIImage imageNamed:@"Patrol_btn"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"Patrol_btn_s"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.layer.cornerRadius = 5.0;
        //[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:FontSize(15)];
        //button.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        //button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [containerView addSubview:button];
    }
    if([_confirme_status isEqualToString:@"unconfirmed"]&&_newHeight2 > 0){//如果是未确认，则需要不显示状态选择栏
        titleLabel.frame = CGRectMake(0, 0, 0, 0);
        containerView.frame = CGRectMake(0, 0, 0, 0);
        [containerView setHidden:YES];
        [titleLabel setHidden:YES];
    }
    
    
    [vc addSubview:containerView];
    //告警类别添加完，添加告警日期
    if(_newHeight2 >0){
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake( 0,Thisheight+FrameWidth(20), FrameWidth(520) , 1)];
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake( 0,Thisheight+FrameWidth(20)+containerView.frame.size.height+titleLabel.frame.size.height, FrameWidth(520) ,1)];
        lineView.backgroundColor = QianGray;
        lineView2.backgroundColor = QianGray;
        [vc addSubview:lineView];
        [vc addSubview:lineView2];
        
        
        
        //设置告警日期标题
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake( FrameWidth(30),Thisheight+containerView.frame.size.height+titleLabel.frame.size.height, FrameWidth(300) , FrameWidth(90))];
        dateLabel.text = @"告警时间";
        
        //dateLabel.backgroundColor = [UIColor redColor];
        dateLabel.textColor = [UIColor grayColor];
        [dateLabel setFont:FontSize(17)];
        [vc addSubview:dateLabel];
        
        UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake( FrameWidth(30),dateLabel.frame.origin.y+dateLabel.frame.size.height, FrameWidth(480) , FrameWidth(60))];
        dateView.backgroundColor = QianGray;
        [vc addSubview:dateView];
        
        _startDate = [[UIButton alloc]initWithFrame:CGRectMake( 5,FrameWidth(10), FrameWidth(215) , FrameWidth(40))];
        
        if(_start_time){
            [_startDate setTitle:_start_time forState:UIControlStateNormal];
        }else{
            [_startDate setTitle:@"开始日期" forState:UIControlStateNormal];
        }
        [_startDate.titleLabel setFont:FontSize(15)];
        [_startDate setTitleEdgeInsets:UIEdgeInsetsMake(0, FrameWidth(8), 0, -FrameWidth(8))];//上左下右
        [_startDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //startDate.titleLabel.textAlignment = NSTextAlignmentLeft;
        _startDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //startDate.titleLabel.textColor = [UIColor grayColor];
        _startDate.backgroundColor = [UIColor whiteColor];
        [_startDate addTarget:self action:@selector(startDateAction) forControlEvents:UIControlEventTouchUpInside];
        [dateView addSubview:_startDate];
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(_startDate.frame.origin.x + _startDate.frame.size.width+5, FrameWidth(28), FrameWidth(23), 4)];
        lineView3.backgroundColor = [UIColor grayColor];
        
        [dateView addSubview:lineView3];
        
        _endDate = [[UIButton alloc]initWithFrame:CGRectMake( FrameWidth(260),FrameWidth(10), FrameWidth(215) ,FrameWidth(40))];
        //[_endDate setTitle:@"结束日期" forState:UIControlStateNormal];
        if(_end_time){
            [_endDate setTitle:_end_time forState:UIControlStateNormal];
        }else{
            [_endDate setTitle:@"结束日期" forState:UIControlStateNormal];
        }
        [_endDate.titleLabel setFont:FontSize(15)];
        // [_endDate setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, FrameWidth(260))];
        [_endDate setTitleEdgeInsets:UIEdgeInsetsMake(0, FrameWidth(8), 0, -FrameWidth(8))];//上左下右
        [_endDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _endDate.backgroundColor = [UIColor whiteColor];
        //_endDate = [UIColor grayColor];
        //_endDate = NSTextAlignmentLeft;
        _endDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_endDate addTarget:self action:@selector(endDateAction) forControlEvents:UIControlEventTouchUpInside];
        [dateView addSubview:_endDate];
        _newHeight4 = dateLabel.frame.size.height +  dateView.frame.size.height ;
        
        [containerView setFrameHeight:containerView.frameHeight + dateView.frameHeight +  dateLabel.frameHeight];
        
        
        
    }
    //返回设置的高度
    return containerView.frame.size.height+titleLabel.frame.size.height;
}


- (void)tapButton:(UIButton *)button{
    
    [button setSelected:true];
    if (button.isSelected) {
        if(button.tag >= 100){//[objects[key]
            for (NSInteger i=0; i<_typetags.count; i++) {
                if(button.tag != [_typetags[i] intValue]){
                    UIButton *thisBtn = [_vc.view viewWithTag:[_typetags[i] intValue] ];
                    thisBtn.selected = false;
                }
            }
            self.statusBtn = button;
        }else if(button.tag >= 50 &&button.tag < 100){
            NSLog(@"button.tag%ld::%@",(long)button.tag,_levelTags);
            for (NSInteger i=0; i<_levelTags.count; i++) {
                if(button.tag != [_levelTags[i] intValue]){
                    UIButton *thisBtn = [_vc.view viewWithTag:[_levelTags[i] intValue] ];
                    thisBtn.selected = false;
                }
            }
            self.levelBtn = button;
        }else{
            NSLog(@"button.tag%ld::%@",(long)button.tag,_ALLtags);
            for (NSInteger i=0; i<_ALLtags.count; i++) {
                if(button.tag != [_ALLtags[i] intValue]){
                    UIButton *thisBtn = [_vc.view viewWithTag:[_ALLtags[i] intValue] ];
                    thisBtn.selected = false;
                }
            }
            
            self.roomBtn = button;
        }
        
    } else{
        if(button.tag >= 100){
            _statusSelect = nil;
        }else if(button.tag >= 50 &&button.tag < 100){
            _levelSelect = nil;
        }else{
            _roomSelect = nil;
        }
        //normal
        
        //[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_checkbox_normal.png"]] forState:UIControlStateNormal];
        
        //[button setTitle:@"点我" forState:UIControlStateNormal];
        
        //[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        //[button setBackgroundColor:QianGray];
    }
    
}

-(void)startDateAction{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    _startDatePicker = datePickManager.datePicker;
    
    _startDatePicker.delegate = self;
    _startDatePicker.datePickerType = PGPickerViewLineTypeline;
    _startDatePicker.isHiddenMiddleText = false;
    //_startDatePicker.maximumDate = [NSDate date];
    _startDatePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
    
}
-(void)endDateAction{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    _endDatePicker = datePickManager.datePicker;
    _endDatePicker.delegate = self;
    _endDatePicker.datePickerType = PGPickerViewLineTypeline;
    _endDatePicker.isHiddenMiddleText = false;
    
    //_endDatePicker.minimumDate = [[NSDate date] earlierDate:_NstartDate];
    //_endDatePicker.maximumDate =  [[NSDate date] earlierDate:_NstartDate];
    _endDatePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
    
}
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyy-MM-dd";
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    // 时间转为字符串
    NSString *dateStr = [formatter stringFromDate:[calendar dateFromComponents:dateComponents]];
    //NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day];
    
    NSLog(@"%@:::%@:::%@",[calendar dateFromComponents:dateComponents],_NstartDate,_NendDate);
    if(datePicker == _endDatePicker){
        if(![[calendar dateFromComponents:dateComponents] isEqualToDate:_NstartDate] &&[[calendar dateFromComponents:dateComponents] laterDate:_NstartDate] == _NstartDate&&_NstartDate != nil){
            [_endDate setTitle:@"结束时间" forState:UIControlStateNormal];
            [FrameBaseRequest showMessage:@"开始时间不能大于结束时间"];
            return ;
        }
        
        
        _NendDate = [calendar dateFromComponents:dateComponents];
        [_endDate setTitle:dateStr forState:UIControlStateNormal];
        
    }
    if(datePicker == _startDatePicker){
        
        if(![_NendDate isEqualToDate:[calendar dateFromComponents:dateComponents]]&&[_NendDate laterDate:[calendar dateFromComponents:dateComponents]] == [calendar dateFromComponents:dateComponents]&&_NendDate != nil){
            [_startDate setTitle:@"开始时间" forState:UIControlStateNormal];
            [FrameBaseRequest showMessage:@"开始时间不能大于结束时间"];
            return ;
        }
        
        
        _NstartDate = [calendar dateFromComponents:dateComponents];
        [_startDate setTitle:dateStr forState:UIControlStateNormal];
        
    }
}

@end


