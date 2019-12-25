//
//  FrameHomeController.m
//  Frame
//
//  Created by hibayWill on 2018/3/29.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FrameHomeController.h"
#import "LoginViewController.h"
#import "PatrolEquipmentController.h"
#import "FrameBaseRequest.h"
#import "StationItems.h"
#import "HomeCarouselView.h"
#import "YQSlideMenuController.h"
#import "UIViewController+YQSlideMenu.h"
#import "PersonalMsgListController.h"
#import "PersonalMsgController.h"
#import "RankController.h"
#import "UIColor+Extension.h"
#import "WheelModel.h"
#import "WarnTableViewCell.h"
#import "PatrolRemindCell.h"
#import "CCZAngelWalker.h"
#import "CCZTrotingLabel.h"
#import <MJExtension.h>
#import "UIView+LX_Frame.h"
@interface FrameHomeController ()<UINavigationControllerDelegate,BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,CCZTrotingLabelDelegate,UIGestureRecognizerDelegate>{
    BMKMapView* _mapView;
    UIWindow * healthWindow;
    UIButton *leftButton;
}
@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;
@property (strong, nonatomic) NSMutableArray<StationItems *> * PatrolRemindItem;
@property(strong,nonatomic)UITableView *stationTabView;
@property(strong,nonatomic)UITableView *PatrolRemindTabView;
@property(weak,nonatomic) UIView *PatrolRemindView;
@property(weak,nonatomic) UIView *AlarmView;


@property (nonatomic,copy) NSDictionary * stationList;
//@property (strong, nonatomic) NSMutableArray<MsgItems *> * msgList;
@property (nonatomic,copy) NSMutableDictionary* stationDIC;
@property (nonatomic,copy) NSMutableArray<BMKPointAnnotation *> *clusters;
@property (nonatomic,copy) NSMutableArray<BMKPointAnnotation *> *clusters2;
@property NSString * FrameCellID;
@property NSString * PatrolCellID;
@property  int annoNum;
@property (nonatomic, weak)UIView *carouselView;
@property (nonatomic, strong) CCZTrotingLabel *rotingLabel;
@property (nonatomic, strong) UIWebView *webView;
@property  BOOL alreadyShow;
@property (nonatomic, strong) NSMutableArray *annotationViewArray;
@property (nonatomic, assign) BOOL isTap;
//定时刷新的定时器
@property (nonatomic, strong) NSTimer* repeatTimer;
@end

@implementation FrameHomeController
+ (void)initialize {
    //设置自定义地图样式，会影响所有地图实例
    //注：必须在BMKMapView对象初始化之前调用
    NSString* path = [[NSBundle mainBundle] pathForResource:@"custom_config" ofType:@""];
    
    [BMKMapView customMapStyle:path];
   
    
   
    //[BMKMapView enableCustomMapStyle:YES];//打开个性化地图
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults objectForKey:@"userAccount"]||[[userDefaults objectForKey:@"userAccount"] isEqualToString:@""]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"alpha0"] forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.title = @" ";
        
        if([CommonExtension isFirstLauch] == 1){//==2
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstLoginNotify) name:@"firstLoginNotify" object:nil];
        }else{
            [self firstLoginNotify];
        }
        return;
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation2"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"智慧台站";
    [self.rotingLabel walk];

    if(_clusters){
        
    }else{
        [self addMapView];
        
    }
    [self getStationData];
    
    //预警提醒
    if(!self.AlarmView){//||[[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstView"]
        [self isAlarmShow];
    }
    [self wheelData];
    if(!self.PatrolRemindView){//||[[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstView"]
        [self isPatrolRemindShow];
    }
    [self getNewsNum];
    [self dataReport];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
     if (!self.repeatTimer) {
          self.repeatTimer = [NSTimer timerWithTimeInterval:10.f target:self selector:@selector(refreshMap) userInfo:nil repeats:YES];
                   [[NSRunLoop currentRunLoop] addTimer:self.repeatTimer forMode:NSRunLoopCommonModes];
                   [[NSRunLoop currentRunLoop] run];
         
     }
    });
}
//刷新地图页面 间隔10s
- (void)refreshMap {
    NSLog(@"refresh------");
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/stationList"];
        [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
            self.carouselView.frame = CGRectMake(20, -1, WIDTH_SCREEN-40, 40);
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                return ;
            }
            _stationList = [result[@"value"] copy];
            //
            [_mapView removeAnnotations:_clusters2];
            [_mapView removeAnnotations:_clusters];
            [self addClusters];
            
        } failure:^(NSURLSessionDataTask *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
            if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
                [FrameBaseRequest logout];
                [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
                
                LoginViewController *login = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:login animated:YES];
                
                return;
            }else if(responses.statusCode == 502){
                
            }
    //        [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
            
        }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.repeatTimer invalidate];
    self.repeatTimer = nil;
      
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.carouselView.frame = CGRectMake(20, -1, WIDTH_SCREEN-40, 40);
    self.webView.frame = CGRectMake(0, 0, 40, self.carouselView.lx_height);
    self.rotingLabel.frame = CGRectMake(CGRectGetMaxX(self.webView.frame), 0, self.carouselView.lx_width - self.webView.lx_width, self.carouselView.lx_height);
}


- (void)viewDidLoad {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(20),NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    self.alreadyShow = false;
    _FrameCellID = @"WarnTableViewCell";
    self.PatrolCellID = @"PatrolRemindCell";
    [super viewDidLoad];
    self.annotationViewArray = [NSMutableArray array];
    
    //导航栏左侧按钮
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0, 35, 35);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"personal_icon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self notificationMonitoring];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults objectForKey:@"userAccount"]||[[userDefaults objectForKey:@"userAccount"] isEqualToString:@""]){
        return;
    }
    //[self isPatrolRemindShow];

}



