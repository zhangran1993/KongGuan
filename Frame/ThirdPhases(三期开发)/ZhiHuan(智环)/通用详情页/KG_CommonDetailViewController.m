//
//  KG_CommonDetailViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/29.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CommonDetailViewController.h"
#import "KG_CommonDetailView.h"
#import "KG_MachineDetailModel.h"
#import "KG_UpsAlertView.h"
#import "StationMachineDetailMoreController.h"
#import "KG_NiControlViewController.h"
#import "KG_KongTiaoControlView.h"
#import "KG_AccessCardView.h"
#import "KG_AccessCardLogViewController.h"
@interface KG_CommonDetailViewController ()<UIScrollViewDelegate>
//topview
@property (nonatomic, strong) UIView         *topView;
@property (nonatomic, strong) UIImageView    *topLeftImage;
@property (nonatomic, strong) UILabel        *topTitleLabel;
@property (nonatomic, strong) UILabel        *statusLabel;
@property (nonatomic, strong) UIImageView    *statusImage;
@property (nonatomic, strong) UILabel        *statusNumLabel;


//
@property (nonatomic, strong) UIView         *sliderBgView;
@property (nonatomic, strong) UIView         *sliderView;
@property (nonatomic, strong) UIScrollView   *scrollView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) KG_MachineDetailModel *detailModel;
@property (strong, nonatomic) KG_UpsAlertView *upsAlertView;
@property (strong, nonatomic) NSMutableArray *rightArray;
@property (nonatomic, assign) int currIndex;



@end

@implementation KG_CommonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    
    [self initData];
    
    [self createTopView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controlLog:) name:@"controlLog" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreCanshu:) name:@"moreCanshu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controlAccessLog:) name:@"controlAccessLog" object:nil];
    if (self.isFromZhiTai) {
         [self queryDMEData];
    }else {
        if (self.zhitaiDic.count) {
            self.detailModel = nil;
            [self.dataArray removeAllObjects];
            if (self.detailModel == nil) {
                self.detailModel = [[KG_MachineDetailModel alloc]init];
            }
            
            [self.detailModel mj_setKeyValues:self.zhitaiDic];
            for (equipmentDetailsModel *detailModel in self.detailModel.equipmentDetails) {
                [self.dataArray addObject:detailModel];
            }
            if(self.dataArray.count ==0){
                return;
            }
            
            NSDictionary *di = [self.dataArray[self.currIndex] mj_keyValues];
            _station_code = safeString(di[@"equipment"][@"stationCode"]);
            _station_name = safeString(di[@"equipment"][@"stationName"]);
            //        self.machine_name = safeString(di[@"equipment"][@"alias"]);
            self.title = [NSString stringWithFormat:@"%@",safeString(self.machine_name)];
            [self refreshData];
        }else {
            //
            [self getMachineDetailList];
            
        }
        
    }
    
    
    
    [self getDetailRightData];
}

- (void)queryDMEData {
    NSString *code = @"";
    int isSystem = 0;
   
//    NSString *  FrameRequestURL  =  [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/api/sitDeviceInfo/%@/%d",code,isSystem];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/sitDeviceInfo/%@/%d",self.engine_room_code,self.isSystemEquipment]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.zhitaiDic = result[@"value"];
        self.detailModel = nil;
        [self.dataArray removeAllObjects];
        if (self.detailModel == nil) {
            self.detailModel = [[KG_MachineDetailModel alloc]init];
        }
        
        [self.detailModel mj_setKeyValues:self.zhitaiDic];
        for (equipmentDetailsModel *detailModel in self.detailModel.equipmentDetails) {
            [self.dataArray addObject:detailModel];
        }
        if(self.dataArray.count ==0){
            return;
        }
        
        NSDictionary *di = [self.dataArray[self.currIndex] mj_keyValues];
        _station_code = safeString(di[@"equipment"][@"stationCode"]);
        _station_name = safeString(di[@"equipment"][@"stationName"]);
        //        self.machine_name = safeString(di[@"equipment"][@"alias"]);
        self.title = [NSString stringWithFormat:@"%@",safeString(self.machine_name)];
        [self refreshData];
        
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
               NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}

