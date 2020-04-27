//
//  StationMachineDetailController.m
//  Frame
//
//  Created by hibayWill on 2018/3/30.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "StationMachineDetailController.h"
#import "FrameBaseRequest.h"
#import <UIImageView+WebCache.h>
#import "MachineItems.h"
#import "StationMachineInfoListController.h"
#import <WebKit/WebKit.h>
#import "RadarTableViewCell.h"
#import <MJExtension.h>
#import "StationMachineDetailMoreController.h"
#import "KG_GaojingView.h"
@interface StationMachineDetailController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) UIView *loadBgView;
@property (nonatomic, strong) UIImageView *loadImageV;

@property NSMutableArray <MachineItems *> *objects;
@property NSMutableArray *objects0;
@property (nonatomic, strong) NSMutableArray *radarList;
@property float wkHeight;

@property (nonatomic, strong) UITableView *radarTableView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *leftView;
/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property   int viewnum;

@property(nonatomic) UITableView *tableview;
@property (nonatomic, strong) KG_GaojingView *gaojingView;
@end

@implementation StationMachineDetailController

#pragma mark - 全局常量



#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification1:) name:@"hiddenRightView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification2:) name:@"hiddenLeftView" object:nil];

    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(16, 0, getScreen.size.width-32,HEIGHT_SCREEN - 160 - TOOLH - ZNAVViewH)];
    if (TOOLH >0) {
        [self.tableview setFrame:CGRectMake(16, 0, getScreen.size.width-32,HEIGHT_SCREEN - 120 - TOOLH - ZNAVViewH)];
    }
    self.tableview.layer.cornerRadius = 16;
    self.tableview.layer.masksToBounds = YES;
    self.radarList = [NSMutableArray arrayWithCapacity:0];
    NSLog(@"tableviewtableviewtableview %f",self.tableview.frameHeight);
    
    [self.view addSubview:self.tableview];
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorStyle = NO;
    if([_machineDetail[@"category"] isEqualToString:@"radar"]){
        [self loadWebView];
        [self loadTableView];
    }
    if(isSafeDictionary(_machineDetail[@"tagList"])) {
        for (NSDictionary *dic in _machineDetail[@"tagList"]) {
            BOOL isEmp = [dic[@"emphasis"] boolValue];
            if (isEmp) {
                [self.radarList addObject:dic];
            }
        }
    }
    [self.radarTableView reloadData];
    self.rightView = [[UIView alloc] init];
    self.rightView.frame = CGRectMake(SCREEN_WIDTH-10,self.tableview.frame.origin.y,10,self.tableview.frame.origin.y +self.tableview.frame.size.height);
    
    self.rightView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
   
    [self.view addSubview:self.rightView];
//    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right);
//        make.top.equalTo(self.tableview.mas_top);
//        make.width.equalTo(@10);
//        make.bottom.equalTo(self.tableview.mas_bottom);
//    }];
    self.rightView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.rightView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(16,16)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.rightView.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.rightView.layer.mask = maskLayer;

    
    self.leftView = [[UIView alloc] init];
    self.leftView.frame = CGRectMake(0,self.tableview.frame.origin.y,10,self.tableview.frame.origin.y +self.tableview.frame.size.height);
    
    self.leftView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
     self.leftView.layer.masksToBounds = YES;
    self.leftView.hidden = YES;
    [self.view addSubview:self.leftView];
//    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.top.equalTo(self.tableview.mas_top);
//        make.width.equalTo(@10);
//        make.bottom.equalTo(self.tableview.mas_bottom);
//    }];
    self.leftView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.leftView.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(16,16)];
    //创建 layer
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = self.leftView.bounds;
    //赋值
    maskLayer1.path = maskPath1.CGPath;
    self.leftView.layer.mask = maskLayer1;
}