#pragma mark--上传用户使用情况的接口，这个接口在台站管理页面、首页每次进入调用一次
- (void)dataReport {
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/dataReport/%@",@"homePage"]];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            [FrameBaseRequest showMessage:[result objectForKey:@"errMsg"]];
            return ;
        }
        NSLog(@"请求成功");
    } failure:^(NSError *error) {
//        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}






-(void)firstLoginNotify{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults objectForKey:@"userAccount"]||[[userDefaults objectForKey:@"userAccount"] isEqualToString:@""]){
        //跳转登陆页
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return ;
    }
}


/**
 点击滚动文字
 @param index 第几个
 */
- (void)CCZTrotingLabelClick:(NSString *)labelText index:(NSInteger)index {
    self.tabBarController.selectedIndex = 1;
}


/**
 弹出个人中心
 */
- (void)leftButtonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyingHeadNotification" object:self];
    [self.slideMenuController showMenu];
}


/**
 轮播数据
 */
- (void)wheelData {
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/getTop5Alarm"];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSMutableArray *modelArray = [NSMutableArray array];
        if (result[@"value"][@"top5Alarm"] && [result[@"value"][@"top5Alarm"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result[@"value"][@"top5Alarm"]) {
                WheelModel *model = [WheelModel mj_objectWithKeyValues:dict];
                [modelArray addObject:model];
            }
            [self.carouselView removeFromSuperview];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, -1, WIDTH_SCREEN-40, 40)];
            view.backgroundColor = [UIColor colorWithRed:112/255.0 green:153/255.0 blue:211/255.0 alpha:0.8];
                                   
            view.layer.cornerRadius = 8;
            view.layer.masksToBounds = YES;
            [self.view addSubview:view];
            self.carouselView = view;
            
            
            self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 40, view.lx_height)];
            self.webView.opaque = NO;
            self.webView.userInteractionEnabled = NO;//用户不可交互
            self.webView.backgroundColor = [UIColor whiteColor];
            
            
            NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle]pathForResource:@"green" ofType:@"gif"]];
            NSString *maxLevel = [NSString stringWithFormat:@"%@",result[@"value"][@"maxLevel"]]  ;
           
            if([maxLevel isEqualToString:@"1"]){
                url = [NSURL URLWithString:[[NSBundle mainBundle]pathForResource:@"red" ofType:@"gif"]];
            }else if([maxLevel isEqualToString:@"2"]){
                url = [NSURL URLWithString:[[NSBundle mainBundle]pathForResource:@"orangea" ofType:@"gif"]];
            }else if([maxLevel isEqualToString:@"3"]){
                url = [NSURL URLWithString:[[NSBundle mainBundle]pathForResource:@"yellow" ofType:@"gif"]];
            }else if([maxLevel isEqualToString:@"4"]){
                url = [NSURL URLWithString:[[NSBundle mainBundle]pathForResource:@"green" ofType:@"gif"]];
            }else{
                url = [NSURL URLWithString:[[NSBundle mainBundle]pathForResource:@"green0" ofType:@"gif"]];
            }
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
            
            /*
            NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"green" ofType:@"gif"]];
            NSString *maxLevel = [NSString stringWithFormat:@"%@",result[@"value"][@"maxLevel"]]  ;
            
            if([maxLevel isEqualToString:@"1"]){
                gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"red" ofType:@"gif"]];
            }else if([maxLevel isEqualToString:@"2"]){
                gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"orange" ofType:@"gif"]];
            }else if([maxLevel isEqualToString:@"3"]){
                gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"yellow" ofType:@"gif"]];
            }else if([maxLevel isEqualToString:@"4"]){
                gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"green" ofType:@"gif"]];
            }else{
                gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"green0" ofType:@"gif"]];
            }
            
            [self.webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
             */
            [self.webView setScalesPageToFit:YES];
            [view addSubview:self.webView];
            
            
            self.rotingLabel = [[CCZTrotingLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.webView.frame), 0, view.lx_width-self.webView.lx_width, view.lx_height)];
            self.rotingLabel.delegate = self;
            self.rotingLabel.backgroundColor = [UIColor clearColor];
            self.rotingLabel.pause = 0.5;
            self.rotingLabel.type = CCZWalkerTypeDescend;
            self.rotingLabel.rate = RateNormal;
            [view addSubview:self.rotingLabel];
            [self.rotingLabel trotingWithAttribute:^(CCZTrotingAttribute * _Nonnull attribute) {
                NSLog(@"%@",attribute);
            }];
            if (modelArray.count > 0) {
                NSMutableArray *arr = [NSMutableArray array];
                for (int i = 0; i < modelArray.count; i++) {
                    WheelModel *model = modelArray[i];
                    [arr addObject:model.context];
                }
                NSArray *array = [arr copy];
                 [self.rotingLabel addTexts:array];
            } else {
                [self.rotingLabel addTexts:[@[@"设备运行正常"] mutableCopy]];
            }
        }
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            return;
        }else if(responses.statusCode == 502){
            
        }
        //[FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

// 解决手势冲突方案


-(void)getStationData{
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/stationList"];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        self.carouselView.frame = CGRectMake(20, -1, WIDTH_SCREEN-40, 40);
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        _stationList = [result[@"value"] copy];
        
        [_mapView removeAnnotations:_clusters2];
        [_mapView removeAnnotations:_clusters];
        [self addClusters];
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest logout];
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
            
            return;
        }else if(responses.statusCode == 502){
            
        }
//        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
}



-(void) addMapView{
    BMKCoordinateRegion region;
    region.center.latitude  = 36.273127;
    
    region.center.longitude = 120.392419;
    
    region.span.latitudeDelta = 7.5;
    
    region.span.longitudeDelta =7.5;
    
   
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
     _mapView.delegate = self;
    
    _mapView.rotateEnabled= NO;

    

    [_mapView setRegion:region animated:YES];
   
    //设定地图View能否支持用户缩放(双击或双指单击)
//    _mapView.zoomEnabledWithTap= NO;
    _mapView.overlookEnabled= NO;
    self.view = _mapView;
    UIPinchGestureRecognizer* pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    
    pinchGR.delegate = self; //
    pinchGR.cancelsTouchesInView = NO;
    pinchGR.delaysTouchesEnded = NO;
    
    [_mapView addGestureRecognizer:pinchGR];
    _mapView.userInteractionEnabled = YES;
    
}


