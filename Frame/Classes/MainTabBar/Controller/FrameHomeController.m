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
#import "AlarmDetailInfoController.h"
#import "BMKClusterManager.h"
#import "JPUSHService.h"
#import "KG_FrameBottomAlertView.h"
#import "FrameScrollList.h"

#import "StationVideoListController.h"

/*
 *点聚合Annotation
 */
@interface ClusterAnnotation : BMKPointAnnotation

///所包含annotation个数
@property (nonatomic, assign) NSInteger size;

@property (nonatomic ,strong) NSArray *dataArr;
@end

@implementation ClusterAnnotation
@synthesize size = _size;
@synthesize dataArr = _dataArr;
@end


/*
 *点聚合AnnotationView
 */
@interface ClusterAnnotationView : BMKPinAnnotationView {
    
}

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *totalTitle;
@end

@implementation ClusterAnnotationView

@synthesize size = _size;
@synthesize label = _label;
@synthesize labelTitle = _labelTitle;
@synthesize dataDic = _dataDic;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 77.f, 77.f)];
        
        self.alpha = 1;
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
}

- (void)setSize:(NSInteger)size {
    _size = size;
    
}

@end

@interface FrameHomeController ()<UINavigationControllerDelegate,BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,CCZTrotingLabelDelegate,UIGestureRecognizerDelegate>{
    BMKMapView* _mapView;
    UIWindow * healthWindow;
    UIButton *leftButton;
    BMKClusterManager *_clusterManager;//点聚合管理类
    NSInteger _clusterZoom;//聚合级别
    NSMutableArray *_clusterCaches;//点聚合缓存标注
}
@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;
@property (strong, nonatomic) NSMutableArray<StationItems *> * PatrolRemindItem;
@property (strong, nonatomic) NSMutableArray * StationAlertArray;
@property(strong,nonatomic)UITableView *stationTabView;
@property(strong,nonatomic)UITableView *PatrolRemindTabView;
@property(weak,nonatomic) UIView *PatrolRemindView;
@property(weak,nonatomic) UIView *AlarmView;


@property(strong,nonatomic)UITableView *stationAlertView;

@property(weak,nonatomic) UIView *AlertView;


@property (nonatomic,copy) NSArray * stationList;
//@property (strong, nonatomic) NSMutableArray<MsgItems *> * msgList;
@property (nonatomic,copy) NSMutableDictionary* stationDIC;
@property (nonatomic,copy) NSMutableArray<ClusterAnnotation *> *clusters;
@property (nonatomic,copy) NSMutableArray<ClusterAnnotation *> *clusters2;
@property NSString * FrameCellID;
@property NSString * PatrolCellID;
@property  int annoNum;
@property (nonatomic, weak)UIView *carouselView;
@property (nonatomic, strong) CCZTrotingLabel *rotingLabel;
@property (nonatomic, strong) UIWebView *webView;
@property  BOOL alreadyShow;
@property (nonatomic, strong) NSMutableArray *annotationViewArray;
@property (nonatomic, assign) BOOL isTap;
@property (nonatomic, assign) BOOL isFirstEnter;
//定时刷新的定时器
@property (nonatomic, strong) NSTimer* repeatTimer;


@property (nonatomic, strong) KG_FrameBottomAlertView *bottomAlertView;

@property (nonatomic, strong) FrameScrollList *scrollListView;

@property (nonatomic, strong) UIView *topBgView;


@property (nonatomic, strong) NSDictionary *currentStationDic;
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
   [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    
   
    
    self.navigationController.navigationBarHidden = YES;
    [_clusterCaches removeAllObjects];
    for (NSInteger i = 3; i <= 21; i++) {
        [_clusterCaches addObject:[NSMutableArray array]];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"station"]){
        self.currentStationDic = [userDefaults objectForKey:@"station"];
    }
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
    [UserManager shareUserManager].loginSuccess = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation2"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"智慧台站";
    [self.rotingLabel walk];
    
    if(_clusters){
        
    }else{
        [self addMapView];
        
    }
//    [self getStationData];
    [self quertFrameData];
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
            self.repeatTimer = [NSTimer timerWithTimeInterval:100.f target:self selector:@selector(refreshMap) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.repeatTimer forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop] run];
            
        }
    });
    if(_bottomAlertView ==  nil){
        [JSHmainWindow addSubview:self.bottomAlertView];
    }
  
   
}
//刷新地图页面 间隔10s
- (void)refreshMap {
    NSLog(@"refresh------");
    NSString *FrameRequestURL = @"http://10.33.33.147:8089/intelligent/api/stationList";
       
    [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
        //        self.carouselView.frame = CGRectMake(20, -1, WIDTH_SCREEN-40, 40);
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
    self.navigationController.navigationBarHidden = NO;
    [self.repeatTimer invalidate];
    self.repeatTimer = nil;
    [self closeAlertView];
    
    [self.topBgView removeFromSuperview];
    self.topBgView = nil;
    [self.scrollListView removeFromSuperview];
    self.scrollListView = nil;
    [self.bottomAlertView removeFromSuperview];
    self.bottomAlertView = nil;
}

- (void)viewDidLoad {
    
   
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(20),NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    self.StationAlertArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertMessage:) name:@"alertMessage" object:nil];
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
    _clusterCaches = [[NSMutableArray alloc] init];
    
    
    //点聚合管理类
    _clusterManager = [[BMKClusterManager alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults objectForKey:@"userAccount"]||[[userDefaults objectForKey:@"userAccount"] isEqualToString:@""]){
        return;
    }
    
