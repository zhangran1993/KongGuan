//
//  AlarmDetailController.m
//  Frame
//
//  Created by hibayWill on 2018/4/4.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "AlarmDetailController.h"
#import "StationRoomController.h"
#import "StationVideoListController.h"
#import "FrameBaseRequest.h"
#import <UIImageView+WebCache.h>
#import "AlarmMachineTypeListController.h"
#import "PatrolHistoryController.h"
#import "AlarmItems.h"
#import "AlarmUserItems.h"
#import "ContactManufacturerView.h"
#import <MJExtension.h>
#import "FSTextView.h"
#import "ZYSpreadButton.h"
#import "ZYSpreadSubButton.h"
#import "TechnicalManualViewController.h"
#import "PersonModel.h"
#import "ValueModel.h"
#import "ValueModel.h"
#import "TelModel.h"
#import "customTableView.h"
#import "PopularCollectionViewCell.h"
#import "PopularModel.h"
#import "UIView+LX_Frame.h"
static NSString *PopularCollectionViewCellID2 = @"PopularCollectionViewCellID2";
@interface AlarmDetailController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,customTableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property NSUInteger newHeight1;
@property NSUInteger newHeight2;
@property NSUInteger newHeight3;
@property NSUInteger newHeight;
@property float keyBoardHeight;
@property float nowheight;
@property BOOL isShooting;
@property NSMutableDictionary *objects;
@property NSMutableArray *AllStatus;
@property(nonatomic) FSTextView* reasonView;
@property(nonatomic) UITextView* jiechugaojingreasonView;
@property(nonatomic) FSTextView *manageInsert;
@property(nonatomic)UITextView *removeInsert;
@property(nonatomic) UIView * bgView;
@property(nonatomic) UIViewController *vc;
/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property   int viewnum;
@property (nonatomic,copy) NSString* litpic;
@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* type;
@property (nonatomic,copy) NSString* rate;
@property (nonatomic,copy) NSString* feedback;
@property (nonatomic,copy) NSString* collect;
@property (nonatomic,copy) NSString* desc;
@property (nonatomic,copy) NSString* address;
@property (nonatomic,copy) NSString* comments;
@property (nonatomic,assign) double iscollect;
@property (nonatomic,assign)  BOOL needAlarmReloadData;
@property(nonatomic) UIView* bottomView;
@property(nonatomic) UITableView *tableview;
@property(nonatomic) UITableView *expertUserTabView;
@property (nonatomic,assign) UIFont * listFont;
@property (strong, nonatomic) NSMutableArray<AlarmUserItems *> * AlarmUserItem;
@property (strong, nonatomic) NSMutableArray<AlarmItems *> * AlarmItem;
@property (nonatomic, strong)ZYSpreadButton *spreadButton;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *labLeArray;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *modelArray;
@property (nonatomic, strong)NSString *textViewTxt;
@end

@implementation AlarmDetailController

#pragma mark - 全局常量



#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.chooseStatus = @"";
    self.reStatus = @"";
    self.alarmStatus = @"";
    self.hangupStatus = @"";
    
    self.navigationItem.title = @"告警处理";//详情
    _listFont = FontSize(15);
    _isShooting = false;
    self.needAlarmReloadData = FALSE;
    _nowheight = FrameWidth(77);
    self.automaticallyAdjustsScrollViewInsets = NO;
    /*
    UITableViewController* tvc=[[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvc];
    self.tableview=tvc.tableView;
     */
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, View_Width, HEIGHT_SCREEN - ZNAVViewH - _nowheight)];
    
    //self.tableview.frame = CGRectMake(0, 0, View_Width, HEIGHT_SCREEN - ZNAVViewH - _nowheight);
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.estimatedRowHeight = 0;
    self.tableview.estimatedSectionHeaderHeight = 0;
    self.tableview.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableview.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        
        self.tableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);//64和49自己看效果，是否应该改成0
        self.tableview.scrollIndicatorInsets =self.tableview.contentInset;
    }
    self.tableview.backgroundColor = BGColor;
    self.view.backgroundColor = [UIColor whiteColor];
    //[self.tableview registerClass:[UITableViewCell class]forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableview];
    [self backBtn];
    [self setupTable];
    [self tagData];
    [self telData];
    
    [self assistantView];
}



-(void)viewWillAppear:(BOOL)animated{
    
    [self registerForKeyboardNotifications];//注册键盘通知
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"AlarmDetailController viewWillDisappear");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"AlarmDetailController viewDidDisappear");
    
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
}


