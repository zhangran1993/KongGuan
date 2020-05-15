//
//  StationRoomController.m
//  Frame
//
//  Created by hibayWill on 2018/3/30.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "StationRoomController.h"
#import "FrameBaseRequest.h"
#import <UIImageView+WebCache.h>
#import "StationItems.h"
#import "StationVideoListController.h"
#import "StationMachineController.h"
#import "StationairConditionerController.h"
#import "EquipmentDetailsModel.h"
#import "EquipmentStatusModel.h"
#import "UIView+LX_Frame.h"
#import <MJExtension.h>
#import "UIColor+Extension.h"
@interface StationRoomController ()<UITableViewDataSource,UITableViewDelegate,ParentViewDelegate>
@property (nonatomic,copy) NSString* airport;
@property (nonatomic,copy) NSString* address;
@property (nonatomic,copy) NSDictionary * romeDetail;


@property (nonatomic, copy) NSMutableArray * objects0;
@property (nonatomic, copy) NSMutableArray * equipmentList;
@property NSUInteger newHeight1;
@property  (assign,nonatomic) NSMutableArray<StationItems *> *roomList;
@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;
@property NSMutableArray *objects1;
@property NSMutableArray *objects10;
@property NSMutableArray *objects2;
@property NSMutableArray *equipmentArray;
@property (nonatomic, strong) NSMutableArray *objects3;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *statusArray;
/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property   int viewnum;
@property (nonatomic,copy) NSString* litpic;

@property (nonatomic,assign) double iscollect;
@property(nonatomic) UIView* bottomView;
@property(nonatomic) UITableView *tableview;
@property(nonatomic) UITableView *filterTabView;
@property(nonatomic) UIButton *rightButton;
@end

@implementation StationRoomController

#pragma mark - 全局常量



