//
//  StationDetailController.m
//  Frame
//
//  Created by hibayWill on 2018/3/29.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "StationDetailController.h"
#import "StationRoomController.h"
#import "StationVideoListController.h"
#import "StationMachineController.h"
#import "FrameBaseRequest.h"
#import <UIImageView+WebCache.h>
#import "LoginViewController.h"
#import "EquipmentDetailsModel.h"
#import "EquipmentStatusModel.h"
#import "StationItems.h"
#import "UIView+LX_Frame.h"
#import <MJExtension.h>
#import "UIColor+Extension.h"
#import <SDImageCache.h>
@interface StationDetailController ()<UITableViewDataSource,UITableViewDelegate,ParentViewDelegate>

@property (nonatomic,copy) NSString* station_code;
@property (nonatomic,copy) NSString* station_name;
@property (nonatomic,copy) NSString* airport;
@property (nonatomic,copy) NSString* imageUrl;
@property (nonatomic,copy) NSString* latitude;
@property (nonatomic,strong) id longitude;
@property (nonatomic,copy) NSString* address;
@property (nonatomic, copy) NSMutableArray * objects0;
@property (copy,nonatomic) NSMutableDictionary * stationDetail;
@property (copy,nonatomic) NSMutableDictionary * weather;
@property NSUInteger newHeight1;
@property long imageHeight;
@property  (assign,nonatomic) NSMutableArray *roomList;
@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;
@property NSMutableArray *objects1;
@property NSMutableArray *objects10;
@property NSMutableArray *objects2;
@property (nonatomic, strong) NSMutableArray *objects3;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *statusArray;
@property BOOL isRefresh;
@property int a;
/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property(nonatomic) UITableView *tableview;
@property(nonatomic) UITableView *filterTabView;
@property(nonatomic) UIButton *rightButton;
@property  (assign,nonatomic) UIFont* btnFont;
@property (nonatomic, strong)  UIView *runView;
/**  标题栏 */
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong)  UIView *navigationView;
@end

@implementation StationDetailController
#pragma mark - 全局常量


#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(20),NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
  
    [self createNaviTopView];
    [self createTopView];
          
          
    float moreheight = ZNAVViewH;
    if(HEIGHT_SCREEN == 812){
        moreheight = FrameWidth(280);
    }
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 215,WIDTH_SCREEN, HEIGHT_SCREEN - ZNAVViewH -MLTabBarHeight)];
    self.tableview.estimatedRowHeight = 0;
    self.tableview.estimatedSectionHeaderHeight = 0;
    self.tableview.estimatedSectionFooterHeight = 0;
    self.tableview.backgroundColor = BGColor;
    if (@available(iOS 11.0, *)) {
        NSLog(@"StationDetailController viewDidLoad");
        self.tableview.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.tableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);//64和49自己看效果，是否应该改成0
    self.tableview.scrollIndicatorInsets =self.tableview.contentInset;
    
    
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorStyle = NO;
    [self.view addSubview:self.tableview];
    
    
    self.filterTabView.delegate =self;
    self.filterTabView.dataSource =self;
    self.filterTabView.separatorStyle = NO;
    self.modelArray = [NSMutableArray array];
    self.statusArray = [NSMutableArray array];
    [super viewDidLoad];
    
    
    
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 215)];
    [self.view addSubview:topImage1];
    topImage1.contentMode = UIViewContentModeScaleAspectFill;
    topImage1.image  =[UIImage imageNamed:@"machine_rs"];
    
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 215)];
    [self.view addSubview:topImage];
    topImage.image  =[UIImage imageNamed:@"zhihuan_bgimage"];
    [self stationBtn];
    
    
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
    self.titleLabel.text = @"智环";
  
    /** 返回按钮 **/
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.navigationView.mas_left);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = IMAGE(@"back_icon");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    
   
}