-(void)dealloc
{
    [super dealloc];
    
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (void)controlAccessLog:(NSNotification *)notification {
    NSDictionary *dic = notification.object;
    KG_AccessCardLogViewController *vc = [[KG_AccessCardLogViewController alloc]init];
    if (dic.count) {
        vc.dic = dic;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)controlLog:(NSNotification *)notification {
    KG_NiControlViewController *vc = [[KG_NiControlViewController alloc]init];
    vc.dataDic = notification.object;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)moreCanshu:(NSNotification *)notification {
    NSDictionary * Detail = notification.object;
    StationMachineDetailMoreController *vc = [[StationMachineDetailMoreController alloc]init];
    vc.machineDetail = Detail;

    [self.navigationController pushViewController:vc animated:YES];
}


       
- (void)initData {
    
    self.currIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
      [self.navigationController setNavigationBarHidden:NO];
    [self createNaviView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshControlLogSegment" object:self];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
    
}

- (void)createNaviView {
    
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    
    UIButton *rightButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButon.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
    [rightButon setImage:[UIImage imageNamed:@"ups_right"] forState:UIControlStateNormal];
    [rightButon addTarget:self action:@selector(getMachinetypeList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightfixedButton = [[UIBarButtonItem alloc]initWithCustomView:rightButon];
    self.navigationItem.rightBarButtonItem = rightfixedButton;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = [NSString stringWithFormat:@"%@",_machine_name];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(18),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#24252A"]}] ;
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}

-(void)getMachinetypeList{
    
    if (self.upsAlertView.isHidden) {
        self.upsAlertView.hidden = NO;
    }
    
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
//sliderview
- (void)createSliderView {
    
    self.sliderBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topView.frame.origin.y + self.topView.frame.size.height, SCREEN_WIDTH, 26)];
    [self.view addSubview:self.sliderBgView];
    self.sliderBgView.backgroundColor = self.view.backgroundColor;
    
    float sliderV_X = SCREEN_WIDTH/2;
    float sliderVX =  sliderV_X;
    UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(sliderVX, 10, 6, 6)];
    
    sliderV.layer.cornerRadius = 3;
    sliderV.backgroundColor = [UIColor colorWithHexString:@"#005DC4"];
    [self.sliderBgView insertSubview:sliderV atIndex:1];
    _sliderView=sliderV;
    for (int i = 0; i <self.dataArray.count; i++) {
        //滑块
        float sliderV_X =SCREEN_WIDTH /2+ i*10;
        //float sliderVX = WIDTH_SCREEN - FrameWidth(sliderV_X);
        
        float sliderX = sliderV_X;//WIDTH_SCREEN - FrameWidth(i*18+30);
        UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(sliderX,  10, 6, 6)];
        sliderV.layer.cornerRadius = 3;
        sliderV.alpha= 0.19;
        sliderV.backgroundColor = [UIColor colorWithHexString:@"#005DC4"];
        [self.sliderBgView insertSubview:sliderV atIndex:0];
        
    }
    
}
- (void)createTopView {
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(16, self.view.frame.origin.y +16, SCREEN_WIDTH - 32, 50)];
    [self.view addSubview:self.topView];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.topView.layer.cornerRadius = 25.f;
    self.topView.layer.masksToBounds = YES;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.equalTo(@50);
    }];
    
    self.topLeftImage = [[UIImageView alloc]init];
    [self.topView addSubview:self.topLeftImage];
    [self.topLeftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(7);
        make.top.equalTo(self.topView.mas_top).offset(6);
        make.width.height.equalTo(@38);
    }];
    
    self.topTitleLabel = [[UILabel alloc]init];
    [self.topView addSubview:self.topTitleLabel];
    self.topTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.topTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.topTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.topTitleLabel.numberOfLines = 1;
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLeftImage.mas_right).offset(10);
        make.top.equalTo(self.topView.mas_top);
        make.width.equalTo(@150);
        make.height.equalTo(self.topView.mas_height);
    }];
    
    self.statusImage = [[UIImageView alloc]init];
    [self.topView addSubview:self.statusImage];
    self.statusImage.image = [UIImage imageNamed:@"level_normal"];
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topLeftImage.mas_centerY);
        make.height.equalTo(@17);
        make.width.equalTo(@32);
        make.right.equalTo(self.topView.mas_right).offset(-18);
    }];
    self.statusNumLabel = [[UILabel alloc]init];
    [self.topView addSubview:self.statusNumLabel];
    self.statusNumLabel.layer.cornerRadius = 5.f;
    self.statusNumLabel.layer.masksToBounds = YES;
    self.statusNumLabel.text = @"1";
    self.statusNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.statusNumLabel.font = [UIFont systemFontOfSize:10];
    self.statusNumLabel.numberOfLines = 1;
    
    self.statusNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.statusNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusImage.mas_right).offset(-5);
        make.bottom.equalTo(self.statusImage.mas_top).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    self.statusLabel = [[UILabel alloc]init];
    [self.topView addSubview:self.statusLabel];
    
    self.statusLabel.text = @"当前状态";
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.numberOfLines = 1;
    
    self.statusLabel.textAlignment = NSTextAlignmentRight;
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusImage.mas_left).offset(-5);
        make.centerY.equalTo(self.topLeftImage.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@25);
    }];
    
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
//选择某个标题
- (void)selectButton:(NSInteger)index
{
    
    [UIView animateWithDuration:0.3 animations:^{
        float sliderV_X = SCREEN_WIDTH/2 + ( index )*10;
        //float sliderVX = WIDTH_SCREEN - FrameWidth(sliderV_X);
        
        float sliderX =  sliderV_X;//WIDTH_SCREEN - FrameWidth(i*18+30);
        _sliderView.frame = CGRectMake(sliderX,10, 6, 6);
        //NSLog(@"selectButton  %f",sliderX);
        [self.sliderBgView insertSubview:_sliderView atIndex:10];
        
        
    }];
    /*
     [selectButton setTitleColor:backColor forState:UIControlStateNormal];
     selectButton = _buttonArray[index];
     [selectButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
     
     */
}

