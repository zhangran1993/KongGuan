//
//  PatrolHistoryController.m
//  Frame
//
//  Created by hibayWill on 2018/3/24.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PatrolHistoryController.h"
#import "FrameBaseRequest.h"
#import "PatrolHistoryCell.h"
#import "StationItems.h"
#import "Patroltems.h"
#import "PGDatePickManager.h"
#import "PatrolSetShowController.h"
#import <MJExtension.h>
#import <Foundation/Foundation.h>
#import "UIView+LX_Frame.h"
//#import <UIImageView+WebCache.h>
#import "SearchView.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "HSIEmptyDataSetView.h"
#import "UIScrollView+EmptyDataSet.h"
@interface PatrolHistoryController ()<UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate,SearchViewDelegeat,EmptyDataSetDelegate>{
}

@property (strong, nonatomic) NSMutableArray<Patroltems *> * Patroltem;
@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;
@property(strong,nonatomic)UITableView *stationTabView;
@property(strong,nonatomic)UITableView *filterTabView;
@property NSMutableArray *radarList;
@property NSMutableArray *navigatioList;
@property NSMutableArray *localList;
@property NSMutableArray *typeList;
@property(strong,nonatomic)UIViewController *vc;
@property NSUInteger newHeight1;
@property NSUInteger newHeight2;
@property NSUInteger newHeight3;
@property NSUInteger newHeight4;
@property NSUInteger newHeight5;
@property(strong,nonatomic)PGDatePicker *startDatePicker;
@property(strong,nonatomic)PGDatePicker *endDatePicker;

@property(strong,nonatomic)UIButton *stationBtn;
@property(strong,nonatomic)UIButton *typeBtn;
@property(strong,nonatomic)UIButton *startDate;
@property(strong,nonatomic)UIButton *endDate;

@property NSDate *NstartDate;
@property NSDate *NendDate;
@property (assign, nonatomic) NSString* start_time;
@property (assign, nonatomic) NSString* end_time;
@property NSString* stationSelect;
@property NSString* typeSelect;
@property NSMutableArray *objects;
@property NSMutableArray *objects1;
@property NSMutableArray *objects2;
@property NSMutableArray *objects0;
@property NSMutableArray *objects01;
@property NSMutableArray *objects02;
@property NSMutableArray *ALLtags;
@property NSMutableArray *typetags;

@property int pageNum;

@property int pageSize;
@property   double hasMore;
@property (nonatomic, strong)SearchView *searchView;
@property (nonatomic, strong)NSString *searchText;

@end

@implementation PatrolHistoryController

//static NSString * const reuseIdentifier = @"Cell";

static NSString * const FrameCellID = @"PatrolHistory";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBtn];
    [self loadBgView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNotificationAction) name:kNetworkStatusNotification object:nil];
    self.typeBtn = [UIButton new];
    self.stationBtn = [UIButton new];
    //[self loadData];
    
}

/**
 监听网络
 */
- (void)resetNotificationAction {
    if (!IsNetwork) {
        self.Patroltem = nil;
        [self.stationTabView reloadData];
    } else {
        [self loadData];
    }
}

-(void)loadBgView{//设置台站列表内容
    self.title = @"历史巡查";
    //背景色
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    self.searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 55)];
    self.searchView.delegeat = self;
    [self.view addSubview:self.searchView];
    
    _stationTabView = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.searchView.frame)+10 , WIDTH_SCREEN -4 , View_Height-self.searchView.lx_height-self.navigationController.navigationBar.frame.size.height)];
    _stationTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _stationTabView.tableFooterView.frame = CGRectMake(0, 0, WIDTH_SCREEN -4 , FrameWidth(30));
    
    [self.view addSubview:_stationTabView];
    _stationTabView.dataSource = self;
    _stationTabView.delegate = self;