//    [JSHmainWindow addSubview:self.bottomAlertView];
}
- (void)quertFrameData{
    NSString *FrameRequestURL = @"http://10.33.33.147:8089/intelligent/api/stationList";
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        _stationList = [result[@"value"] copy];
        
        [_mapView removeAnnotations:_clusters2];
        [_mapView removeAnnotations:_clusters];
        [self addClusters];
        if (!_isFirstEnter) {
            [self performSelector:@selector(changemapView) withObject:nil afterDelay:.1f];
            _isFirstEnter = YES;
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"station"]){
            self.currentStationDic = [userDefaults objectForKey:@"station"];
        }else {
            self.currentStationDic = [_stationList firstObject];
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

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    //UISwipeGestureRecognizerDirectionLeft   UISwipeGestureRecognizerDirectionRight  UISwipeGestureRecognizerDirectionUp  UISwipeGestureRecognizerDirectionDown
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp ) {
        NSLog(@"上滑了");
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.carouselView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(97 + Height_StatusBar - 20-25);
            make.left.equalTo(self.view.mas_left).offset(20);
            //                make.right.equalTo(self.view.mas_right).offset(20);
            make.width.equalTo(@(SCREEN_WIDTH-40));
            make.height.equalTo(@50);
        }];
        
        self.bottomAlertView.hidden= YES;
        if(_scrollListView == nil){
           
            [self.view insertSubview:self.topBgView belowSubview:self.carouselView];
            [JSHmainWindow addSubview:self.scrollListView];

            //   //动画出现
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                 [self.scrollListView setFrame:CGRectMake(0, 62 + Height_StatusBar+50, SCREEN_WIDTH, SCREEN_HEIGHT -(62 + Height_StatusBar)-50-TABBAR_HEIGHT )];
                
            } completion:^(BOOL finished) {
                
                
            }];
           
            
        }else {
            
            [self.scrollListView setFrame:CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT-97, SCREEN_WIDTH, SCREEN_HEIGHT -(62 + Height_StatusBar))];
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                [self.scrollListView setFrame:CGRectMake(0, 62 + Height_StatusBar+50, SCREEN_WIDTH, SCREEN_HEIGHT -(62 + Height_StatusBar)-50-TABBAR_HEIGHT )];
                
            } completion:^(BOOL finished) {
                
                
                      }];
            [self.topBgView setHidden:NO];
            [self.scrollListView setHidden:NO];
            self.scrollListView.refreshData = @"YES";
            
        }
        
        
    }else if (recognizer.direction == UISwipeGestureRecognizerDirectionDown ) {
        NSLog(@"下滑了");
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
       
       
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
            
          
            [self.scrollListView setFrame:CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT-97, SCREEN_WIDTH, SCREEN_HEIGHT -(62 + Height_StatusBar))];
            self.bottomAlertView.hidden = NO;
                   [self.scrollListView setHidden:YES];
                   [self.topBgView setHidden:YES];
                   
        } completion:^(BOOL finished) {
            
            
        }];
        [self.carouselView mas_makeConstraints:^(MASConstraintMaker *make) {
                      make.top.equalTo(self.view.mas_top).offset(20 + Height_StatusBar);
                      make.left.equalTo(self.view.mas_left).offset(20);
                      //                make.right.equalTo(self.view.mas_right).offset(20);
                      make.width.equalTo(@(SCREEN_WIDTH-40));
                      make.height.equalTo(@50);
                  }];
    }
    
}
- (void)alertMessage:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSMutableArray *dataArray = [NSMutableArray array];
    if ([[userInfo allKeys] containsObject:@"aps"]) {
        NSDictionary *dic = userInfo[@"aps"];
        if ([[dic allKeys] containsObject:@"alert"]) {
            NSString *apnCount = dic[@"alert"];
            
            if (apnCount.length ) {
                
                NSArray * array = [apnCount componentsSeparatedByString:@"："];
                if (array.count) {
                    [dataArray addObject:[array firstObject]];
                    NSArray * array1 = [[array lastObject] componentsSeparatedByString:@";"];
                    
                    if (array1.count) {
                        
                        for (NSString *string in array1) {
                            if (string.length >2) {
                                [dataArray addObject:[string substringFromIndex:2]];
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    if (dataArray.count) {
        [self showAlertMessage:dataArray];
    }
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
//    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
//        NSInteger code = [[result objectForKey:@"errCode"] intValue];
//        if(code  <= -1){
//            [FrameBaseRequest showMessage:result[@"errMsg"]];
//            return ;
//        }
//        NSMutableArray *modelArray = [NSMutableArray array];
//        if (result[@"value"][@"top5Alarm"] && [result[@"value"][@"top5Alarm"] isKindOfClass:[NSArray class]]) {
//            for (NSDictionary *dict in result[@"value"][@"top5Alarm"]) {
//                WheelModel *model = [WheelModel mj_objectWithKeyValues:dict];
//                [modelArray addObject:model];
//            }
//            [self.carouselView removeFromSuperview];
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 0, WIDTH_SCREEN-40, 50)];
//
//            view.backgroundColor = [UIColor colorWithHexString:@"#678FDA"];
//            view.layer.cornerRadius = 23;
//            view.layer.masksToBounds = YES;
//            [self.view addSubview:view];
//            self.carouselView = view;
//
//            self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 40, view.lx_height)];
//            self.webView.opaque = NO;
//            self.webView.userInteractionEnabled = NO;//用户不可交互
//            self.webView.backgroundColor = [UIColor whiteColor];
//
//            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(3,3, 44, 44)];
//            [view addSubview:img];
//            img.image = [UIImage imageNamed:[self getNotiImage:[NSString stringWithFormat:@"%@",result[@"value"][@"maxLevel"]]]];
//            UIView *notiView= [[UIView alloc]initWithFrame:CGRectMake(35,0 , 18, 18)];
//
//            [view addSubview:notiView];
//
//            UIImageView *notiimage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 18, 18)];
//            [notiView addSubview:notiimage];
//            notiimage.image = [UIImage imageNamed:@"noti_image"];
//
//            UILabel *notiLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 4, 10, 10)];
//            [notiView addSubview:notiLabel];
//
//            notiLabel.textAlignment = NSTextAlignmentCenter;
//            notiLabel.font = [UIFont systemFontOfSize:14];
//            notiLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
//
//            NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle]pathForResource:@"green" ofType:@"gif"]];
//            NSString *maxLevel = [NSString stringWithFormat:@"%@",result[@"value"][@"maxLevel"]]  ;
//
//            if([maxLevel isEqualToString:@"0"]){
//                img.image = [UIImage imageNamed:@"alert_prompt"];
//            }else if([maxLevel isEqualToString:@"1"]){
//                img.image = [UIImage imageNamed:@"alert_secondary"];
//            }else if([maxLevel isEqualToString:@"2"]){
//                img.image = [UIImage imageNamed:@"alert_secondary"];
//            }else if([maxLevel isEqualToString:@"3"]){
//                img.image = [UIImage imageNamed:@"alert_important"];
//            }else if([maxLevel isEqualToString:@"4"]){
//                img.image = [UIImage imageNamed:@"alert_urgent"];
//            }else{
//                img.image = [UIImage imageNamed:@"alert_prompt"];
//            }
//
//
//            self.rotingLabel = [[CCZTrotingLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.webView.frame), 0, SCREEN_WIDTH - 85-20-20, view.lx_height)];
//            self.rotingLabel.delegate = self;
//            self.rotingLabel.backgroundColor = [UIColor clearColor];
//            self.rotingLabel.pause = 0.5;
//            self.rotingLabel.type = CCZWalkerTypeDescend;
//            self.rotingLabel.rate = RateNormal;
//            self.rotingLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
//            self.rotingLabel.font = [UIFont systemFontOfSize:14];
//            [view addSubview:self.rotingLabel];
//            [self.rotingLabel trotingWithAttribute:^(CCZTrotingAttribute * _Nonnull attribute) {
//                NSLog(@"%@",attribute);
//            }];
//            UIImageView *rightArrowimage = [[UIImageView alloc]initWithFrame:CGRectMake(self.rotingLabel.frame.origin.x + self.rotingLabel.frame.size.width +25, 21, 5, 8)];
//            rightArrowimage.image = [UIImage imageNamed:@"right_arrow"];
//            [view addSubview:rightArrowimage];
//            notiLabel.text = [NSString stringWithFormat:@"%d",(int)modelArray.count];
//            if (modelArray.count > 0) {
//                NSMutableArray *arr = [NSMutableArray array];
//                for (int i = 0; i < modelArray.count; i++) {
//                    WheelModel *model = modelArray[i];
//                    [arr addObject:model.context];
//                }
//                NSArray *array = [arr copy];
//                [self.rotingLabel addTexts:array];
//            } else {
//                [self.rotingLabel addTexts:[@[@"设备运行正常"] mutableCopy]];
//            }
//            [self.carouselView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.view.mas_top).offset(20 + Height_StatusBar);
//                make.left.equalTo(self.view.mas_left).offset(20);
//                //                make.right.equalTo(self.view.mas_right).offset(20);
//                make.width.equalTo(@(SCREEN_WIDTH-40));
//                make.height.equalTo(@50);
//            }];
//            [img mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.carouselView.mas_top);
//                make.left.equalTo(self.carouselView.mas_left);
//                make.width.equalTo(@50);
//                make.height.equalTo(@50);
//            }];
//            [self.rotingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.carouselView.mas_top);
//                make.left.equalTo(img.mas_right).offset(5);
//                make.right.equalTo(self.carouselView.mas_right).offset(-20);
//
//                make.height.equalTo(@50);
//            }];
//        }
//    } failure:^(NSURLSessionDataTask *error)  {
//        FrameLog(@"请求失败，返回数据 : %@",error);
//        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
//            return;
//        }else if(responses.statusCode == 502){
//
//        }
//        //[FrameBaseRequest showMessage:@"网络链接失败"];
//        return ;
//    }];
    
     FrameRequestURL = @"http://10.33.33.147:8089/intelligent/api/topAlarm";
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSMutableArray *modelArray = [NSMutableArray array];
        if (result[@"value"][@"topAlarm"] && [result[@"value"][@"topAlarm"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result[@"value"][@"topAlarm"]) {
                WheelModel *model = [WheelModel mj_objectWithKeyValues:dict];
                [modelArray addObject:model];
            }
            [self.carouselView removeFromSuperview];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 0, WIDTH_SCREEN-40, 50)];
            
            view.backgroundColor = [UIColor colorWithHexString:@"#678FDA"];
            view.layer.cornerRadius = 23;
            view.layer.masksToBounds = YES;
            [self.view addSubview:view];
            self.carouselView = view;
            
            self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 40, view.lx_height)];
            self.webView.opaque = NO;
            self.webView.userInteractionEnabled = NO;//用户不可交互
            self.webView.backgroundColor = [UIColor whiteColor];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(4,3, 44, 44)];
            [view addSubview:img];
            img.image = [UIImage imageNamed:[self getNotiImage:[NSString stringWithFormat:@"%@",result[@"value"][@"maxLevel"]]]];
            UIView *notiView= [[UIView alloc]initWithFrame:CGRectMake(35,0 , 18, 18)];
            
            [view addSubview:notiView];
            
            UIImageView *notiimage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 18, 18)];
            [notiView addSubview:notiimage];
            notiimage.image = [UIImage imageNamed:@"noti_image"];
            
            UILabel *notiLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 4, 10, 10)];
            [notiView addSubview:notiLabel];
            
            notiLabel.textAlignment = NSTextAlignmentCenter;
            notiLabel.font = [UIFont systemFontOfSize:12];
            notiLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
           
            NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle]pathForResource:@"green" ofType:@"gif"]];
            NSString *maxLevel = [NSString stringWithFormat:@"%@",result[@"value"][@"maxLevel"]]  ;
            
            if([maxLevel isEqualToString:@"5"]){
                img.image = [UIImage imageNamed:@"alert_prompt"];
            }else if([maxLevel isEqualToString:@"4"]){
                img.image = [UIImage imageNamed:@"alert_prompt"];
            }else if([maxLevel isEqualToString:@"3"]){
                img.image = [UIImage imageNamed:@"alert_secondary"];
            }else if([maxLevel isEqualToString:@"2"]){
                img.image = [UIImage imageNamed:@"alert_important"];
            }else if([maxLevel isEqualToString:@"1"]){
                img.image = [UIImage imageNamed:@"alert_urgent"];
            }else{
                img.image = [UIImage imageNamed:@"alert_prompt"];
            }
            
            
            self.rotingLabel = [[CCZTrotingLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.webView.frame), 0, SCREEN_WIDTH - 85-20-20, view.lx_height)];
            self.rotingLabel.delegate = self;
            self.rotingLabel.backgroundColor = [UIColor clearColor];
            self.rotingLabel.pause = 0.5;
            self.rotingLabel.type = CCZWalkerTypeDescend;
            self.rotingLabel.rate = RateNormal;
            self.rotingLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
            self.rotingLabel.font = [UIFont systemFontOfSize:14];
            [view addSubview:self.rotingLabel];
            [self.rotingLabel trotingWithAttribute:^(CCZTrotingAttribute * _Nonnull attribute) {
                NSLog(@"%@",attribute);
            }];
            UIImageView *rightArrowimage = [[UIImageView alloc]initWithFrame:CGRectMake(self.rotingLabel.frame.origin.x + self.rotingLabel.frame.size.width +25, 21, 5, 8)];
            rightArrowimage.image = [UIImage imageNamed:@"right_arrow"];
            [view addSubview:rightArrowimage];
            notiLabel.text = [NSString stringWithFormat:@"%d",(int)modelArray.count];
            if (modelArray.count >9) {
                [notiLabel setFrame:CGRectMake(0,0, 18, 18)];
            }
            if (modelArray.count >99) {
                notiLabel.text = @"99";
                [notiLabel setFrame:CGRectMake(0, 4, 18, 10)];
            }
           
            if([maxLevel isEqualToString:@"5"]){
                notiimage.image = [UIImage imageNamed:@"noti_image"];
            }else if([maxLevel isEqualToString:@"4"]){
                notiimage.image = [UIImage imageNamed:@"noti_image"];
            }else if([maxLevel isEqualToString:@"3"]){
                notiimage.image = [UIImage imageNamed:@"qipao_yellow"];
            }else if([maxLevel isEqualToString:@"2"]){
                notiimage.image = [UIImage imageNamed:@"qipao_orange"];
            }else if([maxLevel isEqualToString:@"1"]){
                notiimage.image = [UIImage imageNamed:@"qipao_red"];
            }else{
                notiimage.image = [UIImage imageNamed:@"noti_image"];
            }
            
          
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
            [self.carouselView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(20 + Height_StatusBar);
                make.left.equalTo(self.view.mas_left).offset(20);
                //                make.right.equalTo(self.view.mas_right).offset(20);
                make.width.equalTo(@(SCREEN_WIDTH-40));
                make.height.equalTo(@50);
            }];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.carouselView.mas_top);
                make.left.equalTo(self.carouselView.mas_left);
                make.width.equalTo(@50);
                make.height.equalTo(@50);
            }];
            [self.rotingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.carouselView.mas_top);
                make.left.equalTo(img.mas_right).offset(5);
                make.right.equalTo(self.carouselView.mas_right).offset(-20);
                
                make.height.equalTo(@50);
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
        //[FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

- (NSString *)getNotiImage:(NSString * )level {
    NSString *imageString = @"alert_prompt";
    
    if ([level isEqualToString:@"4"]) {
        imageString = @"alert_prompt";
    }else if ([level isEqualToString:@"3"]) {
        imageString = @"alert_secondary";
    }else if ([level isEqualToString:@"2"]) {
        imageString = @"alert_important";
    }else if ([level isEqualToString:@"1"]) {
        imageString = @"alert_urgent";
    }
    
    
    //紧急
    return imageString;
}