#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorStyle = NO;
    
    
    [super viewDidLoad];
    [self backBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _room_name;//详情
    self.modelArray = [NSMutableArray array];
    self.statusArray = [NSMutableArray array];
    _equipmentArray = [NSMutableArray array];
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationRoomController viewWillAppear");
    if(!_station_code){
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    [self setupTable];
}
#pragma mark - private methods 私有方法

- (void)setupTable{
    
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/engineRoomInfo/%@/%@",_station_code,_room_code]];
    
    NSLog(@"%@",FrameRequestURL);
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [self.modelArray removeAllObjects];
        [self.statusArray removeAllObjects];
        _romeDetail = [result[@"value"] copy];
        
        _objects0 = _romeDetail[@"roomList"];
        _objects1 = [_romeDetail[@"environmentDetails"]copy];
        _equipmentList = [_romeDetail[@"equipmentList"]copy];
        _objects2 = [_romeDetail[@"powerDetails"]copy];
        _equipmentArray = [_romeDetail[@"equipmentDetails"]copy];
        _roomList = [[[StationItems class] mj_objectArrayWithKeyValuesArray:_romeDetail[@"roomList"] ] copy];
        
        if (result[@"value"][@"equipmentDetails"] && [result[@"value"][@"equipmentDetails"] isKindOfClass:[NSArray class]]) {
            _objects3 = [result[@"value"][@"equipmentDetails"] copy];
            for (NSDictionary *dict in result[@"value"][@"equipmentDetails"]) {
                EquipmentDetailsModel *model = [EquipmentDetailsModel mj_objectWithKeyValues:dict];
                [self.modelArray addObject:model];
            }
        }
        
        if (result[@"value"][@"equipmentStatus"] && [result[@"value"][@"equipmentStatus"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = result[@"value"][@"equipmentStatus"];
            EquipmentStatusModel *model = [EquipmentStatusModel mj_objectWithKeyValues:dict];
            [self.statusArray addObject:model];
        }
        [self.tableview reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
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
    [self stationBtn];
    
    [self.view addSubview:self.tableview];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationRoomController viewWillDisappear");
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

#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */



-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
}
-(void)backAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bottomapevent" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)closeFrame {
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView != self.filterTabView){
        if(indexPath.row==0){
            return  allHeight+FrameWidth(20);//+
        }
        return 0;
    }else{
        return FrameWidth(56);
    }
}

#pragma mark - UITableviewDatasource 数据源方法

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.filterTabView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithHexString:kCellHighlightColor];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.filterTabView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.filterTabView){
        return _roomList.count;
    }
    return 1;
}
- (UITableView *)tableview{
    [_tableview setContentOffset:CGPointMake(0,0)animated:NO];
    if (_tableview ==nil)
    {
        self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - ZNAVViewH )];
        self.tableview.delegate =self;
        self.tableview.dataSource =self;
        //[self.tableview registerClass:[UITableViewCell class]forCellReuseIdentifier:cellIdentifier];
        [self.view addSubview:self.tableview];
        
    }
    _tableview.separatorStyle = NO;
    return _tableview;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.filterTabView){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        StationItems *item = _roomList[indexPath.row];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(80), 0, FrameWidth(220), FrameWidth(54))];
        titleLabel.text = item.alias;
        titleLabel.font =  FontSize(15);
        [cell addSubview:titleLabel];
        
        UIImageView *dot = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(55), FrameWidth(20), FrameWidth(12), FrameWidth(12))];
        dot.image = [UIImage imageNamed:@"station_dian"];
        [cell addSubview:dot];
        
        return cell;
    }
    
    
    UITableViewCell *thiscell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - 114)];
    thiscell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    thiscell.backgroundColor = BGColor;
    if (_romeDetail ==nil||!_romeDetail){
        return thiscell;
    }
    //环境监测
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, FrameWidth(84))];
    view.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:view];
    
    CommonExtension *com = [CommonExtension new];
    [com addTouchViewParent:view];
    com.delegate = self;
    com.parentViewTitle = @"环境监测";
    
    view.userInteractionEnabled = YES;
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(84))];
    
    
    title.text = @"环境监测";
    title.font = FontSize(18);
    [view addSubview:title];
    
    
    
    //UITapGestureRecognizer *viewTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jftapevent)];
    //[view addGestureRecognizer:viewTapGesture];
    //[viewTapGesture setNumberOfTapsRequired:1];
    
    
    //
    
    if([_romeDetail[@"environmentStatus"][@"status"] isEqualToString:@"0"]){
        
        
        UIButton *normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        [normalBtn setBackgroundColor:FrameColor(120, 203, 161)];
        normalBtn.layer.cornerRadius = 2;
        normalBtn.titleLabel.font = FontBSize(13);
        [normalBtn setTitle: @"正常"   forState:UIControlStateNormal];
        normalBtn.titleLabel.textColor = [UIColor whiteColor];
        [view addSubview:normalBtn];
    }else if([_romeDetail[@"environmentStatus"][@"status"] isEqualToString:@"3"]){
        
        
        UIButton *normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        [normalBtn setBackgroundColor:FrameColor(252,201,84)];
        normalBtn.layer.cornerRadius = 2;
        normalBtn.titleLabel.font = FontBSize(13);
        [normalBtn setTitle: @"正常"   forState:UIControlStateNormal];
        normalBtn.titleLabel.textColor = [UIColor whiteColor];
        [view addSubview:normalBtn];
    }else if([_romeDetail[@"environmentStatus"][@"status"] isEqualToString:@"1"]){
        UIButton *warnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(420), FrameWidth(32), FrameWidth(120), FrameWidth(28))];
        [warnBtn setBackgroundColor:warnColor];
        warnBtn.layer.cornerRadius = 2;
        warnBtn.titleLabel.font = FontBSize(13);
        [warnBtn setTitle:[NSString stringWithFormat:@"告警数量%@",_romeDetail[@"environmentStatus"][@"num"]] forState:UIControlStateNormal];
        warnBtn.titleLabel.textColor = [UIColor whiteColor];
        [view addSubview:warnBtn];
        //
        UIButton *LevelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        
        LevelBtn.layer.cornerRadius = 2;
        LevelBtn.titleLabel.font = FontBSize(13);
        
        [CommonExtension addLevelBtn:LevelBtn level:_romeDetail[@"environmentStatus"][@"level"]];
        
       
        [view addSubview:LevelBtn];
        
    }else{
        UILabel *noneMachine = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(560), FrameWidth(32), FrameWidth(70), FrameWidth(30))];
        noneMachine.text = @"－－";
        [view addSubview:noneMachine];
    }
    
    
    
    //动力监测
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, FrameWidth(85), WIDTH_SCREEN, FrameWidth(84))];
    view1.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:view1];
    view1.userInteractionEnabled = YES;
    
    CommonExtension *com1 = [CommonExtension new];
    [com1 addTouchViewParent:view1];
    com1.delegate = self;
    com1.parentViewTitle = @"动力监测";
    
    //UITapGestureRecognizer *viewTapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jftapevent)];
    //[view1 addGestureRecognizer:viewTapGesture1];
    //[viewTapGesture1 setNumberOfTapsRequired:1];
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(84))];
    title1.text = @"动力监测";
    title1.font = FontSize(18);
    [view1 addSubview:title1];
    //
    if([_romeDetail[@"powerStatus"][@"status"] isEqualToString:@"0"]){
        
        
        UIButton *normalBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        [normalBtn1 setBackgroundColor:FrameColor(120, 203, 161)];
        normalBtn1.layer.cornerRadius = 2;
        normalBtn1.titleLabel.font = FontBSize(13);
        [normalBtn1 setTitle: @"正常"   forState:UIControlStateNormal];
        normalBtn1.titleLabel.textColor = [UIColor whiteColor];
        [view1 addSubview:normalBtn1];
    }else  if([_romeDetail[@"powerStatus"][@"status"] isEqualToString:@"3"]){
        
        
        UIButton *normalBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        [normalBtn1 setBackgroundColor:FrameColor(252,201,84)];
        normalBtn1.layer.cornerRadius = 2;
        normalBtn1.titleLabel.font = FontBSize(13);
        [normalBtn1 setTitle: @"正常"   forState:UIControlStateNormal];
        normalBtn1.titleLabel.textColor = [UIColor whiteColor];
        [view1 addSubview:normalBtn1];
    }else if([_romeDetail[@"powerStatus"][@"status"] isEqualToString:@"1"]){
        //
        UIButton *warnBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(420), FrameWidth(32), FrameWidth(120), FrameWidth(28))];
        [warnBtn1 setBackgroundColor:warnColor];
        warnBtn1.layer.cornerRadius = 2;
        [warnBtn1 setTitle:[NSString stringWithFormat:@"告警数量%@",_romeDetail[@"powerStatus"][@"num"]] forState:UIControlStateNormal];
        warnBtn1.titleLabel.font = FontBSize(13);
        warnBtn1.titleLabel.textColor = [UIColor whiteColor];
        [view1 addSubview:warnBtn1];
        //
        UIButton *LevelBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        LevelBtn1.layer.cornerRadius = 2;
        LevelBtn1.titleLabel.font = FontBSize(13);
        
        [CommonExtension addLevelBtn:LevelBtn1 level:_romeDetail[@"powerStatus"][@"level"]];
        
        
        
        [view1 addSubview:LevelBtn1];
    }else{
        UILabel *noneMachine = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(560), FrameWidth(32), FrameWidth(70), FrameWidth(26))];
        noneMachine.text = @"－－";
        [view1 addSubview:noneMachine];
    }
    
    
    //设备监测
    UIView *deviceTesting = [[UIView alloc]initWithFrame:CGRectMake(0, FrameWidth(170), WIDTH_SCREEN, FrameWidth(84))];
    deviceTesting.backgroundColor = [UIColor whiteColor];
    deviceTesting.userInteractionEnabled = YES;
    CommonExtension *comdevice = [CommonExtension new];
    [comdevice addTouchViewParent:deviceTesting];
    comdevice.delegate = self;
    comdevice.parentViewTitle = @"设备监测";
    //UITapGestureRecognizer *deviceTestingTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deviceTestingClick)];
    //[deviceTesting addGestureRecognizer:deviceTestingTapGesture];
    [thiscell addSubview:deviceTesting];
    
    UILabel *deviceTestingTitle = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(84))];
    deviceTestingTitle.text = @"设备监测";
    deviceTestingTitle.font = FontSize(18);
    [deviceTesting addSubview:deviceTestingTitle];
    
    if (self.statusArray.count > 0) {
        UIButton *stateBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        stateBtn.layer.cornerRadius = 2;
        stateBtn.titleLabel.font = FontBSize(13);
        stateBtn.titleLabel.textColor = [UIColor whiteColor];
        [deviceTesting addSubview:stateBtn];
        EquipmentStatusModel *model = self.statusArray[0];
        switch (model.status) {
            case 0:
                [stateBtn setTitle: @"正常"   forState:UIControlStateNormal];
                [stateBtn setBackgroundColor:FrameColor(120, 203, 161)];
                break;
            case 1:
                [stateBtn setTitle: [NSString stringWithFormat:@"%ld级",(long)model.level ] forState:UIControlStateNormal];
                [stateBtn setBackgroundColor:FrameColor(242, 108, 107)];
                
                UIButton *warnBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(420), FrameWidth(32), FrameWidth(120), FrameWidth(28))];
                [warnBtn1 setBackgroundColor:warnColor];
                warnBtn1.layer.cornerRadius = 2;
                [warnBtn1 setTitle:[NSString stringWithFormat:@"告警数量%ld",(long)model.num] forState:UIControlStateNormal];
                warnBtn1.titleLabel.font = FontBSize(13);
                warnBtn1.titleLabel.textColor = [UIColor whiteColor];
                [deviceTesting addSubview:warnBtn1];
                break;
            case 2:
                /*
                stateBtn.lx_x = FrameWidth(555) - FrameWidth(65);
                stateBtn.lx_width = FrameWidth(125);
                [stateBtn setBackgroundColor:FrameColor(120, 203, 161)];
                stateBtn.titleLabel.textColor = [UIColor grayColor];
                [stateBtn setTitle: @"--"   forState:UIControlStateNormal];
                */
                [stateBtn setHidden:true];
                UILabel *noneMachine = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(560), FrameWidth(32), FrameWidth(70), FrameWidth(26))];
                noneMachine.text = @"－－";
                [deviceTesting addSubview:noneMachine];
                break;
            case 3:
                [stateBtn setTitle: @"正常"   forState:UIControlStateNormal];
                [stateBtn setBackgroundColor:FrameColor(252,201,84)];
                break;
            default:
                break;
        }
    }
    
    //视频监测
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(deviceTesting.frame)+1, WIDTH_SCREEN, FrameWidth(84))];
    view2.backgroundColor = [UIColor whiteColor];
    
    view2.userInteractionEnabled = YES;
    CommonExtension *com4 = [CommonExtension new];
    [com4 addTouchViewParent:view2];
    com4.delegate = self;
    com4.parentViewTitle = @"视频监测";
    //UITapGestureRecognizer *view2TapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sptapevent:)];
    //[view2 addGestureRecognizer:view2TapGesture];
    //[view2TapGesture setNumberOfTapsRequired:1];
    
    [thiscell addSubview:view2];
    
    UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(84))];
    title2.text = @"视频监测";
    title2.font = FontSize(18);
    [view2 addSubview:title2];//station_right
    
    
    UIImageView *rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(600), FrameWidth(25), FrameWidth(15), FrameWidth(30))];
    rightImg.image = [UIImage imageNamed:@"station_right"];
    [view2 addSubview:rightImg];//station_right
    
    //大图
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view2.frame), WIDTH_SCREEN, FrameWidth(370))];
    view3.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:view3];
    
    
    UIImageView *BigImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(23), FrameWidth(20), FrameWidth(590), FrameWidth(320))];
    
    [BigImg sd_setImageWithURL:[NSURL URLWithString: [WebHost stringByAppendingString:_imageUrl]] placeholderImage:[UIImage imageNamed:@"station_indexbg"]];
    
    [view3 addSubview:BigImg];//station_right
    _objects10 = [NSMutableArray arrayWithObjects:@"temperature",@"humidity",@"immersion",@"ratproof",@"smoke",@"ups",@"electric",@"diesel",@"battery",@"电子围栏",@"红外对射",@"门禁",nil];
    
    for (int i = 0; i< _equipmentList.count; i++) {
        if([_equipmentList[i][@"xCoordinate"] floatValue] <= 0 &&[_equipmentList[i][@"yCoordinate"] floatValue] <= 0){continue;}
        UIButton *equipment = [[UIButton alloc] initWithFrame:CGRectMake([_equipmentList[i][@"xCoordinate"] floatValue] *FrameWidth(590)/100 + FrameWidth(23), [_equipmentList[i][@"yCoordinate"] floatValue] *FrameWidth(320)/100 + FrameWidth(20), FrameWidth(30), FrameWidth(30))];
        NSString *imgIcon =  @"station_tongyong";
        NSUInteger index = [_objects10  indexOfObject:_equipmentList[i][@"category"]];
        switch (index) {
            case 0:
                imgIcon =  @"station_wendu";
                break;
            case 1:
                imgIcon =  @"station_shidu";
                break;
            case 2:
                imgIcon =  @"station_shuijin";
                break;
            case 3:
                imgIcon =  @"station_fangshu";
                break;
            case 4:
                imgIcon =  @"station_yangan";
                break;
            case 5:
                imgIcon =  @"station_UPS";
                break;
            case 6:
                imgIcon =  @"station_shidian";
                break;
            case 7:
                imgIcon =  @"station_diesel";
                break;
            case 8:
                imgIcon =  @"station_xudian";
                break;
            case 9:
                imgIcon =  @"station_dianzi";
                break;
            case 10:
                imgIcon =  @"station_hongwai";
                break;
            case 11:
                imgIcon =  @"station_menjin";
                break;
                
            default:
                break;
        }
        [equipment setImage:[UIImage imageNamed:imgIcon] forState:UIControlStateNormal];
        equipment.tag = 300 + i;
        [equipment addTarget:self action:@selector(machineTapeventBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view3 insertSubview:equipment atIndex:12];
        
        
        //[BigImg addSubview:equipment];
    }
    
    
    
    
    //安放情况
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(0, view3.frame.origin.y + view3.frame.size.height + 5 , WIDTH_SCREEN, FrameWidth(74))];
    view5.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:view5];
    
    UILabel *title5 = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(74))];
    title5.text = @"机房环境监测";
    title5.font = FontSize(18);
    [view5 addSubview:title5];//station_right
    UIButton *ktBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(500), FrameWidth(20), FrameWidth(100), FrameWidth(40))];
    [ktBtn setBackgroundImage:[UIImage imageNamed:@"station_air"] forState:UIControlStateNormal];
    //StationairConditionerController]
    
    [ktBtn addTarget:self action:@selector(airConditioner) forControlEvents:UIControlEventTouchUpInside];
    [view5 addSubview:ktBtn];
    
    UIView *view6 = [[UIView alloc]initWithFrame:CGRectMake(0, view5.frame.origin.y + view5.frame.size.height + 1 , WIDTH_SCREEN, FrameWidth(520))];
    view6.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:view6];
    
    UIView *view7 = [[UIView alloc]init];
    
    
    
    
    CGFloat neworign_y = 0;
    if(_objects1.count > 0){
        for (int i=0; i<_objects1.count; ++i) {
            neworign_y = FrameWidth(40) + i * FrameWidth(60);
            
            
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(1), neworign_y - FrameWidth(15), FrameWidth(580), FrameWidth(60))];
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:backView.bounds];
            
            //            nameLabel.userInteractionEnabled = YES;
            
            nameLabel.font = FontSize(17);
            nameLabel.textColor = listGrayColor;
            
            CommonExtension * com10 = [CommonExtension new];
            com10.delegate = self;
            com10.parentViewTag = i + 100;
            [com10 addTouchViewParentTagClass:backView];
            
            nameLabel.text = [NSString stringWithFormat:@"             %@",_objects1[i][@"name"]] ;//;
            [view7 addSubview:backView];
            [backView addSubview:nameLabel];
            
            
            
            UIImageView *rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(550), neworign_y, FrameWidth(15), FrameWidth(26))];
            rightImg.image = [UIImage imageNamed:@"station_right"];
            [view7 addSubview:rightImg];//station_right
            
            NSString *imgIcon =  @"station_tongyong";
            NSString *btnIcon =  @"正常";
            NSUInteger index = [_objects10  indexOfObject:_objects1[i][@"code"]];
            switch (index) {
                case 0:
                    imgIcon =  @"station_wendu";
                    break;
                case 1:
                    imgIcon =  @"station_shidu";
                    break;
                case 2:
                    imgIcon =  @"station_shuijin";
                    break;
                case 3:
                    imgIcon =  @"station_fangshu";
                    break;
                case 4:
                    imgIcon =  @"station_yangan";
                    break;
                case 5:
                    imgIcon =  @"station_UPS";
                    break;
                case 6:
                    imgIcon =  @"station_shidian";
                    break;
                case 7:
                    imgIcon =  @"station_diesel";
                    break;
                case 8:
                    imgIcon =  @"station_xudian";
                    break;
                case 9:
                    imgIcon =  @"station_dianzi";
                    break;
                case 10:
                    imgIcon =  @"station_hongwai";
                    break;
                case 11:
                    imgIcon =  @"station_menjin";
                    break;
                    
                default:
                    break;
            }
            
            
            UIImageView *imgIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgIcon]];
            [imgIconView setFrame:CGRectMake(FrameWidth(30), neworign_y - FrameWidth(5), FrameWidth(40), FrameWidth(40))];
            [view7 addSubview:imgIconView];
            
            /*
            UIButton * typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(475), neworign_y, FrameWidth(60), FrameWidth(30))];
            [typeBtn setBackgroundImage:[UIImage imageNamed:btnIcon] forState:UIControlStateNormal];
            [view7 addSubview:typeBtn];
            */
            UIButton *typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(475), neworign_y, FrameWidth(60), FrameWidth(28))];
            typeBtn.layer.cornerRadius = 2;
            typeBtn.titleLabel.font = FontBSize(13);
            
            if([_objects1[i][@"status"] isEqual:[NSNull null]]||[_objects1[i][@"status"] intValue ] == 0){
                btnIcon =  @"正常";
                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
            }else if([_objects1[i][@"status"] intValue ] == 1){
                btnIcon =  @"告警";
                [typeBtn setBackgroundColor:FrameColor(242, 108, 107)];
            }else if([_objects1[i][@"status"] intValue ] == 2){
                btnIcon =  @"--";
                [typeBtn setHidden:true];
                UILabel * noStatus = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(475), neworign_y, FrameWidth(60), FrameWidth(28))];
                noStatus.text = btnIcon;
                [view7 addSubview:noStatus];
            }else if([_objects1[i][@"status"] intValue ] == 3){
                btnIcon =  @"正常";//预警
                [typeBtn setBackgroundColor:FrameColor(252,201,84)];
            }else {
                btnIcon =  @"正常";
                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
            }
            
            
            [typeBtn setTitle: btnIcon   forState:UIControlStateNormal];
            typeBtn.titleLabel.textColor = [UIColor whiteColor];
            [view7 addSubview:typeBtn];
            
            
            
            /*
             if(i != 0){
             UIImageView *lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(20), neworign_y, FrameWidth(550), 1)];
             lineImg.image = [UIImage imageNamed:@"line_gray"];
             [view7 addSubview:lineImg];//station_right
             }
             */
            
        }
    }
    [view7 setFrame:CGRectMake(FrameWidth(25), FrameWidth(20), FrameWidth(590), FrameWidth(70)+neworign_y)];
    
    [view6 setFrame:CGRectMake(0, view6.frame.origin.y, WIDTH_SCREEN, FrameWidth(40)+view7.frame.size.height)];
    view7.layer.cornerRadius = 5;
    view7.layer.borderWidth = 1;
    view7.layer.borderColor = QianGray.CGColor;
    [view6 addSubview:view7];
    
    
    //动力情况
    UIView *view8 = [[UIView alloc]initWithFrame:CGRectMake(0, view6.frame.origin.y + view6.frame.size.height + 5 , WIDTH_SCREEN, FrameWidth(74))];
    view8.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:view8];
    
    UILabel *title8 = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(74))];
    title8.text = @"动力情况";
    title8.font = FontSize(18);
    [view8 addSubview:title8];//station_right
    
    UIView *view9 = [[UIView alloc]initWithFrame:CGRectMake(0, view8.frame.origin.y + view8.frame.size.height + 1 , WIDTH_SCREEN, FrameWidth(520))];
    view9.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:view9];
    
    UIView *view10 = [[UIView alloc]init];
    
    
    
    CGFloat neworign_y10 = 0;
    if(_objects2.count > 0){
        //NSInteger rowCount = _objects2.count;
        for (int i=0; i<_objects2.count; ++i) {
            neworign_y10 = FrameWidth(40) + i * FrameWidth(60);
            
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(1), neworign_y10 - FrameWidth(15), FrameWidth(580), FrameWidth(60))];
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:backView.bounds];
            
            //            nameLabel.userInteractionEnabled = YES;
            
            nameLabel.font = FontSize(17);
            nameLabel.textColor = listGrayColor;
            
            CommonExtension * com10 = [CommonExtension new];
            com10.delegate = self;
            com10.parentViewTag = i + 200;
            [com10 addTouchViewParentTagClass:backView];
            
            nameLabel.text = [NSString stringWithFormat:@"             %@",_objects2[i][@"name"]] ;//;
            [view10 addSubview:backView];
            [backView addSubview:nameLabel];
            
            
            
            
            NSString *imgIcon =  @"station_tongyong";
            NSString *btnIcon =  @"正常";
            NSUInteger index = [_objects10  indexOfObject:_objects2[i][@"code"]];
            switch (index) {
                case 0:
                    imgIcon =  @"station_wendu";
                    break;
                case 1:
                    imgIcon =  @"station_shidu";
                    break;
                case 2:
                    imgIcon =  @"station_shuijin";
                    break;
                case 3:
                    imgIcon =  @"station_fangshu";
                    break;
                case 4:
                    imgIcon =  @"station_yangan";
                    break;
                case 5:
                    imgIcon =  @"station_UPS";
                    break;
                case 6:
                    imgIcon =  @"station_shidian";
                    break;
                case 7:
                    imgIcon =  @"station_diesel";
                    break;
                case 8:
                    imgIcon =  @"station_xudian";
                    break;
                case 9:
                    imgIcon =  @"station_dianzi";
                    break;
                case 10:
                    imgIcon =  @"station_hongwai";
                    break;
                case 11:
                    imgIcon =  @"station_menjin";
                    break;
                    
                default:
                    break;
            }
            if([_objects2[i][@"status"] isEqual:[NSNull null]]||[_objects2[i][@"status"] boolValue] == 0){
                btnIcon =  @"正常";
            }else{
                btnIcon =  @"告警";
            }
            
            UIImageView *imgIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgIcon]];
            [imgIconView setFrame:CGRectMake(FrameWidth(30), neworign_y10 - FrameWidth(5), FrameWidth(40), FrameWidth(40))];
            [view10 addSubview:imgIconView];
            
            UIButton *typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(475), neworign_y10, FrameWidth(60), FrameWidth(28))];
            typeBtn.layer.cornerRadius = 2;
            typeBtn.titleLabel.font = FontBSize(13);
            if([_objects2[i][@"status"] isEqual:[NSNull null]]||[_objects2[i][@"status"] intValue ] == 0){
                btnIcon =  @"正常";
                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
            }else if([_objects2[i][@"status"] intValue ] == 1){
                btnIcon =  @"告警";
                [typeBtn setBackgroundColor:FrameColor(242, 108, 107)];
            }else if([_objects2[i][@"status"] intValue ] == 2){
                btnIcon =  @"--";
                [typeBtn setHidden:true];
                UILabel * noStatus = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(475), neworign_y10, FrameWidth(60), FrameWidth(28))];
                noStatus.text = btnIcon;
                [view10 addSubview:noStatus];
            }else if([_objects2[i][@"status"] intValue ] == 3){
                btnIcon =  @"正常";//预警
                [typeBtn setBackgroundColor:FrameColor(252,201,84)];
            }else {
                btnIcon =  @"正常";
                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
            }
            
            
            [typeBtn setTitle: btnIcon   forState:UIControlStateNormal];
            typeBtn.titleLabel.textColor = [UIColor whiteColor];
            [view10 addSubview:typeBtn];
        }
    }
    [view10 setFrame:CGRectMake(FrameWidth(25), FrameWidth(20), FrameWidth(590), FrameWidth(70)+neworign_y10)];
    
    [view9 setFrame:CGRectMake(0, view9.frame.origin.y, WIDTH_SCREEN, FrameWidth(40)+view10.frame.size.height)];
    view10.layer.cornerRadius = 5;
    view10.layer.borderWidth = 1;
    view10.layer.borderColor = QianGray.CGColor;
    [view9 addSubview:view10];
    allHeight = view9.frame.origin.y + view9.frame.size.height ;
    
    
    //设备情况
    UIView *equipmentview8 = [[UIView alloc]initWithFrame:CGRectMake(0, allHeight + 5 , WIDTH_SCREEN, FrameWidth(74))];
    equipmentview8.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:equipmentview8];
    
    UILabel *equipmenttitle8 = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(74))];
    equipmenttitle8.text = @"设备情况";
    equipmenttitle8.font = FontSize(18);
    [equipmentview8 addSubview:equipmenttitle8];//station_right
    
    UIView *equipmentview9 = [[UIView alloc]initWithFrame:CGRectMake(0, equipmentview8.frame.origin.y + equipmentview8.frame.size.height + 1 , WIDTH_SCREEN, FrameWidth(520))];
    equipmentview9.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:equipmentview9];
    
    UIView *equipmentview10 = [[UIView alloc]init];
    
    
    
    CGFloat equipmentneworign_y10 = 0;
    if(_equipmentArray.count > 0){
        //NSInteger rowCount = _objects2.count;
        for (int i=0; i<_equipmentArray.count; ++i) {
            equipmentneworign_y10 = FrameWidth(40) + i * FrameWidth(60);
            
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(1), equipmentneworign_y10 - FrameWidth(15), FrameWidth(580), FrameWidth(60))];
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:backView.bounds];
            
            //            nameLabel.userInteractionEnabled = YES;
            
            nameLabel.font = FontSize(17);
            nameLabel.textColor = listGrayColor;
            
            CommonExtension * com10 = [CommonExtension new];
            com10.delegate = self;
            com10.parentViewTag = i + 400;
            [com10 addTouchViewParentTagClass:backView];
            
            nameLabel.text = [NSString stringWithFormat:@"             %@",_equipmentArray[i][@"name"]] ;//;
            [equipmentview10 addSubview:backView];
            [backView addSubview:nameLabel];
            
            
            
            
            NSString *imgIcon =  @"station_tongyong";
            NSString *btnIcon =  @"正常";
            NSUInteger index = [_objects10  indexOfObject:_equipmentArray[i][@"code"]];
            switch (index) {
                case 0:
                    imgIcon =  @"station_wendu";
                    break;
                case 1:
                    imgIcon =  @"station_shidu";
                    break;
                case 2:
                    imgIcon =  @"station_shuijin";
                    break;
                case 3:
                    imgIcon =  @"station_fangshu";
                    break;
                case 4:
                    imgIcon =  @"station_yangan";
                    break;
                case 5:
                    imgIcon =  @"station_UPS";
                    break;
                case 6:
                    imgIcon =  @"station_shidian";
                    break;
                case 7:
                    imgIcon =  @"station_diesel";
                    break;
                case 8:
                    imgIcon =  @"station_xudian";
                    break;
                case 9:
                    imgIcon =  @"station_dianzi";
                    break;
                case 10:
                    imgIcon =  @"station_hongwai";
                    break;
                case 11:
                    imgIcon =  @"station_menjin";
                    break;
                    
                default:
                    break;
            }
        
            
            UIImageView *imgIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgIcon]];
            [imgIconView setFrame:CGRectMake(FrameWidth(30), equipmentneworign_y10 - FrameWidth(5), FrameWidth(40), FrameWidth(40))];
            [equipmentview10 addSubview:imgIconView];
            
            /*
             UIButton * typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(475), neworign_y10, FrameWidth(60), FrameWidth(30))];
             [typeBtn setBackgroundImage:[UIImage imageNamed:btnIcon] forState:UIControlStateNormal];
             [view10 addSubview:typeBtn];
             
             */
            UIButton *typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(475), equipmentneworign_y10, FrameWidth(60), FrameWidth(28))];
            typeBtn.layer.cornerRadius = 2;
            typeBtn.titleLabel.font = FontBSize(13);
            if([_equipmentArray[i][@"status"] isEqual:[NSNull null]]||[_equipmentArray[i][@"status"] intValue ] == 0){
                btnIcon =  @"正常";
                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
            }else if([_equipmentArray[i][@"status"] intValue ] == 1){
                btnIcon =  @"告警";
                [typeBtn setBackgroundColor:FrameColor(242, 108, 107)];
            }else if([_equipmentArray[i][@"status"] intValue ] == 2){
                btnIcon =  @"--";
                [typeBtn setHidden:true];
                UILabel * noStatus = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(475), equipmentneworign_y10, FrameWidth(60), FrameWidth(28))];
                noStatus.text = btnIcon;
                [view7 addSubview:noStatus];
            }else if([_equipmentArray[i][@"status"] intValue ] == 3){
                btnIcon =  @"正常";//预警
                [typeBtn setBackgroundColor:FrameColor(252,201,84)];
            }else {
                btnIcon =  @"正常";
                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
            }
            
            
            [typeBtn setTitle: btnIcon   forState:UIControlStateNormal];
            typeBtn.titleLabel.textColor = [UIColor whiteColor];
            [equipmentview10 addSubview:typeBtn];
        }
    }
    [equipmentview10 setFrame:CGRectMake(FrameWidth(25), FrameWidth(20), FrameWidth(590), FrameWidth(70)+equipmentneworign_y10)];
    
    [equipmentview9 setFrame:CGRectMake(0, equipmentview9.frame.origin.y, WIDTH_SCREEN, FrameWidth(40)+equipmentview10.frame.size.height)];
    equipmentview10.layer.cornerRadius = 5;
    equipmentview10.layer.borderWidth = 1;
    equipmentview10.layer.borderColor = QianGray.CGColor;
    [equipmentview9 addSubview:equipmentview10];
    allHeight = equipmentview9.frame.origin.y + equipmentview9.frame.size.height ;
    
    
    return thiscell;
    
    
}



