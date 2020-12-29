//
//  PersonalMsgListController.m
//  Frame
//
//  Created by hibayWill on 2018/3/31.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PersonalMsgListController.h"
#import "FrameBaseRequest.h"
#import <UIImageView+WebCache.h>
#import "MsgItems.h"
#import "HSIEmptyDataSetView.h"
#import "UIScrollView+EmptyDataSet.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIColor+Extension.h"
#import "KG_MyMessageDetailCell.h"

#import "KG_YujingDetailCell.h"
#import "KG_GonggaoDetailCell.h"
#import "KG_GaojingDetailCell.h"
@interface PersonalMsgListController ()<UITableViewDataSource,UITableViewDelegate,EmptyDataSetDelegate>

@property (strong, nonatomic) NSMutableArray<MsgItems *> * msgList;
@property BOOL isRefresh;
/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property   int viewnum;
@property (nonatomic,copy) NSString* type;
@property (nonatomic,copy) NSString* putType;
@property (nonatomic,copy) NSString* imgType;

@property (nonatomic,copy) NSString* litpic;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign)  double hasMore;

@property(nonatomic) UITableView *tableview;


@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;

@property (nonatomic, strong)  UIButton *deleteButon;
@property (nonatomic, strong)  UIButton *yiduButon;
@end

@implementation PersonalMsgListController

#pragma mark - 全局常量



#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createNaviTopView];
    
    self.navigationItem.title = _thistitle;//详情
    [self setupTable];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"PersonalMsgListController viewWillAppear");
    
}
#pragma mark - private methods 私有方法

- (void)setupTable{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, WIDTH_SCREEN,HEIGHT_SCREEN-ZNAVViewH)];
    
    self.tableview.backgroundColor = BGColor;
    
    //去除分割线
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorStyle = NO;
    
    
    if (@available(iOS 11.0, *)) {
        self.tableview.estimatedRowHeight = 0;
        self.tableview.estimatedSectionFooterHeight = 0;
        self.tableview.estimatedSectionHeaderHeight = 0;
        self.tableview.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    }
    
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, FrameWidth(30))];
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    [self.view addSubview:self.tableview];
    // 上拉加载
        
    // 头部刷新控件
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableview.mj_header beginRefreshing];
    
    // 尾部刷新控件
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNotificationAction) name:kNetworkStatusNotification object:nil];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"PersonalMsgListController viewWillDisappear");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
}

/**
 监听网络
 */
- (void)resetNotificationAction {
    if (!IsNetwork) {
        self.msgList = nil;
        [self.tableview reloadData];
    } else {
        [self loadData];
    }
}


#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */
- (void)loadData{
    self.pageNum = 1;
    if([_thistitle isEqualToString:@"公告消息"]){
        self.type = @"getAllNoticeMsg";
        self.putType = @"notice";
        self.imgType = @"personal_radio_msg";
    }else if([_thistitle isEqualToString:@"预警消息"]){
        self.type = @"getAllEarlyWarningMsg";
        self.putType = @"warning";
        self.imgType = @"personal_alarm_msg";
    }else{//告警消息
        self.type = @"getAllMsg";
        self.putType = @"alarm";
        self.imgType = @"personal_warn_msg";
        
    }
    self.pageSize = 30;
    self.hasMore = true;
    [self loadMoreData];
}