- (void)backButtonClick:(UIButton *)button {
    
}
- (void)createTopView{
  
    [self.runView removeFromSuperview];
    self.runView = nil;
    self.runView= [[UIView alloc]init];
    [self.view addSubview:self.runView];
    self.runView.backgroundColor = [UIColor whiteColor];
    self.runView.layer.cornerRadius = 9;
    self.runView.layer.masksToBounds = YES;
    [self.runView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT +24);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.equalTo(@100);
    }];
    
    UIImageView *runBgImage = [[UIImageView alloc]init];
    [self.runView addSubview:runBgImage];
    runBgImage.contentMode = UIViewContentModeScaleAspectFill;
    runBgImage.image = [UIImage imageNamed:@"runBgImage"];
    [runBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.runView.mas_top);
        make.left.equalTo(self.runView.mas_left);
        make.right.equalTo(self.runView.mas_right);
        make.height.equalTo(@40);
    }];
    //智环运行状况
    UILabel *zhihuanRunLabel = [[UILabel alloc]init];
    [self.runView addSubview:zhihuanRunLabel];
    zhihuanRunLabel.text = @"智环运行情况";
    zhihuanRunLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    zhihuanRunLabel.font = [UIFont systemFontOfSize:18];
    zhihuanRunLabel.numberOfLines = 1;
    zhihuanRunLabel.textAlignment = NSTextAlignmentLeft;
    [zhihuanRunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runView.mas_left).offset(17);
        make.top.equalTo(self.runView.mas_top).offset(17);
        make.height.equalTo(@24);
        make.width.equalTo(@140);
    }];
    
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn setTitle:@"查看视频" forState:UIControlStateNormal];
    [self.runView addSubview:rightBtn];
    [rightBtn setImage:[UIImage imageNamed:@"watchvideo_right"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 66, 0, 0)];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.runView.mas_right).offset(-20);
        make.centerY.equalTo(zhihuanRunLabel.mas_centerY);
        make.height.equalTo(@20);
        make.width.equalTo(@70);
    }];
    
    UILabel *anfangLalbel = [[UILabel alloc]init];
    [self.runView addSubview:anfangLalbel];
    anfangLalbel.text = @"安防监测";
    anfangLalbel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    anfangLalbel.font = [UIFont systemFontOfSize:14];
    anfangLalbel.numberOfLines = 1;
    anfangLalbel.textAlignment = NSTextAlignmentLeft;
    [anfangLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runView.mas_left).offset(16);
        make.bottom.equalTo(self.runView.mas_bottom).offset(-19);
        make.width.equalTo(@60);
        make.height.equalTo(@18);
    }];
    UIImageView *anfangImage = [[UIImageView alloc]init];
    anfangImage.image = [UIImage imageNamed:@"level_prompt"];
    [self.runView addSubview:anfangImage];
    [anfangImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(anfangLalbel.mas_centerY);
        make.left.equalTo(anfangLalbel.mas_right).offset(1);
        make.width.equalTo(@30);
        make.height.equalTo(@17);
    }];
    
    UILabel *anfangNumLalbel = [[UILabel alloc]init];
    [self.runView addSubview:anfangNumLalbel];
    anfangNumLalbel.layer.cornerRadius = 5.f;
    anfangNumLalbel.layer.masksToBounds = YES;
    anfangNumLalbel.text = @"1";
    anfangNumLalbel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    anfangNumLalbel.font = [UIFont systemFontOfSize:14];
    anfangNumLalbel.numberOfLines = 1;
    
    anfangNumLalbel.textAlignment = NSTextAlignmentLeft;
    [anfangNumLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(anfangImage.mas_right).offset(-5);
        make.bottom.equalTo(anfangImage.mas_top).offset(-5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    //设备监测
    if (self.statusArray.count > 0) {
        EquipmentStatusModel *model = self.statusArray[0];
        switch (model.status) {
            case 0:
                anfangImage.image = [UIImage imageNamed:@"level_normal"];
                break;
            case 1:
                anfangImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%ld级",(long)model.level]]];
                anfangNumLalbel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%ld级",(long)model.level]];
                anfangNumLalbel.text = [NSString stringWithFormat:@"%ld",(long)model.num];
                break;
            case 2:{
                anfangImage.image = [UIImage imageNamed:@"level_normal"];
                break;
            }
            case 3:
                anfangImage.image = [UIImage imageNamed:@"level_normal"];
                break;
            default:
                break;
        }
    }
    UILabel *envLalbel = [[UILabel alloc]init];
    [self.runView addSubview:envLalbel];
    envLalbel.text = @"环境监测";
    envLalbel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    envLalbel.font = [UIFont systemFontOfSize:14];
    envLalbel.numberOfLines = 1;
    envLalbel.textAlignment = NSTextAlignmentLeft;
    [envLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.runView.mas_centerX).offset(-15);
        make.bottom.equalTo(self.runView.mas_bottom).offset(-19);
        make.width.equalTo(@60);
        make.height.equalTo(@18);
    }];
    UIImageView *envImage = [[UIImageView alloc]init];
    envImage.image = [UIImage imageNamed:@"level_prompt"];
    [self.runView addSubview:envImage];
    [envImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(envLalbel.mas_centerY);
        make.left.equalTo(envLalbel.mas_right).offset(1);
        make.width.equalTo(@30);
        make.height.equalTo(@17);
    }];
    
    UILabel *envNumLalbel = [[UILabel alloc]init];
    [self.runView addSubview:envNumLalbel];
    envNumLalbel.text = @"1";
    envNumLalbel.layer.cornerRadius = 5.f;
    envNumLalbel.layer.masksToBounds = YES;
    envNumLalbel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    envNumLalbel.font = [UIFont systemFontOfSize:14];
    envNumLalbel.numberOfLines = 1;
    envNumLalbel.backgroundColor = [self getTextColor:@""];
    envNumLalbel.textAlignment = NSTextAlignmentLeft;
    [envNumLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(envImage.mas_right).offset(-2);
        make.bottom.equalTo(envImage.mas_top).offset(-5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    if([_stationDetail[@"environmentStatus"][@"status"] isEqualToString:@"0"]){
        
        envImage.image = [UIImage imageNamed:@"level_normal"];
    }else if([_stationDetail[@"environmentStatus"][@"status"] isEqualToString:@"3"]){
        
        envImage.image = [UIImage imageNamed:@"level_normal"];
    }else if([_stationDetail[@"environmentStatus"][@"status"] isEqualToString:@"1"]){
        envImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",_stationDetail[@"environmentStatus"][@"level"]]]];
        envNumLalbel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",_stationDetail[@"environmentStatus"][@"level"]]];
        envNumLalbel.text = [NSString stringWithFormat:@"%@",_stationDetail[@"environmentStatus"][@"num"]];
        
    }else{
        envImage.image = [UIImage imageNamed:@"level_normal"];
    }
    
    UILabel *powerLalbel = [[UILabel alloc]init];
    [self.runView addSubview:powerLalbel];
    powerLalbel.text = @"动力监测";
    powerLalbel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    powerLalbel.font = [UIFont systemFontOfSize:14];
    powerLalbel.numberOfLines = 1;
    powerLalbel.textAlignment = NSTextAlignmentLeft;
   
    UIImageView *powerImage = [[UIImageView alloc]init];
    powerImage.image = [UIImage imageNamed:@"level_prompt"];
    [self.runView addSubview:powerImage];
    [powerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(anfangLalbel.mas_centerY);
        make.right.equalTo(self.runView.mas_right).offset(-9);
        make.width.equalTo(@30);
        make.height.equalTo(@17);
    }];
    [powerLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(powerImage.mas_left).offset(-5);
           make.bottom.equalTo(self.runView.mas_bottom).offset(-19);
           make.width.equalTo(@60);
           make.height.equalTo(@18);
       }];
    UILabel *powerNumLabel = [[UILabel alloc]init];
    [self.runView addSubview:powerNumLabel];
    powerNumLabel.text = @"1";
    powerNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    powerNumLabel.font = [UIFont systemFontOfSize:14];
    powerNumLabel.numberOfLines = 1;
    powerNumLabel.layer.cornerRadius = 5.f;
    powerNumLabel.layer.masksToBounds = YES;
    powerNumLabel.backgroundColor = [self getTextColor:@""];
    powerNumLabel.textAlignment = NSTextAlignmentLeft;
    [powerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(powerImage.mas_right).offset(-5);
        make.bottom.equalTo(powerImage.mas_top).offset(-5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    if([_stationDetail[@"powerStatus"][@"status"] isEqualToString:@"0"]){
        
        powerImage.image = [UIImage imageNamed:@"level_normal"];
    }else if([_stationDetail[@"powerStatus"][@"status"] isEqualToString:@"3"]){
        powerImage.image = [UIImage imageNamed:@"level_normal"];
    }else if([_stationDetail[@"powerStatus"][@"status"] isEqualToString:@"1"]){
        powerImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",_stationDetail[@"powerStatus"][@"level"]]]];
        powerNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",_stationDetail[@"powerStatus"][@"level"]]];
        powerNumLabel.text = [NSString stringWithFormat:@"%@",_stationDetail[@"powerStatus"][@"num"]];
    }else{
        powerImage.image = [UIImage imageNamed:@"level_normal"];
    }
    [self.tableview reloadData];
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
//查看视频
- (void)rightButtonClicked:(UIButton *)button {
    [self sptapevent];
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES];
    self.StationItem = nil;
    
    
    [self dataReport];
    
    _imageUrl = @"";
    [_tableview reloadData];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults objectForKey:@"station"]){
        NSDictionary * station = [userDefaults objectForKey:@"station"];
        
        self.navigationItem.title = station[@"alias"];//
        _station_name = station[@"alias"];
        _station_code = station[@"code"];//
        _airport = station[@"airport"];//
        if([getAllStation indexOfObject:_station_code] != NSNotFound){
            
        }else{
            [userDefaults removeObjectForKey:@"station"];
            [FrameBaseRequest showMessage:@"您没有当前台站的权限"];
            [self.tabBarController setSelectedIndex:2];
            return ;
        }
        
    }else{
        [FrameBaseRequest showMessage:@"请选择台站"];
        [self.tabBarController setSelectedIndex:2];
        return ;
    }
    
    [self setupTable];
    self.view.backgroundColor = [UIColor whiteColor];
    //去除分割线
    //[self.view addSubview:_tableview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(gotoBottomApevent:) name:@"bottomapevent" object:nil];
    
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
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.translucent = NO;
    //    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
     [self.navigationController setNavigationBarHidden:NO];
}