#pragma  设备监测入口
- (void)deviceTestingClick {
    NSLog(@"设备监测入口");
    if (self.modelArray.count >0) {
        EquipmentDetailsModel *model = self.modelArray[0];
        StationMachineController  *StationMachine = [[StationMachineController alloc] init];
        StationMachine.category = model.code;
        StationMachine.machine_name = model.name;
        StationMachine.station_name = _station_name;
        StationMachine.station_code = _station_code;
        StationMachine.engine_room_code = @"";
        StationMachine.mList = _objects3;
        [self.navigationController pushViewController:StationMachine animated:YES];
    } else {
         [FrameBaseRequest showMessage:@"当前台站无设备"];
    }
}

-(void)stationBtn{
    if(!self.rightButton){
        self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,  FrameWidth(120), FrameWidth(30))];
        
        [self.rightButton addTarget:self action:@selector(getStationList) forControlEvents:UIControlEventTouchUpInside];
        self.rightButton.titleLabel.font = FontSize(15);
        
        self.rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        self.rightButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.rightButton.titleLabel.numberOfLines = 2;
        if(![CommonExtension isEmptyWithString:_room_name]){
            
            
            NSMutableString* str1=[[NSMutableString alloc]initWithString:_room_name];//存在堆区，可变字符串
            float strLength = floor(str1.length/7);
            if(strLength > 0){
                for (int i =1; i <= strLength &&i <= 2; i++) {
                    [str1 insertString:@"\n"atIndex:(7*i + (i-1))];//把一个字符串插入另一个字符串中的某一个位置
                }
                
                [self.rightButton setTitle:str1 forState:UIControlStateNormal];
            }else{
                [self.rightButton setTitle:_room_name forState:UIControlStateNormal];
                CGSize size = [self.rightButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(15),NSFontAttributeName,nil]];
                
                [self.rightButton setFrameWidth:size.width+3];
            }
            
        }
        
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
        
        
        
        UIButton *rightButton1 = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, FrameWidth(20), FrameWidth(30))];
        [rightButton1 setImage:[UIImage imageNamed:@"station_pulldown"] forState:UIControlStateNormal];
        
        //[rightButton1 addTarget:self action:@selector(jifangAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButton1 = [[UIBarButtonItem alloc]initWithCustomView:rightButton1];
        self.navigationItem.rightBarButtonItems = @[ rightBarButton1,rightBarButton];
    }else{
        if(![CommonExtension isEmptyWithString:_room_name]){
            NSMutableString* str1=[[NSMutableString alloc]initWithString:_room_name];//存在堆区，可变字符串
            float strLength = floor(str1.length/7);
            
            if(strLength > 0){
                for (int i =1; i <= strLength &&i <= 2; i++) {
                    [str1 insertString:@"\n"atIndex:(7*i + (i-1))];//把一个字符串插入另一个字符串中的某一个位置
                }
                
                [self.rightButton setTitle:str1 forState:UIControlStateNormal];
            }else{
                [self.rightButton setTitle:_room_name forState:UIControlStateNormal];
                CGSize size = [self.rightButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(15),NSFontAttributeName,nil]];
                
                [self.rightButton setFrameWidth:size.width+3];
            }
        }
        
    }
    /*
    if(!self.rightButton){
        
        self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,  FrameWidth(120), FrameWidth(30))];
        
        [self.rightButton addTarget:self action:@selector(getStationList) forControlEvents:UIControlEventTouchUpInside];
        self.rightButton.titleLabel.font = FontSize(15);
        
        self.rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        self.rightButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.rightButton.titleLabel.numberOfLines = 2;
        
        
        if(![CommonExtension isEmptyWithString:_room_name]){
            NSMutableString* str1=[[NSMutableString alloc]initWithString:_room_name];//存在堆区，可变字符串
            float strLength = floor(str1.length/7);
            
            for (int i =1; i <= strLength &&i <= 2; i++) {
                [str1 insertString:@"\n"atIndex:(7*i + (i-1))];//把一个字符串插入另一个字符串中的某一个位置
            }
           
            [self.rightButton setTitle:str1 forState:UIControlStateNormal];
        }
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
        
        
        UIButton *rightButton1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FrameWidth(10), FrameWidth(30))];
        [rightButton1 setImage:[UIImage imageNamed:@"station_pulldown"] forState:UIControlStateNormal];
        //[rightButton1 addTarget:self action:@selector(jifangAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButton1 = [[UIBarButtonItem alloc]initWithCustomView:rightButton1];
        self.navigationItem.rightBarButtonItems = @[ rightBarButton1,rightBarButton];
    }else{
        if(![CommonExtension isEmptyWithString:_room_name]){
            NSMutableString* str1=[[NSMutableString alloc]initWithString:_room_name];//存在堆区，可变字符串
            float strLength = floor(str1.length/7);
            
            for (int i =1; i <= strLength &&i <= 2; i++) {
                [str1 insertString:@"\n"atIndex:(7*i + (i-1))];//把一个字符串插入另一个字符串中的某一个位置
            }
            
            [self.rightButton setTitle:str1 forState:UIControlStateNormal];
        }
    }
    */
    /*
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,  FrameWidth(100), FrameWidth(30))];
    
    [rightButton addTarget:self action:@selector(getStationList) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = FontSize(15);
    CGSize size = [_room_name sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(15),NSFontAttributeName,nil]];
    
    //[leftButton setBackgroundColor:[UIColor blueColor]];
    [rightButton setFrame:CGRectMake(FrameWidth(30), 0, size.width+3, FrameWidth(30))];
    [rightButton setTitle:_room_name forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    
    UIButton *rightButton1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FrameWidth(20), FrameWidth(30))];
    [rightButton1 setImage:[UIImage imageNamed:@"station_pulldown"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton1 = [[UIBarButtonItem alloc]initWithCustomView:rightButton1];
    self.navigationItem.rightBarButtonItems = @[ rightBarButton1,rightBarButton];
    
    */
}