#pragma mark-- 助手初始化
- (void)assistantView {
    //技术手册
    ZYSpreadSubButton *manual = [[ZYSpreadSubButton alloc]initWithBackgroundImage:[UIImage imageNamed:@"pop_1"] highlightImage:[UIImage imageNamed:@"Technica_manual"]  clickedBlock:^(int index, UIButton *sender) {
        [self.spreadButton closeButton];
        TechnicalManualViewController *vc = [TechnicalManualViewController new];
        vc.title = @"技术手册";
        vc.alarmInfo = self.alarmInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    //备件
    ZYSpreadSubButton *sparePart = [[ZYSpreadSubButton alloc]initWithBackgroundImage:[UIImage imageNamed:@"pop_2"] highlightImage:[UIImage imageNamed:@"part"]  clickedBlock:^(int index, UIButton *sender) {
        [self.spreadButton closeButton];
        AlarmMachineTypeListController  *MachineTypeList = [[AlarmMachineTypeListController alloc] init];
        [self.navigationController pushViewController:MachineTypeList animated:YES];
    }];
    //巡查记录
    ZYSpreadSubButton *record = [[ZYSpreadSubButton alloc]initWithBackgroundImage:[UIImage imageNamed:@"pop_3"] highlightImage:[UIImage imageNamed:@"Patrol-1"]  clickedBlock:^(int index, UIButton *sender) {
        [self.spreadButton closeButton];
        PatrolHistoryController *vc = [PatrolHistoryController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    //联系厂家
    ZYSpreadSubButton *contact = [[ZYSpreadSubButton alloc]initWithBackgroundImage:[UIImage imageNamed:@"pop_4"] highlightImage:[UIImage imageNamed:@"contact"]  clickedBlock:^(int index, UIButton *sender) {
        NSLog(@"点击4");
        [self.spreadButton closeButton];
        ContactManufacturerView *popView = [ContactManufacturerView new];
        [popView InitializationListView];
        [popView show];
        popView.contactManufactureArray = self.dataArray;
    }];
    //专家会诊
    ZYSpreadSubButton *expert = [[ZYSpreadSubButton alloc]initWithBackgroundImage:[UIImage imageNamed:@"pop_5"] highlightImage:[UIImage imageNamed:@"expert"]  clickedBlock:^(int index, UIButton *sender) {
        [self.spreadButton closeButton];
        customTableView *popView = [customTableView new];
        [popView InitializationListView:[@[@"视频监测"] mutableCopy]];
        popView.delegate = self;
        [popView show];
    }];
    CGSize imageSize = [UIImage imageNamed:@"taizhan_helper"].size;
    self.spreadButton = [[ZYSpreadButton alloc]initWithBackgroundImage:[UIImage imageNamed:@"taizhan_helper"] highlightImage:[UIImage imageNamed:@"taizhan_helper"] position:CGPointMake((WIDTH_SCREEN - imageSize.width) + 10, 300) navigationHeight:ZNAVViewH];
    
    [self.spreadButton setSubButtons:[@[manual,sparePart,record,contact,expert] mutableCopy]];
    self.spreadButton.mode = SpreadModeSickleSpread;
    self.spreadButton.direction = SpreadDirectionLeft;
    self.spreadButton.positionMode = SpreadPositionModeTouchBorder;
    self.spreadButton.radius = 130;
//    self.spreadButton.coverAlpha = 0.3;
    self.spreadButton.touchBorderMargin = 10;
    self.spreadButton.buttonWillSpreadBlock = ^(ZYSpreadButton *spreadButton) {
        
    };
    self.spreadButton.buttonDidSpreadBlock = ^(ZYSpreadButton *spreadButton) {
        
    };
    self.spreadButton.buttonWillCloseBlock = ^(ZYSpreadButton *spreadButton) {
        
    };
    self.spreadButton.buttonDidCloseBlock = ^(ZYSpreadButton *spreadButton) {
        
    };
    [self.view addSubview:self.spreadButton];
    [self.spreadButton defaultOpen];
}


- (void)customTableViewClickCell:(NSString *)text {
    if ([text isEqualToString:@"视频监测"]) {
        StationVideoListController  *StationVideo = [[StationVideoListController alloc] init];
        StationVideo.station_code = self.station_code;
        StationVideo.station_name = self.alarmInfo.stationName;
        [self.navigationController pushViewController:StationVideo animated:YES];
    }
}


/**
 警告管理标签
 */
- (void)tagData {
    if (!self.labLeArray) {//
        NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/getAlarmLabelList"];
        NSDictionary *Map = @{
                              @"alarmInfoId":self.id,
                              @"equipmentName":self.alarmInfo.equipmentName
                              };
        [FrameBaseRequest getWithUrl:FrameRequestURL param:Map success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                return ;
            }
            //#warning 对接警告管理标签接口
            NSMutableArray *labelMutableArray = [NSMutableArray array];
            if (result[@"value"] && [result[@"value"] isKindOfClass:[NSArray class]] &&[result[@"value"] count] > 0) {
                labelMutableArray = [result[@"value"] mutableCopy];
            }
            self.labLeArray = [labelMutableArray copy];
            if (self.labLeArray.count  > 0) {
                NSMutableArray *arr = [NSMutableArray array];
                
                for (int i = 0; i < self.labLeArray.count; i++) {
                    PopularModel *model = [PopularModel new];
                    model.name = self.labLeArray[i];
                    model.Checked = NO;
                    
                    [arr addObject:model];
                }
                self.modelArray = [arr copy];
                
            }
            
            [self.collectionView reloadData];
            [self.tableview reloadData];
        } failure:^(NSURLSessionDataTask *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
            if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
                [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
                return;
            }else if(responses.statusCode == 502){
                
            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        }];
    }
}

- (void)telData {
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/radarAndGpsSupportPerson/"];
    [FrameBaseRequest getWithUrl:[NSString stringWithFormat:@"%@%@/%@",FrameRequestURL,[self getCurrentTimes],self.alarmInfo.measureTagCode] param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSMutableArray *muttArray = [NSMutableArray array];
        NSMutableArray *listArray = [NSMutableArray array];
        NSMutableArray *venderArray = [NSMutableArray array];
        if (result[@"value"] && [result[@"value"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result[@"value"];
            ValueModel *model = [ValueModel mj_objectWithKeyValues:dic];
            for (NSDictionary *cc in dic[@"person"][@"value"]) {
                TelModel *tel = [TelModel mj_objectWithKeyValues:cc];
                [listArray addObject:tel];
            }
             model.person.value = [listArray copy];
            for (NSDictionary *bb in dic[@"vender"][@"value"]) {
                TelModel *tel = [TelModel mj_objectWithKeyValues:bb];
                [venderArray addObject:tel];
            }
            model.vender.value = [venderArray copy];
            [muttArray addObject:model];
        }
        self.dataArray = [muttArray copy];

    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            return;
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

#pragma mark - private methods 私有方法
- (void)setupTable{
    [self guaqiCancel];//隐藏弹窗
    if(self.objects){
        [self getStatus];
        return ;
    }
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/alarmHandleRecordList/%@",_id]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
        self.objects = [result[@"value"] copy];
        
        
        [self getStatus];
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
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
-(void)getStatus{
    NSMutableArray<AlarmItems *> * SItem = [[AlarmItems class] mj_objectArrayWithKeyValuesArray:self.objects[@"recordList"] ];
    self.AlarmItem = [SItem copy];
    NSString *recordStatus = [NSString stringWithFormat:@"%@",[self.objects objectForKey:@"recordStatus"]];
    
    self.alarmStatus = [NSString stringWithFormat:@"%@",[self.objects objectForKey:@"alarmStatus"]];
    
    _AllStatus = [[NSMutableArray alloc]init];
    if(self.chooseStatus == nil||[self.chooseStatus isEqualToString:@""]){
        //self.chooseStatus = self.reStatus;
        [_AllStatus addObjectsFromArray:@[@"unconfirmed",@"confirmed",@"emergency",@"announce",@"shooting",@"completed",@"已解决"]];
        
        for (int i = 0; i <  self.AlarmItem.count; i++) {
            if([self.AlarmItem[i].status isEqualToString:@"completed"]){
                [_AllStatus removeObject:@"completed"];
                continue;
            }else if([self.AlarmItem[i].status isEqualToString:@"shooting"]){
                [_AllStatus removeObject:@"shooting"];
                _isShooting = true;
                continue;
            }else if([self.AlarmItem[i].status isEqualToString:@"announce"]){
                [_AllStatus removeObject:@"announce"];
                continue;
            }else if([self.AlarmItem[i].status isEqualToString:@"emergency"]){
                [_AllStatus removeObject:@"emergency"];
                continue;
            }else if([self.AlarmItem[i].status isEqualToString:@"confirmed"]){
                [_AllStatus removeObject:@"confirmed"];
                [_AllStatus removeObject:@"unconfirmed"];
                continue;
            }else if([self.AlarmItem[i].status isEqualToString:@"unconfirmed"]){
                [_AllStatus removeObject:@"unconfirmed"];
                continue;
            }else {
                continue;
            }
        }
        if(_AllStatus.count > 0){
            self.chooseStatus = _AllStatus[0];
            self.reStatus = _AllStatus[0];
        }
    }
    self.hangupStatus  = [NSString stringWithFormat:@"%@",[self.objects objectForKey:@"hangupStatus"]];
    
    
    NSLog(@"-------------------------- %@  %@   %@  %@",recordStatus,self.chooseStatus,_AllStatus,self.alarmStatus);
    
    
    
    [self loadBottomData];
    [self.tableview reloadData];
}

- (void)loadBottomData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([[userDefaults objectForKey:@"hang"] boolValue] == true ){
        NSLog(@"有挂起权限");
        UIButton * clwc_btn = [[UIButton alloc]initWithFrame: CGRectMake(0,   View_Height  - _nowheight, WIDTH_SCREEN,_nowheight)];
        [clwc_btn setBackgroundColor: navigationColor];
        clwc_btn.titleLabel.textColor = [UIColor whiteColor];
        if(![self.reStatus isEqualToString:@"已解决"]&&![self.alarmStatus isEqualToString:@"removed"]){//告警解决
            if([self.hangupStatus boolValue] == 1 ){
                [clwc_btn setTitle:@"挂起" forState:UIControlStateNormal ];
            }else{
                [clwc_btn setTitle:@"解除挂起" forState:UIControlStateNormal ];
            }
            
            [clwc_btn addTarget:self action:@selector(guaqi) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:clwc_btn];
            return ;
        }else if([self.hangupStatus boolValue] == 0 ){
            [clwc_btn setTitle:@"解除挂起" forState:UIControlStateNormal ];
            
            [clwc_btn addTarget:self action:@selector(guaqi) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:clwc_btn];
            return ;
            
        }else{
            _nowheight = 0;
            [self.tableview setFrameHeight: HEIGHT_SCREEN - ZNAVViewH];
            
        }
        
    }else if([self.hangupStatus boolValue] == 1 ){
        //无挂起权限且未挂起
        BOOL isShow = true;
        if([self.alarmStatus isEqualToString:@"removed"]){//告警解除
                isShow = true;
        }else{
            if([self.chooseStatus isEqualToString:@"confirmed"]||[self.chooseStatus isEqualToString:@"unconfirmed"]){//设备告警
                isShow = false;
                UIButton * jcgj_btn = [[UIButton alloc]initWithFrame: CGRectMake(0,  View_Height  - _nowheight, WIDTH_SCREEN/2-1,_nowheight)];
                [jcgj_btn setBackgroundColor:[UIColor colorWithRed:110/255.0 green:175/255.0 blue:250/255.0 alpha:1]];
                //jcgj_btn.contentEdgeInsets
                //jcgj_btn.bottomAnchor autolay
                [jcgj_btn setTitle:@"解除告警" forState:UIControlStateNormal ];
                jcgj_btn.titleLabel.textColor = [UIColor redColor];
                [jcgj_btn addTarget:self action:@selector(jiechugaojingAction) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:jcgj_btn];
                
                UIButton * qrgj_btn = [[UIButton alloc]initWithFrame: CGRectMake(WIDTH_SCREEN/2,   View_Height  - _nowheight, WIDTH_SCREEN/2,_nowheight)];
                [qrgj_btn setBackgroundColor: navigationColor];
                [qrgj_btn setTitle:@"确认告警" forState:UIControlStateNormal ];
                [qrgj_btn addTarget:self action:@selector(querengaojing) forControlEvents:UIControlEventTouchUpInside];
                qrgj_btn.titleLabel.textColor = [UIColor whiteColor];
                [self.view addSubview:qrgj_btn];
            }else {
                UIButton * clwc_btn = [[UIButton alloc]initWithFrame: CGRectMake(0,   View_Height  - _nowheight, WIDTH_SCREEN,_nowheight)];
                [clwc_btn setBackgroundColor: navigationColor];
                clwc_btn.titleLabel.textColor = [UIColor whiteColor];
                if([self.chooseStatus isEqualToString:@"emergency"]){//应急处理
                    isShow = false;
                    [clwc_btn setTitle:@"处理完成" forState:UIControlStateNormal ];
                    [clwc_btn addTarget:self action:@selector(chuliwancheng) forControlEvents:UIControlEventTouchUpInside];
                }else if([self.chooseStatus isEqualToString:@"announce"]){//故障通告
                    isShow = false;
                    [clwc_btn setTitle:@"通告完成" forState:UIControlStateNormal ];
                    [clwc_btn addTarget:self action:@selector(tonggaowancheng) forControlEvents:UIControlEventTouchUpInside];
                }else if([self.chooseStatus isEqualToString:@"shooting"]){//设备排故
                    isShow = false;
                    [clwc_btn setTitle:@"排故完成" forState:UIControlStateNormal ];
                    [clwc_btn addTarget:self action:@selector(paiguwancheng) forControlEvents:UIControlEventTouchUpInside];
                }else if([self.chooseStatus isEqualToString:@"completed"]){//告警解决
                    isShow = false;
                    [clwc_btn setTitle:@"告警已确认解决" forState:UIControlStateNormal ];
                    [clwc_btn addTarget:self action:@selector(completedSure) forControlEvents:UIControlEventTouchUpInside];
                }else{//其他状态隐藏
                    [clwc_btn setHidden:true];
                }
                [self.view addSubview:clwc_btn];
            }
            
        }
        
        if(isShow){
            NSLog(@"不需要显示操作栏");
            _nowheight = 0;
            self.tableview.frame = CGRectMake(0, 0, View_Width, HEIGHT_SCREEN - ZNAVViewH );
        }
        
    }else{
        NSLog(@"已经挂起不需要显示操作栏");
        _nowheight = 0;
        self.tableview.frame = CGRectMake(0, 0, View_Width, HEIGHT_SCREEN - ZNAVViewH );
    }
}


#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.expertUserTabView == tableView){
        return FrameWidth(78);
        
    }
    if(indexPath.row==0){
        if(getScreen.size.height > allHeight){
            return getScreen.size.height;
        }
        return  allHeight;//+
    }
    return 0;
}

#pragma mark - UITableviewDatasource 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.expertUserTabView == tableView){
        return self.AlarmUserItem.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.expertUserTabView == tableView){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        
        AlarmUserItems *item = self.AlarmUserItem[indexPath.row];
        
        
        UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(40), FrameWidth(25), FrameWidth(30), FrameWidth(30))];
        phoneImg.image = [UIImage imageNamed:@"alarm_phone"];
        [cell addSubview:phoneImg];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(80), 0, FrameWidth(120), FrameWidth(76))];
        nameLabel.text = item.name;
        nameLabel.font = _listFont;
        [cell addSubview:nameLabel];
        
        UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(190), 0, FrameWidth(220), FrameWidth(76))];
        phoneLabel.font = _listFont;
        phoneLabel.text = item.tel;
        phoneLabel.textColor = [UIColor lightGrayColor];
        [cell addSubview:phoneLabel];
        
        
        return cell;
        
    }
    
    
    
    
    UITableViewCell *thiscell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - 114)];
    thiscell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    thiscell.backgroundColor = BGColor;
    //告警
    UIView *AlarmView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, FrameWidth(110))];
    AlarmView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:AlarmView];
    
    UIImageView *levelImgbg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(25), FrameWidth(25), FrameWidth(50),FrameWidth(50))];
    if(self.alarmInfo.level){//iphone5和ipod上偶尔会崩溃，原因似乎是空值
        levelImgbg.image = [UIImage imageNamed:[NSString stringWithFormat:@"alarm_levelbig%@",self.alarmInfo.level]];
        [AlarmView addSubview:levelImgbg];
    }
    
    
    UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(90), FrameWidth(43), FrameWidth(150),FrameWidth(30))];
    levelLabel.text = @"级告警";
    levelLabel.font = FontSize(17);
    [AlarmView addSubview:levelLabel];
    
    UILabel *levelStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(300), FrameWidth(43), FrameWidth(320),FrameWidth(30))];

    if([self.reStatus isEqualToString:@"unconfirmed"]){
        levelStatusLabel.text = @"告警确认中";
        
    }else if([self.reStatus isEqualToString:@"confirmed"]){
        levelStatusLabel.text = @"告警确认中";//@"告警已确认";
        
    }else if([self.reStatus isEqualToString:@"emergency"]){
        levelStatusLabel.text = @"应急处理中";
        
    }else  if([self.reStatus isEqualToString:@"announce"]){
        levelStatusLabel.text = @"故障通告中";
        
    }else if([self.reStatus isEqualToString:@"shooting"]){
        levelStatusLabel.text = @"设备排故中";
        
    }else if([self.reStatus isEqualToString:@"completed"]){
        levelStatusLabel.text = @"确认告警解决";
        
    }else if([self.reStatus isEqualToString:@"已解决"]){
        levelStatusLabel.text = @"告警已解决";
        
    }
    NSLog(@"aaaaaaaaaaaa%@",self.alarmStatus);
    if([self.alarmStatus isEqualToString:@"removed"]){
        levelStatusLabel.text = @"告警已解除";
        
    }
    if([self.hangupStatus boolValue]==0){
        levelStatusLabel.text = @"告警已挂起";
    }
    levelStatusLabel.textAlignment = NSTextAlignmentRight;
    levelStatusLabel.textColor = navigationColor;
    levelStatusLabel.font = _listFont;
    [AlarmView addSubview:levelStatusLabel];
    
    //台站信息
    UIView *stationView = [[UIView alloc]initWithFrame:CGRectMake(0,AlarmView.frame.origin.y + AlarmView.frame.size.height + FrameWidth(10), WIDTH_SCREEN,FrameWidth(200))];
    stationView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:stationView  ];
    
    //等级
    UIImageView *stationImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(25), FrameWidth(20), FrameWidth(35), FrameWidth(35))];
    stationImg.image = [UIImage imageNamed:@"alarm_station"];
    [stationView addSubview:stationImg];
    //名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(80), 0, FrameWidth(545), FrameWidth(75))];
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.alarmInfo.stationName,self.alarmInfo.engineRoomName] ;//@"龙口台站 002机房";
    
    nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    nameLabel.numberOfLines = 2;
    nameLabel.font = FontSize(18);
    //nameLabel.textColor = [UIColor grayColor];
    [stationView addSubview:nameLabel];
    
    //线
    UILabel *lineLabel2  = [[UILabel alloc] initWithFrame:CGRectMake(0,FrameWidth(75), WIDTH_SCREEN, 1)];
    lineLabel2.backgroundColor = BGColor;
    [stationView addSubview:lineLabel2];
    //机器
    UIImageView *machineImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(75), FrameWidth(100), FrameWidth(30), FrameWidth(30))];
    machineImg.image = [UIImage imageNamed:@"alarm_machine"];
    [stationView addSubview:machineImg];
    UILabel *machineLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(120), FrameWidth(100), FrameWidth(400), FrameWidth(30))];
    machineLabel.text = self.alarmInfo.equipmentName ;//@"这是一台机器啊啊吖";
    machineLabel.font = _listFont;
    machineLabel.textColor = [UIColor grayColor];
    [stationView addSubview:machineLabel];
    //动力
    UIImageView *powerImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(75), FrameWidth(145), FrameWidth(30), FrameWidth(30))];
    powerImg.image = [UIImage imageNamed:@"alarm_power"];
    [stationView addSubview:powerImg];
    UILabel *powerLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(120), FrameWidth(130), FrameWidth(290), FrameWidth(60))];
    powerLabel.numberOfLines = 2;
    powerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    powerLabel.text = self.alarmInfo.measureTagName ;
    
    powerLabel.font = _listFont;
    powerLabel.textColor = [UIColor grayColor];
    
    CGSize size = [powerLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:powerLabel.font,NSFontAttributeName,nil]];
    if(size.width > FrameWidth(290)){
        powerLabel.frame = CGRectMake(FrameWidth(120), FrameWidth(130), FrameWidth(290), FrameWidth(60));
    }else{
        powerLabel.frame = CGRectMake(FrameWidth(120), FrameWidth(130), FrameWidth(20)+size.width, FrameWidth(60));
    }
    
    [stationView addSubview:powerLabel];
    
    UILabel *powerLevel = [[UILabel alloc]initWithFrame:CGRectMake(powerLabel.frame.size.width, 0, FrameWidth(90), FrameWidth(60))];
    powerLevel.text = self.alarmInfo.realTimeValueAlias;
    powerLevel.font = _listFont;
    powerLevel.textColor = [UIColor grayColor];
    CGSize size2 = [powerLevel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:powerLevel.font,NSFontAttributeName,nil]];
    powerLevel.frame = CGRectMake(powerLabel.frame.size.width, 0, FrameWidth(10)+size2.width, FrameWidth(60));
    [powerLabel addSubview:powerLevel];
    
    UIImageView *powerTypeImg = [[UIImageView alloc]initWithFrame:CGRectMake(powerLevel.frame.size.width+FrameWidth(10), FrameWidth(20), FrameWidth(15), FrameWidth(20))];
    NSString * powerStatus = @"";
    if([self.alarmInfo.type isEqualToString:@"topLimit"]){
        powerStatus = @"alarm_power_up";
    }else if([self.alarmInfo.type isEqualToString:@"bottomLimit"]){
        powerStatus = @"alarm_power_down";
    }
    powerTypeImg.image = [UIImage imageNamed:powerStatus];
    [powerLevel addSubview:powerTypeImg];
    
    //通告和专家视频
    UIView *tonggaoView = [[UIView alloc]initWithFrame:CGRectMake(0, stationView.frame.origin.y + stationView.frame.size.height + FrameWidth(10), WIDTH_SCREEN, FrameWidth(125))];
    tonggaoView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:tonggaoView];
    
    UIImageView *tonggaoImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(30), FrameWidth(40), FrameWidth(35), FrameWidth(35))];
    tonggaoImg.image = [UIImage imageNamed:@"alarm_tonggao"];
    [tonggaoView addSubview:tonggaoImg];
    UILabel *tonggaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(80), FrameWidth(43), FrameWidth(220), FrameWidth(30))];
    tonggaoLabel.text = @"故障通告";
    tonggaoLabel.font = FontSize(17);
    
    tonggaoLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *viewTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noticeEvent:)];
    [tonggaoLabel addGestureRecognizer:viewTapGesture];
    [viewTapGesture setNumberOfTapsRequired:1];
    
    [tonggaoView addSubview:tonggaoLabel];
    
    
    //if([self.chooseStatus isEqualToString:@"shooting"]){//设备排故 专家视频
        UIImageView *shipinImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(370), FrameWidth(40), FrameWidth(35), FrameWidth(35))];
        shipinImg.image = [UIImage imageNamed:@"alarm_ communication"];
        [tonggaoView addSubview:shipinImg];
        UILabel *shipinLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(415), FrameWidth(43), FrameWidth(220), FrameWidth(30))];
        shipinLabel.text = @"专家视频";
        shipinLabel.font = FontSize(17);
        shipinLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *viewTapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoEvent:)];
        [shipinLabel addGestureRecognizer:viewTapGesture1];
        [viewTapGesture1 setNumberOfTapsRequired:1];
        
        [tonggaoView addSubview:shipinLabel];
    //}
    
    //告警状态
    UIView *alarmStatusView = [[UIView alloc]initWithFrame:CGRectMake(0,tonggaoView.frame.origin.y + tonggaoView.frame.size.height + FrameWidth(10), WIDTH_SCREEN, FrameWidth(200))];
    alarmStatusView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:alarmStatusView];
    
    
    UIView *lineH = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(540), 0, 2, FrameWidth(200))];
    lineH.backgroundColor = BGColor;
    [alarmStatusView addSubview:lineH];
    
    NSString *gjqrImg = @"alarm_gjqr_gray";
    NSString *yjclImg = @"alarm_yjcl_gray";
    NSString *gztgImg = @"alarm_gztg_gray";
    NSString *sbpgImg = @"alarm_sbpg_gray";
    NSString *gjjjImg = @"alarm_gjjj_gray";
    
    NSString *gjqrDian = @"alarm_dangqian_gray";
    NSString *yjclDian = @"alarm_dangqian_gray";
    NSString *gztgDian = @"alarm_dangqian_gray";
    NSString *sbpgDian = @"alarm_dangqian_gray";
    NSString *gjjjDian = @"alarm_dangqian_gray";
    NSString *gqDian = @"alarm_dangqian_gray";
    
    
    for (int i = 0; i <  self.AlarmItem.count; i++) {
        if([self.AlarmItem[i].status isEqualToString:@"hangup"]){continue;}else
        if([self.AlarmItem[i].status isEqualToString:@"removeHangup"]){continue;}else
        if([self.AlarmItem[i].status isEqualToString:@"unconfirmed"]){
            gjqrImg  = @"alarm_gjqr_blue";
            gjqrDian = @"alarm_dangqian_blue";
        }else
        if([self.AlarmItem[i].status isEqualToString:@"confirmed"]){
            gjqrImg  = @"alarm_gjqr_blue";
            gjqrDian = @"alarm_dangqian_blue";
            
        }else
        if([self.AlarmItem[i].status isEqualToString:@"emergency"]){
            yjclImg = @"alarm_yjcl_blue";
            yjclDian = @"alarm_dangqian_blue";
            
        }else
        if([self.AlarmItem[i].status isEqualToString:@"announce"]){
            gztgImg = @"alarm_gztg_blue";
            gztgDian = @"alarm_dangqian_blue";
            
        }else
        if([self.AlarmItem[i].status isEqualToString:@"shooting"]){
            sbpgImg = @"alarm_sbpg_blue";
            sbpgDian = @"alarm_dangqian_blue";
        }else
        if([self.AlarmItem[i].status isEqualToString:@"completed"]){//告警解决
            gjjjImg = @"alarm_gjjj_blue";
            gjjjDian = @"alarm_dangqian_blue";
        }
    }