// 解决手势冲突方案


-(void)getStationData{
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/stationList"];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        //        self.carouselView.frame = CGRectMake(20, -1, WIDTH_SCREEN-40, 40);
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        _stationList = [result[@"value"] copy];
        
        [_mapView removeAnnotations:_clusters2];
        [_mapView removeAnnotations:_clusters];
        [self addClusters];
        if (!_isFirstEnter) {
            [self performSelector:@selector(changemapView) withObject:nil afterDelay:.1f];
            _isFirstEnter = YES;
        }
     
        
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
    //1.设置本地个性化地图样式
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"custom_map_config" ofType:@"json"];
    //    //设置个性化地图样式
    //    [_mapView setCustomMapStylePath:path];
    //    [_mapView setCustomMapStyleEnable:YES];
    //
    //    //2.设置在线个性化地图样式
    //    BMKCustomMapStyleOption *option = [[BMKCustomMapStyleOption alloc] init];
    //    //请输入您的在线个性化样式ID
    //    option.customMapStyleID = @"4e7360bde67c***d6e69bc6a2c53059c";
    //    //获取本地个性化地图模板文件路径
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"custom_map_config" ofType:@"json"];
    //    //在线样式ID加载失败后会加载此路径的文件
    //    option.customMapStyleFilePath = path;
    //    [self.mapView setCustomMapStyleWithOption:option preLoad:^(NSString *path) {
    //        NSLog(@"预加载个性化文件路径：%@",path);
    //    } success:^(NSString *path) {
    //        NSLog(@"在线个性化文件路径：%@",path);
    //    } failure:^(NSError *error, NSString *path) {
    //        NSLog(@"设置在线个性化地图失败：%@---%@",error.userInfo,path);
    //    }];
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
    [self performSelector:@selector(resetClickMethod) withObject:nil afterDelay:1.f];
}