//地图滑动时禁用点击事件
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated reason:(BMKRegionChangeReason)reason {
    for (int i = 0; i < self.annotationViewArray.count; i++) {
        BMKAnnotationView *annotationView = self.annotationViewArray[i];
        annotationView.enabled = NO;
    }
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    for (int i = 0; i < self.annotationViewArray.count; i++) {
        BMKAnnotationView *annotationView = self.annotationViewArray[i];
        annotationView.enabled = YES;
    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([touch.view isKindOfClass:[BMKAnnotationView class]])    {
//        return NO;
//    }
//    return YES;
//}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    for (int i = 0; i < self.annotationViewArray.count; i++) {
        BMKAnnotationView *annotationView = self.annotationViewArray[i];
        annotationView.enabled = YES;
    }
}


//f缩放回调
- (void)pinchAction:(UIPinchGestureRecognizer*)recognizer{
  
    CGFloat velocity = recognizer.velocity;
    CGFloat scale = recognizer.scale;
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        if(scale>1.0){
          _mapView.zoomIn;
        }else{
            _mapView.zoomOut;
        }
    }
    
    for (int i = 0; i < self.annotationViewArray.count; i++) {
        BMKAnnotationView *annotationView = self.annotationViewArray[i];
        annotationView.enabled = NO;
    }
    
        //NSLog(@"正在缩放z%ld",UIGestureRecognizerStateBegan);
       // NSLog(@"ssssss---%ld",[recognizer velocity]);
      //_mapView.zoomIn;
   // }
  
    //NSLog(@"用户捏合的速度为%g、比例为%g",velocity,scale);
    //recognizer.scale = 1;
}
//允许多手势并发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
    
}