//展示navigation背景色
-(void)showNavigation{
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
}




#pragma mark--上传用户使用情况的接口，这个接口在台站管理页面、首页每次进入调用一次
- (void)dataReport {
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/dataReport/%@",@"stationManagement"]];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            [FrameBaseRequest showMessage:[result objectForKey:@"errMsg"]];
            return ;
        }
        NSLog(@"请求成功");
    } failure:^(NSError *error) {
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}







#pragma mark - private methods 私有方法

- (void)setupTable{
    
    
    [self stationBtn];
    //    _station_code = @"S5";
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/stationInfo/%@/%@",_airport,_station_code]];
    NSLog(@"%@",FrameRequestURL);
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [self.modelArray removeAllObjects];
        [self.statusArray removeAllObjects];
        _stationDetail = [result[@"value"] copy];
        _objects0 = [NSMutableArray new];
        [_objects0 addObjectsFromArray:[_stationDetail[@"roomList"] copy]];
        //_objects0 = [_stationDetail[@"roomList"] copy];
        
        _objects1 = [_stationDetail[@"securityDetails"] copy];
        _objects2 = [_stationDetail[@"powerDetails"] copy];
        _objects3 = [_stationDetail[@"equipmentDetails"] copy];
        _roomList = [_stationDetail[@"roomList"] copy];
        _imageUrl = @"";
        _address = @"";
        
        if(_stationDetail[@"station"][@"picture"]){
            _imageUrl= _stationDetail[@"station"][@"picture"];//
        }
        
        if(_stationDetail[@"station"][@"address"]){
            _address= _stationDetail[@"station"][@"address"];//
        }
        
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
        
        if(_stationDetail[@"station"][@"latitude"]){
            _latitude= _stationDetail[@"station"][@"latitude"];//
        }else{
            _latitude = @"0";
        }
        if(_stationDetail[@"station"][@"longitude"]){
            _longitude= _stationDetail[@"station"][@"longitude"];//
            [self getWeather];
        }else{
            _longitude = @"0";
        }
      
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
    
    
    
}

-(void)getWeather{
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/weather/%@/%@/",_latitude,_longitude]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if(result[@"value"]&&![self isBlankDictionary:result[@"value"]  ]){
            _weather = [result[@"value"] copy];
        }
        [self.tableview reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
}