- (void)resetClickMethod {
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
    //    for (int i = 0; i < self.annotationViewArray.count; i++) {
    //        BMKAnnotationView *annotationView = self.annotationViewArray[i];
    //        annotationView.enabled = YES;
    //    }
    [self performSelector:@selector(resetClickMethod) withObject:nil afterDelay:1.f];
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
    [_clusterManager clearClusterItems];
    for (NSDictionary * stationInfo in _stationList) {
        
        ClusterAnnotation* annotation = [[ClusterAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake([stationInfo[@"station"][@"latitude"] floatValue], [stationInfo[@"station"][@"longitude"] floatValue]);
        NSString *isShow = @"0";
        
        
        annotation.subtitle = [NSString stringWithFormat:@"%@%@",stationInfo[@"station"][@"code"],stationInfo[@"station"][@"alias"]] ;
        [allStation addObject:stationInfo[@"station"][@"code"]];
        [aclusters addObject:annotation];
        
        ClusterAnnotation* annotation2 = [[ClusterAnnotation alloc]init];
        annotation2.coordinate = CLLocationCoordinate2DMake([stationInfo[@"station"][@"latitude"] floatValue], [stationInfo[@"station"][@"longitude"] floatValue] );
        annotation2.title = [NSString stringWithFormat:@"%@%@",stationInfo[@"station"][@"code"],stationInfo[@"station"][@"alias"]] ;
        //是否显示全部雷达站
        if(nowKey <= [_stationList count]){
            isShow = @"1";
            [aclusters2 addObject:annotation2];
        }
        
        //向点聚合管理类中添加标注
        
        BMKClusterItem *clusterItem = [[BMKClusterItem alloc] init];
        clusterItem.coor = CLLocationCoordinate2DMake([stationInfo[@"station"][@"latitude"] floatValue], [stationInfo[@"station"][@"longitude"] floatValue] );
        clusterItem.locDic = stationInfo;
        [_clusterManager addClusterItem:clusterItem];
        
        [_clusters addObject:annotation2];
        //        securityStatus
        
        
        NSDictionary  *thisStationDic = @{
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
        NSMutableDictionary *thisStation = [[NSMutableDictionary alloc]initWithDictionary:thisStationDic];
        
        if([[stationInfo allKeys] containsObject:@"securityStatus"]) {
            
            [thisStation setObject:stationInfo[@"securityStatus"] forKey:@"securityStatus"];
            
        }
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
    //    [_mapView addAnnotations:_clusters];
    //    [_mapView addAnnotations:_clusters2];
    //    [self removeClusters];
    [self updateClusters];
    
}

- (void)changemapView {
    [_mapView zoomIn];
}
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    NSString *AnnotationViewID = @"ClusterMark";
    ClusterAnnotation *cluster = (ClusterAnnotation*)annotation;
    ClusterAnnotationView *annotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    annotationView.size = cluster.size;
    annotationView.canShowCallout = NO;//在点击大头针的时候会弹出那个黑框框
    annotationView.draggable = NO;//禁止标注在地图上拖动
    annotationView.annotation = cluster;
    
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
    
    //    annotationView.centerOffset =  CGPointMake(0, -FrameWidth(80));
    UIImageView * bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(-75,0, 164,  59)];
    
    
    bgImg.image = [UIImage imageNamed:@"map_alertbgImage"];
    [annotationView addSubview:bgImg];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,3, 37,  40)];
    
    titleLabel.numberOfLines = 2;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    titleLabel.font = FontSize(12);
    titleLabel.textColor = [UIColor whiteColor];
    NSInteger ss = cluster.size;
    NSArray *dataList = cluster.dataArr;
    
    if (ss >1) {
        titleLabel.text = [NSString stringWithFormat:@"%ld\n台站",(long)cluster.size];
    }else {
        
        for (BMKClusterItem *item in dataList) {
            NSDictionary *dic = item.locDic;
            if (isSafeDictionary(dic)) {
                NSString *titleString = dic[@"station"][@"alias"];
                if (titleString.length) {
                    titleLabel.text = [NSString stringWithFormat:@"%@",safeString(titleString)];
                }
            }
            
        }
    }
    
    [bgImg addSubview:titleLabel];
    //设备
    UILabel * eqpLabel = [[UILabel alloc]initWithFrame:CGRectMake(47, 6, 20, 15)];
    eqpLabel.text = @"设备:";
    eqpLabel.font = FontSize(10);
    eqpLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    [bgImg addSubview:eqpLabel];
    [eqpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImg.mas_left).offset(47);
        make.top.equalTo(bgImg.mas_top).offset(6);
        make.width.equalTo(@25);
        make.height.equalTo(@15);
    }];
    UIImageView *eqpImage = [[UIImageView alloc]init];
    eqpImage.image = [UIImage imageNamed:@"level_normal"];
    [bgImg addSubview:eqpImage];
    [eqpImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(eqpLabel.mas_right).offset(1);
        make.top.equalTo(bgImg.mas_top).offset(6);
        make.width.equalTo(@26);
        make.height.equalTo(@15);
    }];
    //小红点
    UILabel *eqlNumLabel = [[UILabel alloc]init];
    eqlNumLabel.backgroundColor = [UIColor colorWithHexString:@"#2986F1"];
    eqlNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    eqlNumLabel.font = FontSize(10);
    eqlNumLabel.textAlignment = NSTextAlignmentCenter;
    eqlNumLabel.layer.cornerRadius = 5.f;
    eqlNumLabel.layer.masksToBounds = YES;
    eqlNumLabel.hidden = YES;
    [bgImg addSubview:eqlNumLabel];
    
    [eqlNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(eqpImage.mas_right).offset(-5);
        make.top.equalTo(eqpImage.mas_top).offset(-3);
        make.width.height.equalTo(@8);
    }];
    //equipmentStatus
    int equipmentLevel = 5;
    int equipmentStatus = 0;
    for (BMKClusterItem *item in dataList) {
        NSDictionary *dic = item.locDic;
        if (isSafeDictionary(dic)) {
            equipmentStatus += [ dic[@"equipmentStatus"][@"num"] intValue];
           
            if([dic[@"equipmentStatus"][@"level"] intValue] <equipmentLevel  &&[dic[@"equipmentStatus"][@"level"] intValue] >0){
                equipmentLevel = [dic[@"equipmentStatus"][@"level"] intValue];
            }
        }
        
    }
    if (equipmentLevel == 5) {
        equipmentLevel = 0;
    }
    if (dataList.count == 1) {
        for (BMKClusterItem *item in dataList) {
            NSDictionary *dic = item.locDic;
            if([dic[@"equipmentStatus"][@"status"] isEqualToString:@"0"] ||[dic[@"equipmentStatus"] count] ==0){
                eqpImage.image = [UIImage imageNamed:@"level_normal"];
                //正常
                
            }else if([dic[@"equipmentStatus"][@"status"] isEqualToString:@"3"] ){
                eqpImage.image = [UIImage imageNamed:@"level_normal"];
                //正常
            }else{
                
                int isNull = isNull(dic[@"equipmentStatus"][@"num"]);
                NSString *equipNum = isNull == 1?dic[@"equipmentStatus"][@"num"]:@"0";
                eqlNumLabel.text = [NSString stringWithFormat:@"%@",equipNum];
                eqpImage.image = [UIImage imageNamed:[self getLevelImage:dic[@"equipmentStatus"][@"level"]]];
                
            }
        }
    }else {
        if (equipmentStatus == 0) {
            //正常
            eqpImage.image = [UIImage imageNamed:@"level_normal"];
        }else {
            
            eqlNumLabel.text = [NSString stringWithFormat:@"%d",equipmentStatus] ;
            eqpImage.image = [UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%d",equipmentLevel]]];
        }
        
    }
    
    
    //安防
    UILabel * securityLabel = [[UILabel alloc]initWithFrame:CGRectMake(47, 6, 20, 15)];
    securityLabel.text = @"安防:";
    securityLabel.font = FontSize(10);
    [bgImg addSubview:securityLabel];
    [securityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(eqpImage.mas_right).offset(7);
        make.top.equalTo(eqpLabel.mas_top);
        make.width.equalTo(@25);
        make.height.equalTo(@15);
    }];
    UIImageView *securityImage = [[UIImageView alloc]init];
    securityImage.image = [UIImage imageNamed:@"level_normal"];
    [bgImg addSubview:securityImage];
    [securityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(securityLabel.mas_right).offset(1);
        make.top.equalTo(eqpImage.mas_top);
        make.width.equalTo(@26);
        make.height.equalTo(@15);
    }];
    //小红点
    UILabel *securityNumLabel = [[UILabel alloc]init];
    securityNumLabel.backgroundColor = [UIColor colorWithHexString:@"#2986F1"];
    securityNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    securityNumLabel.font = FontSize(10);
    securityNumLabel.textAlignment = NSTextAlignmentCenter;
    securityNumLabel.layer.cornerRadius = 5.f;
    securityNumLabel.layer.masksToBounds = YES;
    securityNumLabel.hidden = YES;
    [bgImg addSubview:securityNumLabel];
    
    [securityNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(securityImage.mas_right).offset(-5);
        make.top.equalTo(securityImage.mas_top).offset(-3);
        make.width.height.equalTo(@8);
    }];
    int securityLevel = 5;
    int securityStatus = 0;
    for (BMKClusterItem *item in dataList) {
        NSDictionary *dic = item.locDic;
        if (isSafeDictionary(dic)) {
            securityStatus += [ dic[@"securityStatus"][@"num"] intValue];
            if([dic[@"securityStatus"][@"level"] intValue] <securityLevel  &&[dic[@"securityStatus"][@"level"] intValue] >0){
                securityLevel = [dic[@"securityStatus"][@"level"] intValue];
            }
        }
    }
    if (securityLevel == 5) {
          securityLevel = 0;
      }
    if (dataList.count == 1) {
        //安防
        for (BMKClusterItem *item in dataList) {
            NSDictionary *dic = item.locDic;
            if([dic[@"securityStatus"][@"status"] isEqualToString:@"0"] ||[dic[@"securityStatus"] count] ==0){
                //正常
                securityImage.image = [UIImage imageNamed:@"level_normal"];
            }else if([dic[@"securityStatus"][@"status"] isEqualToString:@"3"] ){
                //正常
                securityImage.image = [UIImage imageNamed:@"level_normal"];
            }else{
                int isNull = isNull( dic[@"securityStatus"][@"num"]);
                NSString *equipNum = isNull == 1?dic[@"securityStatus"][@"num"]:@"0";
                securityNumLabel.text = [NSString stringWithFormat:@"%@",equipNum];
                securityNumLabel.backgroundColor = [self getTextColor:dic[@"securityStatus"][@"level"]];
                if (isNull >0) {
                    securityNumLabel.hidden = NO;
                }else {
                    securityNumLabel.hidden = YES;
                }
                securityImage.image = [UIImage imageNamed:[self getLevelImage:dic[@"securityStatus"][@"level"]]];
            }
        }
    }else {
        if (securityStatus == 0) {
            securityImage.image = [UIImage imageNamed:@"level_normal"];
        }else {
            if (securityStatus >0) {
                securityNumLabel.hidden = NO;
            }else {
                securityNumLabel.hidden = YES;
            }
            securityNumLabel.text = [NSString stringWithFormat:@"%d",securityStatus];
            securityNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%d",securityLevel]];
            securityImage.image = [UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%d",securityLevel]]];
        }
    }
    
    
    
    
    UILabel * envLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(18), FrameWidth(60), FrameWidth(75),  FrameWidth(27))];
    envLabel.text = @"环境:";
    envLabel.font = FontSize(10);
    [bgImg addSubview:envLabel];
    [envLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImg.mas_left).offset(47);
        make.top.equalTo(eqpImage.mas_bottom).offset(5);
        make.width.equalTo(@25);
        make.height.equalTo(@15);
    }];
    
    UIImageView *envImage = [[UIImageView alloc]init];
    envImage.image = [UIImage imageNamed:@"level_normal"];
    [bgImg addSubview:envImage];
    [envImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(envLabel.mas_right).offset(1);
        make.top.equalTo(eqpImage.mas_bottom).offset(5);
        make.width.equalTo(@26);
        make.height.equalTo(@15);
    }];
    //小红点
    UILabel *envNumLabel = [[UILabel alloc]init];
    envNumLabel.backgroundColor = [UIColor colorWithHexString:@"#2986F1"];
    envNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    envNumLabel.font = FontSize(10);
    envNumLabel.textAlignment = NSTextAlignmentCenter;
    envNumLabel.layer.cornerRadius = 5.f;
    envNumLabel.layer.masksToBounds = YES;
    envNumLabel.hidden = YES;
    [bgImg addSubview:envNumLabel];
    
    [envNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(envImage.mas_right).offset(-5);
        make.top.equalTo(envImage.mas_top).offset(-3);
        make.width.height.equalTo(@8);
    }];

    //    environmentStatus
    
    int environmentLevel = 5;
    int environmentStatus = 0;
    for (BMKClusterItem *item in dataList) {
        NSDictionary *dic = item.locDic;
        if (isSafeDictionary(dic)) {
            environmentStatus += [ dic[@"environmentStatus"][@"num"] intValue];
            
            if([dic[@"environmentStatus"][@"level"] intValue] <environmentLevel  &&[dic[@"environmentStatus"][@"level"] intValue] >0){
                environmentLevel = [dic[@"environmentStatus"][@"level"] intValue];
            }
        }
    }
    if (environmentLevel == 5) {
        environmentLevel = 0;
    }
    if (dataList.count == 1) {
        
        for (BMKClusterItem *item in dataList) {
            NSDictionary *dic = item.locDic;
            if([dic[@"environmentStatus"][@"status"] isEqualToString:@"0"] ||[dic[@"environmentStatus"] count] ==0){
                //正常
                envImage.image = [UIImage imageNamed:@"level_normal"];
            }else if([dic[@"environmentStatus"][@"status"] isEqualToString:@"3"] ){
                //正常
                envImage.image = [UIImage imageNamed:@"level_normal"];
            }else{
                int isNull = isNull( dic[@"environmentStatus"][@"num"]);
                NSString *equipNum = isNull == 1?dic[@"environmentStatus"][@"num"]:@"0";
                envNumLabel.text = [NSString stringWithFormat:@"%@",equipNum] ;
                envNumLabel.backgroundColor = [self getTextColor:dic[@"environmentStatus"][@"level"]];
                envImage.image = [UIImage imageNamed:[self getLevelImage:dic[@"environmentStatus"][@"level"]]];
                if (isNull >0) {
                    envNumLabel.hidden = NO;
                }else {
                    envNumLabel.hidden = YES;
                }
            }
        }
    }else {
        if (environmentStatus == 0) {
            //正常
            envImage.image = [UIImage imageNamed:@"level_normal"];
        }else {
            envNumLabel.text = [NSString stringWithFormat:@"%d",environmentStatus] ;
            envNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%d",environmentLevel]];
            envImage.image = [UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%d",environmentLevel]]];
            
            if (environmentLevel >0) {
                envNumLabel.hidden = NO;
            }else {
                envNumLabel.hidden = YES;
            }
        }
        
    }
       
    
    UILabel * powerLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(18), FrameWidth(33), FrameWidth(75),  FrameWidth(27))];
    powerLabel.text = @"动力:";
    powerLabel.font = FontSize(10);
    [bgImg addSubview:powerLabel];
    [powerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(envImage.mas_right).offset(7);
        make.top.equalTo(eqpImage.mas_bottom).offset(5);
        make.width.equalTo(@25);
        make.height.equalTo(@15);
    }];
    
    
    UIImageView *powerImage = [[UIImageView alloc]init];
    powerImage.image = [UIImage imageNamed:@"level_normal"];
    [bgImg addSubview:powerImage];
    [powerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(powerLabel.mas_right).offset(1);
        make.top.equalTo(envImage.mas_top);
        make.width.equalTo(@26);
        make.height.equalTo(@15);
    }];
    //小红点
    UILabel *powerNumLabel = [[UILabel alloc]init];
    powerNumLabel.backgroundColor = [UIColor colorWithHexString:@"#2986F1"];
    powerNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    powerNumLabel.font = FontSize(10);
    powerNumLabel.textAlignment = NSTextAlignmentCenter;
    powerNumLabel.layer.cornerRadius = 5.f;
    powerNumLabel.layer.masksToBounds = YES;
    powerNumLabel.hidden = YES;
    [bgImg addSubview:powerNumLabel];
    
    [powerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(powerImage.mas_right).offset(-5);
        make.top.equalTo(powerImage.mas_top).offset(-3);
        make.width.height.equalTo(@8);
    }];
    
   
    
     //power
    int powerLevel = 5;
    int powerStatus = 0;
    for (BMKClusterItem *item in dataList) {
        NSDictionary *dic = item.locDic;
        if (isSafeDictionary(dic)) {
            powerStatus += [ dic[@"powerStatus"][@"num"] intValue];
            
            if([dic[@"powerStatus"][@"level"] intValue] <powerLevel && [dic[@"powerStatus"][@"level"] intValue] >0){
                powerLevel = [dic[@"powerStatus"][@"level"] intValue];
            }
        }
    }
    if (powerLevel == 5) {
           powerLevel = 0;
       }
    if (dataList.count == 1) {
        //power
        for (BMKClusterItem *item in dataList) {
            NSDictionary *dic = item.locDic;
            if([dic[@"powerStatus"][@"status"] isEqualToString:@"0"] ||[dic[@"powerStatus"] count] ==0){
                powerImage.image = [UIImage imageNamed:@"level_normal"];
                
            }else if([dic[@"powerStatus"][@"status"] isEqualToString:@"3"] ){
                powerImage.image = [UIImage imageNamed:@"level_normal"];
                
            }else{
                int isNull = isNull(  dic[@"powerStatus"][@"num"]);
                NSString *equipNum = isNull == 1? dic[@"powerStatus"][@"num"]:@"0";
                powerNumLabel.text = [NSString stringWithFormat:@"%@",equipNum] ;
                powerNumLabel.backgroundColor = [self getTextColor:dic[@"powerStatus"][@"level"]];
                powerImage.image = [UIImage imageNamed:[self getLevelImage:dic[@"powerStatus"][@"level"]]];
                
                if (isNull >0) {
                    powerNumLabel.hidden = NO;
                }else {
                    powerNumLabel.hidden = YES;
                }
            }
        }
    }else {
        if (powerStatus == 0) {
            powerImage.image = [UIImage imageNamed:@"level_normal"];
        }else {
            powerNumLabel.text = [NSString stringWithFormat:@"%d",powerStatus] ;
            powerNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%d",powerLevel]];
            powerImage.image = [UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%d",powerLevel]]];
            if (powerLevel >0) {
                powerNumLabel.hidden = NO;
            }else {
                powerNumLabel.hidden = YES;
            }
        }
    }
    
    
    if(powerStatus >9){
        [powerNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@12);
            make.left.equalTo(powerImage.mas_right).offset(-6);
            make.top.equalTo(powerImage.mas_top).offset(-6);
        }];
        powerNumLabel.layer.cornerRadius =6.f;
        powerNumLabel.layer.masksToBounds = YES;
    }
    if(securityStatus >9){
        [securityNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@12);
            make.left.equalTo(securityImage.mas_right).offset(-6);
            make.top.equalTo(securityImage.mas_top).offset(-6);
        }];
        securityNumLabel.layer.cornerRadius =6.f;
        securityNumLabel.layer.masksToBounds = YES;
    }
    if(environmentStatus >9){
        [envNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@12);
            make.left.equalTo(envImage.mas_right).offset(-6);
            make.top.equalTo(envImage.mas_top).offset(-6);
        }];
        envNumLabel.layer.cornerRadius =6.f;
        envNumLabel.layer.masksToBounds = YES;
    }
    if(equipmentStatus >9){
        [eqlNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@12);
            make.left.equalTo(eqpImage.mas_right).offset(-6);
            make.top.equalTo(eqpImage.mas_top).offset(-6);
        }];
        eqlNumLabel.layer.cornerRadius =6.f;
        eqlNumLabel.layer.masksToBounds = YES;
    }
    return  annotationView;
    
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
//
//
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//
//    //普通annotation
//    NSString *AnnotationViewID = @"ClusterMark";
//    ClusterAnnotation *cluster = (ClusterAnnotation*)annotation;
//    ClusterAnnotationView *annotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//    annotationView.size = cluster.size;
//    annotationView.canShowCallout = NO;//在点击大头针的时候会弹出那个黑框框
//    annotationView.draggable = NO;//禁止标注在地图上拖动
//    annotationView.annotation = cluster;
//
//    //    annotationView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:annotation.subtitle]]];
//    //    annotationView.centerOffset=CGPointMake(0,-80);
//
//    annotationView.tag = [_stationDIC[annotation.title][@"nowKey"] intValue]+100;
//
//    //需要判断不同的机型决定字体大小以及背景图
//    if(isIphoneX){//iphonex
//        annotationView.image = [UIImage imageNamed:@"alpha3"];//537*165
//    }else if(isIphone){//iphonex iphone6 iphone8 iphone7
//        annotationView.image = [UIImage imageNamed:@"alpha2"];//350*105
//    }else if(isPlus){//iphone6 plus iphone7plus
//        annotationView.image = [UIImage imageNamed:@"alpha0"];//596*183
//    }else if(is5S){//iphone5s
//        annotationView.image = [UIImage imageNamed:@"alpha1"];//300*100
//    }else{
//        annotationView.image = [UIImage imageNamed:@"alpha0"];//300*100
//    }
//
//    //    annotationView.centerOffset =  CGPointMake(0, -FrameWidth(80));
//
//    //UIImageView * bgImg = [[UIImageView alloc]initWithFrame:CGRectMake((317-FrameWidth(315))/2, (123-FrameWidth(103))/2, FrameWidth(315),  FrameWidth(103))];
//    UIImageView * bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, FrameWidth(315),  FrameWidth(138))];
//
//
//    bgImg.image = [UIImage imageNamed:@"home_detail_biao"];
//    [annotationView addSubview:bgImg];
//
//
//
//    UILabel * securityLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(18), FrameWidth(5), FrameWidth(75),  FrameWidth(27))];
//    securityLabel.text = @"安防:";
//    securityLabel.font = FontSize(12);
//    [bgImg addSubview:securityLabel];
//
//
//
//    UILabel * powerLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(18), FrameWidth(33), FrameWidth(75),  FrameWidth(27))];
//    powerLabel.text = @"动力:";
//    powerLabel.font = FontSize(12);
//    [bgImg addSubview:powerLabel];
//
//
//
//    UILabel * envLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(18), FrameWidth(60), FrameWidth(75),  FrameWidth(27))];
//    envLabel.text = @"环境:";
//    envLabel.font = FontSize(12);
//    [bgImg addSubview:envLabel];
//
//    UILabel * eqpLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(18), FrameWidth(87), FrameWidth(75),  FrameWidth(27))];
//    eqpLabel.text = @"设备:";
//    eqpLabel.font = FontSize(12);
//    [bgImg addSubview:eqpLabel];
//
//
//    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(220), 0, FrameWidth(80),  FrameWidth(117))];
//
//    titleLabel.numberOfLines = 3;
//    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    //titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    titleLabel.font = FontSize(12);
//    titleLabel.textColor = [UIColor whiteColor];
//    NSInteger ss = cluster.size;
//    NSArray *dataList = cluster.dataArr;
//
//    if (ss >1) {
//        titleLabel.text = [NSString stringWithFormat:@"台站%ld",(long)cluster.size];
//    }else {
//
//        for (BMKClusterItem *item in dataList) {
//            NSDictionary *dic = item.locDic;
//            if (isSafeDictionary(dic)) {
//                NSString *titleString = dic[@"station"][@"alias"];
//                if (titleString.length) {
//                    titleLabel.text = [NSString stringWithFormat:@"%@",safeString(titleString)];
//                }
//            }
//
//        }
//    }
//
//    [bgImg addSubview:titleLabel];
//
//    int securityLevel = 0;
//    int securityStatus = 0;
//    for (BMKClusterItem *item in dataList) {
//        NSDictionary *dic = item.locDic;
//        if (isSafeDictionary(dic)) {
//            securityStatus += [ dic[@"securityStatus"][@"num"] intValue];
//            if([dic[@"securityStatus"][@"level"] intValue] >securityLevel ){
//                securityLevel = [dic[@"securityStatus"][@"level"] intValue];
//            }
//        }
//    }
//    if (dataList.count == 1) {
//        //安防
//        for (BMKClusterItem *item in dataList) {
//            NSDictionary *dic = item.locDic;
//            if([dic[@"securityStatus"][@"status"] isEqualToString:@"0"] ||[dic[@"securityStatus"] count] ==0){
//                UIButton *securityOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(8), FrameWidth(45), FrameWidth(22))];
//                [securityOk setBackgroundColor:FrameColor(120, 203, 161)];
//                securityOk.layer.cornerRadius = 2;
//                securityOk.titleLabel.font = FontBSize(10);
//                [securityOk setTitle: @"正常"   forState:UIControlStateNormal];
//                securityOk.titleLabel.textColor = [UIColor whiteColor];
//                [bgImg addSubview:securityOk];
//
//            }else if([dic[@"securityStatus"][@"status"] isEqualToString:@"3"] ){
//                UIButton *securityOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(8), FrameWidth(45), FrameWidth(22))];
//                [securityOk setBackgroundColor:FrameColor(252,201,84)];
//                securityOk.layer.cornerRadius = 2;
//                securityOk.titleLabel.font = FontBSize(10);
//                [securityOk setTitle: @"正常"   forState:UIControlStateNormal];
//                securityOk.titleLabel.textColor = [UIColor whiteColor];
//                [bgImg addSubview:securityOk];
//
//            }else{
//
//                UIButton *warnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(8), FrameWidth(75), FrameWidth(22))];
//                [warnBtn setBackgroundColor:warnColor];//warnColor
//                warnBtn.layer.cornerRadius = 2;
//                warnBtn.titleLabel.font = FontBSize(10);
//
//
//                int isNull = isNull( dic[@"securityStatus"][@"num"]);
//                NSString *equipNum = isNull == 1?dic[@"securityStatus"][@"num"]:@"0";
//
//                [warnBtn setTitle:[NSString stringWithFormat:@"告警%@",equipNum]  forState:UIControlStateNormal];
//
//                //[warnBtn setTitle: [NSString stringWithFormat:@"告警数量%@",_stationDIC[annotation.title][@"powerStatus"][@"num"]]   forState:UIControlStateNormal];
//                warnBtn.titleLabel.textColor = [UIColor whiteColor];
//                [bgImg addSubview:warnBtn];
//
//                UIButton *LevelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(150), FrameWidth(8), FrameWidth(45), FrameWidth(22))];
//
//                LevelBtn.layer.cornerRadius = 2;
//                [CommonExtension addLevelBtn:LevelBtn level:dic[@"securityStatus"][@"level"]];
//                LevelBtn.titleLabel.font = FontBSize(10);
//                [bgImg addSubview:LevelBtn];
//            }
//        }
//    }else {
//
//        if (securityStatus == 0) {
//            UIButton *securityOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(8), FrameWidth(45), FrameWidth(22))];
//            [securityOk setBackgroundColor:FrameColor(120, 203, 161)];
//            securityOk.layer.cornerRadius = 2;
//            securityOk.titleLabel.font = FontBSize(10);
//            [securityOk setTitle: @"正常"   forState:UIControlStateNormal];
//            securityOk.titleLabel.textColor = [UIColor whiteColor];
//            [bgImg addSubview:securityOk];
//        }else {
//            UIButton *warnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(8), FrameWidth(75), FrameWidth(22))];
//            [warnBtn setBackgroundColor:warnColor];//warnColor
//            warnBtn.layer.cornerRadius = 2;
//            warnBtn.titleLabel.font = FontBSize(10);
//
//            [warnBtn setTitle:[NSString stringWithFormat:@"告警%d",securityStatus]  forState:UIControlStateNormal];
//
//            warnBtn.titleLabel.textColor = [UIColor whiteColor];
//            [bgImg addSubview:warnBtn];
//
//            UIButton *LevelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(150), FrameWidth(8), FrameWidth(45), FrameWidth(22))];
//
//            LevelBtn.layer.cornerRadius = 2;
//            [CommonExtension addLevelBtn:LevelBtn level:[NSString stringWithFormat:@"%d",securityLevel]];
//            LevelBtn.titleLabel.font = FontBSize(10);
//            [bgImg addSubview:LevelBtn];
//        }
//
//    }
//    //power
//    int powerLevel = 0;
//    int powerStatus = 0;
//    for (BMKClusterItem *item in dataList) {
//        NSDictionary *dic = item.locDic;
//        if (isSafeDictionary(dic)) {
//            powerStatus += [ dic[@"powerStatus"][@"num"] intValue];
//
//            if([dic[@"powerStatus"][@"level"] intValue] >powerLevel ){
//                powerLevel = [dic[@"powerStatus"][@"level"] intValue];
//            }
//        }
//    }
//    if (dataList.count == 1) {
//        //power
//        for (BMKClusterItem *item in dataList) {
//            NSDictionary *dic = item.locDic;
//            if([dic[@"powerStatus"][@"status"] isEqualToString:@"0"] ||[dic[@"powerStatus"] count] ==0){
//                UIButton *powerOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(35), FrameWidth(45), FrameWidth(22))];
//                [powerOk setBackgroundColor:FrameColor(120, 203, 161)];
//                powerOk.layer.cornerRadius = 2;
//                powerOk.titleLabel.font = FontBSize(10);
//                [powerOk setTitle: @"正常"   forState:UIControlStateNormal];
//                powerOk.titleLabel.textColor = [UIColor whiteColor];
//                [bgImg addSubview:powerOk];
//
//            }else if([dic[@"powerStatus"][@"status"] isEqualToString:@"3"] ){
//                UIButton *powerOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(35), FrameWidth(45), FrameWidth(22))];
//                [powerOk setBackgroundColor:FrameColor(252,201,84)];
//                powerOk.layer.cornerRadius = 2;
//                powerOk.titleLabel.font = FontBSize(10);
//                [powerOk setTitle: @"正常"   forState:UIControlStateNormal];
//                powerOk.titleLabel.textColor = [UIColor whiteColor];
//                [bgImg addSubview:powerOk];
//
//            }else{
//
//                UIButton *warnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(35), FrameWidth(75), FrameWidth(22))];
//                [warnBtn setBackgroundColor:warnColor];//warnColor
//                warnBtn.layer.cornerRadius = 2;
//                warnBtn.titleLabel.font = FontBSize(10);
//
//
//                int isNull = isNull(  dic[@"powerStatus"][@"num"]);
//                NSString *equipNum = isNull == 1? dic[@"powerStatus"][@"num"]:@"0";
//
//                [warnBtn setTitle:[NSString stringWithFormat:@"告警%@",equipNum]  forState:UIControlStateNormal];
//
//                //[warnBtn setTitle: [NSString stringWithFormat:@"告警数量%@",_stationDIC[annotation.title][@"powerStatus"][@"num"]]   forState:UIControlStateNormal];
//                warnBtn.titleLabel.textColor = [UIColor whiteColor];
//                [bgImg addSubview:warnBtn];
//
//                UIButton *LevelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(150), FrameWidth(35), FrameWidth(45), FrameWidth(22))];
//
//                LevelBtn.layer.cornerRadius = 2;
//                [CommonExtension addLevelBtn:LevelBtn level: dic[@"powerStatus"][@"level"]];
//                LevelBtn.titleLabel.font = FontBSize(10);
//                [bgImg addSubview:LevelBtn];
//            }
//        }
//    }else {
//
//        if (powerStatus == 0) {
//            UIButton *powerOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(35), FrameWidth(45), FrameWidth(22))];
//            [powerOk setBackgroundColor:FrameColor(120, 203, 161)];
//            powerOk.layer.cornerRadius = 2;
//            powerOk.titleLabel.font = FontBSize(10);
//            [powerOk setTitle: @"正常"   forState:UIControlStateNormal];
//            powerOk.titleLabel.textColor = [UIColor whiteColor];
//            [bgImg addSubview:powerOk];
//        }else {
//            UIButton *warnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(35), FrameWidth(75), FrameWidth(22))];
//            [warnBtn setBackgroundColor:warnColor];//warnColor
//            warnBtn.layer.cornerRadius = 2;
//            warnBtn.titleLabel.font = FontBSize(10);
//            [warnBtn setTitle:[NSString stringWithFormat:@"告警%d",powerStatus]  forState:UIControlStateNormal];
//            warnBtn.titleLabel.textColor = [UIColor whiteColor];
//            [bgImg addSubview:warnBtn];
//
//            UIButton *LevelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(150), FrameWidth(35), FrameWidth(45), FrameWidth(22))];
//
//            LevelBtn.layer.cornerRadius = 2;
//            [CommonExtension addLevelBtn:LevelBtn level:[NSString stringWithFormat:@"%d",powerLevel]];
//            LevelBtn.titleLabel.font = FontBSize(10);
//            [bgImg addSubview:LevelBtn];
//        }
//
//    }
//    //environmentStatus
//
//    int environmentLevel = 0;
//    int environmentStatus = 0;
//    for (BMKClusterItem *item in dataList) {
//        NSDictionary *dic = item.locDic;
//        if (isSafeDictionary(dic)) {
//            environmentStatus += [ dic[@"environmentStatus"][@"num"] intValue];
//
//            if([dic[@"environmentStatus"][@"level"] intValue] >environmentLevel ){
//                environmentLevel = [dic[@"environmentStatus"][@"level"] intValue];
//            }
//        }
//    }
//    if (dataList.count == 1) {
//
//        for (BMKClusterItem *item in dataList) {
//            NSDictionary *dic = item.locDic;
//            if([dic[@"environmentStatus"][@"status"] isEqualToString:@"0"] ||[dic[@"environmentStatus"] count] ==0){
//                UIButton *envOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(62), FrameWidth(45), FrameWidth(22))];
//                [envOk setBackgroundColor:FrameColor(120, 203, 161)];
//                envOk.layer.cornerRadius = 2;
//                envOk.titleLabel.font = FontBSize(10);
//                [envOk setTitle: @"正常"   forState:UIControlStateNormal];
//                envOk.titleLabel.textColor = [UIColor whiteColor];
//                [bgImg addSubview:envOk];
//
//            }else if([dic[@"environmentStatus"][@"status"] isEqualToString:@"3"] ){
//                UIButton *envOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(62), FrameWidth(45), FrameWidth(22))];
//                [envOk setBackgroundColor:FrameColor(252,201,84)];
//                envOk.layer.cornerRadius = 2;
//                envOk.titleLabel.font = FontBSize(10);
//                [envOk setTitle: @"正常"   forState:UIControlStateNormal];
//                envOk.titleLabel.textColor = [UIColor whiteColor];
//                [bgImg addSubview:envOk];
//
//            }else{
//
//                UIButton *envWarnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(62), FrameWidth(75), FrameWidth(22))];
//                [envWarnBtn setBackgroundColor:warnColor];
//                envWarnBtn.layer.cornerRadius = 2;
//                envWarnBtn.titleLabel.font = FontBSize(10);
//                int isNull = isNull( dic[@"environmentStatus"][@"num"]);
//                NSString *equipNum = isNull == 1?dic[@"environmentStatus"][@"num"]:@"0";
//                [envWarnBtn setTitle:[NSString stringWithFormat:@"告警%@",equipNum]  forState:UIControlStateNormal];
//                envWarnBtn.titleLabel.textColor = [UIColor whiteColor];
//                [bgImg addSubview:envWarnBtn];
//
//                UIButton *envLevelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(150), FrameWidth(62), FrameWidth(45), FrameWidth(22))];
//
//                envLevelBtn.layer.cornerRadius = 2;
//
//                [CommonExtension addLevelBtn:envLevelBtn level:dic[@"environmentStatus"][@"level"]];
//                envLevelBtn.titleLabel.font = FontBSize(10);
//                envLevelBtn.titleLabel.textColor = [UIColor whiteColor];
//                [bgImg addSubview:envLevelBtn];
//
//            }
//        }
//    }else {
//
//        if (environmentStatus == 0) {
//            UIButton *envOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(62), FrameWidth(45), FrameWidth(22))];
//            [envOk setBackgroundColor:FrameColor(120, 203, 161)];
//            envOk.layer.cornerRadius = 2;
//            envOk.titleLabel.font = FontBSize(10);
//            [envOk setTitle: @"正常"   forState:UIControlStateNormal];
//            envOk.titleLabel.textColor = [UIColor whiteColor];
//            [bgImg addSubview:envOk];
//        }else {
//
//            UIButton *envWarnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(62), FrameWidth(75), FrameWidth(22))];
//            [envWarnBtn setBackgroundColor:warnColor];
//            envWarnBtn.layer.cornerRadius = 2;
//            envWarnBtn.titleLabel.font = FontBSize(10);
//
//            [envWarnBtn setTitle:[NSString stringWithFormat:@"告警%d",environmentStatus]  forState:UIControlStateNormal];
//            envWarnBtn.titleLabel.textColor = [UIColor whiteColor];
//            [bgImg addSubview:envWarnBtn];
//            UIButton *envLevelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(150), FrameWidth(62), FrameWidth(45), FrameWidth(22))];
//            envLevelBtn.layer.cornerRadius = 2;
//            [CommonExtension addLevelBtn:envLevelBtn level:[NSString stringWithFormat:@"%d",environmentLevel]];
//            envLevelBtn.titleLabel.font = FontBSize(10);
//            envLevelBtn.titleLabel.textColor = [UIColor whiteColor];
//            [bgImg addSubview:envLevelBtn];
//        }
//
//    }
//    //equipmentStatus
//
//    int equipmentLevel = 0;
//    int equipmentStatus = 0;
//    for (BMKClusterItem *item in dataList) {
//        NSDictionary *dic = item.locDic;
//        if (isSafeDictionary(dic)) {
//            equipmentStatus += [ dic[@"equipmentStatus"][@"num"] intValue];
//            equipmentLevel += [ dic[@"equipmentStatus"][@"level"] intValue];
//            if([dic[@"equipmentStatus"][@"level"] intValue] >equipmentLevel ){
//                equipmentLevel = [dic[@"equipmentStatus"][@"level"] intValue];
//            }
//        }
//    }
//    if (dataList.count == 1) {
//        for (BMKClusterItem *item in dataList) {
//            NSDictionary *dic = item.locDic;
//            if([dic[@"equipmentStatus"][@"status"] isEqualToString:@"0"] ||[dic[@"equipmentStatus"] count] ==0){
//                UIButton *equipOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(89), FrameWidth(45), FrameWidth(22))];
//                [equipOk setBackgroundColor:FrameColor(120, 203, 161)];
//                equipOk.layer.cornerRadius = 2;
//                equipOk.titleLabel.font = FontBSize(10);
//                [equipOk setTitle: @"正常"   forState:UIControlStateNormal];
//                equipOk.titleLabel.textColor = [UIColor whiteColor];
//                [bgImg addSubview:equipOk];
//
//            }else if([dic[@"equipmentStatus"][@"status"] isEqualToString:@"3"] ){
//                UIButton *equipOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(89), FrameWidth(45), FrameWidth(22))];
//                [equipOk setBackgroundColor:FrameColor(252,201,84)];
//                equipOk.layer.cornerRadius = 2;
//                equipOk.titleLabel.font = FontBSize(10);
//                [equipOk setTitle: @"正常"   forState:UIControlStateNormal];
//                equipOk.titleLabel.textColor = [UIColor whiteColor];
//                [bgImg addSubview:equipOk];
//            }else{
//                UIButton *equipWarnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(89), FrameWidth(75), FrameWidth(22))];
//                [equipWarnBtn setBackgroundColor:warnColor];
//                equipWarnBtn.layer.cornerRadius = 2;
//                equipWarnBtn.titleLabel.font = FontBSize(10);
//                int isNull = isNull(dic[@"equipmentStatus"][@"num"]);
//                NSString *equipNum = isNull == 1?dic[@"equipmentStatus"][@"num"]:@"0";
//                [equipWarnBtn setTitle:[NSString stringWithFormat:@"告警%@",equipNum]  forState:UIControlStateNormal];
//                equipWarnBtn.titleLabel.textColor = [UIColor whiteColor];
//                [bgImg addSubview:equipWarnBtn];
//
//                UIButton *equipLevelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(150), FrameWidth(89), FrameWidth(45), FrameWidth(22))];
//                equipLevelBtn.titleLabel.font = FontBSize(10);
//                equipLevelBtn.layer.cornerRadius = 2;
//                [CommonExtension addLevelBtn:equipLevelBtn level:dic[@"equipmentStatus"][@"level"]];
//                [bgImg addSubview:equipLevelBtn];
//            }
//        }
//    }else {
//        if (equipmentStatus == 0) {
//            UIButton *equipOk = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(89), FrameWidth(45), FrameWidth(22))];
//            [equipOk setBackgroundColor:FrameColor(120, 203, 161)];
//            equipOk.layer.cornerRadius = 2;
//            equipOk.titleLabel.font = FontBSize(10);
//            [equipOk setTitle: @"正常"   forState:UIControlStateNormal];
//            equipOk.titleLabel.textColor = [UIColor whiteColor];
//            [bgImg addSubview:equipOk];
//        }else {
//            UIButton *equipWarnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(89), FrameWidth(75), FrameWidth(22))];
//            [equipWarnBtn setBackgroundColor:warnColor];
//            equipWarnBtn.layer.cornerRadius = 2;
//            equipWarnBtn.titleLabel.font = FontBSize(10);
//            [equipWarnBtn setTitle:[NSString stringWithFormat:@"告警%d",equipmentStatus]  forState:UIControlStateNormal];
//            equipWarnBtn.titleLabel.textColor = [UIColor whiteColor];
//            [bgImg addSubview:equipWarnBtn];
//
//            UIButton *equipLevelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(150), FrameWidth(89), FrameWidth(45), FrameWidth(22))];
//            equipLevelBtn.titleLabel.font = FontBSize(10);
//            equipLevelBtn.layer.cornerRadius = 2;
//            [CommonExtension addLevelBtn:equipLevelBtn level:[NSString stringWithFormat:@"%d",equipmentLevel]];
//            [bgImg addSubview:equipLevelBtn];
//        }
//
//    }
//    return annotationView;
//}