//实现方法
-(void)notification1:(NSNotification *)notification{
    NSLog(@"接收 不带参数的消息");
    NSString *str = notification.object;
    if ([str isEqualToString:@"YES"]) {
        self.rightView.hidden = YES;
    }else {
        self.rightView.hidden = NO;
    }
    
}
//实现方法
-(void)notification2:(NSNotification *)notification{
    NSLog(@"接收 不带参数的消息");
    NSString *str = notification.object;
    if ([str isEqualToString:@"YES"]) {
        self.leftView.hidden = YES;
    }else {
        self.leftView.hidden = NO;
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    countnum = 0;
}
#pragma mark - private methods 私有方法



-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
    
}

#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //if(self.detail[indexPath.row].typeid==1){
    if ([tableView isEqual:self.radarTableView]) {
        return 50;
    }
    NSLog(@"allHeightallHeight %f::: %ld",allHeight,(long)indexPath.row);
    if(indexPath.row==0&&allHeight>FrameWidth(500)){
        return  allHeight;//+
    }
    return FrameWidth(800);
}

#pragma mark - UITableviewDatasource 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:self.radarTableView]) {
        return [self.radarList count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.radarTableView]) {
        
        RadarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RadarTableViewCell"];
        if (cell == nil) {
            cell = [[RadarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RadarTableViewCell"];
        }
        cell.titleLabel.text = safeString(self.radarList[indexPath.row][@"name"]) ;
        cell.detailLabel.text = safeString(self.radarList[indexPath.row][@"tagValue"]);
        
        return cell;
    }
    
    
    UITableViewCell *thiscell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
    thiscell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    
    thiscell.backgroundColor = self.view.backgroundColor;
    
    
    
    //UPS设备
    UIView *machineView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 140)];
    machineView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:machineView];
  
    
    UIImageView *machineImg = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(20), FrameWidth(200), FrameWidth(250))];
    NSString * img = @"station_big_normal";

   
    machineImg.contentMode = 1;
    NSString *cag = safeString(_machineDetail[@"category"]);
    if ([cag isEqualToString:@"ats"]) {
        machineImg.image = [UIImage imageNamed:@"machine_ats"];
    }else if ([cag isEqualToString:@"navigation"]) {
        machineImg.image = [UIImage imageNamed:@"machine_dme"];
    }else if ([cag isEqualToString:@"ups"]) {
        machineImg.image = [UIImage imageNamed:@"machine_ups"];
    }else if ([cag isEqualToString:@"dvor"]) {
        machineImg.image = [UIImage imageNamed:@"machine_dvor"];
    }else if ([cag isEqualToString:@"airSwitch"]) {
        machineImg.image = [UIImage imageNamed:@"machine_kongkai"];
    }else if ([cag isEqualToString:@"rs"]) {
        machineImg.image = [UIImage imageNamed:@"machine_rs"];
    }else {
//         [machineImg sd_setImageWithURL:[NSURL URLWithString: [WebHost stringByAppendingString:safeString(_machineDetail[@"picture"])]]];
        [machineImg sd_setImageWithURL:[NSURL URLWithString: [@"http://10.33.33.147:8089" stringByAppendingString:safeString(_machineDetail[@"picture"])]]];
              
    }
    
    UIImageView *topBgImageView = [[UIImageView alloc]init];
    topBgImageView.backgroundColor = [UIColor colorWithHexString:@"#F3F5F9"];
    [machineView addSubview:topBgImageView];
    [topBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@145);
        make.height.equalTo(@106);
        make.left.equalTo(machineView.mas_left).offset(16);
        make.top.equalTo(machineView.mas_top).offset(20);
    }];
    
    
    machineImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *viewTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MachineInfoPicture:)];
    [machineImg addGestureRecognizer:viewTapGesture];
    [viewTapGesture setNumberOfTapsRequired:1];
    
    [machineView addSubview:machineImg];
    [machineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@145);
        make.height.equalTo(@89);
        make.left.equalTo(machineView.mas_left).offset(16);
        make.top.equalTo(topBgImageView.mas_top).offset(9);
        
    }];
    
    UIImageView *greenDotImage = [[UIImageView alloc]init];
    greenDotImage.backgroundColor = [UIColor colorWithHexString:@"#03C3B6"];
    [machineView addSubview:greenDotImage];
    greenDotImage.layer.cornerRadius = 4.f;
    greenDotImage.layer.masksToBounds = YES;
    [greenDotImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@8);
        make.height.equalTo(@8);
        make.left.equalTo(topBgImageView.mas_right).offset(10);
        make.top.equalTo(topBgImageView.mas_top).offset(11);
    }];
    
    
    UILabel *machineLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(240), FrameWidth(40), FrameWidth(380), FrameWidth(30))];
    machineLabel.font = FontSize(14);
    machineLabel.text = [NSString stringWithFormat:@"%@-%@",_machineDetail[@"roomName"],_machineDetail[@"alias"]];//_machineDetail[@"alias"];//@"***-温度;
    [machineView addSubview:machineLabel];
    machineLabel.numberOfLines = 1;
    machineLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    [machineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.lessThanOrEqualTo(@200);
        make.height.equalTo(@21);
        make.left.equalTo(greenDotImage.mas_right).offset(7);
        make.top.equalTo(topBgImageView.mas_top).offset(4);
    }];
   
    
    UILabel *bhLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(240)+60, FrameWidth(90), FrameWidth(380), FrameWidth(30))];
    bhLabel.font = FontSize(14);
    bhLabel.text = [NSString stringWithFormat:@"%@",@"告警状态"];//@"告警状态
    [machineView addSubview:bhLabel];
    bhLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    [bhLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(machineLabel.mas_left);
        make.top.equalTo(machineLabel.mas_bottom).offset(5);
        make.width.equalTo(@200);
        make.height.equalTo(@21);
    }];
    //warn_save
    UILabel *ztLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(240)+60, FrameWidth(140), FrameWidth(80), FrameWidth(30))];
    ztLabel.font = FontSize(14);
    ztLabel.text = @"运行状态:";
    ztLabel.hidden = YES;
    
    ztLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    [machineView addSubview:ztLabel];
    [ztLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(machineLabel.mas_left);
        make.top.equalTo(bhLabel.mas_bottom).offset(5);
        make.width.equalTo(@200);
        make.height.equalTo(@21);
    }];
    
    
    NSMutableArray *dataArray = [NSMutableArray array];
    if(isSafeArray(_machineDetail[@"tagList"])) {
        for (NSDictionary *dic in _machineDetail[@"tagList"]) {
            BOOL picShow = [dic[@"picShow"] boolValue];
            if (picShow) {
                [dataArray addObject:dic];
            }
        }
    }
    if (dataArray.count) {
        self.gaojingView = [[KG_GaojingView alloc]init];
        [machineView addSubview:self.gaojingView];
        [self.gaojingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@42);
            make.left.equalTo(bhLabel.mas_left);
            make.right.equalTo(machineView.mas_right).offset(-16-20);
            make.top.equalTo(bhLabel.mas_bottom).offset(5);
        }];
        self.gaojingView.powArray = dataArray;
    }
   
    UIImageView *statusImage = [[UIImageView alloc]init];
    [machineView addSubview:statusImage];
    statusImage.image = [UIImage imageNamed:@"level_normal"];
    [statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bhLabel.mas_centerY);
        make.height.equalTo(@17);
        make.width.equalTo(@32);
        make.right.equalTo(machineView.mas_right).offset(-60);
    }];
    UILabel * statusNumLalbel = [[UILabel alloc]init];
    [machineView addSubview:statusNumLalbel];
    statusNumLalbel.layer.cornerRadius = 5.f;
    statusNumLalbel.layer.masksToBounds = YES;
    statusNumLalbel.text = @"1";
    statusNumLalbel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    statusNumLalbel.font = [UIFont systemFontOfSize:10];
    statusNumLalbel.numberOfLines = 1;
    
    statusNumLalbel.textAlignment = NSTextAlignmentCenter;
    [statusNumLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusImage.mas_right).offset(-5);
        make.bottom.equalTo(statusImage.mas_top).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    if([_machineDetail[@"status"] isEqualToString:@"1"]){
        statusNumLalbel.text =[NSString stringWithFormat:@"%@",_machineDetail[@"num"]];
       
        statusImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",_machineDetail[@"level"]]]];
        statusNumLalbel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",_machineDetail[@"level"]]];
      
       
    }else if([_machineDetail[@"status"] isEqualToString:@"2"]){
        
       statusImage.image = [UIImage imageNamed:@"level_normal"];
    }else if([_machineDetail[@"status"] isEqualToString:@"3"]){
        
      statusImage.image = [UIImage imageNamed:@"level_normal"];
    }else{
        
       statusImage.image = [UIImage imageNamed:@"level_normal"];
    }
    if ([_machineDetail[@"num"] intValue] == 0) {
        statusNumLalbel.hidden = YES;
    }else {
        statusNumLalbel.hidden =NO;
    }
    
    
    int descripptionHeight = 0;
    //新增告警显示
    if (safeString(_machineDetail[@"description"]).length) {
        UILabel *warnLabel = [[UILabel alloc]init];
        [machineView addSubview:warnLabel];
        warnLabel.textAlignment = NSTextAlignmentLeft;
        warnLabel.numberOfLines = 6;
        warnLabel.textColor = [UIColor orangeColor];
        warnLabel.font = [UIFont systemFontOfSize:12];
        [warnLabel sizeToFit];
        warnLabel.text = [NSString stringWithFormat:@"%@",safeString(_machineDetail[@"description"])];
      
        [warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ztLabel.mas_left);
            make.right.equalTo(machineView.mas_right).offset(-20);
            make.top.equalTo(ztLabel.mas_bottom).offset(5);
        }];
        CGSize size = [warnLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - FrameWidth(240) -20, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:warnLabel.font}
                                                  context:nil].size;
        
    
        descripptionHeight = size.height;
        CGRect machineViewFrame = machineView.frame;
        if(descripptionHeight >70) {
            machineViewFrame.size.height += 40;
        }else if(descripptionHeight >50) {
            machineViewFrame.size.height += 30;
        }else{
//            machineViewFrame.size.height += descripptionHeight;
        }
        
        machineView.frame = machineViewFrame;
        
    }
     UIButton * manageBtn = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(400), FrameWidth(240), FrameWidth(125), FrameWidth(40))];
    if([_machineDetail[@"status"] isEqualToString:@"1"]){
       
        [manageBtn setBackgroundImage:[UIImage imageNamed:@"station_manage"] forState:UIControlStateNormal];
        [manageBtn addTarget:self action:@selector(Alarmapevent:) forControlEvents:UIControlEventTouchUpInside];
        
        [machineView addSubview:manageBtn];
        [manageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ztLabel.mas_bottom).offset(5 + descripptionHeight);
            make.right.equalTo(machineView.mas_right).offset(-80);
            make.width.equalTo(@(FrameWidth(125)));
            make.height.equalTo(@(FrameWidth(40)));
        }];
    }
  
    
    if([_machineDetail[@"category"] isEqualToString:@"radar"]){
       // 添加一段描述
        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(240), FrameWidth(180), FrameWidth(390), FrameWidth(400))];
        descLabel.font = FontSize(15);
        descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descLabel.numberOfLines = 0;
        descLabel.textColor = FrameColor(255, 87, 26);
        descLabel.text = [NSString stringWithFormat:@"%@",_machineDetail[@"description"]];
        [machineView addSubview:descLabel];
        [descLabel sizeToFit];
     
        //雷达框图
        UIView *machineStatusView = [[UIView alloc]initWithFrame:CGRectMake(0, machineView.frame.origin.y + machineView.frame.size.height + 5 , WIDTH_SCREEN, FrameWidth(77))];
        machineStatusView.backgroundColor = [UIColor whiteColor];
        [thiscell addSubview:machineStatusView];
        
        UIImageView *nowMachine = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(18), FrameWidth(45), FrameWidth(45))];
        NSString * img1 = @"equipment";
        if([AllEquipment indexOfObject:_machineDetail[@"category"]] != NSNotFound){
            img1 = _machineDetail[@"category"];
            
        }
        nowMachine.image = [UIImage imageNamed:img1];
        [machineStatusView addSubview:nowMachine];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(75), 0, WIDTH_SCREEN, FrameWidth(77))];
        title.font = FontSize(16);