//    if([self.alarmStatus isEqualToString:@"removed"] ){
//        if([self.chooseStatus isEqualToString:@"unconfirmed"]){//设备告警
//            gjqrImg  = @"alarm_gjqr_blue";
//            gjqrDian = @"alarm_dangqian_blue";
//        }else if([self.chooseStatus isEqualToString:@"confirmed"]){//确认告警
//            gjqrImg  = @"alarm_gjqr_blue";
//            gjqrDian = @"alarm_dangqian_blue";
//        }else  if([self.chooseStatus isEqualToString:@"emergency"]){//应急处理
//            yjclImg = @"alarm_yjcl_blue";
//            yjclDian = @"alarm_dangqian_blue";
//
//        }else   if([self.chooseStatus isEqualToString:@"announce"]){//故障通告
//            gztgImg = @"alarm_gztg_blue";
//            gztgDian = @"alarm_dangqian_blue";
//        }else  if([self.chooseStatus isEqualToString:@"shooting"]){//设备排故
//            sbpgImg = @"alarm_sbpg_blue";
//            sbpgDian = @"alarm_dangqian_blue";
//        }else  if([self.chooseStatus isEqualToString:@"completed"]){//告警解决
//            gjjjImg = @"alarm_gjjj_blue";
//            gjjjDian = @"alarm_dangqian_blue";
//        }
//    }else
    if([self.hangupStatus boolValue] == 0 ){
        gqDian = @"alarm_dangqian_yellow";
        /*
        if([self.chooseStatus isEqualToString:@"unconfirmed"]){//设备告警
            gjqrImg  = @"alarm_gjqr_blue";
            gjqrDian = @"alarm_dangqian_blue";
        }else
        if([self.chooseStatus isEqualToString:@"confirmed"]){//确认告警
            gjqrImg  = @"alarm_gjqr_blue";
            gjqrDian = @"alarm_dangqian_blue";
        }else
        if([self.chooseStatus isEqualToString:@"emergency"]){//应急处理
            yjclImg = @"alarm_yjcl_blue";
            yjclDian = @"alarm_dangqian_blue";
            
        }else
        if([self.chooseStatus isEqualToString:@"announce"]){//故障通告
            gztgImg = @"alarm_gztg_blue";
            gztgDian = @"alarm_dangqian_blue";
        }else
        if([self.chooseStatus isEqualToString:@"shooting"]){//设备排故
            sbpgImg = @"alarm_sbpg_blue";
            sbpgDian = @"alarm_dangqian_blue";
        }else
        if([self.chooseStatus isEqualToString:@"completed"]){//告警解决
            gjjjImg = @"alarm_gjjj_blue";
            gjjjDian = @"alarm_dangqian_blue";
        }
        */
    }else{
        if([self.chooseStatus isEqualToString:@"unconfirmed"]){//设备告警
            gjqrImg  = @"alarm_gjqr_blue_d";
            gjqrDian = @"alarm_dangqian";
        }else
        if([self.chooseStatus isEqualToString:@"confirmed"]){//确认告警
            gjqrImg  = @"alarm_gjqr_blue_d";
            gjqrDian = @"alarm_dangqian";
        }else
        if([self.chooseStatus isEqualToString:@"emergency"]){//应急处理
            yjclImg = @"alarm_yjcl_blue_d";
            yjclDian = @"alarm_dangqian";
            
        }else
        if([self.chooseStatus isEqualToString:@"announce"]){//故障通告
            gztgImg = @"alarm_gztg_blue_d";
            gztgDian = @"alarm_dangqian";
        }else
        if([self.chooseStatus isEqualToString:@"shooting"]){//设备排故
            sbpgImg = @"alarm_sbpg_blue_d";
            sbpgDian = @"alarm_dangqian";
        }else
        if([self.chooseStatus isEqualToString:@"completed"]){//告警解决
            gjjjImg = @"alarm_gjjj_blue_d";
            gjjjDian = @"alarm_dangqian";
        }
    }
    
    
    
    
    UIButton *gjqrBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(10), FrameWidth(22), FrameWidth(120), FrameWidth(50))];
    [gjqrBtn setBackgroundImage:[UIImage imageNamed:gjqrImg] forState:UIControlStateNormal];
    gjqrBtn.tag = 1000;
    [gjqrBtn addTarget:self action:@selector(StatusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [alarmStatusView addSubview:gjqrBtn];
    
    UIImageView *gjqrdangqianImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(47), FrameWidth(56), FrameWidth(25), FrameWidth(25))];
    gjqrdangqianImg.image = [UIImage imageNamed:gjqrDian];
    [gjqrBtn addSubview:gjqrdangqianImg];
    
    
    UIButton *yjclBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(110), FrameWidth(115), FrameWidth(120), FrameWidth(50))];
    [yjclBtn setBackgroundImage:[UIImage imageNamed:yjclImg] forState:UIControlStateNormal];
    yjclBtn.tag = 1001;
    [yjclBtn addTarget:self action:@selector(StatusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [alarmStatusView addSubview:yjclBtn];
    
    UIImageView *yjcldangqianImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(47), -FrameWidth(36), FrameWidth(25), FrameWidth(25))];
    yjcldangqianImg.image = [UIImage imageNamed:yjclDian];
    [yjclBtn addSubview:yjcldangqianImg];
    
    
    UIButton *gztgBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(210), FrameWidth(22), FrameWidth(120), FrameWidth(50))];
    [gztgBtn setBackgroundImage:[UIImage imageNamed:gztgImg] forState:UIControlStateNormal];
    gztgBtn.tag = 1002;
    [gztgBtn addTarget:self action:@selector(StatusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [alarmStatusView addSubview:gztgBtn];
    
    UIImageView *gztgdangqianImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(47), FrameWidth(56), FrameWidth(25), FrameWidth(25))];
    gztgdangqianImg.image = [UIImage imageNamed:gztgDian];
    [gztgBtn addSubview:gztgdangqianImg];
    
    
    
    UIButton *sbpgBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(310), FrameWidth(115), FrameWidth(120), FrameWidth(50))];
    [sbpgBtn setBackgroundImage:[UIImage imageNamed:sbpgImg] forState:UIControlStateNormal];
    sbpgBtn.tag = 1003;
    [sbpgBtn addTarget:self action:@selector(StatusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [alarmStatusView addSubview:sbpgBtn];
    
    UIImageView *sbpgdangqianImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(47), -FrameWidth(36), FrameWidth(25), FrameWidth(25))];
    sbpgdangqianImg.image = [UIImage imageNamed:sbpgDian];
    [sbpgBtn addSubview:sbpgdangqianImg];
    
    
    
    UIButton *gjjjBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(410), FrameWidth(22), FrameWidth(120), FrameWidth(50))];
    [gjjjBtn setBackgroundImage:[UIImage imageNamed:gjjjImg] forState:UIControlStateNormal];
    gjjjBtn.tag = 1004;
    [gjjjBtn addTarget:self action:@selector(StatusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [alarmStatusView addSubview:gjjjBtn];
    
    UIImageView *gjjjdangqianImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(47), FrameWidth(56), FrameWidth(25), FrameWidth(25))];
    gjjjdangqianImg.image = [UIImage imageNamed:gjjjDian];
    [gjjjBtn addSubview:gjjjdangqianImg];
    
    
    
    UIButton *gqBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(520), FrameWidth(115), FrameWidth(120), FrameWidth(50))];
    
    [gqBtn setTitle:@"挂起" forState:UIControlStateNormal];
    gqBtn.titleLabel.font = _listFont;
    [gqBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //[gqBtn setBackgroundImage:[UIImage imageNamed:sbpgImg] forState:UIControlStateNormal];
    [alarmStatusView addSubview:gqBtn];
    
    UIImageView *gqdangqianImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(47), -FrameWidth(36), FrameWidth(25), FrameWidth(25))];
    gqdangqianImg.image = [UIImage imageNamed:gqDian];
    [gqBtn addSubview:gqdangqianImg];
    
    for(int i = 0; i < 4; ++i) {
        UIImageView *dangqianImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(95)+i*FrameWidth(100), FrameWidth(90), FrameWidth(53), FrameWidth(5))];
        dangqianImg.image = [UIImage imageNamed:@"alarm_dian"];
        [alarmStatusView addSubview:dangqianImg];
    }
    
    
    UIView *manageInsertDesc = [[UIView alloc]initWithFrame:alarmStatusView.frame];