//监听滚动事件判断当前拖动到哪一个了
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / (SCREEN_WIDTH- 32);
    [self selectButton:index];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"111111%f",scrollView.contentOffset.x);
    NSInteger index = scrollView.contentOffset.x / (SCREEN_WIDTH- 32);
    self.currIndex = (int)index;
    if (index >=self.currIndex) {
        return;
    }
    equipmentDetailsModel *detailModel = self.dataArray[self.currIndex];
    NSDictionary *dataDic = detailModel.equipment;
    NSString *equipStr = @"device_UPS";
    self.topTitleLabel.text = safeString(self.machine_name);
    if ([safeString(dataDic[@"alias"]) isEqualToString:@"水浸"]) {
        equipStr = @"device_shuijin";
    }
    NSDictionary *totalDic = [self.detailModel.totalDetail mj_keyValues];
    self.topLeftImage.image =  [UIImage imageNamed:[NSString stringWithFormat:@"%@2",[CommonExtension getDeviceIcon:safeString(dataDic[@"category"])]]];
    if([safeString(dataDic[@"category"]) isEqualToString:@"navigation"]){
        if ([safeString(dataDic[@"type"]) isEqualToString:@"dme"]) {
            self.topLeftImage.image =  [UIImage imageNamed:@"导航DME2"];
        }else if ([safeString(dataDic[@"type"]) isEqualToString:@"dvor"]) {
            self.topLeftImage.image =  [UIImage imageNamed:@"导航DVOR2"];
        }
    }
    
    
    
    self.statusImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",totalDic[@"totalLevel"]]]];
    self.statusNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",totalDic[@"totalLevel"]]];
    self.statusNumLabel.text = [NSString stringWithFormat:@"%@",totalDic[@"totalNum"]];
    if([totalDic[@"totalLevel"] intValue] ==0) {
        self.statusNumLabel.hidden = YES;
    }else {
        self.statusNumLabel.hidden = NO;
    }
     
    
}