//        title.text = @"雷达组成框图";//@"UPS状态";
        title.text = _machineDetail[@"alias"];
        [machineStatusView addSubview:title];//station_right
        
        
        UIButton *moreBtn = [[UIButton alloc]init];
        [machineStatusView addSubview:moreBtn];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"station_right"] forState:UIControlStateNormal];
        [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0,0,0, -90)];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:17];

        [moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(machineStatusView.mas_right).offset(-30);
            make.width.equalTo(@80);
            make.centerY.equalTo(title.mas_centerY);
            make.height.equalTo(@77);
            
        }];
        [machineStatusView addSubview:self.webview];
        self.webview.hidden = YES;
        
        [machineStatusView addSubview:self.radarTableView];
      
        // Do any additional setup after loading the view from its nib.'
        
        allHeight = self.webview.frame.origin.y + self.webview.frame.size.height +FrameWidth(100) ;
//        [machineStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(manageBtn.mas_bottom).offset(10);
//            make.left.equalTo(thiscell.mas_left);
//            make.right.equalTo(thiscell.mas_right);
//            make.bottom.equalTo(thiscell.mas_bottom);
//        }];
        
    }else{
       
        //UPS状态
        UIView *machineStatusView = [[UIView alloc]initWithFrame:CGRectMake(0, machineView.frame.origin.y + machineView.frame.size.height, WIDTH_SCREEN, 50)];
        machineStatusView.backgroundColor = [UIColor whiteColor];
        
//        [machineStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(thiscell.mas_left);
//            make.right.equalTo(thiscell.mas_right);
//            make.top.equalTo(machineView.mas_bottom).offset(5);
//            make.height.equalTo(@(FrameWidth(77)));
//        }];
        [thiscell addSubview:machineStatusView];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(39, 0, 200, 50)];
        title.font = FontSize(14);
        title.text = [NSString stringWithFormat:@"%@",_machineDetail[@"alias"]];//@"UPS状态";
        [machineStatusView addSubview:title];//station_right
        
        UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 16-100-23, 0, 100, 50)];
        title2.text = @"更多参数";
        title2.textAlignment = NSTextAlignmentRight ;
        title2.font = FontSize(14);
        title2.textColor = [UIColor colorWithHexString:@"#1860B0"];
        title2.userInteractionEnabled = YES;
        UITapGestureRecognizer *viewTapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MachineInfoList:)];
        [title2 addGestureRecognizer:viewTapGesture1];
        [viewTapGesture setNumberOfTapsRequired:1];
        [machineStatusView addSubview:title2];
        [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(machineStatusView.mas_right).offset(-23-16-20);
            make.top.equalTo(machineStatusView.mas_top);
            make.width.equalTo(@100);
            make.height.equalTo(@50);
        }];
        
        UIImageView *rightArrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-16-16-4, 23, 4, 4)];
        rightArrowImg.image = [UIImage imageNamed:@"blue_jiantou"];
        [machineStatusView addSubview:rightArrowImg];//station_right
        [rightArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title2.mas_right).offset(2);
            make.top.equalTo(machineStatusView.mas_top).offset(23);
            make.width.equalTo(@4);
            make.height.equalTo(@4);
        }];
       
        UIImageView *rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(600), FrameWidth(25), FrameWidth(15), FrameWidth(30))];
        rightImg.image = [UIImage imageNamed:@"station_right"];
        [machineStatusView addSubview:rightImg];//station_right
        
        
        //UPS图片
        UIImageView *nowMachine = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(18), FrameWidth(45), FrameWidth(45))];
        NSString * img1 = @"equipment";
        if([AllEquipment indexOfObject:_machineDetail[@"category"]] != NSNotFound){
            img1 = _machineDetail[@"category"];
            
        }
        nowMachine.image = [UIImage imageNamed:img1];
        [machineStatusView addSubview:nowMachine];
        
        
        UIView *machineStatusMain = [[UIView alloc]initWithFrame:CGRectMake(0, machineStatusView.frame.origin.y + machineStatusView.frame.size.height + 1 , WIDTH_SCREEN, FrameWidth(520))];
        machineStatusMain.backgroundColor = [UIColor whiteColor];
        [thiscell addSubview:machineStatusMain];
        
        UIView *InView = [[UIView alloc]init];
        self.objects =  [[MachineItems class] mj_objectArrayWithKeyValuesArray: _machineDetail[@"tagList"]];
        
        
        
        CGFloat neworign_y = -FrameWidth(80) ;
        if(self.objects.count > 0){
            for (int i=0; i<self.objects.count; ++i) {
                if(self.objects[i].emphasis == false){
                    continue;
                }
                neworign_y +=  50;
                
                
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(38, neworign_y, FrameWidth(200),50)];
                nameLabel.font = FontSize(14);
                nameLabel.text = [CommonExtension isEmptyWithString:   self.objects[i].name]?@"":self.objects[i].name;//[self.objects[i].name isEqual:[NSNull null]]?@"":self.objects[i].name;
                nameLabel.numberOfLines = 0;
                nameLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
                
                nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
                [InView addSubview:nameLabel];
                
                UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -100-17, neworign_y, FrameWidth(180), 50)];
                numLabel.font = FontSize(14);
                NSString * unit = [CommonExtension isEmptyWithString:   self.objects[i].unit]?@"":self.objects[i].unit;
                NSString * tagValue = [CommonExtension isEmptyWithString:   self.objects[i].tagValue]?@"":self.objects[i].tagValue;
                if(tagValue.length >0){
                    numLabel.text =[NSString stringWithFormat:@"%@%@",tagValue ,unit] ;
                }
                
                numLabel.textAlignment = NSTextAlignmentCenter;
                //numLabel.text =self.objects[i].tagValue;
                [InView addSubview:numLabel];
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(400), neworign_y, FrameWidth(190), FrameWidth(80))];
                titleLabel.font = FontSize(14);
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
                
                NSString *bottomLimit = @"";
                NSString *topLimit = @"";
                if([FrameBaseRequest isPureInt:self.objects[i].bottomLimit]){
                    bottomLimit = [NSString stringWithFormat:@"%0.1f",[self.objects[i].bottomLimit floatValue]];
                    topLimit = [NSString stringWithFormat:@"%0.1f",[self.objects[i].topLimit floatValue]];
                }else{
                    bottomLimit = [self.objects[i].bottomLimit isEqual:[NSNull null]]?@"":self.objects[i].bottomLimit;//self.objects[i].bottomLimit;
                    topLimit = [self.objects[i].topLimit isEqual:[NSNull null]]?@"":self.objects[i].topLimit;//self.objects[i].topLimit;
                }
                
                titleLabel.text =  [NSString stringWithFormat:@"%@%@~%@%@",bottomLimit,unit,topLimit,unit];
                
                if(![self.objects[i].category isEqualToString:@"switchQuantity"]){
                    //暂时隐藏
                    //[InView addSubview:titleLabel];
                }
                
                
                
                UIImageView * typeImg = [[UIImageView alloc]initWithFrame:CGRectMake(23, neworign_y+22, 6, 6)];
                typeImg.backgroundColor = [UIColor colorWithHexString:@"#95A8D7"];
                typeImg.layer.cornerRadius = 3.f;
                typeImg.layer.masksToBounds = YES;
                [InView addSubview:typeImg];
                if(self.objects[i].alarmStatus){
                    typeImg.backgroundColor = [UIColor colorWithHexString:@"#F11B3D"];
                    titleLabel.textColor =  [UIColor colorWithHexString:@"#F11B3D"];
                    nameLabel.textColor = [UIColor colorWithHexString:@"#F11B3D"];
                    numLabel.textColor = [UIColor colorWithHexString:@"#F11B3D"];
                }
                
              
                
            }
        }
        if(neworign_y < 0){neworign_y = 0;}
        [InView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100+neworign_y)];
        
        [machineStatusMain setFrame:CGRectMake(0, machineStatusMain.frame.origin.y, WIDTH_SCREEN, FrameWidth(28)+InView.frame.size.height)];
     
        [machineStatusMain addSubview:InView];
        
        allHeight = machineStatusMain.frame.origin.y + machineStatusMain.frame.size.height ;
        
    }
    
    
    
    
    return thiscell;
    
    
}