-(void)getStationList{
    
    float moreheight = FrameWidth(900);
    if(HEIGHT_SCREEN == 812){
        moreheight = -FrameWidth(1100);
    }
    
    UIViewController *vc = [UIViewController new];
    
    vc.view.frame = CGRectMake(FrameWidth(320), FrameWidth(128), FrameWidth(320), moreheight );
    //_vc.view.layer.cornerRadius = 4.0;
    vc.view.layer.masksToBounds = YES;
    UIImageView * xialaImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, FrameWidth(300),  FrameWidth(20))];
    xialaImage.image = [UIImage imageNamed:@"station_pulldown_right"];
    [vc.view addSubview:xialaImage];
    
    //设置滚动
    float tabelHeight = _roomList.count * FrameWidth(56);
    if(tabelHeight > FrameWidth(400)){
        tabelHeight = FrameWidth(400);
    }
    
    UIView *alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, tabelHeight, FrameWidth(300),  FrameWidth(1000))];
    alphaView.userInteractionEnabled = YES;
    UITapGestureRecognizer *viewTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeFrame)];
    [alphaView addGestureRecognizer:viewTapGesture];
    [viewTapGesture setNumberOfTapsRequired:1];
    [vc.view addSubview:alphaView];
    
    
    
    self.filterTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, FrameWidth(20), FrameWidth(300) ,tabelHeight)];
    self.filterTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [vc.view addSubview:self.filterTabView];
    self.filterTabView.dataSource = self;
    self.filterTabView.delegate = self;
    [self.filterTabView reloadData];
    
    
    [self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentRight overlayDismissed:nil];
    
}