//    _stationTabView.emptyDataSetDelegate = self;
    _stationTabView.estimatedRowHeight = 0;
    _stationTabView.estimatedSectionHeaderHeight = 0;
    _stationTabView.estimatedSectionFooterHeight = 0;
    
    _stationTabView.separatorStyle = NO;
    // 注册重用Cell
    [_stationTabView registerNib:[UINib nibWithNibName:NSStringFromClass([PatrolHistoryCell class]) bundle:nil] forCellReuseIdentifier:FrameCellID];//cell的class
    // 头部刷新控件
    _stationTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_stationTabView.mj_header beginRefreshing];
    
    // 尾部刷新控件
    _stationTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    return ;
}

#pragma mark--点击搜索
- (void)startSearch:(NSString *)searchFieldText {
    self.searchText = searchFieldText;
    [self loadData];
}

-(void)loadData{
    
    self.pageNum = 1;
    self.pageSize = 30;
    _hasMore = true ;
    [self loadMoreData];
}

/**
 *  加载更多数据
 */
- (void)loadMoreData{//获取台站数据
    if(!_hasMore){
        [_stationTabView.mj_header endRefreshing];
        [_stationTabView.mj_footer endRefreshing];
        //_stationTabView.mj_footer.state = MJRefreshStateNoMoreData;
        return ;
    }
    NSLog(@"loadMoreData %d",self.pageNum);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type_code"] = _typeSelect;
    params[@"station_code"] = _stationSelect;
    params[@"start_time"] = _start_time;
    params[@"end_time"] = _end_time;
    
    
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/atcPatrolRecodeList/%d/%d",self.pageNum,self.pageSize]];
    if (self.searchText.length > 0) {
        params[@"description"] = self.searchText;
       // FrameRequestURL = [NSString stringWithFormat:@"%@?description=%@",FrameRequestURL,self.searchText];
       // FrameRequestURL = [FrameRequestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    
    
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params  success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            _stationTabView.emptyDataSetDelegate = self;
            [_stationTabView reloadData];
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if(self.pageNum == 1){
            self.Patroltem = [[Patroltems class] mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"] ];
            if(self.Patroltem.count < self.pageSize){
                _hasMore = false;
            }else{
                self.pageNum ++;
            }
        }else{
            NSArray *array = [Patroltems mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
            if(array.count < self.pageSize){
                _hasMore = false;
            }else{
                self.pageNum ++;
            }
            [self.Patroltem addObjectsFromArray:array];
        }
        
        _stationTabView.emptyDataSetDelegate = self;
        [_stationTabView reloadData];
        [_stationTabView.mj_header endRefreshing];
        [_stationTabView.mj_footer endRefreshing];
        if(self.Patroltem.count > 0){
            // _stationTabView.mj_footer.state = MJRefreshStateNoMoreData;//;
        }else{
            // _stationTabView.mj_footer.state = MJRefreshStateNoData;//MJRefreshStateNoMoreData;
        }
    } failure:^(NSURLSessionDataTask *error)  {
        _stationTabView.emptyDataSetDelegate = self;
        [_stationTabView reloadData];
        [_stationTabView.mj_header endRefreshing];
        [_stationTabView.mj_footer endRefreshing];
        //_stationTabView.mj_footer.state = MJRefreshStateNoMoreData;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _stationTabView){
        return FrameWidth(130)  ;
    }else{//如果是筛选的列表，则判断高度决定cell高度
        NSInteger HEIGHT = _newHeight1+_newHeight2+_newHeight3+_newHeight4+_newHeight5;
        if(HEIGHT > tableView.frameHeight){
            return HEIGHT;
        }
        return tableView.frameHeight;
    }
    return FrameWidth(130);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _stationTabView){
        return self.Patroltem.count;
    }else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _stationTabView){
        
        PatrolHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:FrameCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        Patroltems *item = self.Patroltem[indexPath.row];
        cell.Patroltem = item;
        return cell;
    }
    
    
    if(tableView == _filterTabView){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        //cell.backgroundColor = [UIColor cyanColor];
        
        self.typeList = [@[
                           @{
                               @"alias":@"例行巡查",
                               @"code":@"routine",
                               @"typeCode":@"routine"
                               
                               },
                           @{
                               @"alias":@"全面巡查",
                               @"code":@"comprehensive",
                               @"typeCode":@"comprehensive"
                               
                               },
                           @{
                               @"alias":@"特殊巡查",
                               @"code":@"special",
                               @"typeCode":@"special"
                               
                               }
                           ] mutableCopy];
        
        _newHeight1 = [self setFilterBtn:cell objects:self.navigatioList title:@"导航台站"];
        if(_newHeight1 > 0){
            _newHeight2 = [self setFilterBtn:cell objects:self.radarList title:@"雷达台站"];
            if(_newHeight2 > 0){
                _newHeight3 = [self setFilterBtn:cell objects:self.localList title:@"本场"];
                if(_newHeight3 > 0){
                    _newHeight4 = [self setFilterBtn:cell objects:self.typeList title:@"巡查类别"];
                }
            }
        }
        return cell;
        
    }else{
        UITableViewCell  * cell = [UITableViewCell alloc];
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    
    
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    if(tableView == _filterTabView){
        return ;
    }
    
    Patroltems * item = self.Patroltem[indexPath.row];
    PatrolSetShowController  *PatrolSetShow = [[PatrolSetShowController alloc] init];
    PatrolSetShow.stationCode = item.stationCode;
    PatrolSetShow.id = item.id;
    PatrolSetShow.type_code = item.typeCode;//comprehensive//special
    [self.navigationController pushViewController:PatrolSetShow animated:YES];
    
}

-(void)stationAction {
    //[self getStationList];
    if(self.navigatioList){
        [self filterAction];
    }else{
        NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/getClassifyStation"];
        NSLog(@"%@",FrameRequestURL);
        [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                return ;
            }
            NSMutableArray * navigatio = [NSMutableArray array];
            NSMutableArray * radar = [NSMutableArray array];
            NSMutableArray * local = [NSMutableArray array];
            
            
            NSArray *StationList = [result objectForKey:@"value"];
            
            for (int i = 0; i < StationList.count; i++) {
                NSMutableArray *stations = StationList[i][@"stationList"];
                if([StationList[i][@"code"] isEqualToString:@"radar"]){
                    [radar addObjectsFromArray:stations];
                }
                if([StationList[i][@"code"] isEqualToString:@"navigation"]){
                    [navigatio addObjectsFromArray:stations];
                    
                }
                if([StationList[i][@"code"] isEqualToString:@"local"]){
                    [local addObjectsFromArray:stations];
                    
                }
            }
            self.navigatioList = [navigatio copy];
            self.radarList = [radar copy];
            self.localList = [local copy];
            
            [self filterAction];
            
        } failure:^(NSURLSessionDataTask *error)  {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//            if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//                [FrameBaseRequest logout];
//                UIViewController *viewCtl = self.navigationController.viewControllers[0];
//                [self.navigationController popToViewController:viewCtl animated:YES];
//                return;
//            }else if(responses.statusCode == 502){
//
//            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
            
        }];
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

- (void)filterAction {
    _newHeight1=0;
    _newHeight2=0;
    _newHeight3=0;
    _newHeight4=0;
    _newHeight5=0;
    _ALLtags = [[NSMutableArray alloc]init];
    _typetags = [[NSMutableArray alloc]init];
    _vc = [UIViewController new];
    _vc.view.backgroundColor = [UIColor whiteColor];
    
    _vc.view.frame = CGRectMake(FrameWidth(120), 0, FrameWidth(520), HEIGHT_SCREEN);
    //_vc.view.layer.cornerRadius = 4.0;
    _vc.view.layer.masksToBounds = YES;
    //设置滚动
    _filterTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, FrameWidth(25), WIDTH_SCREEN -4 , FrameWidth(1050))];
    _filterTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_vc.view addSubview:_filterTabView];
    _filterTabView.dataSource = self;
    _filterTabView.delegate = self;
    [_filterTabView reloadData];
    
    //设置重置和提交
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //   FrameWidth(1075)
    [resetBtn setFrame:CGRectMake(0,HEIGHT_SCREEN - FrameWidth(61),
                                  FrameWidth(260),
                                  FrameWidth(61))];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    //resetBtn.layer.cornerRadius = 5.0;
    resetBtn.backgroundColor = [UIColor colorWithRed:85/255.0 green:185/255.0 blue:250/255.0 alpha:1];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[resetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [resetBtn.titleLabel setFont:FontSize(14)];
    [resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_vc.view addSubview:resetBtn];
    
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [completeBtn setFrame:CGRectMake(FrameWidth(260),HEIGHT_SCREEN - FrameWidth(61),
                                     FrameWidth(260),
                                     FrameWidth(61))];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    //completeBtn.layer.cornerRadius = 5.0;
    [completeBtn setBackgroundColor:[UIColor colorWithRed:30/255.0 green:160/255.0 blue:240/255.0 alpha:1]];
    //completeBtn.backgroundColor = [UIColor colorWithRed:30 green:160 blue:240 alpha:1];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[completeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [completeBtn.titleLabel setFont:FontSize(14)];
    [completeBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_vc.view addSubview:completeBtn];
    
    
    [self cb_presentPopupViewController:_vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentRight overlayDismissed:nil];
    //[self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentTop overlayDismissed:nil];
    
}