//更多按钮
- (void)moreAction :(id)sender {
    if (self.moreAction) {
        self.moreAction();
    }
  
    
}
-(void)MachineInfoList:(UITapGestureRecognizer *)recognizer{
    
    NSDictionary *dic = _machineDetail;
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Machine" object:dic];
    
}

-(void)MachineInfoPicture:(UITapGestureRecognizer *)recognizer{
    NSDictionary *dic = _machineDetail;
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Picture" object:dic];
    
}
-(void)Alarmapevent:(UITapGestureRecognizer *)recognizer{
    NSDictionary *dic = _machineDetail;
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Alarmapevent" object:dic];
    
}


#pragma mark - UITableviewDelegate 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
}

-(CGFloat) setFilterBtn :(UIView *)vc objects:(NSArray *)objects title:(NSString *)title  {
    //设置按钮
    const NSInteger countPerRow = 4;
    NSInteger rowCount = (objects.count + (countPerRow - 1)) / countPerRow;
    CGFloat horizontalPadding = FrameWidth(10);
    CGFloat verticalPadding = FrameWidth(13);
    
    UIView *containerView = [UIView new];
    containerView.frame = CGRectMake(0, 0, FrameWidth(592), rowCount*FrameWidth(70));
    containerView.center = CGPointMake(WIDTH_SCREEN * 0.5, (containerView.frame.size.height+FrameWidth(20))*0.5);
    [self.view addSubview:containerView];
    
    CGFloat buttonWidth = (containerView.bounds.size.width - horizontalPadding * (countPerRow - 1)) / countPerRow;
    CGFloat buttonHeight = (containerView.bounds.size.height - verticalPadding * (rowCount - 1)) / rowCount;
    
    for (int i=0; i<objects.count; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping ;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setFrame:CGRectMake((buttonWidth + horizontalPadding) * (i % countPerRow),
                                    (buttonHeight + verticalPadding) * (i / countPerRow),
                                    buttonWidth,
                                    buttonHeight)];
        [button setTitle:objects[i] forState:UIControlStateNormal];
        button.tag = i+1;
        
        //button.backgroundColor = QianGray;
        [button setBackgroundImage:[UIImage imageNamed:@"station_machine_btn"] forState:UIControlStateNormal];
        //[button setBackgroundImage:[UIImage imageNamed:@"Patrol_btn_s"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.layer.cornerRadius = 5.0;
        //[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:FontSize(14)];
        [containerView addSubview:button];
    }
    [vc addSubview:containerView];
    
    //返回设置的高度
    return containerView.frame.size.height;
}
-(void)loadWebView{
    self.webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, FrameWidth(80), WIDTH_SCREEN, HEIGHT_SCREEN-FrameWidth(80))];
    self.webview.backgroundColor = [UIColor whiteColor];
    //self.webview.UIDelegate =self;
    self.webview.navigationDelegate = self;
    self.webview.scrollView.showsVerticalScrollIndicator = NO;
    self.webview.scrollView.scrollEnabled = NO;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",WebHost,@"/appRadarComposition?code=",_machineDetail[@"code"]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
}
- (void)loadTableView {
    self.radarTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, FrameWidth(80), WIDTH_SCREEN, HEIGHT_SCREEN - 150 - TOOLH - ZNAVViewH)];
    self.radarTableView.delegate =self;
    self.radarTableView.dataSource =self;
    self.radarTableView.separatorStyle = NO;
    
    if (TOOLH >0) {
        [self.radarTableView setFrame:CGRectMake(0, FrameWidth(80), WIDTH_SCREEN,HEIGHT_SCREEN - 90 - TOOLH - ZNAVViewH)];
    }
}