-(void)sptapevent{
    StationVideoListController  *StationVideo = [[StationVideoListController alloc] init];
    StationVideo.station_code = _station_code;
    StationVideo.station_name = _station_name;
    [self.navigationController pushViewController:StationVideo animated:YES];
}

-(void)machineTapevent:(id)sender{
    NSString * category = @"";
    NSString * machinename = @"";
    NSMutableArray * mList = [NSMutableArray alloc];
    NSLog(@"machineTapevent %ld ::%@",[sender view].tag,_station_name);
    if([sender view].tag >= 100 &&[sender view].tag < 200 &&[sender view].tag - 100 >= 0){//是安防
        category = _objects1[[sender view].tag - 100][@"code"];
        machinename = _objects1[[sender view].tag - 100][@"alias"];
        mList = _objects1;
        //_station_code/category?engine_room_code=
        //_objects1 = [_stationDetail[@"securityDetails"] copy];
        //_objects2 = [_stationDetail[@"powerDetails"] copy];
    }else if([sender view].tag >= 200 &&[sender view].tag < 300 &&[sender view].tag - 200 >=0){//是power
        category = _objects2[[sender view].tag - 200][@"code"];
        machinename = _objects2[[sender view].tag - 200][@"alias"];
        mList = _objects2;
    }else if([sender view].tag >= 300 &&[sender view].tag < 400 &&[sender view].tag - 300 >=0){//是power
        NSLog(@"_equipmentList_equipmentList  %@",_equipmentList);
        category = _equipmentList[[sender view].tag - 300][@"code"];
        machinename = _equipmentList[[sender view].tag - 300][@"alias"];
        mList = _objects1;
    }else{
        [FrameBaseRequest showMessage:@"请求失败，请检查网络"];
        return;
    }
    if([category isEqualToString:@""]||!_station_name){
        return ;
    }
    
    StationMachineController  *StationMachine = [[StationMachineController alloc] init];
    StationMachine.category = category;
    StationMachine.machine_name = machinename;
    StationMachine.station_name = _station_name;
    StationMachine.station_code = _station_code;
    
    StationMachine.mList = mList;
    StationMachine.engine_room_code = _room_code;
    [self.navigationController pushViewController:StationMachine animated:YES];
}