-(CGFloat) setFilterBtn :(UITableViewCell *)vc objects:(NSArray *)objects title:(NSString *)title  {
    CGFloat Thisheight = FrameWidth(10)+_newHeight1+_newHeight2+_newHeight3;
    
    //设置标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( FrameWidth(30),Thisheight, FrameWidth(300) , FrameWidth(90))];
    titleLabel.text = title;
    //titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font =  FontSize(17);
    [vc addSubview:titleLabel];
    
    //设置按钮
    const NSInteger countPerRow = 3;
    NSInteger rowCount = (objects.count + (countPerRow - 1)) / countPerRow;
    CGFloat horizontalPadding = FrameWidth(10);
    CGFloat verticalPadding = FrameWidth(9);
    UIView *containerView = [UIView new];
    containerView.frame = CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height, FrameWidth(470), FrameWidth(70)*rowCount);
    containerView.center = CGPointMake(FrameWidth(260), containerView.frame.size.height/2+titleLabel.frame.origin.y+titleLabel.frame.size.height);
    [self.view addSubview:containerView];
    
    CGFloat buttonWidth = (containerView.frame.size.width - horizontalPadding * (countPerRow - 1)) / countPerRow;
    NSMutableArray *heights = [NSMutableArray new];
    for (int i=0; i<objects.count; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:objects[i][@"alias"] forState:UIControlStateNormal];
        
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
            [_ALLtags addObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
            if([_stationSelect isEqualToString:objects[i][@"code"] ]){
                [button setSelected:YES];
                self.stationBtn = button;
            }
        }
        if(_newHeight1 > 0&&_newHeight2 == 0){
            button.tag =i+50;
            [_ALLtags addObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
            if([_stationSelect isEqualToString:objects[i][@"code"] ]){
                [button setSelected:YES];
                self.stationBtn = button;
            }
        }
        if(_newHeight1 > 0&&_newHeight2 > 0&&_newHeight3 == 0){
            button.tag = i+100;
            [_ALLtags addObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
            if([_stationSelect isEqualToString:objects[i][@"code"] ]){
                [button setSelected:YES];
                self.stationBtn = button;
            }
        }
        if(_newHeight1 > 0&&_newHeight2 > 0&&_newHeight3 > 0 &&_newHeight4 == 0){
            button.tag = i+200;
            [_typetags addObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
            if([_typeSelect isEqualToString:objects[i][@"code"] ]){
                [button setSelected:YES];
                self.typeBtn = button;
            }
        }
        [button setBackgroundImage:[UIImage imageNamed:@"Patrol_btn"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"Patrol_btn_s"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button.titleLabel setFont:FontSize(14)];
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        //[button sizeToFit];
        //[button setTitleEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        button.titleLabel.adjustsFontForContentSizeCategory = YES;
        [containerView addSubview:button];
        
    }
    [vc addSubview:containerView];
    //巡查类别添加完，添加巡查日期
    if(_newHeight3 >0){
        //containerView.layer.borderColor = QianGray.CGColor;
        // containerView.layer.borderWidth = 1;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake( 0,Thisheight+FrameWidth(20), FrameWidth(520) , 1)];
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake( 0,Thisheight+FrameWidth(20)+containerView.frame.size.height+titleLabel.frame.size.height,FrameWidth(520) , 1)];
        lineView.backgroundColor = QianGray;
        lineView2.backgroundColor = QianGray;
        [vc addSubview:lineView];
        [vc addSubview:lineView2];
        
        
        
        //设置巡查日期标题
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake( FrameWidth(30),Thisheight+containerView.frame.size.height+titleLabel.frame.size.height, FrameWidth(300) , FrameWidth(90))];
        dateLabel.text = @"巡查日期";
        dateLabel.textColor = [UIColor grayColor];
        [dateLabel setFont:FontSize(17)];
        [vc addSubview:dateLabel];
        
        UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake( FrameWidth(30),dateLabel.frame.origin.y+dateLabel.frame.size.height, FrameWidth(480) , FrameWidth(60))];
        dateView.backgroundColor = QianGray;
        [vc addSubview:dateView];
        
        _startDate = [[UIButton alloc]initWithFrame:CGRectMake( FrameWidth(5),FrameWidth(10), FrameWidth(215), FrameWidth(40))];
        if(_start_time){
            [_startDate setTitle:_start_time forState:UIControlStateNormal];
        }else{
            [_startDate setTitle:@"开始日期" forState:UIControlStateNormal];
        }
        [_startDate setTitleEdgeInsets:UIEdgeInsetsMake(0, FrameWidth(8), 0, -FrameWidth(8))];//上左下右
        [_startDate.titleLabel setFont:FontSize(15)];
        [_startDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //_startDate = NSTextAlignmentLeft;
        _startDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //startDate.titleLabel.textColor = [UIColor grayColor];
        _startDate.backgroundColor = [UIColor whiteColor];
        [_startDate addTarget:self action:@selector(startDateAction) forControlEvents:UIControlEventTouchUpInside];
        [dateView addSubview:_startDate];
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(_startDate.frame.origin.x+_startDate.frame.size.width+5, FrameWidth(28), FrameWidth(23), 4)];
        lineView3.backgroundColor = [UIColor grayColor];
        
        [dateView addSubview:lineView3];
        
        _endDate = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(260),FrameWidth(10), FrameWidth(215), FrameWidth(40))];
        
        if(_end_time){
            [_endDate setTitle:_end_time forState:UIControlStateNormal];
        }else{
            [_endDate setTitle:@"结束日期" forState:UIControlStateNormal];
        }
        [_endDate.titleLabel setFont:FontSize(15)];
        [_endDate setTitleEdgeInsets:UIEdgeInsetsMake(0, FrameWidth(8), 0, -FrameWidth(8))];//上左下右
        [_endDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _endDate.backgroundColor = [UIColor whiteColor];
        //endDate.titleLabel.textColor = [UIColor grayColor];
        //endDate.titleLabel.textAlignment = NSTextAlignmentLeft;
        _endDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_endDate addTarget:self action:@selector(endDateAction) forControlEvents:UIControlEventTouchUpInside];
        [dateView addSubview:_endDate];
        _newHeight5 = dateView.frameHeight +  dateLabel.frameHeight ;
        [containerView setFrameHeight:containerView.frameHeight + dateView.frameHeight ];
        
        
    }
    
    //返回设置的高度
    return containerView.frame.size.height+titleLabel.frame.size.height;
}