-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
    if(_isRefresh){
        _isRefresh = false;
        return ;
    }
    //    _imageUrl = @"";
    //    [_tableview reloadData];
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //
    //    if([userDefaults objectForKey:@"station"]){
    //        NSDictionary * station = [userDefaults objectForKey:@"station"];
    //
    //        self.navigationItem.title = station[@"alias"];//
    //        _station_name = station[@"alias"];
    //        _station_code = station[@"code"];//
    //        _airport = station[@"airport"];//
    //        if([getAllStation indexOfObject:_station_code] != NSNotFound){
    //
    //        }else{
    //            [userDefaults removeObjectForKey:@"station"];
    //            [FrameBaseRequest showMessage:@"您没有当前台站的权限"];
    //            [self.tabBarController setSelectedIndex:2];
    //            return ;
    //        }
    //
    //    }else{
    //        [FrameBaseRequest showMessage:@"请选择台站"];
    //        [self.tabBarController setSelectedIndex:2];
    //        return ;
    //    }
    //
    //    [self setupTable];
    //    self.view.backgroundColor = [UIColor whiteColor];
    //    //去除分割线
    //    //[self.view addSubview:_tableview];
    //
    //    [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(gotoBottomApevent:) name:@"bottomapevent" object:nil];
    
}
-(void)gotoBottomApevent:(NSNotification *)notification{
    NSLog(@"stationdetail通知过来的 - dic = %@",notification.object);
    _isRefresh = true ;
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

-(void)dealloc{
    //第一种方法.这里可以移除该控制器下的所有通知
    // 移除当前所有通知
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //第二种方法.这里可以移除该控制器下名称为tongzhi的通知
    //移除名称为tongzhi的那个通知
    //NSLog(@"移除了名称为Machine的通知");
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"Machine" object:nil];
    [super dealloc];
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewDidDisappear");
    
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
    
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


- (void)ParentViewTitle:(NSString *)ParentViewTitle {
    NSLog(@"点击的是%@",ParentViewTitle);
    if([ParentViewTitle isEqualToString:@"环境监测"]){
        [self jftapevent];
    }else if([ParentViewTitle isEqualToString:@"设备监测"]){
        [self deviceTestingClick];
        
    }else if([ParentViewTitle isEqualToString:@"视频监测"]){
        [self sptapevent];
    }
    
    
}


- (void)ParentViewTag:(NSInteger)tag{
    NSLog(@"点击的是tagtag %ld",(long)tag);
    [self machineTapeventTag:tag];
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
        return self.StationItem.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.filterTabView){
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
            titleLabel.font =  FontSize(16);
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
    
    UITableViewCell *thiscell = [[UITableViewCell alloc] init];
    thiscell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    thiscell.backgroundColor = BGColor;
    if (!_stationDetail||_stationDetail == nil||[_stationDetail isEqual:[NSNull null]]) {
        NSLog(@"_stationDetail == nil ");
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
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(84))];
    
    title.font = FontSize(18);
    title.text = @"环境监测";
    [view addSubview:title];
    
    _btnFont = FontBSize(13);
    //
    if([_stationDetail[@"environmentStatus"][@"status"] isEqualToString:@"0"]){
        
        UIButton *normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        [normalBtn setBackgroundColor:FrameColor(120, 203, 161)];
        normalBtn.layer.cornerRadius = 2;
        normalBtn.titleLabel.font = _btnFont;
        [normalBtn setTitle: @"正常"   forState:UIControlStateNormal];
        normalBtn.titleLabel.textColor = [UIColor whiteColor];
        [view addSubview:normalBtn];
    }else if([_stationDetail[@"environmentStatus"][@"status"] isEqualToString:@"3"]){
        
        UIButton *normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        [normalBtn setBackgroundColor:FrameColor(252,201,84)];
        normalBtn.layer.cornerRadius = 2;
        normalBtn.titleLabel.font = _btnFont;
        [normalBtn setTitle: @"正常"   forState:UIControlStateNormal];
        normalBtn.titleLabel.textColor = [UIColor whiteColor];
        [view addSubview:normalBtn];
    }else if([_stationDetail[@"environmentStatus"][@"status"] isEqualToString:@"1"]){
        UIButton *warnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(420), FrameWidth(32), FrameWidth(120), FrameWidth(28))];
        
        [warnBtn setBackgroundColor:warnColor];
        warnBtn.layer.cornerRadius = 2;
        
        warnBtn.titleLabel.font = _btnFont;
        [warnBtn setTitle:[NSString stringWithFormat:@"告警数量%@",_stationDetail[@"environmentStatus"][@"num"]] forState:UIControlStateNormal];
        warnBtn.titleLabel.textColor = [UIColor whiteColor];
        [view addSubview:warnBtn];
        //
        UIButton *LevelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        LevelBtn.layer.cornerRadius = 2;
        LevelBtn.titleLabel.font = _btnFont;
        [CommonExtension addLevelBtn:LevelBtn level:_stationDetail[@"environmentStatus"][@"level"]];
        
        [view addSubview:LevelBtn];
        
    }else{
        UILabel *noneMachine = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(560), FrameWidth(32), FrameWidth(70), FrameWidth(26))];
        noneMachine.text = @"－－";
        [view addSubview:noneMachine];
    }
    //动力监测
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, FrameWidth(85), WIDTH_SCREEN, FrameWidth(84))];
    view1.backgroundColor = [UIColor whiteColor];
    //    view1.userInteractionEnabled = YES;
    //    view1.tag = 200;
    //    UITapGestureRecognizer *viewTapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(machineTapevent:)];
    //    [view1 addGestureRecognizer:viewTapGesture1];
    //    [viewTapGesture1 setNumberOfTapsRequired:1];
    
    [thiscell addSubview:view1];
    
    CommonExtension *com1 = [CommonExtension new];
    [com1 addTouchViewParentTagClass:view1];
    com1.delegate = self;
    com1.parentViewTag = 200;
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(84))];
    title1.text = @"动力监测";
    title1.font = FontSize(18);
    [view1 addSubview:title1];
    //
    if([_stationDetail[@"powerStatus"][@"status"] isEqualToString:@"0"]){
        
        UIButton *normalBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        [normalBtn1 setBackgroundColor:FrameColor(120, 203, 161)];
        normalBtn1.layer.cornerRadius = 2;
        normalBtn1.titleLabel.font = _btnFont;
        [normalBtn1 setTitle: @"正常"   forState:UIControlStateNormal];
        normalBtn1.titleLabel.textColor = [UIColor whiteColor];
        [view1 addSubview:normalBtn1];
    }else if([_stationDetail[@"powerStatus"][@"status"] isEqualToString:@"3"]){
        
        UIButton *normalBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        [normalBtn1 setBackgroundColor:FrameColor(252,201,84)];
        normalBtn1.layer.cornerRadius = 2;
        normalBtn1.titleLabel.font = _btnFont;
        [normalBtn1 setTitle: @"正常"   forState:UIControlStateNormal];
        normalBtn1.titleLabel.textColor = [UIColor whiteColor];
        [view1 addSubview:normalBtn1];
    }else if([_stationDetail[@"powerStatus"][@"status"] isEqualToString:@"1"]){
        //
        UIButton *warnBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(420), FrameWidth(32), FrameWidth(120), FrameWidth(28))];
        [warnBtn1 setBackgroundColor:warnColor];
        warnBtn1.layer.cornerRadius = 2;
        [warnBtn1 setTitle:[NSString stringWithFormat:@"告警数量%@",_stationDetail[@"powerStatus"][@"num"]] forState:UIControlStateNormal];
        warnBtn1.titleLabel.font = _btnFont;
        warnBtn1.titleLabel.textColor = [UIColor whiteColor];
        [view1 addSubview:warnBtn1];
        //
        UIButton *LevelBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        LevelBtn1.layer.cornerRadius = 2;
        LevelBtn1.titleLabel.font = _btnFont;
        [CommonExtension addLevelBtn:LevelBtn1 level:_stationDetail[@"powerStatus"][@"level"]];
        
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
    CommonExtension *com3 = [CommonExtension new];
    [com3 addTouchViewParent:deviceTesting];
    com3.delegate = self;
    com3.parentViewTitle = @"设备监测";
    [thiscell addSubview:deviceTesting];
    
    //UITapGestureRecognizer *deviceTestingTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deviceTestingClick)];
    //[deviceTesting addGestureRecognizer:deviceTestingTapGesture];
    //
    
    UILabel *deviceTestingTitle = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(84))];
    deviceTestingTitle.text = @"设备监测";
    deviceTestingTitle.font = FontSize(18);
    [deviceTesting addSubview:deviceTestingTitle];
    
    //    UIButton *stateBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
    //    [stateBtn setBackgroundColor:FrameColor(120, 203, 161)];
    //    stateBtn.layer.cornerRadius = 2;
    //    stateBtn.titleLabel.font = _btnFont;
    //    stateBtn.titleLabel.textColor = [UIColor whiteColor];
    //    [deviceTesting addSubview:stateBtn];
    
    if (self.statusArray.count > 0) {
        UIButton *stateBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(555), FrameWidth(32), FrameWidth(60), FrameWidth(28))];
        stateBtn.layer.cornerRadius = 2;
        stateBtn.titleLabel.font = _btnFont;
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
                warnBtn1.titleLabel.font = _btnFont;
                warnBtn1.titleLabel.textColor = [UIColor whiteColor];
                [deviceTesting addSubview:warnBtn1];
                
                break;
            case 2:{
                UILabel *noneMachine = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(560), FrameWidth(32), FrameWidth(70), FrameWidth(26))];
                noneMachine.text = @"－－";
                [deviceTesting addSubview:noneMachine];
                break;
            }
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
    
    float viewHeight = FrameWidth(448);
    if(self.imageHeight >0){
        viewHeight = self.imageHeight +FrameWidth(51);
    }
    
    //    NSString *path_document = NSHomeDirectory();
    //    //设置一个图片的存储路径
    //    NSString *imagePath = [path_document stringByAppendingString:@"/Documents/pic.png"];
    //    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    //    [UIImagePNGRepresentation(image2) writeToFile:imagePath atomically:YES];
    //    UIImage *getimage2 = [UIImage imageWithContentsOfFile:imagePath];
    //    NSLog(@"image2 is size %@",NSStringFromCGSize(getimage2.size));
    
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view2.frame)+5, WIDTH_SCREEN, viewHeight)];
    view3.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:view3];
    
    
    NSString *stationString = @"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults objectForKey:@"station"]){
        NSDictionary * station = [userDefaults objectForKey:@"station"];
        stationString =  station[@"alias"];
        
    }
    // 读取沙盒路径图片
    
    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),stationString];
    
    // 拿到沙盒路径图片
    
    UIImageView *BigImg = [[UIImageView alloc]init];
    
    UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
    if(imgFromUrl3) {
        
        NSLog(@"you");
        [BigImg setImage:imgFromUrl3 ];
        
    }else {
        
        NSString *urlString =  [WebHost stringByAppendingString:_imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
        UIImage *image = [UIImage imageWithData:data]; // 取得图片
        
        // 本地沙盒目录
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        // 得到本地沙盒中名为"MyImage"的路径，"MyImage"是保存的图片名
        NSString *imageFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",stationString]];
        // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
        BOOL success = [UIImageJPEGRepresentation(image, 0.5) writeToFile:imageFilePath  atomically:YES];
        if (success){
            NSLog(@"写入本地成功");
        }
    }
    
    
    
    //先从缓存中找是否有图片
    SDImageCache *cache =  [SDImageCache sharedImageCache];
    UIImage *memoryImage = [cache imageFromMemoryCacheForKey:stationString];
    
    [BigImg sd_setImageWithURL:[NSURL URLWithString: [WebHost stringByAppendingString:_imageUrl]] placeholderImage:[UIImage imageNamed:@"station_indexbg"]];
    
    [BigImg sd_setImageWithURL:[NSURL URLWithString:[WebHost stringByAppendingString:_imageUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"cself.imageHeight %ld",self.imageHeight);
        if (self.imageHeight==0) {
            self.imageHeight = (image.size.height / image.size.width) * BigImg.frameWidth;
            NSLog(@"bself.imageHeight %ld",self.imageHeight);
            if (self.imageHeight==0) {self.imageHeight =FrameWidth(397); }
            NSLog(@"aself.imageHeight %ld",self.imageHeight);
            [self.tableview reloadData ];
            return ;
        }
    }];
    
    BigImg.frame = CGRectMake(FrameWidth(23), FrameWidth(20), FrameWidth(595), viewHeight - FrameWidth(51));
    BigImg.contentMode = UIViewContentModeScaleAspectFill;
    if([userDefaults objectForKey:@"station"]){
        NSDictionary * station = [userDefaults objectForKey:@"station"];
        
        [[SDImageCache sharedImageCache] storeImage:BigImg.image forKey:station[@"alias"] toDisk:YES completion:nil];
        
    }
    
    [view3 addSubview:BigImg];//station_right
    
    UIView *view4 = [[UIView alloc] init];
    view4.backgroundColor = [UIColor whiteColor];
    _newHeight1 = [self setFilterBtn:view4 objects:_objects0 title:@"机房"];
    [view4 setFrame:CGRectMake(0, view3.frame.origin.y + view3.frame.size.height +1, WIDTH_SCREEN, FrameWidth(40)+_newHeight1)];
    [thiscell addSubview:view4];
    
    
    //安防情况
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(0, view4.frame.origin.y + view4.frame.size.height + 5 , WIDTH_SCREEN, FrameWidth(74))];
    view5.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:view5];
    
    UILabel *title5 = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(74))];
    title5.text = @"安防情况";
    title5.font = FontSize(18);
    [view5 addSubview:title5];//station_right
    
    UIView *view6 = [[UIView alloc]initWithFrame:CGRectMake(0, view5.frame.origin.y + view5.frame.size.height + 1 , WIDTH_SCREEN, FrameWidth(520))];
    view6.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:view6];
    
    UIView *view7 = [[UIView alloc]init];
    
    
    _objects10 = [NSMutableArray arrayWithObjects:@"temperature",@"humidity",@"immersion",@"ratproof",@"smoke",@"ups",@"electric",@"diesel",@"battery",@"电子围栏",@"红外对射",@"门禁",nil];
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
            
            
            
            
            NSString *imgIcon =  @"station_tongyong";
            NSString *btnIcon =  @"正常";
            
            
            NSUInteger index = [_objects10  indexOfObject:_objects1[i][@"name"]];
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
            
            UIButton *typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(504), neworign_y, FrameWidth(60), FrameWidth(28))];
            typeBtn.layer.cornerRadius = 2;
            typeBtn.titleLabel.font = _btnFont;
            
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
            
            
            UIImageView *rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(550), neworign_y10, FrameWidth(15), FrameWidth(26))];
            rightImg.image = [UIImage imageNamed:@"station_right"];
            [view10 addSubview:rightImg];//station_right
            
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
            
            
            
            
            UIImageView *imgIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgIcon]];
            [imgIconView setFrame:CGRectMake(FrameWidth(30), neworign_y10 - FrameWidth(5), FrameWidth(40), FrameWidth(40))];
            [view10 addSubview:imgIconView];
            
            UIButton *typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(475), neworign_y10, FrameWidth(60), FrameWidth(28))];
            typeBtn.layer.cornerRadius = 2;
            typeBtn.titleLabel.font = _btnFont;
            
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
    
    
    //设备情况
    UIView *equipview = [[UIView alloc]initWithFrame:CGRectMake(0, view9.frame.origin.y + view9.frame.size.height + 5 , WIDTH_SCREEN, FrameWidth(74))];
    equipview.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:equipview];
    
    UILabel *equiptitle8 = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(74))];
    equiptitle8.text = @"设备情况";
    equiptitle8.font = FontSize(18);
    [equipview addSubview:equiptitle8];//station_right
    
    UIView *equipview9 = [[UIView alloc]initWithFrame:CGRectMake(0, equipview.frame.origin.y + equipview.frame.size.height + 1 , WIDTH_SCREEN, FrameWidth(520))];
    equipview9.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:equipview9];
    
    UIView *equipview10 = [[UIView alloc]init];
    
    
    CGFloat equipneworign_y10 = 0;
    if(_objects3.count > 0){
        for (int i=0; i<_objects3.count; ++i) {
            equipneworign_y10 = FrameWidth(40) + i * FrameWidth(60);
            
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(1), equipneworign_y10 - FrameWidth(15), FrameWidth(580), FrameWidth(60))];
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:backView.bounds];
            
            //            nameLabel.userInteractionEnabled = YES;
            
            nameLabel.font = FontSize(17);
            nameLabel.textColor = listGrayColor;
            
            CommonExtension * com10 = [CommonExtension new];
            com10.delegate = self;
            com10.parentViewTag = i + 300;
            [com10 addTouchViewParentTagClass:backView];
            
            nameLabel.text = [NSString stringWithFormat:@"             %@",_objects3[i][@"name"]] ;//;
            [equipview10 addSubview:backView];
            [backView addSubview:nameLabel];
            
            
            
            UIImageView *rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(550), equipneworign_y10, FrameWidth(15), FrameWidth(26))];
            rightImg.image = [UIImage imageNamed:@"station_right"];
            [equipview10 addSubview:rightImg];//station_right
            
            NSString *imgIcon =  @"station_tongyong";
            NSString *btnIcon =  @"正常";
            NSUInteger index = [_objects10  indexOfObject:_objects3[i][@"code"]];
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
            
            
            
            
            UIImageView *equipimgIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgIcon]];
            [equipimgIconView setFrame:CGRectMake(FrameWidth(30), equipneworign_y10 - FrameWidth(5), FrameWidth(40), FrameWidth(40))];
            
            [equipview10 addSubview:equipimgIconView];
            /*
             UIButton * typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(475), neworign_y10, FrameWidth(60), FrameWidth(30))];
             [typeBtn setBackgroundImage:[UIImage imageNamed:btnIcon] forState:UIControlStateNormal];
             [view10 addSubview:typeBtn];
             */
            UIButton *typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(475), equipneworign_y10, FrameWidth(60), FrameWidth(28))];
            typeBtn.layer.cornerRadius = 2;
            typeBtn.titleLabel.font = _btnFont;
            
            if([_objects3[i][@"status"] isEqual:[NSNull null]]||[_objects3[i][@"status"] intValue ] == 0){
                btnIcon =  @"正常";
                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
            }else if([_objects3[i][@"status"] intValue ] == 1){
                btnIcon =  @"告警";
                [typeBtn setBackgroundColor:FrameColor(242, 108, 107)];
            }else if([_objects3[i][@"status"] intValue ] == 2){
                btnIcon =  @"--";
                [typeBtn setHidden:true];
                UILabel * noStatus = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(475), equipneworign_y10, FrameWidth(60), FrameWidth(28))];
                noStatus.text = btnIcon;
                [equipview10 addSubview:noStatus];
            }else if([_objects3[i][@"status"] intValue ] == 3){
                btnIcon =  @"正常";//预警
                [typeBtn setBackgroundColor:FrameColor(252,201,84)];
            }else {
                btnIcon =  @"正常";
                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
            }
            
            [typeBtn setTitle: btnIcon   forState:UIControlStateNormal];
            typeBtn.titleLabel.textColor = [UIColor whiteColor];
            [equipview10 addSubview:typeBtn];
            
        }
    }
    [equipview10 setFrame:CGRectMake(FrameWidth(25), FrameWidth(20), FrameWidth(590), FrameWidth(70)+equipneworign_y10)];
    
    [equipview9 setFrame:CGRectMake(0, equipview9.frame.origin.y, WIDTH_SCREEN, FrameWidth(40)+equipview10.frame.size.height)];
    equipview10.layer.cornerRadius = 5;
    equipview10.layer.borderWidth = 1;
    equipview10.layer.borderColor = QianGray.CGColor;
    [equipview9 addSubview:equipview10];
    
    //天气
    UIView *view11 =  [[UIView alloc] initWithFrame:CGRectMake(0, equipview9.frame.origin.y + equipview9.frame.size.height + 5, WIDTH_SCREEN, FrameWidth(290))];
    view11.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:view11];
    
    UIImageView *view12 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"station_tqbg"]];
    
    view12.frame = CGRectMake(FrameWidth(20), FrameWidth(30), FrameWidth(600), FrameWidth(222));
    
    view12.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [view11 addSubview:view12];
    
    UIImageView *lineH = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"station_tg_line"]];
    
    lineH.frame = CGRectMake(FrameWidth(340), FrameWidth(36), FrameWidth(2), FrameWidth(150));
    
    [view12 addSubview:lineH];
    
    
    
    UIFont *btnFont = FontSize(15);
    
    
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(5), FrameWidth(260), FrameWidth(75))];
    addressLabel.font = btnFont;
    addressLabel.text = [_address  isEqual:[NSNull null]]?@"xxx":_address;
    addressLabel.numberOfLines = 0;
    addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [view12 addSubview:addressLabel];
    
    UIImageView *addressImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"station_address"]];
    [addressImg setFrame:CGRectMake(-FrameWidth(45), FrameWidth(20), FrameWidth(23), FrameWidth(28))];
    [addressLabel addSubview:addressImg];
    
    NSString *weat = @"";
    NSDictionary * weather = [NSMutableDictionary alloc];
    if([_weather isEqual:[NSNull null]]||[_weather  isKindOfClass:[NSNull class]]||[self isBlankDictionary:_weather  ]){
        weather = @{
            @"WEAT":@"－－",
            @"windDir":@"－－",
            @"windSpeed":@"－－",
            @"pressure":@"－－",
            @"humidity":@"－－",
            @"temp":@"－－",
            @"condition":@"－－"
        };
    }else{
        //匹配图片
        NSArray *weatherArray = @[@"雾",@"云",@"雷",@"霾",@"晴",@"雪",@"雨"];
        weat = [NSString stringWithFormat:@"%@",_weather[@"condition"]];
        for (int i = 0; i < weatherArray.count; i++) {
            if ([weat rangeOfString:weatherArray[i]].location != NSNotFound ) {
                weat = weatherArray[i];
                break;
            }
        }
        if ([weat isEqualToString:@"阴"]) {
            weat = @"云";
        }
        weather = _weather;
    }
    
    UIImageView *tqImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:weat] ];
    [tqImg setFrame:CGRectMake(FrameWidth(30), FrameWidth(90), FrameWidth(100), FrameWidth(100))];
    [view12 addSubview:tqImg];
    
    UILabel *fxLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(360), FrameWidth(40), FrameWidth(240), FrameWidth(25))];
    fxLabel.font = btnFont;
    NSString *WindD = [weather[@"WindD"] isEqualToString:@""]?@"－－":weather[@"windDir"];
    fxLabel.text = [NSString stringWithFormat:@"%@%@",@"风向：  ",WindD];
    //_stationDetail[@"weather"][@"WindD"];
    [view12 addSubview:fxLabel];
    
    UILabel *fsLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(360), fxLabel.frame.origin.y *2, FrameWidth(240), FrameWidth(25))];
    fsLabel.font = btnFont;
    NSString *windSpeed = [weather[@"windSpeed"] isEqualToString:@""]?@"－－":weather[@"windSpeed"];
    fsLabel.text = [windSpeed isEqualToString:@"－－"]?[NSString stringWithFormat:@"%@%@%@",@"风速：   ",windSpeed,@""]:[NSString stringWithFormat:@"%@%@%@",@"风速：  ",windSpeed,@"m/s"];
    [view12 addSubview:fsLabel];
    
    UILabel *njdLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(360), fxLabel.frame.origin.y *3, FrameWidth(240), FrameWidth(25))];
    njdLabel.font = btnFont;
    NSString *humidity = [weather[@"humidity"] isEqualToString:@""]?@"－－":weather[@"humidity"];
    njdLabel.text = [humidity isEqualToString:@"－－"]?[NSString stringWithFormat:@"%@%@%@",@"湿度：   ",humidity,@""]:[NSString stringWithFormat:@"%@%@%@",@"湿度：  ",humidity,@"%"];
    //@"能见度：50m";
    [view12 addSubview:njdLabel];
    
    UILabel *QNHLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(360), fxLabel.frame.origin.y *4, FrameWidth(240), FrameWidth(25))];
    QNHLabel.font = btnFont;
    NSString *QNH = [weather[@"pressure"] isEqualToString:@""]?@"－－":weather[@"pressure"];
    QNHLabel.text = [QNH isEqualToString:@"－－"]?[NSString stringWithFormat:@"%@%@%@",@"QNH：  ",QNH,@""]:[NSString stringWithFormat:@"%@%@%@",@"QNH： ",QNH,@"百帕"];
    
    [view12 addSubview:QNHLabel];
    
    UILabel *qwLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(155),tqImg.lx_y + tqImg.lx_height/2.5 , FrameWidth(130), FrameWidth(60))];
    qwLabel.font = FontSize(35);
    qwLabel.text = [weather[@"temp"] isEqualToString:@"－－"]?@"--":[NSString stringWithFormat:@"%@%@",weather[@"temp"],@"°"];
    CGSize size =[qwLabel.text sizeWithAttributes:@{NSFontAttributeName:FontSize(35)}];
    //@"13°";
    [view12 addSubview:qwLabel];
    
    UILabel *tqLabel = [[UILabel alloc]initWithFrame:CGRectMake(size.width+FrameWidth(20), FrameWidth(20), FrameWidth(90), FrameWidth(30))];
    tqLabel.font = FontSize(17);
    tqLabel.text = weather[@"condition"];
    tqLabel.textAlignment = NSTextAlignmentCenter;
    [qwLabel addSubview:tqLabel];
    allHeight = view11.frame.origin.y + view11.frame.size.height ;
    return thiscell;
    
    
}