//#warning 告警标签
    //告警标签
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(manageInsertDesc.frame), 0, 0);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    NSLog(@"告警标签self.chooseStatus  %@  %@",_AllStatus,self.reStatus);
    //if([self.chooseStatus isEqualToString:@"shooting"]||[self.chooseStatus isEqualToString:@"completed"]||[self.chooseStatus isEqualToString:@"已解决"]||[self.chooseStatus isEqualToString:@"announce"]){//设备排故
        //||||![self.objects[@"recordDescription"] isEqual:[NSNull null]]||[self.chooseStatus isEqualToString:@"emergency"]
    //if(_isShooting || [self.chooseStatus isEqualToString:@"shooting"] ||[self.chooseStatus isEqualToString:@"已解决"]){
    if(_isShooting || [self.reStatus isEqualToString:@"shooting"]|| [self.reStatus isEqualToString:@"completed"] ||[self.reStatus isEqualToString:@"已解决"]|| [self.chooseStatus isEqualToString:@"shooting"]){

        //处理描述
        UIView *manageDesc = [[UIView alloc]initWithFrame:CGRectMake(0,alarmStatusView.frame.origin.y + alarmStatusView.frame.size.height + FrameWidth(10), WIDTH_SCREEN,FrameWidth(78))];
        manageDesc.backgroundColor = [UIColor whiteColor];
        [thiscell addSubview:manageDesc];
        
        UIImageView *manageImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(25), FrameWidth(20), FrameWidth(25), FrameWidth(35))];
        manageImg.image = [UIImage imageNamed:@"alarm_desc"];
        [manageDesc addSubview:manageImg];
        //名称
        UILabel *manageLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(80), FrameWidth(23), FrameWidth(500), FrameWidth(30))];
        manageLabel.text = @"处理描述";
        manageLabel.font = FontSize(17);
        //nameLabel.textColor = [UIColor grayColor];
        [manageDesc addSubview:manageLabel];
    
        //输入框
        manageInsertDesc = [[UIView alloc]initWithFrame:CGRectMake(0,manageDesc.frame.origin.y + manageDesc.frame.size.height + 1, WIDTH_SCREEN,FrameWidth(256))];
        manageInsertDesc.backgroundColor = [UIColor whiteColor];
        [thiscell addSubview:manageInsertDesc  ];
        
        UIView * resultTView = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(26), FrameWidth(25), FrameWidth(590), FrameWidth(156))];
        resultTView.layer.borderWidth = 1;
        resultTView.layer.borderColor = BGColor.CGColor;
        [manageInsertDesc addSubview:resultTView];
        _manageInsert = [FSTextView textView];
        if(![self.objects[@"recordDescription"] isEqual:[NSNull null]]){
            _manageInsert.text = self.objects[@"recordDescription"]?self.objects[@"recordDescription"]:@"";
        }
        if(![self.chooseStatus isEqualToString:@"shooting"]){
            //_manageInsert.editable = NO;
        }
        
        [manageInsertDesc addSubview:_manageInsert];
        [self addTViewParent:resultTView textView:_manageInsert text:_manageInsert.text placeholder:@"排故描述" maxLength:1000];
        CGFloat collectionViewHeihgt = 0.0;
        if (self.modelArray.count > 0) {
            int num = (int)self.modelArray.count % 4 == 0 ? (int)self.modelArray.count / 4 : (int)self.modelArray.count / 4 + 1;
            collectionViewHeihgt = num*50;
        }
        
        self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(resultTView.frame), WIDTH_SCREEN, collectionViewHeihgt);
        
        [manageInsertDesc addSubview:self.collectionView];
        
        
        //if(![self.chooseStatus isEqualToString:@"shooting"]){
            //保存按钮
            UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(500), CGRectGetMaxY(self.collectionView.frame) + 15, FrameWidth(126), FrameWidth(40))];
            [saveBtn setBackgroundImage:[UIImage imageNamed:@"alarm_save"] forState:UIControlStateNormal];
            [saveBtn addTarget:self action:@selector(addRecordDescription) forControlEvents:UIControlEventTouchUpInside];
            [manageInsertDesc addSubview:saveBtn];
        //}
        manageInsertDesc.lx_height = manageInsertDesc.lx_height + self.collectionView.lx_height;
    }
    UIView *manageInsertDesc1 = [[UIView alloc]initWithFrame:manageInsertDesc.frame];
    
    if([self.hangupStatus boolValue] == 0 ){
        //处理描述
        UIView *manageDesc = [[UIView alloc]initWithFrame:CGRectMake(0,manageInsertDesc.frame.origin.y + manageInsertDesc.frame.size.height + FrameWidth(10), WIDTH_SCREEN,FrameWidth(78))];
        manageDesc.backgroundColor = [UIColor whiteColor];
        [thiscell addSubview:manageDesc  ];
        
        UIImageView *manageImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(25), FrameWidth(20), FrameWidth(25), FrameWidth(35))];
        manageImg.image = [UIImage imageNamed:@"alarm_desc"];
        [manageDesc addSubview:manageImg];
        //名称
        UILabel *manageLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(80), FrameWidth(23), FrameWidth(500), FrameWidth(30))];
        manageLabel.text = @"挂起原因";
        manageLabel.font = FontSize(17);
        //nameLabel.textColor = [UIColor grayColor];
        [manageDesc addSubview:manageLabel];
        //输入框
        manageInsertDesc1 = [[UIView alloc]initWithFrame:CGRectMake(0,manageDesc.frame.origin.y + manageDesc.frame.size.height + 1, WIDTH_SCREEN,FrameWidth(256))];
        manageInsertDesc1.backgroundColor = [UIColor whiteColor];
        [thiscell addSubview:manageInsertDesc1  ];
        
        UITextView *manageInsert = [[UITextView alloc]initWithFrame:CGRectMake(FrameWidth(26), FrameWidth(25), FrameWidth(590), FrameWidth(156))];
        manageInsert.layer.borderWidth = 1;
        manageInsert.font = FontSize(16);
        manageInsert.layer.borderColor = BGColor.CGColor;
        if(![self.objects[@"alarmDescription"] isEqual:[NSNull null]]){
            manageInsert.text = self.objects[@"alarmDescription"]?self.objects[@"alarmDescription"]:@"";
        }
        manageInsert.textColor = [UIColor grayColor];
        [manageInsert setEditable:NO];
        
        [manageInsertDesc1 addSubview:manageInsert];
    }else if([self.alarmStatus isEqualToString:@"removed"] ){
        //处理描述
        UIView *manageDesc = [[UIView alloc]initWithFrame:CGRectMake(0,manageInsertDesc.frame.origin.y + manageInsertDesc.frame.size.height + FrameWidth(10), WIDTH_SCREEN,FrameWidth(78))];
        manageDesc.backgroundColor = [UIColor whiteColor];
        [thiscell addSubview:manageDesc  ];
        
        UIImageView *manageImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(25), FrameWidth(20), FrameWidth(25), FrameWidth(35))];
        manageImg.image = [UIImage imageNamed:@"alarm_desc"];
        [manageDesc addSubview:manageImg];
        //名称
        UILabel *manageLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(80), FrameWidth(23), FrameWidth(500), FrameWidth(30))];
        manageLabel.text = @"解除原因";
        manageLabel.font = FontSize(17);
        //nameLabel.textColor = [UIColor grayColor];
        [manageDesc addSubview:manageLabel];
        //输入框
        manageInsertDesc1 = [[UIView alloc]initWithFrame:CGRectMake(0,manageDesc.frame.origin.y + manageDesc.frame.size.height + 1, WIDTH_SCREEN,FrameWidth(256))];
        manageInsertDesc1.backgroundColor = [UIColor whiteColor];
        [thiscell addSubview:manageInsertDesc1  ];
        
        self.removeInsert = [[UITextView alloc]initWithFrame:CGRectMake(FrameWidth(26), FrameWidth(25), FrameWidth(590), FrameWidth(156))];
        self.removeInsert.layer.borderWidth = 1;
        self.removeInsert.font = FontSize(16);
        self.removeInsert.layer.borderColor = BGColor.CGColor;
        if(![self.objects[@"alarmDescription"] isEqual:[NSNull null]]){
            self.removeInsert.text = self.objects[@"alarmDescription"]?self.objects[@"alarmDescription"]:@"";
        }
        self.removeInsert.textColor = [UIColor grayColor];
        
        //解除原因保存
        UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(500), CGRectGetMaxY(self.removeInsert.frame) + 15, FrameWidth(126), FrameWidth(40))];
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"alarm_save"] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(jiechuTwoSure) forControlEvents:UIControlEventTouchUpInside];
        [manageInsertDesc1 addSubview:saveBtn];
        
        [manageInsertDesc1 addSubview:self.removeInsert];
    }
    
    
    //流程记录
    UIView *flowDesc = [[UIView alloc]initWithFrame:CGRectMake(0,manageInsertDesc1.frame.origin.y + manageInsertDesc1.frame.size.height + FrameWidth(10), WIDTH_SCREEN,FrameWidth(78))];
    flowDesc.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:flowDesc  ];
    
    UIImageView *flowImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(25), FrameWidth(20), FrameWidth(25), FrameWidth(35))];
    flowImg.image = [UIImage imageNamed:@"alarm_desc"];
    [flowDesc addSubview:flowImg];
    //名称
    UILabel *flowLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(80), FrameWidth(23), FrameWidth(500), FrameWidth(30))];
    flowLabel.text = @"流程记录";
    flowLabel.font = FontSize(17);
    //nameLabel.textColor = [UIColor grayColor];
    [flowDesc addSubview:flowLabel];
    
    
    UIView *flowListView = [[UIView alloc]initWithFrame:CGRectMake(0,flowDesc.frame.origin.y + flowDesc.frame.size.height + 1, WIDTH_SCREEN,FrameWidth(50)+FrameWidth(60)*self.AlarmItem.count)];
    flowListView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview: flowListView ];
    for (NSInteger i=0; i<self.AlarmItem.count; i++) {
        AlarmItems  *dictArray= self.AlarmItem[i];
        UIImageView *dianImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(32), FrameWidth(50)+FrameWidth(60)*i, FrameWidth(13), FrameWidth(13))];
        dianImg.image = [UIImage imageNamed:@"alarm_dangqian"];
        [flowListView addSubview:dianImg];
        
        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(60), FrameWidth(25)+FrameWidth(60)*i, FrameWidth(550), FrameWidth(65))];
        descLabel.textColor = [UIColor grayColor];
        if([dictArray.userName isEqual:[NSNull null]] || dictArray.userName == nil){
            descLabel.text =  [NSString stringWithFormat:@"%@  %@ ",[FrameBaseRequest getDateByTimesp:dictArray.createTime dateType:@"YYYY-MM-dd HH:mm"],dictArray.content ] ;// dictArray.content;
        }else{
            descLabel.text =  [NSString stringWithFormat:@"%@  %@  %@",[FrameBaseRequest getDateByTimesp:dictArray.createTime dateType:@"YYYY-MM-dd HH:mm"],dictArray.content,dictArray.userName ] ;// dictArray.content;
        }
        descLabel.lineBreakMode = NSLineBreakByCharWrapping;
        descLabel.numberOfLines = 2;
        descLabel.font = _listFont;
        [flowListView addSubview:descLabel];
        
    }
    allHeight = flowListView.frame.origin.y + flowListView.frame.size.height;
    return thiscell;
    
    
}