-(void)addClusters{
    NSMutableArray * aclusters = [NSMutableArray array];
    NSMutableArray * aclusters2 = [NSMutableArray array];

    NSMutableArray * allStation = [NSMutableArray array];
    _stationDIC = [[NSMutableDictionary alloc] init];
    int nowKey = 0;
    //NSLog(@"array = %@", _stationList);
    for (NSDictionary * stationInfo in _stationList) {
        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake([stationInfo[@"station"][@"latitude"] floatValue], [stationInfo[@"station"][@"longitude"] floatValue]);
        NSString *isShow = @"0";
        
        
        annotation.subtitle = [NSString stringWithFormat:@"%@%@",stationInfo[@"station"][@"code"],stationInfo[@"station"][@"alias"]] ;
        [allStation addObject:stationInfo[@"station"][@"code"]];
        [aclusters addObject:annotation];
        
        BMKPointAnnotation* annotation2 = [[BMKPointAnnotation alloc]init];
        annotation2.coordinate = CLLocationCoordinate2DMake([stationInfo[@"station"][@"latitude"] floatValue], [stationInfo[@"station"][@"longitude"] floatValue] );
        annotation2.title = [NSString stringWithFormat:@"%@%@",stationInfo[@"station"][@"code"],stationInfo[@"station"][@"alias"]] ;
        //是否显示全部雷达站
        if(nowKey <= [_stationList count]){
            isShow = @"1";
            [aclusters2 addObject:annotation2];
        }
        //[_clusters addObject:annotation2];
        NSDictionary  *thisStation = @{
                                       @"name":stationInfo[@"station"][@"alias"],
                                       @"alias":stationInfo[@"station"][@"alias"],
                                       @"environmentStatus":stationInfo[@"environmentStatus"],
                                       @"equipmentStatus":stationInfo[@"equipmentStatus"],
                                       @"powerStatus":stationInfo[@"powerStatus"],
                                       @"alarmStatus":stationInfo[@"station"][@"alarmStatus"],
                                       @"code":stationInfo[@"station"][@"code"],
                                       @"airport":stationInfo[@"station"][@"airport"],
                                       @"latitude":stationInfo[@"station"][@"latitude"],
                                       @"longitude":stationInfo[@"station"][@"longitude"],
                                       @"picture":stationInfo[@"station"][@"picture"],
                                       @"address":stationInfo[@"station"][@"address"],
                                       @"nowKey":[NSString stringWithFormat:@"%d",nowKey],
                                       @"isShow":isShow
                                       };
        
        _stationDIC[annotation2.title] = thisStation;
        
        //[_mapView addAnnotation:annotation2];
        nowKey ++;
        
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:allStation forKey:@"allStation"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    _clusters2 = [aclusters2 mutableCopy];
    aclusters2 =nil;
    _clusters = [aclusters mutableCopy];
    aclusters =nil;
    [_mapView addAnnotations:_clusters];
    [_mapView addAnnotations:_clusters2];
    [self removeClusters];
}
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        NSString *reuseIndetifier = [NSString stringWithFormat:@"annotationReuseIndetifier"];
        
        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil){
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:reuseIndetifier];
        }
        annotationView.canShowCallout = NO;
        
        @try {
            // 可能会出现崩溃的代码
            if(annotation.subtitle  != nil){
                annotationView.tag = [_stationDIC[annotation.subtitle][@"nowKey"] intValue];
                if([_stationDIC[annotation.subtitle][@"alarmStatus"] isEqualToString:@"1"] ){
                    annotationView.image = [UIImage imageNamed:@"home_warn_biao"];
                }else{
                    annotationView.image = [UIImage imageNamed:@"home_normal_biao"];
                }
                
                
            }else{
                NSString *reuseIndetifier2 = [NSString stringWithFormat:@"annotationReuseIndetifier2"];
                annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                               reuseIdentifier:reuseIndetifier2];
                
                annotationView.tag = [_stationDIC[annotation.title][@"nowKey"] intValue]+100;
                
                //需要判断不同的机型决定字体大小以及背景图
                if(isIphoneX){//iphonex
                    annotationView.image = [UIImage imageNamed:@"alpha3"];//537*165
                }else if(isIphone){//iphonex iphone6 iphone8 iphone7
                    annotationView.image = [UIImage imageNamed:@"alpha2"];//350*105
                }else if(isPlus){//iphone6 plus iphone7plus
                    annotationView.image = [UIImage imageNamed:@"alpha0"];//596*183
                }else if(is5S){//iphone5s
                    annotationView.image = [UIImage imageNamed:@"alpha1"];//300*100
                }else{
                    annotationView.image = [UIImage imageNamed:@"alpha0"];//300*100
                }
                
                annotationView.centerOffset =  CGPointMake(0, -FrameWidth(80));
                
                //UIImageView * bgImg = [[UIImageView alloc]initWithFrame:CGRectMake((317-FrameWidth(315))/2, (123-FrameWidth(103))/2, FrameWidth(315),  FrameWidth(103))];
                UIImageView * bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, FrameWidth(315),  FrameWidth(103))];
                
                
                bgImg.image = [UIImage imageNamed:@"home_detail_biao"];
                [annotationView addSubview:bgImg];
                
                UILabel * powerLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(18), FrameWidth(5), FrameWidth(75),  FrameWidth(27))];
                powerLabel.text = @"动力:";
                powerLabel.font = FontSize(12);
                [bgImg addSubview:powerLabel];
                
                
                
                UILabel * envLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(18), FrameWidth(33), FrameWidth(75),  FrameWidth(27))];
                envLabel.text = @"环境:";
                envLabel.font = FontSize(12);
                [bgImg addSubview:envLabel];
                
                UILabel * eqpLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(18), FrameWidth(58), FrameWidth(75),  FrameWidth(27))];
                eqpLabel.text = @"设备:";
                eqpLabel.font = FontSize(12);
                [bgImg addSubview:eqpLabel];
                
                
                UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(220), 0, FrameWidth(80),  FrameWidth(90))];
                titleLabel.text = _stationDIC[annotation.title][@"alias"];
                titleLabel.numberOfLines = 3;
                titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                titleLabel.textAlignment = NSTextAlignmentCenter;
                //titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
                titleLabel.font = FontSize(12);
                titleLabel.textColor = [UIColor whiteColor];
                [bgImg addSubview:titleLabel];
                //powerstatus
                if([_stationDIC[annotation.title][@"powerStatus"][@"status"] isEqualToString:@"0"] ||[_stationDIC[annotation.title][@"powerStatus"] count] ==0){
                    UIButton *powerOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(8), FrameWidth(45), FrameWidth(22))];
                    [powerOk setBackgroundColor:FrameColor(120, 203, 161)];
                    powerOk.layer.cornerRadius = 2;
                    powerOk.titleLabel.font = FontBSize(10);
                    [powerOk setTitle: @"正常"   forState:UIControlStateNormal];
                    powerOk.titleLabel.textColor = [UIColor whiteColor];
                    [bgImg addSubview:powerOk];
                    
                }else if([_stationDIC[annotation.title][@"powerStatus"][@"status"] isEqualToString:@"3"] ){
                    UIButton *powerOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(8), FrameWidth(45), FrameWidth(22))];
                    [powerOk setBackgroundColor:FrameColor(252,201,84)];
                    powerOk.layer.cornerRadius = 2;
                    powerOk.titleLabel.font = FontBSize(10);
                    [powerOk setTitle: @"正常"   forState:UIControlStateNormal];
                    powerOk.titleLabel.textColor = [UIColor whiteColor];
                    [bgImg addSubview:powerOk];
                    
                }else{
                    
                    UIButton *warnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(8), FrameWidth(90), FrameWidth(22))];
                    [warnBtn setBackgroundColor:warnColor];//warnColor
                    warnBtn.layer.cornerRadius = 2;
                    warnBtn.titleLabel.font = FontBSize(10);
                    
                    
                    int isNull = isNull( _stationDIC[annotation.title][@"powerStatus"][@"num"]);
                    NSString *equipNum = isNull == 1?_stationDIC[annotation.title][@"powerStatus"][@"num"]:@"0";
                    
                    [warnBtn setTitle:[NSString stringWithFormat:@"告警数量%@",equipNum]  forState:UIControlStateNormal];
                    
                    //[warnBtn setTitle: [NSString stringWithFormat:@"告警数量%@",_stationDIC[annotation.title][@"powerStatus"][@"num"]]   forState:UIControlStateNormal];
                    warnBtn.titleLabel.textColor = [UIColor whiteColor];
                    [bgImg addSubview:warnBtn];
                    
                    UIButton *LevelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(165), FrameWidth(8), FrameWidth(45), FrameWidth(22))];
                    
                    LevelBtn.layer.cornerRadius = 2;
                    [CommonExtension addLevelBtn:LevelBtn level:_stationDIC[annotation.title][@"powerStatus"][@"level"]];
                    LevelBtn.titleLabel.font = FontBSize(10);
                    [bgImg addSubview:LevelBtn];
                }
                
                //environmentStatus
                if([_stationDIC[annotation.title][@"environmentStatus"][@"status"] isEqualToString:@"0"]||[_stationDIC[annotation.title][@"environmentStatus"] count] ==0 ){
                 
                    UIButton *envOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(34), FrameWidth(45), FrameWidth(22))];
                    [envOk setBackgroundColor:FrameColor(120, 203, 161)];
                    envOk.layer.cornerRadius = 2;
                    envOk.titleLabel.font = FontBSize(10);
                    [envOk setTitle: @"正常"   forState:UIControlStateNormal];
                    envOk.titleLabel.textColor = [UIColor whiteColor];
                    [bgImg addSubview:envOk];
                    
                }else if([_stationDIC[annotation.title][@"environmentStatus"][@"status"] isEqualToString:@"3"] ){
                    
                    UIButton *envOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(34), FrameWidth(45), FrameWidth(22))];
                    [envOk setBackgroundColor:FrameColor(252,201,84)];
                    envOk.layer.cornerRadius = 2;
                    envOk.titleLabel.font = FontBSize(10);
                    [envOk setTitle: @"正常"   forState:UIControlStateNormal];
                    envOk.titleLabel.textColor = [UIColor whiteColor];
                    [bgImg addSubview:envOk];
                    
                }else{
                    UIButton *envWarnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(34), FrameWidth(90), FrameWidth(22))];
                    [envWarnBtn setBackgroundColor:warnColor];
                    envWarnBtn.layer.cornerRadius = 2;
                    envWarnBtn.titleLabel.font = FontBSize(10);
                    
                    int isNull = isNull( _stationDIC[annotation.title][@"environmentStatus"][@"num"]);
                    NSString *equipNum = isNull == 1?_stationDIC[annotation.title][@"environmentStatus"][@"num"]:@"0";
                    [envWarnBtn setTitle:[NSString stringWithFormat:@"告警数量%@",equipNum]  forState:UIControlStateNormal];
                    
                    //[envWarnBtn setTitle:[NSString stringWithFormat:@"告警数量%@",_stationDIC[annotation.title][@"environmentStatus"][@"num"]]  forState:UIControlStateNormal];
                    envWarnBtn.titleLabel.textColor = [UIColor whiteColor];
                    [bgImg addSubview:envWarnBtn];
                    
                    UIButton *envLevelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(165), FrameWidth(34), FrameWidth(48), FrameWidth(22))];
                    
                    envLevelBtn.layer.cornerRadius = 2;
                    
                    [CommonExtension addLevelBtn:envLevelBtn level:_stationDIC[annotation.title][@"environmentStatus"][@"level"]];
                    
                    
                    envLevelBtn.titleLabel.font = FontBSize(10);
                    envLevelBtn.titleLabel.textColor = [UIColor whiteColor];
                    [bgImg addSubview:envLevelBtn];
                    
                    
                }
                
                //equipmentStatus
                if([_stationDIC[annotation.title][@"equipmentStatus"][@"status"] isEqualToString:@"0"]||[_stationDIC[annotation.title][@"equipmentStatus"] count] ==0){
                    UIButton *equipOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(60), FrameWidth(45), FrameWidth(22))];
                    [equipOk setBackgroundColor:FrameColor(120, 203, 161)];
                    equipOk.layer.cornerRadius = 2;
                    equipOk.titleLabel.font = FontBSize(10);
                    [equipOk setTitle: @"正常"   forState:UIControlStateNormal];
                    equipOk.titleLabel.textColor = [UIColor whiteColor];
                    [bgImg addSubview:equipOk];
                    
                }else if([_stationDIC[annotation.title][@"equipmentStatus"][@"status"] isEqualToString:@"3"]){
                    UIButton *equipOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(60), FrameWidth(45), FrameWidth(22))];
                    [equipOk setBackgroundColor:FrameColor(252,201,84)];
                    equipOk.layer.cornerRadius = 2;
                    equipOk.titleLabel.font = FontBSize(10);
                    [equipOk setTitle: @"正常"   forState:UIControlStateNormal];
                    equipOk.titleLabel.textColor = [UIColor whiteColor];
                    [bgImg addSubview:equipOk];
                    
                }else{
                    UIButton *equipWarnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(60), FrameWidth(90), FrameWidth(22))];
                    [equipWarnBtn setBackgroundColor:warnColor];
                    equipWarnBtn.layer.cornerRadius = 2;
                    equipWarnBtn.titleLabel.font = FontBSize(10);
                    int isNull = isNull( _stationDIC[annotation.title][@"equipmentStatus"][@"num"]);
                    NSString *equipNum = isNull == 1?_stationDIC[annotation.title][@"equipmentStatus"][@"num"]:@"0";
                    [equipWarnBtn setTitle:[NSString stringWithFormat:@"告警数量%@",equipNum]  forState:UIControlStateNormal];
                    equipWarnBtn.titleLabel.textColor = [UIColor whiteColor];
                    [bgImg addSubview:equipWarnBtn];
                    
                    UIButton *equipLevelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(165), FrameWidth(60), FrameWidth(48), FrameWidth(22))];
                    
                    equipLevelBtn.titleLabel.font = FontBSize(10);
                    equipLevelBtn.layer.cornerRadius = 2;
                    [CommonExtension addLevelBtn:equipLevelBtn level:_stationDIC[annotation.title][@"equipmentStatus"][@"level"]];
                    
                    [bgImg addSubview:equipLevelBtn];
                    
                    
                }
                
                
            }
        } @catch (NSException *exception) {
            // 捕获到的异常exception
            NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
            dispatch_async(dispatch_get_main_queue(), ^{
                return ;
            });
        } @finally {
            // 结果处理
        }
        