- (void)initWithController
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    NSLog(@"SCREEN_HEIGHT %f",SCREEN_HEIGHT);
    NSLog(@"HEIGHT_SCREEN %f",HEIGHT_SCREEN);
    scrollView.frame = CGRectMake(0, self.topView.frame.origin.y +  self.topView.size.height + 26, SCREEN_WIDTH,self.view.frame.size.height -self.topView.frame.origin.y -  self.topView.size.height -26 );
    scrollView.layer.cornerRadius = 16;
    scrollView.layer.masksToBounds = YES;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.dataArray.count, 0);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    if ([self.machine_name isEqualToString:@"门禁"]) {
        NSLog(@"_scrollView.frameHeight %f",_scrollView.frameHeight);
           for (int i = 0; i < self.dataArray.count; i++) {
               
               KG_AccessCardView *viewcon= [[KG_AccessCardView alloc] initWithFrame:CGRectMake(16 +SCREEN_WIDTH*i, 0, SCREEN_WIDTH-32, self.scrollView.frame.size.height)];
               
               equipmentDetailsModel *detailModel = self.dataArray[i];
               
               NSDictionary *dataDic = [detailModel.equipment mj_keyValues];
               viewcon.alarmArray = detailModel.equipmentAlarmInfo;
               viewcon.level = safeString(detailModel.level);
               viewcon.num = safeString(detailModel.num);
               viewcon.status = safeString(detailModel.status);
               viewcon.gotoDetail = ^{
                   self.tabBarController.selectedIndex = 3;
               };
               viewcon.dataDic = dataDic;
               viewcon.frame = CGRectMake(16 +SCREEN_WIDTH*i, 0, SCREEN_WIDTH -32,self.scrollView.frame.size.height);
               NSArray *equipmentDetails = [KG_MachineDetailModel mj_keyValuesArrayWithObjectArray:self.dataArray];
               
               NSDictionary * Detail = @{@"station_name":_station_name,
                                         @"machine_name":_machine_name,
                                         @"name":equipmentDetails[i][@"equipment"][@"alias"],
                                         @"alias":equipmentDetails[i][@"equipment"][@"alias"],
                                         @"code":equipmentDetails[i][@"equipment"][@"code"],
                                         @"roomName":equipmentDetails[i][@"equipment"][@"roomName"],
                                         @"picture":equipmentDetails[i][@"equipment"][@"picture"],
                                         @"status":equipmentDetails[i][@"status"],
                                         @"level":equipmentDetails[i][@"level"]?equipmentDetails[i][@"level"]:@"",
                                         @"num":equipmentDetails[i][@"num"]?equipmentDetails[i][@"num"]:@"",
                                         @"category":equipmentDetails[i][@"equipment"][@"category"],
                                         @"tagList":equipmentDetails[i][@"equipment"][@"measureTagList"],
                                             
                                        
                                         @"description":equipmentDetails[i][@"equipment"][@"description"]
               };
               viewcon.moreAction = ^{
                   StationMachineDetailMoreController *vc = [[StationMachineDetailMoreController alloc]init];
                   vc.machineDetail = Detail;
                   vc.alarmArray  = detailModel.equipmentAlarmInfo;
                                     
                   [self.navigationController pushViewController:vc animated:YES];
               };
               
               
               
               NSLog(@"_scrollView.frameHeight %f",_scrollView.frameHeight);
               [_scrollView addSubview:viewcon];
               
           }
           
    }else if ([self.machine_name isEqualToString:@"空调"]) {
        NSLog(@"_scrollView.frameHeight %f",_scrollView.frameHeight);
                  for (int i = 0; i < self.dataArray.count; i++) {
                      
                      KG_KongTiaoControlView *viewcon= [[KG_KongTiaoControlView alloc] initWithFrame:CGRectMake(16 +SCREEN_WIDTH*i, 0, SCREEN_WIDTH-32, self.scrollView.frame.size.height)];
                      
                      equipmentDetailsModel *detailModel = self.dataArray[i];
                      
                      NSDictionary *dataDic = [detailModel.equipment mj_keyValues];
                      viewcon.alarmArray = detailModel.equipmentAlarmInfo;
                      viewcon.level = safeString(detailModel.level);
                      viewcon.num = safeString(detailModel.num);
                      viewcon.status = safeString(detailModel.status);
                      viewcon.gotoDetail = ^{
                          self.tabBarController.selectedIndex = 3;
                      };
                      viewcon.dataDic = dataDic;
                      viewcon.frame = CGRectMake(16 +SCREEN_WIDTH*i, 0, SCREEN_WIDTH -32,self.scrollView.frame.size.height);
                      NSArray *equipmentDetails = [KG_MachineDetailModel mj_keyValuesArrayWithObjectArray:self.dataArray];
                      
                      NSDictionary * Detail = @{@"station_name":_station_name,
                                                @"machine_name":_machine_name,
                                                @"name":equipmentDetails[i][@"equipment"][@"alias"],
                                                @"alias":equipmentDetails[i][@"equipment"][@"alias"],
                                                @"code":equipmentDetails[i][@"equipment"][@"code"],
                                                @"roomName":equipmentDetails[i][@"equipment"][@"roomName"],
                                                @"picture":equipmentDetails[i][@"equipment"][@"picture"],
                                                @"status":equipmentDetails[i][@"status"],
                                                @"level":equipmentDetails[i][@"level"]?equipmentDetails[i][@"level"]:@"",
                                                @"num":equipmentDetails[i][@"num"]?equipmentDetails[i][@"num"]:@"",
                                                @"category":equipmentDetails[i][@"equipment"][@"category"],
                                                @"tagList":equipmentDetails[i][@"equipment"][@"measureTagList"],
                                                
                                                
                                                @"description":equipmentDetails[i][@"equipment"][@"description"]
                      };
                      viewcon.moreAction = ^{
                          StationMachineDetailMoreController *vc = [[StationMachineDetailMoreController alloc]init];
                          vc.machineDetail = Detail;
                          
                          [self.navigationController pushViewController:vc animated:YES];
                      };
                      
                      
                      
                      NSLog(@"_scrollView.frameHeight %f",_scrollView.frameHeight);
                      [_scrollView addSubview:viewcon];
                      
                  }
        
    }else {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < self.dataArray.count; i++) {
            equipmentDetailsModel *detailModel = self.dataArray[i];
            if ([safeString(detailModel.equipment[@"category"]) isEqualToString:safeString(self.category)]) {
                [arr addObject:detailModel];
            }
        }
        
    
    NSLog(@"_scrollView.frameHeight %f",_scrollView.frameHeight);
     for (int i = 0; i < arr.count; i++) {
        
        KG_CommonDetailView *viewcon= [[KG_CommonDetailView alloc] init];
         viewcon.gotoDetail = ^{
             self.tabBarController.selectedIndex = 3;
         };
         equipmentDetailsModel *detailModel = self.dataArray[i];
         
         NSDictionary *dataDic = [detailModel.equipment mj_keyValues];
         viewcon.alarmArray = detailModel.equipmentAlarmInfo;
         viewcon.machineName = self.machine_name;
         viewcon.level = safeString(detailModel.level);
         viewcon.num = safeString(detailModel.num);
         viewcon.status = safeString(detailModel.status);
         
         viewcon.dataDic = dataDic;
      
         viewcon.frame = CGRectMake(16 +SCREEN_WIDTH*i, 0, SCREEN_WIDTH -32,self.scrollView.frame.size.height);
         NSArray *equipmentDetails = [KG_MachineDetailModel mj_keyValuesArrayWithObjectArray:self.dataArray];
         
         NSDictionary * Detail = @{@"station_name":_station_name,
                                   @"machine_name":_machine_name,
                                   @"name":equipmentDetails[i][@"equipment"][@"alias"],
                                   @"alias":equipmentDetails[i][@"equipment"][@"alias"],
                                   @"code":equipmentDetails[i][@"equipment"][@"code"],
                                   @"roomName":equipmentDetails[i][@"equipment"][@"roomName"],
                                  @"picture":equipmentDetails[i][@"equipment"][@"picture"],
                                  @"status":equipmentDetails[i][@"status"],
                                  @"level":equipmentDetails[i][@"level"]?equipmentDetails[i][@"level"]:@"",
                                  @"num":equipmentDetails[i][@"num"]?equipmentDetails[i][@"num"]:@"",
                                  @"category":equipmentDetails[i][@"equipment"][@"category"],
                                  @"tagList":equipmentDetails[i][@"equipment"][@"measureTagList"],
                                  @"equipmentAlarmInfo":equipmentDetails[i][@"equipmentAlarmInfo"],
                                                                          
                                  
                                  @"description":equipmentDetails[i][@"equipment"][@"description"]
        };
        viewcon.moreAction = ^{
            StationMachineDetailMoreController *vc = [[StationMachineDetailMoreController alloc]init];
            vc.machineDetail = Detail;
           
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        
        
        NSLog(@"_scrollView.frameHeight %f",_scrollView.frameHeight);
        [_scrollView addSubview:viewcon];
        
    }
    }
      
    
    
}
//获取某个台站下某个机房的详情页接口：
//请求地址：/intelligent/api/envRoomInfo/{stationCode}/{engineRoomCode}
//     其中，stationCode是台站编码，engineRoomCode是机房编码
//请求方式：GET
//请求返回：
//   如：
//{