#pragma mark - UITableviewDelegate 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [self.view endEditing:YES];
    [_vc.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    if(self.expertUserTabView == tableView){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.AlarmUserItem[indexPath.row].tel];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        [callWebview release];
        [str release];
    }
    
}


-(void)videoEvent:(UIButton *) nlabel{
    [FrameBaseRequest showMessage:@"功能正在开发中"];
    
}
-(void)noticeEvent:(UIButton *) nlabel{
    ContactManufacturerView *popView = [ContactManufacturerView new];
    [popView InitializationListView];
    [popView show];
    popView.contactManufactureArray = self.dataArray;
    
}
-(void)StatusBtnClick:(UIButton *)btn{
    
    NSString *msg = @"";
    for (NSInteger i=0; i<self.AlarmItem.count; i++) {
        AlarmItems  *dictArray= self.AlarmItem[i];
        if([dictArray.status isEqualToString:@"confirmed"]&&btn.tag == 1000){
            msg = [NSString stringWithFormat:@"告警确认\n\n处理人:%@\n\n处理时间：%@",dictArray.userName, [FrameBaseRequest getDateByTimesp:dictArray.createTime dateType:@"YYYY-MM-dd HH:mm:ss"]];
            break ;
        }
        
        if([dictArray.status isEqualToString:@"emergency"]&&btn.tag == 1001){
            msg = [NSString stringWithFormat:@"应急处理\n\n处理人:%@\n\n处理时间：%@",dictArray.userName, [FrameBaseRequest getDateByTimesp:dictArray.createTime dateType:@"YYYY-MM-dd HH:mm:ss"]];
            break ;
        }
        if([dictArray.status isEqualToString:@"announce"]&&btn.tag == 1002){
            msg = [NSString stringWithFormat:@"故障通告\n\n处理人:%@\n\n处理时间：%@",dictArray.userName, [FrameBaseRequest getDateByTimesp:dictArray.createTime dateType:@"YYYY-MM-dd HH:mm:ss"]];
            break ;
        }
        if([dictArray.status isEqualToString:@"shooting"]&&btn.tag == 1003){
            msg = [NSString stringWithFormat:@"设备排故\n\n处理人:%@\n\n处理时间：%@",dictArray.userName, [FrameBaseRequest getDateByTimesp:dictArray.createTime dateType:@"YYYY-MM-dd HH:mm:ss"]];
            
            break ;
        }
        
        if([dictArray.status isEqualToString:@"completed"]&&btn.tag == 1004){
            msg = [NSString stringWithFormat:@"告警解决\n\n处理人:%@\n\n处理时间：%@",dictArray.userName, [FrameBaseRequest getDateByTimesp:dictArray.createTime dateType:@"YYYY-MM-dd HH:mm:ss"]];
            break ;
        }
        
    }
    if([msg isEqualToString:@""]){
        NSLog(@"self.reStatusself.reStatusself.reStatusself.reStatus %@",self.reStatus);
        if([self.reStatus isEqualToString:@"emergency"] ||[self.reStatus isEqualToString: @"announce"]||[self.reStatus isEqualToString: @"shooting"]||[self.reStatus isEqualToString: @"completed"]){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            if([[userDefaults objectForKey:@"hang"] boolValue] == true ){
                return ;
            }
            if([self.hangupStatus boolValue] == 0){//挂起
                
            }else{
                if(btn.tag == 1001){
                    self.chooseStatus = @"emergency";
                }else if(btn.tag == 1002){
                    self.chooseStatus = @"announce";
                }else if(btn.tag == 1003){
                    self.chooseStatus = @"shooting";
                    self.labLeArray = nil;
                    [self tagData];
                }else {
                    return ;
                }
                [self setupTable];
                return;
            }
        }
        
        
        
        return ;
    }
    
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:msg];
    [messageAtt addAttribute:NSFontAttributeName value:_listFont range:NSMakeRange(0, msg.length)];
    [messageAtt addAttribute:NSForegroundColorAttributeName value:[UIColor darkTextColor] range:NSMakeRange(0, msg.length)];
    [alertContor setValue:messageAtt forKey:@"attributedMessage"];
    
    
    [alertContor addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertContor animated:NO completion:nil];
    
    
    return;
}