-(void)machineTapeventTag:(NSInteger)senderTag{
    NSString * category = @"";
    NSString * machinename = @"";
    NSMutableArray * mList = [NSMutableArray alloc];
    NSLog(@"machineTapevent %ld ::%@",senderTag,_station_name);
    if(senderTag >= 100 &&senderTag < 200 &&senderTag - 100 >= 0){//是安防
        category = _objects1[senderTag - 100][@"code"];
        machinename = _objects1[senderTag - 100][@"name"];
        mList = _objects1;
        //_station_code/category?engine_room_code=
        //_objects1 = [_stationDetail[@"securityDetails"] copy];
        //_objects2 = [_stationDetail[@"powerDetails"] copy];
    }else if(senderTag >= 200 &&senderTag < 300 &&senderTag - 200 >=0){//是power
        category = _objects2[senderTag - 200][@"code"];
        machinename = _objects2[senderTag - 200][@"name"];
        mList = _objects2;
    }else if(senderTag >= 300 &&senderTag < 400 &&senderTag - 300 >=0){//是power  _equipmentArray
        NSLog(@"_equipmentList_equipmentList  %@",_equipmentList);
        category = _equipmentList[senderTag - 300][@"code"];
        machinename = _equipmentList[senderTag - 300][@"name"];
        mList = _objects1;
    }else if(senderTag >= 400 &&senderTag < 500 ){//是power  _equipmentArray
        NSLog(@"_equipmentList_equipmentList  %@",_equipmentList);
        category = _equipmentArray[senderTag - 400][@"code"];
        machinename = _equipmentArray[senderTag - 400][@"name"];
        mList = _equipmentArray;
    }else{
        [FrameBaseRequest showMessage:@"请求失败，请检查网络"];
        return;
    }
    if([category isEqualToString:@""]||!_station_name){
        return ;
    }
    
    StationMachineController  *StationMachine = [[StationMachineController alloc] init];
    StationMachine.category = category;
    StationMachine.machine_name = machinename;
    StationMachine.station_name = _station_name;
    StationMachine.station_code = _station_code;
    
    StationMachine.mList = mList;
    StationMachine.engine_room_code = _room_code;
    [self.navigationController pushViewController:StationMachine animated:YES];
}