//        annotationView.enabled = NO;
        [self.annotationViewArray addObject:annotationView];
        return annotationView;
    }
    return nil;
}


/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 选中的annotation views
 */
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
 
    [mapView deselectAnnotation:view.annotation animated:true];
    
    if(view.tag < 100){
        if([_stationDIC[view.annotation.subtitle][@"isShow"] isEqualToString:@"0"]){
            
            //BMKAnnotationView * view1 = [mapView viewWithTag:view.tag+100];
            
            NSDictionary  *thisStation1 = _stationDIC[view.annotation.subtitle];
            
            BMKPointAnnotation* annotation2 = [[BMKPointAnnotation alloc]init];
            annotation2.coordinate = CLLocationCoordinate2DMake([thisStation1[@"latitude"] floatValue], [thisStation1[@"longitude"] floatValue] );
            annotation2.title = view.annotation.subtitle;
            [mapView addAnnotation:annotation2];
            
            [_clusters2 addObject:annotation2];
            
            NSDictionary  *thisStation2 = @{
                                            @"name":thisStation1[@"alias"],
                                            @"alias":thisStation1[@"alias"],
                                            @"environmentStatus":thisStation1[@"environmentStatus"],
                                            @"powerStatus":thisStation1[@"powerStatus"],
                                            @"alarmStatus":thisStation1[@"alarmStatus"],
                                            @"code":thisStation1[@"code"],
                                            @"airport":thisStation1[@"airport"],
                                            @"latitude":thisStation1[@"latitude"],
                                            @"longitude":thisStation1[@"longitude"],
                                            @"picture":thisStation1[@"picture"],
                                            @"nowKey":thisStation1[@"nowKey"],
                                            @"address":thisStation1[@"address"],
                                            @"isShow":@"1"
                                            };
            
            _stationDIC[view.annotation.subtitle] = thisStation2;
            
        }else{
            BMKAnnotationView * view1 = [mapView viewWithTag:view.tag+100];
            
            
            NSDictionary  *thisStation1 = _stationDIC[view.annotation.subtitle];
            
            
            [mapView removeAnnotation:view1.annotation];
            
            
            //[_stationDIC removeObjectForKey:view.annotation.subtitle];
            NSDictionary  *thisStation2 = @{
                                            @"name":thisStation1[@"alias"],
                                            @"alias":thisStation1[@"alias"],
                                            @"environmentStatus":thisStation1[@"environmentStatus"],
                                            @"powerStatus":thisStation1[@"powerStatus"],
                                            @"alarmStatus":thisStation1[@"alarmStatus"],
                                            @"code":thisStation1[@"code"],
                                            @"airport":thisStation1[@"airport"],
                                            @"latitude":thisStation1[@"latitude"],
                                            @"longitude":thisStation1[@"longitude"],
                                            @"picture":thisStation1[@"picture"],
                                            @"nowKey":thisStation1[@"nowKey"],
                                            @"address":thisStation1[@"address"],
                                            @"isShow":@"0"
                                            };
            _stationDIC[view.annotation.subtitle] = thisStation2;
        }
    }else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:_stationDIC[view.annotation.title] forKey:@"station"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController.tabBarController setSelectedIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"choiceStationNotification" object:self];

    }
    
    //[mapView selectAnnotation:view.annotation animated:true];
}
/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 取消选中的annotation views
 */