#pragma mark - UITableviewDelegate 代理方法


-(CGFloat) setFilterBtn :(UIView *)vc objects:(NSArray *)objects title:(NSString *)title  {
    //设置按钮
    const NSInteger countPerRow = 4;
    NSInteger rowCount = (objects.count + (countPerRow - 1)) / countPerRow;
    CGFloat horizontalPadding = FrameWidth(10);
    CGFloat verticalPadding = FrameWidth(8);
    
    UIView *containerView = [UIView new];
    containerView.frame = CGRectMake(0, 0, FrameWidth(592), rowCount*FrameWidth(60));
    containerView.center = CGPointMake(WIDTH_SCREEN * 0.5, (containerView.frame.size.height+FrameWidth(10))*0.5);
    [self.view addSubview:containerView];
    
    CGFloat buttonWidth = (containerView.bounds.size.width - horizontalPadding * (countPerRow - 1)) / countPerRow;
    CGFloat buttonHeight = (containerView.bounds.size.height - verticalPadding * rowCount) / rowCount;
    NSMutableDictionary *rowHeightD = [[NSMutableDictionary alloc] init];
    for (int i = 1; i <= rowCount; i++) {
        rowHeightD[[NSString stringWithFormat:@"%d",i]] = [NSString stringWithFormat:@"%f",buttonHeight];
    }
    NSMutableArray *heights = [NSMutableArray new];
    for (int i=0; i<objects.count; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping ;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.numberOfLines = 0;
        
        if( [NSString stringWithFormat:@"%@",objects[i][@"alias"]].length > 5 ){
            [button setFrame:CGRectMake((buttonWidth + horizontalPadding) * (i % countPerRow),
                                        (buttonHeight + verticalPadding) * (i / countPerRow),
                                        buttonWidth,
                                        buttonHeight * 1.3)];
        }else{
            [button setFrame:CGRectMake((buttonWidth + horizontalPadding) * (i % countPerRow),
                                        (buttonHeight + verticalPadding) * (i / countPerRow),
                                        buttonWidth,
                                        buttonHeight)];
        }
        
        
        
        
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
        [containerView setFrameHeight:button.originY + [heights[heights.count-1] floatValue] ];
        
        
        
        
        button.tag = i+1;
        
        //button.backgroundColor = QianGray;
        
        if([objects[i][@"alarmStatus"] isEqual:[NSNull null]]||[objects[i][@"alarmStatus"] boolValue]==1){
            [button setBackgroundImage:[UIImage imageNamed:@"station_machine_btn_w"] forState:UIControlStateNormal];
        }else{
            [button setBackgroundImage:[UIImage imageNamed:@"station_machine_btn"] forState:UIControlStateNormal];
        }
        
        //[button setBackgroundImage:[UIImage imageNamed:@"Patrol_btn_s"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.layer.cornerRadius = 5.0;
        //[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:FontSize(15)];
        //button.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        //button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [button addTarget:self action:@selector(jfbtapevent:) forControlEvents:UIControlEventTouchUpInside];
        
        [containerView addSubview:button];
    }
    [vc addSubview:containerView];
    
    //返回设置的高度
    return containerView.frame.size.height;
}
-(void)jfbtapevent:(UIButton *) nlabel{
    if (!_objects0 || _objects0[nlabel.tag - 1][@"code"] == nil) {
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }
    if(_objects0.count == 0){
        [FrameBaseRequest showMessage:@"当前台站无机房"];
        return ;
    }
    
    
    StationRoomController  *StationRoom = [[StationRoomController alloc] init];
    
    StationRoom.imageUrl = _objects0[nlabel.tag - 1][@"picture"];
    StationRoom.room_code = _objects0[nlabel.tag - 1][@"code"];
    StationRoom.room_name = _objects0[nlabel.tag - 1][@"alias"];
    StationRoom.station_code = _station_code;
    StationRoom.station_name = _station_name;
    [self.navigationController pushViewController:StationRoom animated:YES];
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
        [FrameBaseRequest showMessage:@"当前分组无设备"];
    }
}