-(void)machineTapeventBtn:(UIButton *)sender{
    NSString * category = @"";
    NSString * machinename = @"";
    NSMutableArray * mList = [NSMutableArray alloc];
    if(sender.tag >= 300 &&sender.tag - 300 >=0){//是power
        category = _equipmentList[sender.tag - 300][@"category"];
        machinename = _equipmentList[sender.tag - 300][@"alias"];
        mList = _objects1;
    }else{
        [FrameBaseRequest showMessage:@"请求失败，请检查网络"];
        return;
    }
    if([category isEqualToString:@""]||!_station_name){
        return ;
    }
    StationMachineController  *StationMachine = [[StationMachineController alloc] init];
    StationMachine.category = category;
    StationMachine.machine_name = machinename;
    StationMachine.station_name = _station_name;
    StationMachine.station_code = _station_code;
    
    StationMachine.mList = mList;
    StationMachine.engine_room_code = _room_code;
    [self.navigationController pushViewController:StationMachine animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    
    if(tableView == self.filterTabView){
        StationItems *item = _roomList[indexPath.row];
        if(![item.category isEqualToString:@"title"]){
            [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
            _room_name = item.alias;
            _room_code = item.code;
            //self.title = station[@"name"];//
            _imageUrl = item.picture;//
            self.navigationItem.title = _room_name;//
            
            [self setupTable];
        }
        
    }
}

-(void)airConditioner{
    
    StationairConditionerController  *StationMachine = [[StationairConditionerController alloc] init];
    
    StationMachine.engine_room_code = _room_code;
    
    StationMachine.engine_room_name = _room_name;
    [self.navigationController pushViewController:StationMachine animated:YES];
}

-(void)jftapevent{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void)ParentViewTag:(NSInteger)tag {
    NSLog(@"点击的是tagtag %ld",(long)tag);
    [self machineTapeventTag:tag];
}

- (void)ParentViewTitle:(NSString *)ParentViewTitle {
    NSLog(@"点击的是%@",ParentViewTitle);
    if([ParentViewTitle isEqualToString:@"动力监测"]){
        [self jftapevent];
    }else if([ParentViewTitle isEqualToString:@"环境监测"]){
        [self jftapevent];
    }else if([ParentViewTitle isEqualToString:@"设备监测"]){
        [self deviceTestingClick];
        
    }else if([ParentViewTitle isEqualToString:@"视频监测"]){
        [self sptapevent];
    }
}


@end