-(void)getMachineDetailList{
//    NSString *  FrameRequestURL = [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/api/envDeviceInfo/%@/%@",_station_code,_category];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
     NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/envDeviceInfo/%@/%@",_station_code,_category]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
       [MBProgressHUD hideHUDForView:JSHmainWindow];
        self.detailModel = nil;
        [self.dataArray removeAllObjects];
        if (self.detailModel == nil) {
            self.detailModel = [[KG_MachineDetailModel alloc]init];
        }
        
        [self.detailModel mj_setKeyValues:result[@"value"]];
        for (equipmentDetailsModel *detailModel in self.detailModel.equipmentDetails) {
            [self.dataArray addObject:detailModel];
        }
        if(self.dataArray.count ==0){
            return;
        }
       
        NSDictionary *di = [self.dataArray[self.currIndex] mj_keyValues];
        _station_code = safeString(di[@"equipment"][@"stationCode"]);
        _station_name = safeString(di[@"equipment"][@"stationName"]);
//        self.machine_name = safeString(di[@"equipment"][@"alias"]);
        self.title = [NSString stringWithFormat:@"%@",safeString(self.machine_name)];
        [self refreshData];
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        
        [MBProgressHUD hideHUDForView:JSHmainWindow];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}
- (void)refreshData {
    
    equipmentDetailsModel *detailModel = self.dataArray[self.currIndex];
    NSDictionary *dataDic = detailModel.equipment;
    NSString *equipStr = [CommonExtension getDeviceIcon:safeString(dataDic[@"category"])];
    self.topTitleLabel.text = safeString(self.machine_name);
   
    NSDictionary *totalDic = [self.detailModel.totalDetail mj_keyValues];
  
    self.topLeftImage.image =  [UIImage imageNamed:[NSString stringWithFormat:@"%@2",[CommonExtension getDeviceIcon:safeString(dataDic[@"category"])]]];
    if([safeString(dataDic[@"category"]) isEqualToString:@"navigation"]){
        if ([safeString(dataDic[@"type"]) isEqualToString:@"dme"]) {
            self.topLeftImage.image =  [UIImage imageNamed:@"导航DME2"];
        }else if ([safeString(dataDic[@"type"]) isEqualToString:@"dvor"]) {
            self.topLeftImage.image =  [UIImage imageNamed:@"导航DVOR2"];
        }
    }
    
    self.topTitleLabel.text = safeString(self.machine_name);
    self.statusImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",totalDic[@"totalLevel"]]]];
    self.statusNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",totalDic[@"totalLevel"]]];
    self.statusNumLabel.text = [NSString stringWithFormat:@"%@",totalDic[@"totalNum"]];
    if([totalDic[@"totalLevel"] intValue] ==0) {
        self.statusNumLabel.hidden = YES;
    }else {
        self.statusNumLabel.hidden = NO;
    }
    
    
    [self createSliderView];
    
    [self initWithController];
}