-(void)jftapevent{
    if (!_objects0 ) {
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }
    if(_objects0.count == 0){
        [FrameBaseRequest showMessage:@"当前台站无机房"];
        return ;
    }
    StationRoomController  *StationRoom = [[StationRoomController alloc] init];
    
    StationRoom.imageUrl = _objects0[0][@"picture"];
    StationRoom.room_code = _objects0[0][@"code"];
    StationRoom.room_name = _objects0[0][@"alias"];
    StationRoom.station_code = _station_code;
    StationRoom.station_name = _station_name;
    
    for (int i =0; i< _objects0.count; i++) {
        if([_objects0[i][@"category"] isEqualToString:@"environmental"]){
            if([_objects0[i][@"alarmStatus"] isEqual:[NSNull null]]||[_objects0[i][@"alarmStatus"] boolValue]==1){
                
                StationRoom.imageUrl = _objects0[i][@"picture"];
                StationRoom.room_code = _objects0[i][@"code"];
                StationRoom.room_name = _objects0[i][@"alias"];
                StationRoom.station_code = _station_code;
                StationRoom.station_name = _station_name;
            }
        }
        
    }
    
    
    [self.navigationController pushViewController:StationRoom animated:YES];
    
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
    if([sender view].tag >= 100 &&_objects1.count > [sender view].tag - 100){//是安防
        mList = _objects1;
        return ;
    }else if([sender view].tag >= 200 &&_objects2.count > [sender view].tag - 200){//是power
        category = _objects2[[sender view].tag - 200][@"code"];
        machinename = _objects2[[sender view].tag - 200][@"name"];
        mList = _objects2;
    }else if([sender view].tag >= 300 &&_objects3.count > [sender view].tag - 300){//是power
        category = _objects3[[sender view].tag - 300][@"code"];
        machinename = _objects3[[sender view].tag - 300][@"name"];
        mList = _objects3;
    }else{
        [FrameBaseRequest showMessage:@"当前台站无设备"];
        return;
    }
    
    StationMachineController  *StationMachine = [[StationMachineController alloc] init];
    StationMachine.category = category;
    StationMachine.machine_name = machinename;
    StationMachine.station_name = _station_name;
    StationMachine.station_code = _station_code;
    StationMachine.engine_room_code = @"";
    StationMachine.mList = mList;
    [self.navigationController pushViewController:StationMachine animated:YES];
}