-(void)guaqi{
    
    if([self.hangupStatus boolValue]==0){
        UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"确定解除挂起？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            [self guaqiPut:@"false" reason:@""];
            
        }]];
        
        [self presentViewController:alertContor animated:NO completion:nil];
        
        return ;
    }
    _vc = [UIViewController new];
    
    _vc.view.frame = CGRectMake(0, 0,WIDTH_SCREEN,  HEIGHT_SCREEN);
    //_vc.view.layer.cornerRadius = 4.0;
    _vc.view.layer.masksToBounds = YES;
    
    
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(120), FrameWidth(320), FrameWidth(400) , FrameWidth(380))];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_vc.view addSubview:_bgView];
    _bgView.layer.cornerRadius = 9.0;
    
    UILabel * reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0,0, FrameWidth(400) , FrameWidth(80))];
    reasonLabel.text = @"挂起原因";
    reasonLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview: reasonLabel];
    
    UILabel * line1  = [[UILabel alloc]initWithFrame:CGRectMake( 0,FrameWidth(90), FrameWidth(400) , 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview: line1];
    
    UILabel * line2  = [[UILabel alloc]initWithFrame:CGRectMake( 0,FrameWidth(310), FrameWidth(400) , 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview: line2];
    
    UILabel * line3  = [[UILabel alloc]initWithFrame:CGRectMake( FrameWidth(200),FrameWidth(310), 1 ,FrameWidth(60))];
    line3.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview: line3];
    
    UIView * resultTView = [[UIView alloc]initWithFrame:CGRectMake( FrameWidth(15),FrameWidth(105), FrameWidth(370) , FrameWidth(190))];
    resultTView.layer.borderWidth = 1;
    resultTView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_bgView addSubview:resultTView];
    _reasonView = [FSTextView textView];
    _reasonView.delegate = self;
    [_bgView addSubview:_reasonView];
    [self addTViewParent:resultTView textView:_reasonView text:_reasonView.text placeholder:@"挂起后将不能继续告警处理流程" maxLength:200];
    
    
    
    
    UIButton * cancelBtn =[ [UIButton alloc]initWithFrame:CGRectMake( FrameWidth(60),FrameWidth(310), FrameWidth(140) , FrameWidth(60))];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:navigationColor forState:UIControlStateNormal];
    //[cancelBtn setImage:[UIImage imageNamed:@"alarm_close"] forState:UIControlStateNormal];
    //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"alarm_close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(guaqiCancel) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:cancelBtn];
    
    UIButton * sureBtn =[ [UIButton alloc]initWithFrame:CGRectMake( FrameWidth(200),FrameWidth(310), FrameWidth(140) , FrameWidth(60))];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:navigationColor forState:UIControlStateNormal];
    //[sureBtn setImage:[UIImage imageNamed:@"alarm_close"] forState:UIControlStateNormal];
    //[sureBtn setBackgroundImage:[UIImage imageNamed:@"alarm_close"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(guaqiSure) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:sureBtn];
    
    
    
    
    [self cb_presentPopupViewController:_vc animationType:CBPopupViewAnimationSlideFromTop aligment:CBPopupViewAligmentCenter overlayDismissed:nil];
    
    
}