-(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)resizeWithImage:(UIImage *)image{
    CGFloat top = image.size.height/2.0;
    CGFloat left = image.size.width/2.0;
    CGFloat bottom = image.size.height/2.0;
    CGFloat right = image.size.width/2.0;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)resizingMode:UIImageResizingModeStretch];
}


/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 选中的annotation views
 */
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    [mapView deselectAnnotation:view.annotation animated:true];
    ClusterAnnotation *clusterAnnotation = (ClusterAnnotation*)view.annotation;
    if (clusterAnnotation.size > 1) {
        [mapView setCenterCoordinate:view.annotation.coordinate];
        [mapView zoomIn];
        
    }else {
        NSArray *dataList = clusterAnnotation.dataArr;
        if (dataList.count == 1) {
            for (BMKClusterItem *item in dataList) {
                
                NSDictionary *dataD = [[NSMutableDictionary alloc]initWithDictionary:[item.locDic mj_keyValues]];
                if (isSafeDictionary(dataD)) {
                    
                    [self saveDefaultData:dataD];
                    
                }
            }
        }
        //
        //        if(view.tag < 100){
        //            if([_stationDIC[view.annotation.subtitle][@"isShow"] isEqualToString:@"0"]){
        //
        //                //BMKAnnotationView * view1 = [mapView viewWithTag:view.tag+100];
        //
        //                NSDictionary  *thisStation1 = _stationDIC[view.annotation.subtitle];
        //
        //                ClusterAnnotation* annotation2 = [[ClusterAnnotation alloc]init];
        //                annotation2.coordinate = CLLocationCoordinate2DMake([thisStation1[@"latitude"] floatValue], [thisStation1[@"longitude"] floatValue] );
        //                annotation2.title = view.annotation.subtitle;
        //                [mapView addAnnotation:annotation2];
        //
        //                [_clusters2 addObject:annotation2];
        //
        //                NSDictionary  *thisStation2 = @{
        //                    @"name":thisStation1[@"alias"],
        //                    @"alias":thisStation1[@"alias"],
        //                    @"environmentStatus":thisStation1[@"environmentStatus"],
        //                    @"powerStatus":thisStation1[@"powerStatus"],
        //                    @"alarmStatus":thisStation1[@"alarmStatus"],
        //                    @"code":thisStation1[@"code"],
        //                    @"airport":thisStation1[@"airport"],
        //                    @"latitude":thisStation1[@"latitude"],
        //                    @"longitude":thisStation1[@"longitude"],
        //                    @"picture":thisStation1[@"picture"],
        //                    @"nowKey":thisStation1[@"nowKey"],
        //                    @"address":thisStation1[@"address"],
        //                    @"isShow":@"1"
        //                };
        //
        //                _stationDIC[view.annotation.subtitle] = thisStation2;
        //
        //            }else{
        //                BMKAnnotationView * view1 = [mapView viewWithTag:view.tag+100];
        //
        //
        //                NSDictionary  *thisStation1 = _stationDIC[view.annotation.subtitle];
        //
        //
        //                [mapView removeAnnotation:view1.annotation];
        //
        //
        //                //[_stationDIC removeObjectForKey:view.annotation.subtitle];
        //                NSDictionary  *thisStation2 = @{
        //                    @"name":thisStation1[@"alias"],
        //                    @"alias":thisStation1[@"alias"],
        //                    @"environmentStatus":thisStation1[@"environmentStatus"],
        //                    @"powerStatus":thisStation1[@"powerStatus"],
        //                    @"alarmStatus":thisStation1[@"alarmStatus"],
        //                    @"code":thisStation1[@"code"],
        //                    @"airport":thisStation1[@"airport"],
        //                    @"latitude":thisStation1[@"latitude"],
        //                    @"longitude":thisStation1[@"longitude"],
        //                    @"picture":thisStation1[@"picture"],
        //                    @"nowKey":thisStation1[@"nowKey"],
        //                    @"address":thisStation1[@"address"],
        //                    @"isShow":@"0"
        //                };
        //                _stationDIC[view.annotation.subtitle] = thisStation2;
        //            }
        //        }else{
        //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //            [userDefaults setObject:_stationDIC[view.annotation.title] forKey:@"station"];
        //            [[NSUserDefaults standardUserDefaults] synchronize];
        //            [self.navigationController.tabBarController setSelectedIndex:0];
        //            [[NSNotificationCenter defaultCenter] postNotificationName:@"choiceStationNotification" object:self];
        //
        //        }
        //
        //[mapView selectAnnotation:view.annotation animated:true];
    }
    
}
- (void)saveDefaultData:(NSDictionary *)dataD {
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithDictionary:dataD[@"station"]];
    for (NSString*s in [dataDic allKeys]) {
        if ([dataDic[s] isEqual:[NSNull null]]) {
            [dataDic setObject:@"" forKey:s];
        }
    }
    NSMutableDictionary *secDic = [[NSMutableDictionary alloc]initWithDictionary:dataD[@"securityStatus"]];
    for (NSString*s in [secDic allKeys]) {
        if ([secDic[s] isEqual:[NSNull null]]) {
            [secDic setObject:@"" forKey:s];
        }
    }
    NSMutableDictionary *equDic = [[NSMutableDictionary alloc]initWithDictionary:dataD[@"equipmentStatus"]];
    for (NSString*s in [equDic allKeys]) {
        if ([equDic[s] isEqual:[NSNull null]]) {
            [equDic setObject:@"" forKey:s];
        }
    }
    NSMutableDictionary *envDic = [[NSMutableDictionary alloc]initWithDictionary:dataD[@"environmentStatus"]];
    for (NSString*s in [envDic allKeys]) {
        if ([envDic[s] isEqual:[NSNull null]]) {
            [envDic setObject:@"" forKey:s];
        }
    }
    NSMutableDictionary *powerDic = [[NSMutableDictionary alloc]initWithDictionary:dataD[@"powerStatus"]];
    for (NSString*s in [powerDic allKeys]) {
        if ([powerDic[s] isEqual:[NSNull null]]) {
            [powerDic setObject:@"" forKey:s];
        }
    }
    
    
      
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataDic forKey:@"station"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    [userDefaults1 setObject:secDic forKey:@"securityStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSUserDefaults *userDefaults2 = [NSUserDefaults standardUserDefaults];
    [userDefaults2 setObject:equDic forKey:@"equipmentStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSUserDefaults *userDefaults3 = [NSUserDefaults standardUserDefaults];
    [userDefaults3 setObject:envDic forKey:@"environmentStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSUserDefaults *userDefaults4 = [NSUserDefaults standardUserDefaults];
    [userDefaults4 setObject:powerDic forKey:@"powerStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController.tabBarController setSelectedIndex:2];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"choiceStationNotification" object:self];
    
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
    //    [self removeClusters];
    [self addStationHealthBtn];
    [self updateClusters];
    
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
    UIButton * healthBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 82-10, FrameWidth(560),82, 80)];
    [healthBtn setBackgroundImage:[UIImage imageNamed:@"stationhealth"] forState:UIControlStateNormal];
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
- (void)showAlertMessage:(NSMutableArray *)array {
    
    if (![UserManager shareUserManager].loginSuccess ) {
        return;
    }
    self.StationAlertArray = array;
    
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //if( ![[userDefaults objectForKey:@"warningId"] isEqualToString:self.StationItem[0].warningId]){
    
    self.AlertView = [[UIView alloc]init];
    //    self.AlertView.frame = CGRectMake(FrameWidth(80),FrameWidth(150),  FrameWidth(480), FrameWidth(600));
    
    self.AlertView.frame = CGRectMake(WIDTH_SCREEN + FrameWidth(80),FrameWidth(150) + NAVIGATIONBAR_HEIGHT,  FrameWidth(500), FrameWidth(630));
    self.AlertView.layer.cornerRadius = 9.0;
    UIImageView * explanAll = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warn_bg"]];
    explanAll.frame =  CGRectMake(0,FrameWidth(30),  FrameWidth(480), FrameWidth(585));
    //CGRectMake(0, 0 ,  FrameWidth(480), FrameWidth(585));
    [self.AlertView addSubview:explanAll];
    //关闭
    UIButton * closeBtn = [[UIButton alloc]initWithFrame:CGRectMake( FrameWidth(440), 0,FrameWidth(60), FrameWidth(60))];
    //[[UIButton alloc]initWithFrame:CGRectMake( FrameWidth(440), -FrameWidth(20),FrameWidth(60), FrameWidth(60))];
    //[closeBtn setBackgroundImage:[UIImage imageNamed:@"warn_close"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"warn_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.AlertView addSubview:closeBtn];
    //标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,explanAll.frameWidth, FrameWidth(80))];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = FontBSize(20);
    titleLabel.text = @"告警提醒";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [explanAll addSubview:titleLabel];
    
    //提醒列表
    _stationAlertView = [[UITableView alloc] initWithFrame:CGRectMake(FrameWidth(20),FrameWidth(150) , explanAll.frameWidth -FrameWidth(60), FrameWidth(340))];
    _stationAlertView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _stationAlertView.dataSource = self;
    _stationAlertView.delegate = self;
    _stationAlertView.separatorStyle =NO;
    
    
    
    // 注册重用Cell
    [_stationAlertView registerNib:[UINib nibWithNibName:NSStringFromClass([WarnTableViewCell class]) bundle:nil] forCellReuseIdentifier:_FrameCellID];//cell的class
    //_stationTabView.separatorStyle = NO;
    [self.AlertView addSubview:_stationAlertView];
    
    [_stationAlertView reloadData];
    
    //查看和确认
    
    // UIButton * showDetailBtn = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(80), FrameWidth(510), FrameWidth(150), FrameWidth(45))];
    UIButton * showDetailBtn = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(160), FrameWidth(520), FrameWidth(150), FrameWidth(45))];
    [showDetailBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [showDetailBtn addTarget:self action:@selector(confirmMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [showDetailBtn.layer setCornerRadius:FrameWidth(10)]; //设置矩形四个圆角半径
    [showDetailBtn.layer setBorderWidth:1.5]; //边框宽度
    [showDetailBtn setTitleColor:FrameColor(100, 170, 250) forState:UIControlStateNormal];//title color
    showDetailBtn.titleLabel.font = FontSize(15);
    [showDetailBtn.layer setBorderColor:[UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1].CGColor];//边框颜色
    [self.AlertView addSubview:showDetailBtn];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.AlertView ];
    //    self.AlertView.hidden = YES;
    
    //动画出现
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.AlertView.frame = CGRectMake(FrameWidth(80),FrameWidth(150)+ NAVIGATIONBAR_HEIGHT,  FrameWidth(480), FrameWidth(600));
        self.AlertView.hidden = NO;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
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
            
            self.AlarmView.frame = CGRectMake(WIDTH_SCREEN + FrameWidth(80),FrameWidth(250),  FrameWidth(500), FrameWidth(630));
            
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
                
                self.AlarmView.frame = CGRectMake(FrameWidth(80),FrameWidth(250),  FrameWidth(480), FrameWidth(600));
                
                
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
                
                self.PatrolRemindView.frame = CGRectMake(FrameWidth(80),FrameWidth(150),  FrameWidth(530), FrameWidth(600));
                
                
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
    }else if(_stationAlertView == tableView){
        
        
        return UITableViewAutomaticDimension;
    }
    return FrameWidth(90);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.PatrolRemindTabView == tableView){
        return self.PatrolRemindItem.count;
    }else if(_stationTabView == tableView){
        return self.StationItem.count;
    }else if(_stationAlertView == tableView){
        return self.StationAlertArray.count;
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
    }else if(_stationAlertView == tableView){
        // 1.2 去缓存池中取Cell
        WarnTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:_FrameCellID];
        cell.contentView.backgroundColor =[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        cell.backgroundColor = [UIColor clearColor];//;
        // cell = [tableView dequeueReusableCellWithIdentifier:ID];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        NSString *string = self.StationAlertArray[indexPath.row];
        cell.currentRow = indexPath.row;
        cell.String = string;
        
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
    //动画出现
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.AlarmView.frame = CGRectMake(WIDTH_SCREEN + FrameWidth(80),FrameWidth(150),  FrameWidth(530), FrameWidth(600));
    } completion:^(BOOL finished) {
        //self.AlarmView = nil;
        //[self.AlarmView removeFromSuperview];
    }];
}
-(void)closeAlertView{
    //动画出现
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.AlertView.frame = CGRectMake(WIDTH_SCREEN + FrameWidth(80),FrameWidth(150)+ NAVIGATIONBAR_HEIGHT,  FrameWidth(530), FrameWidth(600));
    } completion:^(BOOL finished) {
        self.AlertView.hidden = YES;
        self.AlertView = nil;
        [self.AlertView removeFromSuperview];
    }];
}
-(void)confirmMessage {
    [self closeAlertView];
}
-(void)closePatrolRemind{
    //动画出现
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.PatrolRemindView.frame = CGRectMake(WIDTH_SCREEN + FrameWidth(80),FrameWidth(150),  FrameWidth(530), FrameWidth(600));
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
    //    AlarmDetailInfoController  * PersonalMsg = [[AlarmDetailInfoController alloc] init];
    PatrolEquipmentController *PersonalMsg = [[PatrolEquipmentController alloc] init];
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
//更新聚合状态
- (void)updateClusters {
    _clusterZoom = (NSInteger)_mapView.zoomLevel;
    if(_clusterZoom >21) {
        return;
    }
    @synchronized(_clusterCaches) {
        __block NSMutableArray *clusters = [_clusterCaches objectAtIndex:(_clusterZoom - 3)];
        
        
        if (clusters.count > 0) {
            [_mapView removeAnnotations:_mapView.annotations];
            [_mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                ///获取聚合后的标注
                NSArray *array = [_clusterManager getClusters:_clusterZoom];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    for (int i=0;i<[array count];i++) {
                        
                        BMKCluster *item=array[i];
                        if ((NSInteger)_mapView.zoomLevel >=20 ) {
                            if (item.clusterItems.count >1) {
                                for (BMKClusterItem *itemDetail in item.clusterItems) {
                                    ClusterAnnotation *annotation = [[ClusterAnnotation alloc] init];
                                    annotation.coordinate = itemDetail.coor;
                                    annotation.size = 1;
                                    NSMutableArray *arr = [NSMutableArray array];
                                    [arr addObject:itemDetail];
                                    annotation.dataArr = arr;
                                    [clusters addObject:annotation];
                                }
                            }
                        }else {
                            ClusterAnnotation *annotation = [[ClusterAnnotation alloc] init];
                            annotation.coordinate = item.coordinate;
                            annotation.size = item.size;
                            annotation.dataArr = item.clusterItems;
                            [clusters addObject:annotation];
                        }
                        
                    }
                    
                    [_mapView removeAnnotations:_mapView.annotations];
                    [_mapView addAnnotations:clusters];
                    
                    
                });
            });
        }
    }
}