-(void)machineTapeventTag:(NSInteger)senderTag{
    NSString * category = @"";
    NSString * machinename = @"";
    NSMutableArray * mList = [NSMutableArray alloc];
    if(senderTag >= 100 &&_objects1.count > senderTag - 100){//是安防
        mList = _objects1;
        category = _objects1[senderTag - 100][@"code"];
        machinename = _objects1[senderTag- 100][@"name"];
        //        return ;
    }else if(senderTag >= 200 &&_objects2.count > senderTag - 200){//是power
        category = _objects2[senderTag - 200][@"code"];
        machinename = _objects2[senderTag- 200][@"name"];
        mList = _objects2;
    }else if(senderTag >= 300 &&_objects3.count > senderTag - 300){//是power
        category = _objects3[senderTag - 300][@"code"];
        machinename = _objects3[senderTag - 300][@"name"];
        mList = _objects3;
    }else{
        [FrameBaseRequest showMessage:@"当前台站无设备"];
        return;
    }
    
    StationMachineController  *StationMachine = [[StationMachineController alloc] init];
    StationMachine.category = category;
    StationMachine.machine_name = machinename;
    StationMachine.station_name = _station_name;
    StationMachine.station_code = _station_code;
    StationMachine.engine_room_code = @"";
    StationMachine.mList = mList;
    [self.navigationController pushViewController:StationMachine animated:YES];
}
-(void)stationBtn{
    if(!self.rightButton){
        self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,  FrameWidth(120), FrameWidth(30))];
        
        [self.rightButton addTarget:self action:@selector(stationAction) forControlEvents:UIControlEventTouchUpInside];
        self.rightButton.titleLabel.font = FontSize(15);
        
        self.rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        self.rightButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.rightButton.titleLabel.numberOfLines = 2;
        if(![CommonExtension isEmptyWithString:_station_name]){
            
            
            NSMutableString* str1=[[NSMutableString alloc]initWithString:_station_name];//存在堆区，可变字符串
            float strLength = floor(str1.length/7);
            if(strLength > 0){
                for (int i =1; i <= strLength &&i <= 2; i++) {
                    [str1 insertString:@"\n"atIndex:(7*i + (i-1))];//把一个字符串插入另一个字符串中的某一个位置
                }
                
                [self.rightButton setTitle:str1 forState:UIControlStateNormal];
            }else{
                [self.rightButton setTitle:_station_name forState:UIControlStateNormal];
                CGSize size = [self.rightButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(15),NSFontAttributeName,nil]];
                
                [self.rightButton setFrameWidth:size.width+3];
            }
            
        }