-(void)guaqiSure{
    
    
    if([CommonExtension isEmptyWithString:_reasonView.text]){
        [_vc.view endEditing:YES];
        [FrameBaseRequest showMessage:@"请输入挂起原因"];
        return ;
    }
    
    [self guaqiPut:@"true" reason:_reasonView.text];
}

-(void)guaqiPut:(NSString *)hangupStatus reason:(NSString *)reason{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"alarmInfoId"] = _id;
    params[@"hangupStatus"] = hangupStatus;
    params[@"description"] = reason;
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@%@?alarmInfoId=%@&hangupStatus=%@&description=%@",WebHost,@"/api/updateHangupStatus",_id,hangupStatus,reason];
    
    [FrameBaseRequest putWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }else{
            [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
            [self guaqiCancel];
            self.chooseStatus = @"";
            self.needAlarmReloadData = true;
            self.objects = nil;
            [self setupTable];
            return ;
        }
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}


-(void)addRecordDescription{//添加处理描述
    NSLog(@"添加处理描述");
    if([CommonExtension isEmptyWithString:_manageInsert.text]){
        [FrameBaseRequest showMessage:@"不能为空"];return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"alarmId"] = _id;
    params[@"recordDescription"] = _manageInsert.text;
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@%@?alarmId=%@&recordDescription=%@",WebHost,@"/api/addRecordDescription",_id,params[@"recordDescription"]];
    
    //FrameRequestURL = [FrameRequestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }else{
            [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
            //刷新
            self.objects = nil;
            [self setupTable];
            return ;
        }
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
}
-(void)jiechugaojingAction{
    _vc = [UIViewController new];
    
    _vc.view.frame = CGRectMake(0, 0,WIDTH_SCREEN,  HEIGHT_SCREEN);
    //_vc.view.layer.cornerRadius = 4.0;
    _vc.view.layer.masksToBounds = YES;
    
    
    
    UIView *_jiechugaojingbgView = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(120), FrameWidth(320), FrameWidth(400) , FrameWidth(380))];
    _jiechugaojingbgView.backgroundColor = [UIColor whiteColor];
    [_vc.view addSubview:_jiechugaojingbgView];
    _jiechugaojingbgView.layer.cornerRadius = 9.0;
    
    UILabel * reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0,0, FrameWidth(400) , FrameWidth(80))];
    reasonLabel.text = @"解除原因";
    reasonLabel.textAlignment = NSTextAlignmentCenter;
    [_jiechugaojingbgView addSubview: reasonLabel];
    
    UILabel * line1  = [[UILabel alloc]initWithFrame:CGRectMake( 0,FrameWidth(90), FrameWidth(400) , 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [_jiechugaojingbgView addSubview: line1];
    
    UILabel * line2  = [[UILabel alloc]initWithFrame:CGRectMake( 0,FrameWidth(310), FrameWidth(400) , 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [_jiechugaojingbgView addSubview: line2];
    
    UILabel * line3  = [[UILabel alloc]initWithFrame:CGRectMake( FrameWidth(200),FrameWidth(310), 1 ,FrameWidth(60))];
    line3.backgroundColor = [UIColor lightGrayColor];
    [_jiechugaojingbgView addSubview: line3];
    
    _jiechugaojingreasonView = [[UITextView alloc]initWithFrame:CGRectMake( FrameWidth(15),FrameWidth(105), FrameWidth(370) , FrameWidth(190))];
    _jiechugaojingreasonView.font = FontSize(16);
    _jiechugaojingreasonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _jiechugaojingreasonView.layer.borderWidth = 1.0;
    [_jiechugaojingbgView addSubview:_jiechugaojingreasonView];
    _jiechugaojingreasonView.delegate=self;
    
    _jiechugaojingreasonView.returnKeyType=UIReturnKeyDone;
    
    UIButton * cancelBtn =[ [UIButton alloc]initWithFrame:CGRectMake( FrameWidth(60),FrameWidth(310), FrameWidth(140) , FrameWidth(60))];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:navigationColor forState:UIControlStateNormal];
    //[cancelBtn setImage:[UIImage imageNamed:@"alarm_close"] forState:UIControlStateNormal];
    //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"alarm_close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(guaqiCancel) forControlEvents:UIControlEventTouchUpInside];
    [_jiechugaojingbgView addSubview:cancelBtn];
    
    UIButton * sureBtn =[ [UIButton alloc]initWithFrame:CGRectMake( FrameWidth(200),FrameWidth(310), FrameWidth(140) , FrameWidth(60))];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:navigationColor forState:UIControlStateNormal];
    //[sureBtn setImage:[UIImage imageNamed:@"alarm_close"] forState:UIControlStateNormal];
    //[sureBtn setBackgroundImage:[UIImage imageNamed:@"alarm_close"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(jiechuSure) forControlEvents:UIControlEventTouchUpInside];
    [_jiechugaojingbgView addSubview:sureBtn];
    
    
    
    
    [self cb_presentPopupViewController:_vc animationType:CBPopupViewAnimationSlideFromTop aligment:CBPopupViewAligmentCenter overlayDismissed:nil];
}
-(void)completedSure{//确定解决
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"确定告警已解决？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"alarmInfoId"] = _id;
        params[@"content"] = @"确定告警已解决";
        params[@"status"] = @"completed";
        
        NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/api/atcAlarmHandleRecord"];
        
        //FrameRequestURL = [FrameRequestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                
                return ;
            }else{
                [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
                
                self.needAlarmReloadData = true;
                self.chooseStatus = @"";
                self.objects = nil;
                [self setupTable];
                return ;
            }
            
        } failure:^(NSError *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
                [FrameBaseRequest logout];
                UIViewController *viewCtl = self.navigationController.viewControllers[0];
                [self.navigationController popToViewController:viewCtl animated:YES];
                return;
            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        }];
        
    }]];
    
    [self presentViewController:alertContor animated:NO completion:nil];
    
    return ;
}
-(void)paiguwancheng{
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"确定排故完成？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if([CommonExtension isEmptyWithString:_manageInsert.text]){
            [FrameBaseRequest showMessage:@"不能为空"];return ;
        }else{
            [self performSelector:@selector(addRecordDescription) withObject:nil afterDelay:1];
            [self atcAlarmHandleRecord];
        }
        
        
        
        
    }]];
    
    [self presentViewController:alertContor animated:NO completion:nil];
    
    return ;
}
-(void)atcAlarmHandleRecord{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"alarmInfoId"] = _id;
    params[@"content"] = @"确定排故完成";
    params[@"status"] = @"shooting";
    params[@"description"] = _manageInsert.text;
    
    NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/api/atcAlarmHandleRecord"];
    
    //FrameRequestURL = [FrameRequestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }else{
            [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
            
            self.needAlarmReloadData = true;
            
            self.chooseStatus = @"";
            self.objects = nil;
            [self setupTable];
            return ;
        }
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