//  页面开始加载web内容时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.loadBgView = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(280), FrameWidth(100), WIDTH_SCREEN - FrameWidth(560), WIDTH_SCREEN - FrameWidth(560))];
    self.loadBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    self.loadBgView.layer.cornerRadius = 10;
    [self.webview addSubview:self.loadBgView];
    self.loadImageV = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(10), FrameWidth(10), self.loadBgView.frameWidth-FrameWidth(20), self.loadBgView.frameWidth-FrameWidth(20))];
    self.loadImageV.image = [UIImage imageNamed:@"webloading"];
    [self.loadBgView addSubview:self.loadImageV];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        
        self.loadImageV.transform = CGAffineTransformRotate(self.loadBgView.transform, M_PI_4*4);
        //动画设置
    } completion:^(BOOL finished) {
        
        //动画结束执行的操作
    }];
    
    
}

//  页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //[SVProgressHUD dismiss];
    [self.loadBgView removeFromSuperview];
    __block CGFloat webViewHeight;
    self.wkHeight = webView.frame.size.height;
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        webViewHeight = [result doubleValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (webViewHeight >= self.wkHeight) {
                self.wkHeight = webViewHeight+FrameWidth(300);
                [webView setFrameHeight:self.wkHeight];
                [self.tableview reloadData];
                
            }
        });
    }];
    
    NSLog(@"结束加载");
}