- (void)loadMoreData{
    NSLog(@"loadMoreDataloadMoreData");
    //api/getAllMsg/{pageNum}/{pageSize}
    if(!self.hasMore){
        [self.tableview.mj_footer endRefreshing];
        [self.tableview.mj_header endRefreshing];
        //[self.tableview.mj_footer endRefreshing];
        //self.tableview.mj_footer.state = MJRefreshStateNoMoreData;
        
        return ;
    }
    NSString * pageNow = [NSString stringWithFormat:@"/intelligent/api/%@/%ld/%ld",self.type,(long)self.pageNum,(long)self.pageSize];
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:pageNow];
    NSLog(@"loadMoreDataloadMoreData %@",FrameRequestURL);
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            self.tableview.emptyDataSetDelegate = self;
            [self.tableview reloadData];
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        //self.msgList = [[MsgItems class] mj_objectArrayWithKeyValuesArray: result[@"value"][@"records"]];
        
        //[self.tableview reloadData];
        
        
        
        
        if(self.pageNum == 1){
            self.msgList = [[MsgItems class] mj_objectArrayWithKeyValuesArray: result[@"value"][@"records"]];
            if(self.msgList.count < self.pageSize){
                self.hasMore = false;
            }else{
                self.pageNum ++;
            }
        }else{
            NSArray *array = [MsgItems mj_objectArrayWithKeyValuesArray:result[@"value"][@"records"]];
            if(array.count < self.pageSize){
                self.hasMore = false;
            }else{
                self.pageNum ++;
            }
            [self.msgList addObjectsFromArray:array];
        }
        
        for (int i =0; i< self.msgList.count; i++) {
            NSStringDrawingOptions option = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            self.msgList[i].content = [NSString stringWithFormat:@"%@",self.msgList[i].content]  ;
            CGSize lblSize = [self.msgList[i].content boundingRectWithSize:CGSizeMake(FrameWidth(550) , MAXFLOAT) options:option attributes:@{NSFontAttributeName:FontSize(14)} context:nil].size;
            self.msgList[i].LabelHeight = ceilf(lblSize.height);
        }
        
        
        
        
        
        self.tableview.emptyDataSetDelegate = self;
        [self.tableview reloadData];
        
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if(self.msgList.count > 0){
            //self.tableview.mj_footer.state = MJRefreshStateNoMoreData;//;
        }else{
            //self.tableview.mj_footer.state = MJRefreshStateNoData;//MJRefreshStateNoMoreData;
        }
        
        if (self.deleteButon == nil) {
            
            self.deleteButon = [UIButton buttonWithType:UIButtonTypeCustom];
            if(self.msgList.count > 0){
                self.deleteButon.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
                [self.deleteButon setImage:[UIImage imageNamed:@"msg_delete"] forState:UIControlStateNormal];
                [self.deleteButon addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.navigationView addSubview:self.deleteButon];
            
        }
        
        BOOL isRead = false;
        for (int i = 0; i< self.msgList.count; i++) {
            if(self.msgList[i].status != 1){
                isRead = true;
            }
        }
        if (self.yiduButon == nil) {
            self.yiduButon  = [UIButton buttonWithType:UIButtonTypeCustom];
            if( isRead){
                self.yiduButon.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
                [self.yiduButon setImage:[UIImage imageNamed:@"msg_read"] forState:UIControlStateNormal];
                [self.yiduButon addTarget:self action:@selector(yiduAction) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.navigationView addSubview:self.yiduButon];
        }
        [self.deleteButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.right.equalTo(self.navigationView.mas_right).offset(-20);
        }];
        [self.yiduButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.right.equalTo(self.deleteButon.mas_right).offset(-40);
        }];
        
        if (!self.hasMore) {
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (self.tableview.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableview.mj_footer resetNoMoreData];
            }
        }
        
        
        
    } failure:^(NSURLSessionDataTask *error)  {
        self.tableview.emptyDataSetDelegate = self;
        [self.tableview reloadData];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        //self.tableview.mj_footer.state = MJRefreshStateNoMoreData;
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


#pragma mark --EmptyDataSetDelegate
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



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MsgItems *model = self.msgList[indexPath.row];
    NSString *str = safeString(model.content);
    CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 32-57, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
    NSLog(@"%f",fontRect.size.height);
    int height = 0;
    if (fontRect.size.height <21) {
        height =21;
    }else {
        height = fontRect.size.height;
    }
    return 50 + 12 +12 + 40 + height;
    
    
    
    //    height += fontRect.size.height;
}
//
//#pragma mark - UITableviewDatasource 数据源方法
//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor colorWithHexString:kCellHighlightColor];
//}
//
//- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    [self backBtn];
    return self.msgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_thistitle isEqualToString:@"公告消息"]){
        
        KG_GonggaoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_GonggaoDetailCell"];
        if (cell == nil) {
            cell = [[KG_GonggaoDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_GonggaoDetailCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString * createTime =  [FrameBaseRequest getDateByTimesp:self.msgList[indexPath.row].createTime dateType:@"YYYY-MM-dd HH:mm"];
        
        cell.titleLabel.text  = [NSString stringWithFormat:@"【%@】",_thistitle] ;//@"【告警消息】"
        
        cell.timeLabel.text = createTime;
        NSString *msgString =  self.msgList[indexPath.row].content;
        cell.detailLabel.text = msgString;
        cell.iconImage.image = [UIImage imageNamed:[self getGaoJingImage:safeString(msgString)]];
        
        return cell;
    }else if([_thistitle isEqualToString:@"预警消息"]){
        
        KG_YujingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_YujingDetailCell"];
        if (cell == nil) {
            cell = [[KG_YujingDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_YujingDetailCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString * createTime =  [FrameBaseRequest getDateByTimesp:self.msgList[indexPath.row].createTime dateType:@"YYYY-MM-dd HH:mm"];
        
        cell.titleLabel.text  = [NSString stringWithFormat:@"【%@】",_thistitle] ;//@"【告警消息】"
        
        cell.timeLabel.text = createTime;
        NSString *msgString =  self.msgList[indexPath.row].content;
        cell.detailLabel.text = msgString;
        return cell;
    }else{//告警消息
        
        KG_GaojingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_GaojingDetailCell"];
        if (cell == nil) {
            cell = [[KG_GaojingDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_GaojingDetailCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString * createTime =  [FrameBaseRequest getDateByTimesp:self.msgList[indexPath.row].createTime dateType:@"YYYY-MM-dd HH:mm"];
        
        cell.titleLabel.text  = [NSString stringWithFormat:@"【%@】",_thistitle] ;//@"【告警消息】"
        
        cell.timeLabel.text = createTime;
        NSString *msgString =  self.msgList[indexPath.row].content;
        cell.detailLabel.text = msgString;
        
        cell.iconImage.image = [UIImage imageNamed:[self getGaoJingImage:safeString(msgString)]];
        return cell;
        
    }
   
   
 
    
    return nil;
    
    
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //添加一个删除按钮
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"标为已读" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/addUserAlarm/%@/%@",self.putType,self.msgList[indexPath.row].id]];
        
        
        [FrameBaseRequest postWithUrl:FrameRequestURL param:params  success:^(id result) {
            FrameLog(@"请求result返回数据 : %@",result);
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                
                return ;
            }
            [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
            [self loadData];
            return ;
        } failure:^(NSError *error)  {
            FrameLog(@"errorerrorerrorerrorerrorerror : %ld",(long)error.code);
            FrameLog(@"请求失败，返回数据 : %@",error);
            //            if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            //                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            //                [FrameBaseRequest logout];
            //                UIViewController *viewCtl = self.navigationController.viewControllers[0];
            //                [self.navigationController popToViewController:viewCtl animated:YES];
            //                return;
            //            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        }];
        
        
    }];
    editAction.backgroundColor = [UIColor lightGrayColor];
    
    //添加一个编辑按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/deleteUserAlarm/%@/%@",self.putType,self.msgList[indexPath.row].id]];
        
        [FrameBaseRequest deleteWithUrl:FrameRequestURL param:params  success:^(id result) {
            FrameLog(@"请求result返回数据 : %@",result);
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                return ;
            }
            [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
            [self loadData];
            return ;
        } failure:^(NSError *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            //            if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            //                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            //                [FrameBaseRequest logout];
            //                UIViewController *viewCtl = self.navigationController.viewControllers[0];
            //                [self.navigationController popToViewController:viewCtl animated:YES];
            //                return;
            //            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        }];
        
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    if(self.msgList[indexPath.row].status == 1){
        return @[deleteAction];//topAction,
    }
    
    
    
    return @[deleteAction,editAction];//topAction,
    
}


#pragma mark - UITableviewDelegate 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    
    if(self.msgList[indexPath.row].status == 1){
        return;
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/addUserAlarm/%@",self.msgList[indexPath.row].id]];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/addUserAlarm/%@/%@",self.putType,self.msgList[indexPath.row].id]];
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params  success:^(id result) {
        FrameLog(@"请求result返回数据 : %@",result);
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
        [self loadData];
        return ;
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        //        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
        //            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
        //            [FrameBaseRequest logout];
        //            UIViewController *viewCtl = self.navigationController.viewControllers[0];
        //            [self.navigationController popToViewController:viewCtl animated:YES];
        //            return;
        //        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}


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
    
    
    UIButton *deleteButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if(self.msgList.count > 0){
        deleteButon.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
        [deleteButon setImage:[UIImage imageNamed:@"personal_delete"] forState:UIControlStateNormal];
        [deleteButon addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *deleteButtonItem = [[UIBarButtonItem alloc]initWithCustomView:deleteButon];
    
    BOOL isRead = false;
    for (int i = 0; i< self.msgList.count; i++) {
        if(self.msgList[i].status != 1){
            isRead = true;
        }
    }
    UIButton *yiduButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if( isRead){
        yiduButon.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
        [yiduButon setImage:[UIImage imageNamed:@"personal_yidu"] forState:UIControlStateNormal];
        [yiduButon addTarget:self action:@selector(yiduAction) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *yiduButtonItem = [[UIBarButtonItem alloc]initWithCustomView:yiduButon];
    
    self.navigationItem.rightBarButtonItems = @[deleteButtonItem,yiduButtonItem];
    
}
-(void)backAction {
    if([_from isEqualToString:@"home"]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation2"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)deleteAction {
    if(self.msgList.count == 0){
        return ;
    }
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"是否要清空列表？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/deleteUserAlarmList/%@",self.putType]];
        [FrameBaseRequest deleteWithUrl:FrameRequestURL param:nil success:^(id result) {
            
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code != 0){
                [FrameBaseRequest showMessage:[result objectForKey:@"errMsg"]];
                return ;
            }
            [FrameBaseRequest showMessage:@"批量删除告警信息成功"];
            
            [self setupTable];//刷新列表
        }  failure:^(NSError *error) {
            NSLog(@"请求失败 原因：%@",error);
            //            if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            //                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            //                [FrameBaseRequest logout];
            //                UIViewController *viewCtl = self.navigationController.viewControllers[0];
            //                [self.navigationController popToViewController:viewCtl animated:YES];
            //                return;
            //            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        } ];
        
    }]];
    
    [self presentViewController:alertContor animated:NO completion:nil];
    return ;
    
    
    
}
-(void)yiduAction {
    if(self.msgList.count == 0){
        return ;
    }
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"是否全部设置成已读？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/addUserAlarmList/%@",self.putType]];
        [FrameBaseRequest postWithUrl:FrameRequestURL param:nil success:^(id result) {
            
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code != 0){
                [FrameBaseRequest showMessage:[result objectForKey:@"errMsg"]];
                return ;
            }
            
            [FrameBaseRequest showMessage:@"批量标记告警信息为已读已成功"];
            [self setupTable];//刷新列表
        }  failure:^(NSError *error) {
            NSLog(@"请求失败 原因：%@",error);
            //            if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            //                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            //                [FrameBaseRequest logout];
            //                UIViewController *viewCtl = self.navigationController.viewControllers[0];
            //                [self.navigationController popToViewController:viewCtl animated:YES];
            //                return;
            //            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        } ];
        
    }]];
    
    [self presentViewController:alertContor animated:NO completion:nil];
    return ;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
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
    self.titleLabel.text = _thistitle;
    
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


- (NSString *)getGaoJingImage:(NSString *)level {
    NSString *levelString = @"level_normal";
    
    if ([level containsString:@"正常"]) {
        levelString = @"gaojing_red";
    }else if ([level containsString:@"提示"]) {
        levelString = @"gaojing_prompt";
    }else if ([level containsString:@"次要"]) {
        levelString = @"gaojing_ciyao";
    }else if ([level containsString:@"重要"]) {
        levelString = @"gaojing_important";
    }else if ([level containsString:@"紧急"]) {
        levelString = @"gaojing_red";
    }else {
        levelString = @"gaojing_red";
    }
    //紧急
    return levelString;
}

@end