- (void)getDetailRightData {
//    NSString *  FrameRequestURL  =  [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/api/envDeviceCategory/%@",_station_code];
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/envDeviceCategory/%@",_station_code]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.rightArray = result[@"value"];
        
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
               NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
}

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

- (KG_UpsAlertView *)upsAlertView {
    if (!_upsAlertView) {
        _upsAlertView = [[KG_UpsAlertView alloc]init];
        [_upsAlertView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [JSHmainWindow addSubview:self.upsAlertView];
//        [self.upsAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.bottom.left.equalTo(self.view);
//            make.top.equalTo(self.view.mas_top).offset(-NAVIGATIONBAR_HEIGHT);
//
//        }];
        _upsAlertView.dataArray = self.rightArray;
        _upsAlertView.didsel = ^(NSDictionary * _Nonnull selDic) {
            [self.sliderBgView removeFromSuperview];
            _sliderBgView = nil;
            [self.sliderView removeFromSuperview];
            _sliderView = nil;
            [self createSliderView];
            _category =safeString(selDic[@"categoryCode"]);
            self.machine_name = safeString(selDic[@"categoryName"]);
            self.currIndex = 0;
            [self getMachineDetailList];
        };
        
    }
    return _upsAlertView;
}
- (NSMutableArray *)rightArray
{
    if (!_rightArray) {
        _rightArray = [[NSMutableArray alloc] init];
    }
    return _rightArray;
}


@end