//  页面加载失败时调用 ( 【web视图加载内容时】发生错误)
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.loadBgView removeFromSuperview];
    //[SVProgressHUD dismiss];
}

  //  thiscell.backgroundColor = self.view.backgroundColor;
- (UIColor *)getTextColor:(NSString *)level {
    UIColor *textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    if ([level isEqualToString:@"0"]) {
        textColor = [UIColor colorWithHexString:@"FFFFFF"];
    }else if ([level isEqualToString:@"4"]) {
        textColor = [UIColor colorWithHexString:@"2986F1"];
    }else if ([level isEqualToString:@"3"]) {
        textColor = [UIColor colorWithHexString:@"FFA800"];
    }else if ([level isEqualToString:@"2"]) {
        textColor = [UIColor colorWithHexString:@"FC7D0E"];
    }else if ([level isEqualToString:@"1"]) {
        textColor = [UIColor colorWithHexString:@"F62546"];
    }
    
    //紧急
    return textColor;
}


- (NSString *)getLevelImage:(NSString *)level {
    NSString *levelString = @"level_normal";
    
    if ([level isEqualToString:@"0"]) {
        levelString = @"level_normal";
    }else if ([level isEqualToString:@"4"]) {
        levelString = @"level_prompt";
    }else if ([level isEqualToString:@"3"]) {
        levelString = @"level_ciyao";
    }else if ([level isEqualToString:@"2"]) {
        levelString = @"level_important";
    }else if ([level isEqualToString:@"1"]) {
        levelString = @"level_jinji";
    }
    
    //紧急
    return levelString;
}

@end