-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
   // NSLog(@"取消了选中%@",view.annotation.subtitle);//
    
    return ;
}



- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    NSLog(@"地图加载完成%d",_annoNum);
    [BMKMapView enableCustomMapStyle:YES];
    //地图加载完成后才可以删除
    [self removeClusters];
    [self addStationHealthBtn];

}

-(void)removeClusters{
    for (NSString * station in _stationDIC) {
        if([_stationDIC[station][@"isShow"] isEqualToString:@"0"]){
            BMKAnnotationView * view1 = [_mapView viewWithTag:[_stationDIC[station][@"nowKey"] integerValue]+100];
            [_mapView removeAnnotation:view1.annotation];
            
        }
    }
}

/**
 *点中底图空白处会回调此接口
 *@param mapView 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
   NSLog(@"点击地图空白处");
    return ;
}

/**
 *当mapView新添加annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 新添加的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    //NSLog(@"新添加annotation");
    //BMKAnnotationView * view1 = [mapView viewWithTag:[_stationDIC[views][@"nowKey"] integerValue]+100];
    //[mapView removeAnnotation:view1.annotation];
}



//台站健康度

-(void)addStationHealthBtn{
    //healthWindow = [[UIWindow alloc]initWithFrame:CGRectMake(FrameWidth(520), FrameWidth(560), FrameWidth(120), FrameWidth(120))];
    UIButton * healthBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(520), FrameWidth(560),FrameWidth(120), FrameWidth(120))];
    [healthBtn setBackgroundImage:[UIImage imageNamed:@"home_health_biao"] forState:UIControlStateNormal];
    [healthBtn addTarget:self action:@selector(healthBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:healthBtn];
    //[self.view addSubview:healthWindow];
    
    
    
}
-(void)healthBtnClick{
    NSLog(@"healthBtnClick");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    RankController *Rank = [[RankController alloc] init];
    [self.navigationController pushViewController:Rank animated:YES];
}

//预警提醒
-(void)isAlarmShow{
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/getWarning"];//getWarning
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if (result[@"value"] && [result[@"value"] isKindOfClass:[NSArray class]] && [result[@"value"] count] > 0) {
            
            
            self.StationItem = [[StationItems class] mj_objectArrayWithKeyValuesArray:result[@"value"] ];
            //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //if( ![[userDefaults objectForKey:@"warningId"] isEqualToString:self.StationItem[0].warningId]){
                
                self.AlarmView = [[UIView alloc]init];
                
                self.AlarmView.frame = CGRectMake(WIDTH_SCREEN + FrameWidth(80),FrameWidth(150),  FrameWidth(500), FrameWidth(630));
                self.AlarmView.layer.cornerRadius = 9.0;
                UIImageView * explanAll = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warn_bg"]];
                explanAll.frame =  CGRectMake(0,FrameWidth(30),  FrameWidth(480), FrameWidth(585));
                //CGRectMake(0, 0 ,  FrameWidth(480), FrameWidth(585));
                [self.AlarmView addSubview:explanAll];
                //关闭
                UIButton * closeBtn = [[UIButton alloc]initWithFrame:CGRectMake( FrameWidth(440), 0,FrameWidth(60), FrameWidth(60))];
                //[[UIButton alloc]initWithFrame:CGRectMake( FrameWidth(440), -FrameWidth(20),FrameWidth(60), FrameWidth(60))];
                //[closeBtn setBackgroundImage:[UIImage imageNamed:@"warn_close"] forState:UIControlStateNormal];
                [closeBtn setImage:[UIImage imageNamed:@"warn_close"] forState:UIControlStateNormal];
                [closeBtn addTarget:self action:@selector(closeAlarmView) forControlEvents:UIControlEventTouchUpInside];
                [self.AlarmView addSubview:closeBtn];
                //标题
                UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,explanAll.frameWidth, FrameWidth(80))];
                titleLabel.textColor = [UIColor whiteColor];
                titleLabel.font = FontBSize(20);
                titleLabel.text = @"预警提醒";
                titleLabel.textAlignment = NSTextAlignmentCenter;
                [explanAll addSubview:titleLabel];
                
                //提醒列表
                _stationTabView = [[UITableView alloc] initWithFrame:CGRectMake(FrameWidth(20),FrameWidth(150) , explanAll.frameWidth -FrameWidth(60), FrameWidth(340))];
                _stationTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                
                _stationTabView.dataSource = self;
                _stationTabView.delegate = self;
                _stationTabView.separatorStyle =NO;
//                _stationTabView.estimatedRowHeight = 0;
//                _stationTabView.estimatedSectionHeaderHeight = 0;
//                _stationTabView.estimatedSectionFooterHeight = 0;
                float isAllWeather = YES;
                for (int i = 0; i< self.StationItem.count; i++) {
                    StationItems *item = self.StationItem[i];
                    self.StationItem[i].num = i + 1;
                    //计算高度
                    NSStringDrawingOptions option = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
                    
//                    CGSize lblSize = [item.content boundingRectWithSize:CGSizeMake(_stationTabView.frameWidth -FrameWidth(60) , MAXFLOAT) options:option attributes:@{NSFontAttributeName:FontSize(15)} context:nil].size;
//                    self.StationItem[i].LabelHeight = ceilf(lblSize.height);
                    if(![self.StationItem[i].type isEqualToString:@"weather"]){
                        isAllWeather = NO;
                    }
                    
                    
                }
                
                
                // 注册重用Cell
                [_stationTabView registerNib:[UINib nibWithNibName:NSStringFromClass([WarnTableViewCell class]) bundle:nil] forCellReuseIdentifier:_FrameCellID];//cell的class
                //_stationTabView.separatorStyle = NO;
                [self.AlarmView addSubview:_stationTabView];
                
                [_stationTabView reloadData];
                
                //查看和确认
                
               // UIButton * showDetailBtn = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(80), FrameWidth(510), FrameWidth(150), FrameWidth(45))];
                UIButton * showDetailBtn = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(160), FrameWidth(520), FrameWidth(150), FrameWidth(45))];
                [showDetailBtn setTitle:@"查看" forState:UIControlStateNormal];
                
            if(isAllWeather){
                [showDetailBtn addTarget:self action:@selector(seeDetail) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [showDetailBtn addTarget:self action:@selector(seeAlarmMsg) forControlEvents:UIControlEventTouchUpInside];
            }
            
                [showDetailBtn.layer setCornerRadius:FrameWidth(10)]; //设置矩形四个圆角半径
                [showDetailBtn.layer setBorderWidth:1.5]; //边框宽度
                [showDetailBtn setTitleColor:FrameColor(100, 170, 250) forState:UIControlStateNormal];//title color
                showDetailBtn.titleLabel.font = FontSize(15);
                [showDetailBtn.layer setBorderColor:[UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1].CGColor];//边框颜色
                [self.AlarmView addSubview:showDetailBtn];
            
                [self.view addSubview:self.AlarmView ];
                
                
                //动画出现
                [UIView animateWithDuration:0.3
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseIn animations:^{
                                        
                                        self.AlarmView.frame = CGRectMake(FrameWidth(80),FrameWidth(180),  FrameWidth(480), FrameWidth(600));
                                        
                                        
                                    } completion:^(BOOL finished) {
                                        
                                        
                                    }];
                
            }
        //记录下曾经弹过窗
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //}
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            return;
        }else if(responses.statusCode == 502){
            
        }
//        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
//巡查到期提醒

-(void)isPatrolRemindShow{
    
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/getPatrolRemind"];//getWarning
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if (result[@"value"] && [result[@"value"] isKindOfClass:[NSArray class]] && [result[@"value"] count] > 0) {
            self.alreadyShow = true;
            self.PatrolRemindItem = [[StationItems class] mj_objectArrayWithKeyValuesArray:result[@"value"] ];

            self.PatrolRemindView = [[UIView alloc]init];
            self.PatrolRemindView.frame = CGRectMake(WIDTH_SCREEN + FrameWidth(80),FrameWidth(150),  FrameWidth(530), FrameWidth(630));
            
            UIImageView * explanAll = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warn_bg"]];
            explanAll.frame = CGRectMake(0,FrameWidth(30),  FrameWidth(480), FrameWidth(585));
            [self.PatrolRemindView addSubview:explanAll];
            //关闭
            //[closeBtn setBackgroundImage:[UIImage imageNamed:@"warn_close"] forState:UIControlStateNormal];
            UIButton * closeBtn = [[UIButton alloc]initWithFrame:CGRectMake( FrameWidth(440), 0,FrameWidth(60), FrameWidth(60))];
            
            [closeBtn setImage:[UIImage imageNamed:@"warn_close"] forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(closePatrolRemind) forControlEvents:UIControlEventTouchUpInside];
            [self.PatrolRemindView  addSubview:closeBtn];
            //标题
            UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,explanAll.frameWidth, FrameWidth(80))];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = FontBSize(20);
            titleLabel.text = @"巡查提醒";
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [explanAll addSubview:titleLabel];
            
            //提醒列表
            self.PatrolRemindTabView = [[UITableView alloc] initWithFrame:CGRectMake(FrameWidth(20),FrameWidth(150) , explanAll.frameWidth -FrameWidth(60), FrameWidth(340))];
            self.PatrolRemindTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            self.PatrolRemindTabView.dataSource = self;
            self.PatrolRemindTabView.delegate = self;
            self.PatrolRemindTabView.estimatedRowHeight = 0;
            self.PatrolRemindTabView.estimatedSectionHeaderHeight = 0;
            self.PatrolRemindTabView.estimatedSectionFooterHeight = 0;
            self.PatrolRemindTabView.separatorStyle =NO;
            
            for (int i = 0; i< self.PatrolRemindItem.count; i++) {
                
                self.PatrolRemindItem[i].num = i + 1;
                
                self.PatrolRemindItem[i].LabelHeight = FrameWidth(100);
                
            }
            
            
            // 注册重用Cell
            [self.PatrolRemindTabView registerNib:[UINib nibWithNibName:NSStringFromClass([PatrolRemindCell class]) bundle:nil] forCellReuseIdentifier:self.PatrolCellID];//cell的class
            [self.PatrolRemindView addSubview:self.PatrolRemindTabView];
            
            [self.PatrolRemindTabView reloadData];
            [self.view addSubview:self.PatrolRemindView];
            
            //查看
            
            UIButton * showDetailBtn = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(160), FrameWidth(520), FrameWidth(150), FrameWidth(45))];
            [showDetailBtn setTitle:@"查看" forState:UIControlStateNormal];
            
            
            [showDetailBtn addTarget:self action:@selector(seeMsg) forControlEvents:UIControlEventTouchUpInside];
            [showDetailBtn.layer setCornerRadius:FrameWidth(10)]; //设置矩形四个圆角半径
            [showDetailBtn.layer setBorderWidth:1.5]; //边框宽度
            [showDetailBtn setTitleColor:FrameColor(100, 170, 250) forState:UIControlStateNormal];//title color
            showDetailBtn.titleLabel.font = FontSize(15);
            [showDetailBtn.layer setBorderColor:[UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1].CGColor];//边框颜色
            [self.PatrolRemindView addSubview:showDetailBtn];
            
            
            
            //动画出现
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn animations:^{
                                    
                                    self.PatrolRemindView.frame = CGRectMake(FrameWidth(80),FrameWidth(180),  FrameWidth(530), FrameWidth(600));
                                    
                                    
                                } completion:^(BOOL finished) {
                                    
                                    
                                }];
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            
            return;
        }else if(responses.statusCode == 502){
            
        }
//        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

#pragma mark - UITableviewDatasource 数据源方法


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _stationTabView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithHexString:kCellHighlightColor];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _stationTabView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.PatrolRemindTabView == tableView){
        
        StationItems *item = self.PatrolRemindItem[indexPath.row];
        return item.LabelHeight;
    }else if(_stationTabView == tableView){
        
//        StationItems *item = self.StationItem[indexPath.row];
//
//        if(item.LabelHeight >0 ){
//            return item.LabelHeight+15;
//        }
        return UITableViewAutomaticDimension;
    }
    return FrameWidth(90);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.PatrolRemindTabView == tableView){
        return self.PatrolRemindItem.count;
    }else if(_stationTabView == tableView){
        return self.StationItem.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.PatrolRemindTabView == tableView){
        // 1.2 去缓存池中取Cell
        PatrolRemindCell *cell  = [tableView dequeueReusableCellWithIdentifier:self.PatrolCellID];
        cell.contentView.backgroundColor =[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        cell.backgroundColor = [UIColor clearColor];//;
        StationItems *item = self.PatrolRemindItem[indexPath.row];
        cell.StationItem = item;
        return cell;
    }else if(_stationTabView == tableView){
        // 1.2 去缓存池中取Cell
        WarnTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:_FrameCellID];
        cell.contentView.backgroundColor =[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        cell.backgroundColor = [UIColor clearColor];//;
        // cell = [tableView dequeueReusableCellWithIdentifier:ID];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        StationItems *item = self.StationItem[indexPath.row];
        cell.StationItem = item;
        return cell;
    }
    UITableViewCell *noCell = [[UITableViewCell alloc]init];
    return noCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    if(tableView == self.PatrolRemindTabView){
        [self gotoMyMsg];
    }
    
}


-(void)closeExplain{
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
}

-(void)closeAlarmView{
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:self.StationItem[0].warningId forKey:@"warningId"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    //动画出现
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            
                            self.AlarmView.frame = CGRectMake(WIDTH_SCREEN + FrameWidth(80),FrameWidth(180),  FrameWidth(530), FrameWidth(600));
                        } completion:^(BOOL finished) {
                            //self.AlarmView = nil;
                            //[self.AlarmView removeFromSuperview];
                        }];
}

-(void)closePatrolRemind{
    //动画出现
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            
                            self.PatrolRemindView.frame = CGRectMake(WIDTH_SCREEN + FrameWidth(80),FrameWidth(180),  FrameWidth(530), FrameWidth(600));
                        } completion:^(BOOL finished) {
                            
                            //self.PatrolRemindView = nil;
                            //[self.PatrolRemindView removeFromSuperview];
                        }];
}

-(void)showDetail{//预警提醒跳转特殊巡查
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    PatrolEquipmentController *PatrolEquipment = [[PatrolEquipmentController alloc] init];
    [self.navigationController pushViewController:PatrolEquipment animated:YES];
}
-(void)seeDetail{
    [self showDetail];
    [self closeAlarmView];
}
-(void)seeAlarmMsg{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    PersonalMsgController  * PersonalMsg = [[PersonalMsgController alloc] init];
    [self.navigationController pushViewController: PersonalMsg animated:YES];
    [self closeAlarmView];
}
-(void)seeMsg{
    [self closePatrolRemind];
    [self gotoMyMsg];
}
-(void)gotoMyMsg{//跳转公告消息弹窗不消失
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    PersonalMsgListController  * PersonalMsg = [[PersonalMsgListController alloc] init];
    PersonalMsg.thistitle = @"公告消息";
    PersonalMsg.from = @"home";
    [self.navigationController pushViewController: PersonalMsg animated:YES];
}

- (void)notificationMonitoring {
    //进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(monitiorNetworkChange:) name:kApplicationGoesToTheForegroundNotification object:nil];
}

- (void)monitiorNetworkChange:(NSNotification *)notification {
    [self.rotingLabel walk];
}


//获取消息数量

-(void)getNewsNum{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/api/getNotReadNum/all"];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if(code == 0){
            
            [[NSUserDefaults standardUserDefaults] setInteger:[result[@"value"][@"num"] integerValue] forKey:@"unReadNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if(unReadNum > 0){
                [leftButton setBackgroundImage:[UIImage imageNamed:@"personal_icon_unread"] forState:UIControlStateNormal];
            }else{
                [leftButton setBackgroundImage:[UIImage imageNamed:@"personal_icon"] forState:UIControlStateNormal];
            }
            
        }
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            
            return;
        }
        //[FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
@end