-(void)tonggaowancheng{
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"确定通告完成？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"alarmInfoId"] = _id;
        params[@"content"] = @"确定通告完成";
        params[@"status"] = @"announce";
        
        NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/api/atcAlarmHandleRecord"];
        
        //FrameRequestURL = [FrameRequestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                
                return ;
            }else{
                [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
                
                self.needAlarmReloadData = true;
                self.chooseStatus = @"";
                self.objects = nil;
                [self setupTable];
                return ;
            }
            
        } failure:^(NSError *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
                [FrameBaseRequest logout];
                UIViewController *viewCtl = self.navigationController.viewControllers[0];
                [self.navigationController popToViewController:viewCtl animated:YES];
                return;
            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        }];
        
    }]];
    
    [self presentViewController:alertContor animated:NO completion:nil];
    
    return ;
}

-(void)chuliwancheng{
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"确定处理完成？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"alarmInfoId"] = _id;
        params[@"content"] = @"应急处理";
        params[@"status"] = @"emergency";
        
        NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/api/atcAlarmHandleRecord"];
        
        //FrameRequestURL = [FrameRequestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                
                return ;
            }else{
                [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
                
                self.needAlarmReloadData = true;
                self.chooseStatus = @"";
                self.objects = nil;
                [self setupTable];
                return ;
            }
            
        } failure:^(NSError *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
                [FrameBaseRequest logout];
                UIViewController *viewCtl = self.navigationController.viewControllers[0];
                [self.navigationController popToViewController:viewCtl animated:YES];
                return;
            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        }];
        
    }]];
    
    [self presentViewController:alertContor animated:NO completion:nil];
    
    return ;
}

-(void)querengaojing{
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"确定进入处理？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"alarmInfoId"] = _id;
        params[@"content"] = @"确认告警";
        params[@"status"] = @"confirmed";
        
        NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/api/atcAlarmHandleRecord"];
        
        //FrameRequestURL = [FrameRequestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                
                return ;
            }else{
                [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
                
                self.needAlarmReloadData = true;
                self.chooseStatus = @"";
                self.objects = nil;
                [self setupTable];
                return ;
            }
            
        } failure:^(NSError *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
                [FrameBaseRequest logout];
                UIViewController *viewCtl = self.navigationController.viewControllers[0];
                [self.navigationController popToViewController:viewCtl animated:YES];
                return;
            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        }];
        
    }]];
    
    [self presentViewController:alertContor animated:NO completion:nil];
    
    return ;
}
-(void)jiechuSure{
    if([CommonExtension isEmptyWithString:_jiechugaojingreasonView.text]){
        [_vc.view endEditing:YES];
        [FrameBaseRequest showMessage:@"请输入解除原因"];
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"alarmId"] = [NSString stringWithFormat:@"%@",_id];
    params[@"description"] = [NSString stringWithFormat:@"%@",_jiechugaojingreasonView.text];//;
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@%@?alarmId=%@&description=%@",WebHost,@"/api/cancelAlarm",_id,_jiechugaojingreasonView.text];
    
    
    //[WebHost stringByAppendingString:@"/api/cancelAlarm"];
    
    //FrameRequestURL = [FrameRequestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [FrameBaseRequest putWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }else{
            [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
            
            self.needAlarmReloadData = true;
            self.chooseStatus = @"";
            self.objects = nil;
            [self setupTable];
            return ;
        }
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}




-(void)jiechuTwoSure{
    if([CommonExtension isEmptyWithString:self.removeInsert.text]){
        [self.view endEditing:YES];
        [FrameBaseRequest showMessage:@"请输入解除原因"];
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"alarmId"] = [NSString stringWithFormat:@"%@",self.id];
    params[@"alarmDescription"] = [NSString stringWithFormat:@"%@",self.removeInsert.text];//;
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@%@?alarmId=%@&alarmDescription=%@",WebHost,@"/api/addAlarmDescription",self.id,self.removeInsert.text];
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }else{
            [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
            
            self.needAlarmReloadData = true;
            self.chooseStatus = @"";
            self.objects = nil;
            [self setupTable];
            return ;
        }
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}


-(void)guaqiCancel{//关闭弹窗
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
}
-(void)closeAction:(UIButton *)btn{
    
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
}
-(void)jftapevent:(UILabel *) nlabel{
    StationRoomController  *StationRoom = [[StationRoomController alloc] init];
    [self.navigationController pushViewController:StationRoom animated:YES];
}

-(void)sptapevent:(UILabel *) nlabel{
    StationVideoListController  *StationVideo = [[StationVideoListController alloc] init];
    [self.navigationController pushViewController:StationVideo animated:YES];
}


-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    
    UIButton *rightButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButon.titleLabel.font = FontSize(15);
    [rightButon setTitle:@"备件" forState:UIControlStateNormal];
    rightButon.frame = CGRectMake(0,0,50,40);
    //[rightButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    //[rightButon setContentEdgeInsets:UIEdgeInsetsMake(0, - 17, 0, 17)];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [rightButon addTarget:self action:@selector(beijianAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButon];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
}
-(void)backAction {
    
    if(self.needAlarmReloadData == true){
        //返回时，确定是否通知刷新
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"alarmBottomapevent" object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)beijianAction {
    AlarmMachineTypeListController  *MachineTypeList = [[AlarmMachineTypeListController alloc] init];
    [self.navigationController pushViewController:MachineTypeList animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_vc.view endEditing:YES];
    [self.view endEditing:YES];
}




-(void)addTViewParent:(UIView *)ParentView textView:(FSTextView *)textView text:(NSString*)text placeholder:(NSString *)placeholder maxLength:(int)maxLength{
    
    // FSTextView
    //textView = [FSTextView textView];
    textView.placeholder = placeholder;
    textView.font = FontSize(16);
    textView.canPerformAction = NO;
    [ParentView addSubview:textView];
    textView.text = text;
    textView.textColor = [UIColor grayColor];
    // 限制输入最大字符数.
    textView.maxLength = maxLength;
    // 添加输入改变Block回调.
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        NSLog(@"addTextDidChangeHandler   %@",textView.text);
    }];
    // 添加到达最大限制Block回调.
    [textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        NSLog(@"addTextLengthDidMaxHandler");
    }];
    // constraint
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [ParentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    [ParentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}


//注册键盘事件
- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //键盘消失时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification{
    NSLog(@"keyboardWillShow");
    
    NSDictionary* info = [notification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    _keyBoardHeight = kbSize.height;
    
    [self.tableview setFrameHeight:HEIGHT_SCREEN - ZNAVViewH  -_keyBoardHeight];
    [self.tableview setContentOffset:CGPointMake(0, _keyBoardHeight) animated:YES];
    //设置视图移动的位移
    //[_vc.view setOriginY:_vc.view.originY -50];
    //CGPoint offset = self.tableview.contentOffset;
    //offset.y += _keyBoardHeight;
    //[self.tableview setContentOffset:offset];
        //self.tableview.frame = CGRectMake(self.tableview.frame.origin.x, 0, self.tableview.frame.size.width, self.tableview.frame.size.height-_keyBoardHeight);
       // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
       // [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
   // }
    
    
}

- (void)keyboardWillHide:(NSNotification *)notification{//返回
    NSLog(@"keyboardWillHide");
    //[self.tableview setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.tableview setFrameHeight: HEIGHT_SCREEN - ZNAVViewH -_nowheight ];
   // [_vc.view setOriginY:_vc.view.originY + 50];
    //self.tableview.frame = CGRectMake(self.tableview.frame.origin.x, 0, self.tableview.frame.size.width, self.view.bounds.size.height);
}

- (NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

- (void)clickCell:(NSString *)text isBool:(BOOL)isBool{
    if (isBool) {
        self.manageInsert.text = [self wordProcessing:self.manageInsert.text markText:text];
    } else {
        self.manageInsert.text = [self wordProcessing:self.manageInsert.text markText:text];
    }
}



/**
 处理manageInsert 与标签文字逻辑

 @param textViewTxt manageInsert 文字
 @param markText 标签文字
 @return manageInsert文字
 */
- (NSString *)wordProcessing:(NSString *)textViewTxt markText:(NSString *)markText {
    return  textViewTxt = [NSString stringWithFormat:@"%@%@",textViewTxt,markText];
    /*
    if ([textViewTxt containsString:[NSString stringWithFormat:@"%@",markText]]) {
       return textViewTxt = [textViewTxt stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@", markText] withString:@""];
    } else {
        return  textViewTxt = [NSString stringWithFormat:@"%@%@",textViewTxt,markText];
    }
     */
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PopularCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PopularCollectionViewCellID2 forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PopularModel *model = self.modelArray[indexPath.row];
    model.Checked = true;//!model.Checked
    [self clickCell:model.name isBool:model.Checked];
    [self.collectionView reloadData];
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//定义每个Section 的 margin (内容整体边距设置)//分别为上、左、下、右
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath   {
    return CGSizeMake((WIDTH_SCREEN-50)/4, 30);
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset =UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.itemSize = CGSizeMake(100, 120);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.bounces = YES;
        _collectionView.scrollEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PopularCollectionViewCell class]) bundle:nil]  forCellWithReuseIdentifier:PopularCollectionViewCellID2];
    }
    
    return _collectionView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.spreadButton release];
    [super dealloc];
}
@end