//        
//        [self.navigationView addSubview:self.rightButton];
//        
//        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.height.equalTo(self.navigationView.mas_right).offset(-20);
//            make.centerY.equalTo(self.titleLabel.mas_centerY);
//            make.width.equalTo(@200);
//        }];
           
    }else{
        if(![CommonExtension isEmptyWithString:_station_name]){
            NSMutableString* str1=[[NSMutableString alloc]initWithString:_station_name];//存在堆区，可变字符串
            float strLength = floor(str1.length/7);
            
            if(strLength > 0){
                for (int i =1; i <= strLength &&i <= 2; i++) {
                    [str1 insertString:@"\n"atIndex:(7*i + (i-1))];//把一个字符串插入另一个字符串中的某一个位置
                }
                
                [self.rightButton setTitle:str1 forState:UIControlStateNormal];
            }else{
                [self.rightButton setTitle:_station_name forState:UIControlStateNormal];
                CGSize size = [self.rightButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(15),NSFontAttributeName,nil]];
                
                [self.rightButton setFrameWidth:size.width+3];
            }
        }
        
    }
    
    
    
}
-(void)stationAction {
    //if(self.StationItem){
    //    [self getStationList];
    //}else{
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/allStationList"];
    NSLog(@"%@",FrameRequestURL);
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
        self.StationItem = [radar copy];
        
        [self getStationList];
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }else if(responses.statusCode == 502){
            
        }
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
    vc.view.frame = CGRectMake(FrameWidth(320), FrameWidth(128), FrameWidth(320),  moreheight);
    //_vc.view.layer.cornerRadius = 4.0;
    vc.view.layer.masksToBounds = YES;
    UIImageView * xialaImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, FrameWidth(300),  FrameWidth(20))];
    xialaImage.image = [UIImage imageNamed:@"station_pulldown_right"];
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
    _filterTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, FrameWidth(20), FrameWidth(300) , tabelHeight)];
    _filterTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [vc.view addSubview:_filterTabView];
    _filterTabView.dataSource = self;
    _filterTabView.delegate = self;
    [self.filterTabView reloadData];
    
    
    
    [self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentRight overlayDismissed:nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    
    if(tableView == self.filterTabView){
        StationItems *item = self.StationItem[indexPath.row];
        if(![item.category isEqualToString:@"title"]){
            [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
            self.navigationItem.title = item.alias;//
            _station_name = item.alias;
            _station_code = item.code;//
            _airport = item.airport;//
            _imageUrl = [item.picture copy];//
            _address = item.address;
            
            NSDictionary  *thisStation2 = @{
                @"name":_station_name,
                @"alias":_station_name,
                @"code":_station_code,
                @"airport":_airport,
                @"picture":_imageUrl,
                @"address":_address,
                @"isShow":@"1"
            };
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:thisStation2 forKey:@"station"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self setupTable];
        }
        
    }
}
-(void)closeFrame{
    
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
}






//判断字典是否为空
-(BOOL)isBlankDictionary:(NSDictionary *)dic {
    
    if (!dic) {
        
        return YES;
        
    }
    
    if ([dic isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        
        return YES;
        
    }
    
    if (!dic.count) {
        
        return YES;
        
    }
    
    if (dic == nil) {
        
        return YES;
        
    }
    
    if (dic == NULL) {
        
        return YES;
        
    }
    
    return NO;
    
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
/** 标题栏 **/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}
@end