/**
 *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 *@param mapview 地图View
 *@param status 此时地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    if (_clusterZoom != 0 && _clusterZoom != (NSInteger)mapView.zoomLevel) {
        [self updateClusters];
    }
}
- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 97+Height_StatusBar-20 +50)];
        _topBgView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        UIView *topView= [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 97+Height_StatusBar-20 )];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
        [_topBgView addSubview:topView];
        topView.backgroundColor = [UIColor colorWithHexString:@"#005BD0"];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = topView.bounds;
        maskLayer.path = maskPath.CGPath;
        topView.layer.mask = maskLayer;
        
        UILabel *titleLabel = [[UILabel alloc ]init];
        [topView addSubview:titleLabel];
        titleLabel.text = @"我的台站";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 1;
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(topView.mas_centerX);
            make.width.equalTo(@120);
            make.height.equalTo(@27);
            make.bottom.equalTo(topView.mas_bottom).offset(-42);
        }];
        
    }
    return _topBgView;
}

- (FrameScrollList  *)scrollListView {
    if (!_scrollListView) {
        _scrollListView = [[FrameScrollList alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT-97, SCREEN_WIDTH, SCREEN_HEIGHT -(62 + Height_StatusBar))];
        
        _scrollListView.watchVideo = ^(NSString * _Nonnull stationCode, NSString * _Nonnull stationName) {
            StationVideoListController  *StationVideo = [[StationVideoListController alloc] init];
            StationVideo.station_code = stationCode;
            StationVideo.station_name = stationName;
            [self.navigationController pushViewController:StationVideo animated:YES];
        };
        
        _scrollListView.sliderDown = ^(BOOL isSliderDown) {
            if (isSliderDown) {
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                
                self.bottomAlertView.hidden = NO;
                [self.scrollListView setHidden:YES];
                [self.topBgView setHidden:YES];
                
                [self.carouselView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_top).offset(20 + Height_StatusBar);
                    make.left.equalTo(self.view.mas_left).offset(20);
                    //                make.right.equalTo(self.view.mas_right).offset(20);
                    make.width.equalTo(@(SCREEN_WIDTH-40));
                    make.height.equalTo(@50);
                }];
            }
        };
    }
    return _scrollListView;
}
- (KG_FrameBottomAlertView *)bottomAlertView {
    if (!_bottomAlertView) {
        _bottomAlertView = [[KG_FrameBottomAlertView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT-97, SCREEN_WIDTH, 97)];
        if (self.currentStationDic.count >0) {
            _bottomAlertView.dataDic = self.currentStationDic;
        }
        _bottomAlertView.watchVideo = ^(NSString * _Nonnull stationCode, NSString * _Nonnull stationName) {
               StationVideoListController  *StationVideo = [[StationVideoListController alloc] init];
               StationVideo.station_code = stationCode;
               StationVideo.station_name = stationName;
               [self.navigationController pushViewController:StationVideo animated:YES];
           };
        UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [self.bottomAlertView addGestureRecognizer:recognizer];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bottomAlertView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        
        maskLayer.frame = _bottomAlertView.bounds;
        
        maskLayer.path = maskPath.CGPath;
        _bottomAlertView.layer.mask = maskLayer;
        
        UIView *theView = [[UIView alloc]initWithFrame:CGRectMake(0, _bottomAlertView.frame.size.height - 2, SCREEN_HEIGHT, 2)];
        theView.layer.masksToBounds = NO;
        theView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        theView.layer.shadowColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:0.5].CGColor;
        theView.layer.shadowOffset = CGSizeMake(0,0);
        theView.layer.shadowOpacity = 1;
        theView.layer.shadowRadius = 4;
        [_bottomAlertView addSubview:theView];
    }
    return _bottomAlertView;
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
@end