- (void)tapButton:(UIButton *)button{
    
    [button setSelected:true];
    //[button setSelected:!button.isSelected];
    
    if (button.isSelected) {
        if(button.tag >= 200){//[objects[key]
            
            for (NSInteger i=0; i<_typetags.count; i++) {
                if(button.tag != [_typetags[i] intValue]){
                    UIButton *thisBtn = [_vc.view viewWithTag:[_typetags[i] intValue] ];
                    NSLog(@"%@----%ld",thisBtn.titleLabel.text,(long)i);
                    thisBtn.selected = false;
                }
            }
            _typeSelect = self.typeList[button.tag-200][@"code"];
            self.typeBtn = button;
        }else{
            for (NSInteger i=0; i<_ALLtags.count; i++) {
                if(button.tag != [_ALLtags[i] intValue]){
                    UIButton *thisBtn = [_vc.view viewWithTag:[_ALLtags[i] intValue] ];
                    thisBtn.selected = false;
                }
            }
            
            
            long tagnum = 0;
            
            if(button.tag >= 100){
                tagnum = button.tag -100;
                self.stationBtn = button;
                _stationSelect = self.localList[tagnum][@"code"];
                return ;
            }
            if(button.tag >= 50){
                tagnum = button.tag-50;
                self.stationBtn = button;
                _stationSelect = self.radarList[tagnum][@"code"];
                return ;
                
            }
            if(button.tag >= 1){
                tagnum = button.tag-1;
                self.stationBtn = button;
                _stationSelect = self.navigatioList[tagnum][@"code"];
                return ;
            }
            
        }
        //[button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        //[button setBackgroundColor:[UIColor colorWithRed:30/255.0 green:160/255.0 blue:240/255.0 alpha:1]];
    } else{
        if(button.tag >= 200){
            _typeSelect = nil;
        }else{
            _stationSelect = nil;
        }
    }
    
}

-(void)startDateAction{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    _startDatePicker = datePickManager.datePicker;
    _startDatePicker.delegate = self;
    _startDatePicker.datePickerType = PGPickerViewLineTypeline;
    _startDatePicker.isHiddenMiddleText = false;
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
    
    
    UIButton *rightButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButon.frame = CGRectMake(0,0,FrameWidth(70),FrameWidth(40));
    [rightButon setTitle:@"筛选" forState:UIControlStateNormal];
    rightButon.titleLabel.font = FontSize(15);
    [rightButon addTarget:self action:@selector(stationAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButon];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}
-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)closeFrame{
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
    
}
-(void)resetAction{
    
    [self.stationBtn setSelected:false];
    [self.typeBtn setSelected:false];
    [_endDate setTitle:@"结束日期" forState:UIControlStateNormal];
    [_startDate setTitle:@"开始日期" forState:UIControlStateNormal];
    
}
-(void)submitAction{
    long tagnum = 0;
    if(self.stationBtn.tag >= 100&&self.stationBtn.isSelected){
        tagnum = self.stationBtn.tag -100;
        _stationSelect = self.localList[tagnum][@"code"];
    }else if(self.stationBtn.tag >= 50&&self.stationBtn.isSelected){
        tagnum = self.stationBtn.tag-50;
        _stationSelect = self.radarList[tagnum][@"code"];
        
    }else if(self.stationBtn.tag >= 1&&self.stationBtn.isSelected){
        tagnum = self.stationBtn.tag-1;
        _stationSelect = self.navigatioList[tagnum][@"code"];
    }else{
         _stationSelect = nil;
    }
    
    if(self.typeBtn.tag >= 200&&self.typeBtn.isSelected){
        _typeSelect = self.typeList[self.typeBtn.tag-200][@"code"];
    }else{
        _typeSelect = nil;
    }
    
    
    _start_time = ![_startDate.titleLabel.text isEqualToString:@"开始日期"]?_startDate.titleLabel.text:nil;
    _end_time = ![_endDate.titleLabel.text isEqualToString:@"结束日期"]?_endDate.titleLabel.text:nil;
    [self closeFrame];
    
    [self loadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
