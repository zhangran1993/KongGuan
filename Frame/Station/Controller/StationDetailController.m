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
#import "KG_SecView.h"
#import "KG_EnvView.h"
#import "KG_PowView.h"
#import "KG_StationDetailModel.h"
#import "KG_SecondFloorViewController.h"
#import "KG_MachineStationModel.h"
#import "KG_KongTiaoViewController.h"
#import "KG_CommonDetailViewController.h"
#import "KG_ZhiTaiStationModel.h"
#import "LoginViewController.h"
#import "UIViewController+YQSlideMenu.h"
#import <UIButton+WebCache.h>
#import "KG_CommonWebAlertView.h"
#import "KG_MineViewController.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface StationDetailController ()<UITableViewDataSource,UITableViewDelegate,ParentViewDelegate,UINavigationControllerDelegate>

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
@property  (strong,nonatomic) NSMutableArray *roomList;
@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;
@property NSMutableArray *objects1;
@property NSMutableArray *objects10;
@property NSMutableArray *objects2;
@property (nonatomic, strong) NSMutableArray *objects3;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *statusArray;
@property BOOL isRefresh;
@property int a;

@property  (assign,nonatomic) int roomHeight;
/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property(nonatomic) UITableView *tableview;
@property(nonatomic) UITableView *filterTabView;
@property(nonatomic) UIButton *rightButton;
@property  (assign,nonatomic) UIFont* btnFont;
@property (nonatomic, strong) UIView *runView;
/**  标题栏 */
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView *navigationView;
//安防
@property (strong, nonatomic) KG_SecView *secView;
//环境
@property (strong, nonatomic) KG_EnvView *envView;
//动力
@property (strong, nonatomic) KG_PowView *powerView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableDictionary *dataDic;
//天气
@property (strong, nonatomic) NSDictionary *currentStationDic;
@property (strong, nonatomic) NSDictionary *weatherDic;
@property (strong, nonatomic) KG_StationDetailModel *dataModel;

@property (strong, nonatomic) UIImageView *anfangImage;
@property (strong, nonatomic) UILabel *anfangNumLalbel;
@property (strong, nonatomic) UIImageView *envImage;
@property (strong, nonatomic) UILabel *envNumLalbel;
@property (strong, nonatomic) UIImageView *powerImage;
@property (strong, nonatomic) UILabel *powerNumLabel;

@property (strong, nonatomic) NSMutableArray *temArray;
@property (strong, nonatomic) UIImageView *topImage1;


@property(strong,nonatomic)   NSArray *stationArray;
@property(strong,nonatomic)   UITableView *stationTabView;

@property (nonatomic, strong) UIView *tableHeadView;
@property (strong, nonatomic) UIButton *leftIconImage;

@property (strong, nonatomic) KG_CommonWebAlertView *webAlertView;
@property (nonatomic, copy) NSString *hxStr;
@property (nonatomic, copy) NSString *txStr;


@property (nonatomic, assign) BOOL       pushToUpPage; //这个字段用来判断是否是从顶部下拉到空管设备页面，使其只能跳转一次
@end

@implementation StationDetailController
#pragma mark - 全局常量

- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(20),NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshZhiHuanData) name:@"refreshZhiHuanData" object:nil];
      
    [super viewDidLoad];
    [self createData];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    if (currDic.count) {
        [self.rightButton setTitle:safeString(currDic[@"alias"]) forState:UIControlStateNormal];
    }
}

- (void)refreshZhiHuanData {
    
    [self loadData];
    
    [self queryStationDetailData];
}

- (void)createData {
    
    self.tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100 +31 +NAVIGATIONBAR_HEIGHT)];
    
   
    float moreheight = ZNAVViewH;
    if(HEIGHT_SCREEN == 812){
        moreheight = FrameWidth(280);
    }
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,WIDTH_SCREEN, HEIGHT_SCREEN)];
    self.tableview.estimatedRowHeight = 0;
    self.tableview.estimatedSectionHeaderHeight = 0;
    self.tableview.estimatedSectionFooterHeight = 0;
    self.tableview.backgroundColor = BGColor;
    if (@available(iOS 11.0, *)) {
        NSLog(@"StationDetailController viewDidLoad");
        self.tableview.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableview.tableHeaderView = self.tableHeadView;
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
    [self createNaviTopView];
    [self createTopView];
    
    [self loadData];
    self.dataModel = [[KG_StationDetailModel alloc]init];
    [self queryStationDetailData];
    
}
- (void)loadData {
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
            
            [FrameBaseRequest showMessage:@"您没有当前台站的权限"];
            [self.tabBarController setSelectedIndex:2];
            return ;
        }
        
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    //去除分割线
    //[self.view addSubview:_tableview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(gotoBottomApevent:) name:@"bottomapevent" object:nil];
    
}
- (void)createNaviTopView {
    
    self.topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100+31+NAVIGATIONBAR_HEIGHT)];
    [self.tableHeadView addSubview:self.topImage1];
//    self.topImage1.contentMode = UIViewContentModeScaleAspectFill;
    self.topImage1.image  =[UIImage imageNamed:@"machine_rs"];
//    self.topImage1.contentMode = UIViewContentModeScaleAspectFill;
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100+31+NAVIGATIONBAR_HEIGHT)];
    [self.tableHeadView addSubview:topImage];
    topImage.contentMode = UIViewContentModeScaleAspectFill;
    topImage.image  =[UIImage imageNamed:@"zhihuan_bgimage"];
    if(IS_IPHONE_X_SERIES) {
        topImage.image  =[UIImage imageNamed:@"zhihuan_bgfullimage"];
    }
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
        make.left.equalTo(self.navigationView.mas_left).offset(10);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    self.leftIconImage = [[UIButton alloc] init];
    
    [self.navigationView addSubview:self.leftIconImage];
    self.leftIconImage.layer.cornerRadius =17.f;
    self.leftIconImage.layer.masksToBounds = YES;
    [self.leftIconImage setImage:[UIImage imageNamed:@"head_blueIcon"] forState:UIControlStateNormal];
    [self.leftIconImage addTarget:self action:@selector(leftCenterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"icon"]){
        
        [self.leftIconImage sd_setImageWithURL:[NSURL URLWithString:[WebNewHost stringByAppendingString:[userDefaults objectForKey:@"icon"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_icon"]];
        
    }else {
        
        [self.leftIconImage setImage: [UIImage imageNamed:@"head_icon"] forState:UIControlStateNormal];
    }
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.titleLabel.font = FontSize(12);
    
    self.rightButton.layer.borderColor = [[UIColor colorWithHexString:@"#DFDFDF"]CGColor];
    self.rightButton.layer.borderWidth = 0.5f;
    self.rightButton.layer.cornerRadius = 12.5f;
    self.rightButton.layer.masksToBounds = YES;
    
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"黄城导航台" forState:UIControlStateNormal];
    self.rightButton.frame = CGRectMake(0,0,81,22);
    [self.rightButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0,0 )];
    [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0,0 )];
    [self.navigationView addSubview:self.rightButton];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    if (currDic.count) {
        [self.rightButton setTitle:safeString(currDic[@"alias"]) forState:UIControlStateNormal];
    }
    [self.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@81);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.height.equalTo(@22);
        make.right.equalTo(self.navigationView.mas_right).offset(-16);
    }];
    [self.leftIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationView.mas_left).offset(16);
        make.width.height.equalTo(@34);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    //单台站不可点击
    self.rightButton.userInteractionEnabled = NO;
    
}

- (void)rightAction {
    [self stationAction];
}
- (void)getTemHuiData :(NSString *) stationCode withCode:(NSString *)code{
    //    NSString *  FrameRequestURL  =  @"http://10.33.33.147:8089/intelligent/api/envRoomInfo/HCDHT/HCDHT-PDS";
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/envRoomInfo/%@/%@",stationCode,code]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.temArray = [KG_MachineStationModel mj_objectArrayWithKeyValuesArray:result[@"value"]];
        [self.tableview reloadData];
        
        
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
- (void)backButtonClick:(UIButton *)button {
    [self leftCenterButtonClick];
//    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    
}
/**
 弹出个人中心
 */
- (void)leftCenterButtonClick {
    
//    KG_MineViewController  *vc = [[KG_MineViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyingHeadNotification" object:self];
//    [self.slideMenuController showMenu];
    KG_MineViewController  *vc = [[KG_MineViewController alloc]init];
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;            //改变视图控制器出现的方式
    transition.subtype = kCATransitionFromLeft;     //出现的位置
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)createTopView{
    [self.runView removeFromSuperview];
    self.runView = nil;
    self.runView= [[UIView alloc]initWithFrame:CGRectMake(16, NAVIGATIONBAR_HEIGHT+24, SCREEN_WIDTH-32, 100)];
    [self.tableHeadView addSubview:self.runView];
    self.runView.backgroundColor = [UIColor whiteColor];
    self.runView.layer.cornerRadius = 9;
    self.runView.layer.masksToBounds = YES;
    [self.runView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableHeadView.mas_bottom);
        make.left.equalTo(self.tableHeadView.mas_left).offset(16);
        make.right.equalTo(self.tableHeadView.mas_right).offset(-16);
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
    zhihuanRunLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    zhihuanRunLabel.font = [UIFont my_font:18];
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
    anfangLalbel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    anfangLalbel.font = [UIFont my_font:14];
    anfangLalbel.numberOfLines = 1;
    [anfangLalbel sizeToFit];
    anfangLalbel.textAlignment = NSTextAlignmentLeft;
    [anfangLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runView.mas_left).offset(16);
        make.bottom.equalTo(self.runView.mas_bottom).offset(-19);
        make.width.mas_greaterThanOrEqualTo(@60);
        make.height.equalTo(@18);
    }];
    self.anfangImage = [[UIImageView alloc]init];
    self.anfangImage.image = [UIImage imageNamed:@"level_prompt"];
    [self.runView addSubview:self.anfangImage];
    [self.anfangImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(anfangLalbel.mas_centerY);
        make.left.equalTo(anfangLalbel.mas_right).offset(1);
        make.width.equalTo(@30);
        make.height.equalTo(@17);
    }];
    
    self.anfangNumLalbel = [[UILabel alloc]init];
    [self.runView addSubview:self.anfangNumLalbel];
    self.anfangNumLalbel.layer.cornerRadius = 5.f;
    self.anfangNumLalbel.layer.masksToBounds = YES;
    self.anfangNumLalbel.text = @"1";
    self.anfangNumLalbel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.anfangNumLalbel.font = [UIFont systemFontOfSize:10];
    self.anfangNumLalbel.font = [UIFont my_font:10];
    self.anfangNumLalbel.numberOfLines = 1;
    
    self.anfangNumLalbel.textAlignment = NSTextAlignmentCenter;
    [self.anfangNumLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.anfangImage.mas_right).offset(-5);
        make.bottom.equalTo(self.anfangImage.mas_top).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    UILabel *envLalbel = [[UILabel alloc]init];
    [self.runView addSubview:envLalbel];
    envLalbel.text = @"环境监测";
    envLalbel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    envLalbel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    envLalbel.font = [UIFont my_font:14];
    envLalbel.numberOfLines = 1;
    [envLalbel sizeToFit];
    envLalbel.textAlignment = NSTextAlignmentLeft;
    [envLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.runView.mas_centerX).offset(-15);
        make.bottom.equalTo(self.runView.mas_bottom).offset(-19);
        make.width.mas_greaterThanOrEqualTo(@60);
        make.height.equalTo(@18);
    }];
    self.envImage = [[UIImageView alloc]init];
    self.envImage.image = [UIImage imageNamed:@"level_prompt"];
    [self.runView addSubview:self.envImage];
    [self.envImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(envLalbel.mas_centerY);
        make.left.equalTo(envLalbel.mas_right).offset(1);
        make.width.equalTo(@30);
        make.height.equalTo(@17);
    }];
    
    self.envNumLalbel = [[UILabel alloc]init];
    [self.runView addSubview:self.envNumLalbel];
    self.envNumLalbel.text = @"1";
    self.envNumLalbel.layer.cornerRadius = 5.f;
    self.envNumLalbel.layer.masksToBounds = YES;
    self.envNumLalbel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.envNumLalbel.font = [UIFont systemFontOfSize:10];
    self.envNumLalbel.font = [UIFont my_font:10];
    self.envNumLalbel.numberOfLines = 1;
    self.envNumLalbel.backgroundColor = [self getTextColor:@""];
    self.envNumLalbel.textAlignment = NSTextAlignmentCenter;
    [self.envNumLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.envImage.mas_right).offset(-2);
        make.bottom.equalTo(self.envImage.mas_top).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    UILabel *powerLalbel = [[UILabel alloc]init];
    [self.runView addSubview:powerLalbel];
    powerLalbel.text = @"动力监测";
    powerLalbel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    powerLalbel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    powerLalbel.font = [UIFont my_font:14];
    powerLalbel.numberOfLines = 1;
    [powerLalbel sizeToFit];
    powerLalbel.textAlignment = NSTextAlignmentLeft;
    
    self.powerImage = [[UIImageView alloc]init];
    self.powerImage.image = [UIImage imageNamed:@"level_prompt"];
    [self.runView addSubview:self.powerImage];
    [self.powerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(anfangLalbel.mas_centerY);
        make.right.equalTo(self.runView.mas_right).offset(-9);
        make.width.equalTo(@30);
        make.height.equalTo(@17);
    }];
    [powerLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.powerImage.mas_left).offset(-5);
        make.bottom.equalTo(self.runView.mas_bottom).offset(-19);
        make.width.mas_greaterThanOrEqualTo(@60);
        make.height.equalTo(@18);
    }];
    self.powerNumLabel = [[UILabel alloc]init];
    [self.runView addSubview:self.powerNumLabel];
    self.powerNumLabel.text = @"1";
    self.powerNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.powerNumLabel.font = [UIFont systemFontOfSize:10];
    self.powerNumLabel.font = [UIFont my_font:10];
    self.powerNumLabel.numberOfLines = 1;
    self.powerNumLabel.layer.cornerRadius = 5.f;
    self.powerNumLabel.layer.masksToBounds = YES;
    self.powerNumLabel.backgroundColor = [self getTextColor:@""];
    self.powerNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.powerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.powerImage.mas_right).offset(-5);
        make.bottom.equalTo(self.powerImage.mas_top).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
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
    [self loadData];
      
    [self queryStationDetailData];
    [self.tableview reloadData];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    if (currDic.count) {
        [self.rightButton setTitle:safeString(currDic[@"alias"]) forState:UIControlStateNormal];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"icon"]){
        
        [self.leftIconImage sd_setImageWithURL:[NSURL URLWithString:[WebNewHost stringByAppendingString:[userDefaults objectForKey:@"icon"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_icon"]];
    }else {
        
        [self.leftIconImage setImage:[UIImage imageNamed:@"head_icon"] forState:UIControlStateNormal] ;
    }
}


- (void)refreshData {
    //设备监测
    NSDictionary *secDic = self.dataModel.securityStatus;
    if (isSafeDictionary(secDic)) {
        if([secDic[@"status"] isEqualToString:@"0"]){
            self.anfangImage.image = [UIImage imageNamed:@"level_normal"];
        }else if([secDic[@"status"] isEqualToString:@"3"]){
            self.anfangImage.image = [UIImage imageNamed:@"level_normal"];
        }else if([secDic[@"status"] isEqualToString:@"1"]){
            self.anfangImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",secDic[@"level"]]]];
            self.anfangNumLalbel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",secDic[@"level"]]];
            self.anfangNumLalbel.text = [NSString stringWithFormat:@"%@",secDic[@"num"]];
            
        }else{
            self.anfangImage.image = [UIImage imageNamed:@"level_normal"];
        }
        if ([secDic[@"num"] intValue] == 0) {
            self.anfangNumLalbel.hidden = YES;
        }else {
            self.anfangNumLalbel.hidden =NO;
        }
    }
    
    
    NSDictionary *envDic = self.dataModel.environmentStatus;
    if (isSafeDictionary(envDic)) {
        if([envDic[@"status"] isEqualToString:@"0"]){
            
            self.envImage.image = [UIImage imageNamed:@"level_normal"];
        }else if([envDic[@"status"] isEqualToString:@"3"]){
            
            self.envImage.image = [UIImage imageNamed:@"level_normal"];
        }else if([envDic[@"status"] isEqualToString:@"1"]){
            self.envImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",envDic[@"level"]]]];
            self.envNumLalbel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",envDic[@"level"]]];
            self.envNumLalbel.text = [NSString stringWithFormat:@"%@",envDic[@"num"]];
            
        }else{
            self.envImage.image = [UIImage imageNamed:@"level_normal"];
        }
        if ([envDic[@"num"] intValue] == 0) {
            self.envNumLalbel.hidden = YES;
        }else {
            self.envNumLalbel.hidden =NO;
        }
    }
    NSDictionary *powDic = self.dataModel.powerStatus;
    if (isSafeDictionary(powDic)) {
        if([powDic[@"status"] isEqualToString:@"0"]){
            
            self.powerImage.image = [UIImage imageNamed:@"level_normal"];
        }else if([powDic[@"status"] isEqualToString:@"3"]){
            self.powerImage.image = [UIImage imageNamed:@"level_normal"];
        }else if([powDic[@"status"] isEqualToString:@"1"]){
            self.powerImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",powDic[@"level"]]]];
            self.powerNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",powDic[@"level"]]];
            self.powerNumLabel.text = [NSString stringWithFormat:@"%@",powDic[@"num"]];
        }else{
            self.powerImage.image = [UIImage imageNamed:@"level_normal"];
        }
        if ([powDic[@"num"] intValue] == 0) {
            self.powerNumLabel.hidden = YES;
        }else {
            self.powerNumLabel.hidden =NO;
        }
        
    }
    [self.tableview reloadData];
}
//获取某个台站详情页接口：

- (void)queryStationDetailData{
    
    NSDictionary *dic = [UserManager shareUserManager].currentStationDic;
    //    NSString *FrameRequestURL = [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/api/stationEnvInfo/%@",dic[@"code"]];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/stationEnvInfo/%@",dic[@"code"]]];
    //    FrameRequestURL = @"http://10.33.33.147:8089/intelligent/api/stationEnvInfo/35TXFC";
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
            if(safeString(_stationDetail[@"station"][@"thumbnail"]).length >0 ){
                _imageUrl= _stationDetail[@"station"][@"thumbnail"];//
            }
            
            [self.topImage1 sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,_imageUrl]] placeholderImage:[UIImage imageNamed:@"machine_rs"] ];
          
            
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
        [self.dataModel mj_setKeyValues:result[@"value"]];
        [self refreshData];
        [self queryWeatherData:self.dataModel.station[@"latitude"] withLon:self.dataModel.station[@"longitude"]];
        if (_objects0.count >0) {
           
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            if ([userdefaults objectForKey:@"zhihuanImage"]) {
                
                NSString *ss = [userdefaults objectForKey:@"zhihuanImage"];
                for (NSDictionary *dd in _objects0) {
                    if ([safeString(dd[@"code"]) isEqualToString:ss]) {
                        [self getTemHuiData:safeString(dd[@"stationCode"]) withCode:safeString(dd[@"code"])];
                    }
                }
            }else {
                 [self getTemHuiData:[_objects0 firstObject][@"stationCode"] withCode:[_objects0 firstObject][@"code"]];
            }
           
        }else {
            
            [self.temArray removeAllObjects];
            
        }
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
    
}

//展示navigation背景色
-(void)showNavigation{
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
}




#pragma mark--上传用户使用情况的接口，这个接口在台站管理页面、首页每次进入调用一次
- (void)dataReport {
    //    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/dataReport/%@",@"stationManagement"]];
    //    [FrameBaseRequest postWithUrl:FrameRequestURL param:nil success:^(id result) {
    //        NSInteger code = [[result objectForKey:@"errCode"] intValue];
    //        if(code != 0){
    //            [FrameBaseRequest showMessage:[result objectForKey:@"errMsg"]];
    //            return ;
    //        }
    //        NSLog(@"请求成功");
    //    } failure:^(NSError *error) {
    //        [FrameBaseRequest showMessage:@"网络链接失败"];
    //        return ;
    //    }];
}







#pragma mark - private methods 私有方法

- (void)setupTable{
    
    
    //    _station_code = @"S5";
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/api/stationInfo/%@/%@",_airport,_station_code]];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
    
    
    
}

-(void)getWeather{
    //    http://10.33.33.147:8089/intelligent/api/weather/36.317888/120.111424/
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/weather/%@/%@/",_latitude,_longitude]];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
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
    if(tableView == self.stationTabView){
        
        return 40;
    }
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
    }else if(tableView == self.stationTabView){
        return self.stationArray.count;
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
            titleLabel.font = [UIFont my_font:16];
            [cell addSubview:titleLabel];
        }else{
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(80), 0, FrameWidth(220), FrameWidth(54))];
            titleLabel.text = item.alias;
            titleLabel.font =  FontSize(15);
            titleLabel.font = [UIFont my_font:15];
            [cell addSubview:titleLabel];
            
            UIImageView *dot = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(55), FrameWidth(20), FrameWidth(12), FrameWidth(12))];
            dot.image = [UIImage imageNamed:@"station_dian"];
            [cell addSubview:dot];
            
        }
        
        return cell;
    }else if(tableView == self.stationTabView){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        KG_ZhiTaiStationModel *model = self.stationArray[indexPath.row];
        cell.textLabel.text = safeString(model.name) ;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        
        return cell;
        
    }
    
    
    UITableViewCell *thiscell = [[UITableViewCell alloc] init];
    thiscell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    thiscell.backgroundColor = BGColor;
    if (!_stationDetail||_stationDetail == nil||[_stationDetail isEqual:[NSNull null]]) {
        NSLog(@"_stationDetail == nil ");
        return thiscell;
    }
    int roH = 0;
    for (int i=0; i<self.dataModel.roomList.count; i++) {
        
        if(safeString(self.dataModel.roomList[i][@"alias"]).length >5) {
          
            roH += 50;
        }else {
            
           
            roH +=30;
        }
    }
        if (roH +51 >241) {
            self.roomHeight =  51 + roH+ 20;
        }else {
            self.roomHeight = 241;
        }

    UIView *bgView = [[UIView alloc] init];
    
    bgView.frame = CGRectMake(16,10,SCREEN_WIDTH -32,self.roomHeight);
    
    bgView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    bgView.layer.cornerRadius = 9;
    bgView.layer.shadowColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:245/255.0 alpha:1.0].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,2);
    bgView.layer.shadowOpacity = 1;
    bgView.layer.shadowRadius = 2;
    [thiscell addSubview:bgView];
    
    UILabel  *leftTitle = [[UILabel alloc]init];
    leftTitle.text = @"机房实时视频";
    leftTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    leftTitle.font = [UIFont my_font:16];
    leftTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    [bgView addSubview:leftTitle];
    leftTitle.numberOfLines = 1;
    leftTitle.textAlignment = NSTextAlignmentLeft;
    [leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(16);
        make.top.equalTo(bgView.mas_top).offset(17);
        make.width.equalTo(@180);
        make.height.equalTo(@22);
    }];
    
    
    //大图
    
    float viewHeight =128;
    int widthh = SCREEN_WIDTH - 32 - 16- 73-7 -16;
    
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 225, WIDTH_SCREEN, viewHeight)];
    view3.backgroundColor = [UIColor whiteColor];
    //    [thiscell addSubview:view3];
    
    
    NSString *stationString = @"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    UIImageView *BigImg = [[UIImageView alloc]init];
    
    BigImg.contentMode = UIViewContentModeScaleAspectFit;
    
    
    
    UIView *bgImage = [[UIView alloc] init];
    bgImage.frame = CGRectMake(96,51,231,150);
    
    bgImage.layer.backgroundColor = [UIColor colorWithRed:237/255.0 green:242/255.0 blue:252/255.0 alpha:1.0].CGColor;
    bgImage.layer.cornerRadius = 4;
    bgImage.layer.shadowColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:245/255.0 alpha:1.0].CGColor;
    bgImage.layer.shadowOffset = CGSizeMake(0,2);
    bgImage.layer.shadowOpacity = 1;
    bgImage.layer.shadowRadius = 2;
    [bgView addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-16);
        make.width.equalTo(@(widthh));
        make.height.equalTo(@150);
        make.top.equalTo(bgView.mas_top).offset(51);
    }];
    [bgView addSubview:BigImg];//station_right
    [BigImg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(bgImage.mas_centerX);
        make.height.equalTo(@140);
        make.width.equalTo(@(widthh));
        make.top.equalTo(bgImage.mas_top).offset(5);
    }];
    UIImageView *noDataImage = [[UIImageView alloc]init];
    [bgView addSubview:noDataImage];
    [noDataImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(bgImage.mas_centerX);
        make.height.equalTo(@63);
        make.width.equalTo(@120);
        make.centerY.equalTo(bgImage.mas_centerY);
    }];
    noDataImage.image = [UIImage imageNamed:@"huan_noStationBgImage"];
    noDataImage.hidden = YES;
    if (self.dataModel.roomList.count) {
        [BigImg sd_setImageWithURL:[NSURL URLWithString:[WebNewHost stringByAppendingString:safeString(self.dataModel.roomList[0][@"picture"])]] ];
        if([userDefaults objectForKey:@"zhihuanImage"]){
            stationString = [userDefaults objectForKey:@"zhihuanImage"];
            
            for (int i=0; i<self.dataModel.roomList.count; i++) {
                
                if([stationString isEqualToString:safeString(self.dataModel.roomList[i][@"code"])]) {
                    [BigImg sd_setImageWithURL:[NSURL URLWithString: [WebNewHost stringByAppendingString:safeString(self.dataModel.roomList[i][@"picture"])]] ];
                    
                    if(safeString(self.dataModel.roomList[i][@"picture"]).length == 0){
                        
                         noDataImage.hidden = NO;
                    }
                        
                    break;
                }
            }
        }
    }
    
    
    
    
    
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn setTitle:@"查看视频" forState:UIControlStateNormal];
     [thiscell addSubview:rightBtn];
    [rightBtn setImage:[UIImage imageNamed:@"watchvideo_right"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 66, 0, 0)];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-20);
        make.bottom.equalTo(bgView.mas_bottom).offset(-8);
        make.height.equalTo(@20);
        make.width.equalTo(@70);
    }];
   
    
    
    UIView *view4 = [[UIView alloc] init];
    view4.backgroundColor = [UIColor whiteColor];
    _newHeight1 = [self setFilterBtn:view4 objects:_objects0 title:@"机房"];
    [view4 setFrame:CGRectMake(0, view3.frame.origin.y + view3.frame.size.height +1, WIDTH_SCREEN, FrameWidth(40)+_newHeight1)];
    //    [thiscell addSubview:view4];
    int num = 0;
    for (int i=0; i<self.dataModel.roomList.count; i++) {
        if([stationString isEqualToString:self.dataModel.roomList[i][@"code"]]) {
            num ++;
        }
        
    }
    float btnHeight = 0;
    for (int i=0; i<self.dataModel.roomList.count; i++) {
        UIButton *btn  =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.numberOfLines = 2;
        if(safeString(self.dataModel.roomList[i][@"alias"]).length >5) {
            
            [btn setFrame:CGRectMake(16+7, 51 + bgView.frame.origin.y + (btnHeight +10) ,83, 50)];
            btnHeight += 50;
        }else {
            
            [btn setFrame:CGRectMake(16+7, 51 + bgView.frame.origin.y + btnHeight+10 ,83, 30)];
            btnHeight +=30;
        }
        btn.tag = i+1;
        
        [thiscell addSubview:btn];
        [btn addTarget:self action:@selector(jfbtapevent:) forControlEvents:UIControlEventTouchUpInside];
        if([stationString isEqualToString:self.dataModel.roomList[i][@"code"]]) {
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2FC"]];
            [btn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
        }else {
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [btn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
        }
        if (num == 0 && i == 0) {
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2FC"]];
            [btn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
        }
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:self.dataModel.roomList[i][@"alias"] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
    }
    
    UIView *tempView = [[UIView alloc]init];
    [thiscell addSubview:tempView];
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thiscell.mas_left).offset(14);
        make.top.equalTo(bgView.mas_bottom).offset(10);
        make.width.equalTo(@((SCREEN_WIDTH -28-10)/2));
        make.height.equalTo(@92);
    }];
    UIImageView *tempCenterImage = [[UIImageView alloc]init];
    [tempView addSubview:tempCenterImage];
    tempCenterImage.image = [UIImage imageNamed:@"wendu_bgimage"];
    [tempCenterImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempView.mas_left);
        make.top.equalTo(tempView.mas_top);
        make.width.equalTo(tempView.mas_width);
        make.height.equalTo(tempView.mas_height);
    }];
    UIImageView *tempImage = [[UIImageView alloc]init];
    [tempView addSubview:tempImage];
    [tempImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempView.mas_left).offset(18);
        make.top.equalTo(tempView.mas_top).offset(22);
        make.width.equalTo(@10);
        make.height.equalTo(@14);
    }];
    tempImage.image = [UIImage imageNamed:@"temp_icon"];
    
    UILabel *tempLabel = [[UILabel alloc]init];
    tempLabel.text = @"温度";
    [tempView addSubview:tempLabel];
    tempLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    tempLabel.numberOfLines = 1;
    tempLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    tempLabel.font = [UIFont my_font:16];
    tempLabel.textAlignment = NSTextAlignmentLeft;
    [tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempImage.mas_right).offset(4);
        make.top.equalTo(tempView.mas_top).offset(19);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    
    UILabel *tempNumLabel = [[UILabel alloc]init];
    tempNumLabel.text = @"40.3";
    [tempView addSubview:tempNumLabel];
    tempNumLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    tempNumLabel.numberOfLines = 1;
    tempNumLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    tempNumLabel.font = [UIFont my_font:14];
    tempNumLabel.textAlignment = NSTextAlignmentLeft;
    [tempNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempView.mas_left).offset(30);
        make.top.equalTo(tempLabel.mas_bottom).offset(9);
        make.width.equalTo(@42);
        make.height.equalTo(@25);
    }];
    
    tempNumLabel.text = [NSString stringWithFormat:@"%.2f", [safeString(self.dataModel.station[@"temperature"]) floatValue]];
    if ([safeString(self.dataModel.station[@"temperature"]) doubleValue] == 0) {
        tempNumLabel.text = @"__";
    }
    UILabel *tempTitleLabel = [[UILabel alloc]init];
    tempTitleLabel.text = @"℃";
    [tempView addSubview:tempTitleLabel];
    tempTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    tempTitleLabel.numberOfLines = 1;
    tempTitleLabel.font = [UIFont systemFontOfSize:10];
    tempTitleLabel.font = [UIFont my_font:10];
    tempTitleLabel.textAlignment = NSTextAlignmentLeft;
    [tempTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempNumLabel.mas_right);
        make.top.equalTo(tempNumLabel.mas_top).offset(3);
        make.width.equalTo(@20);
        make.height.equalTo(@14);
    }];
    UIImageView *tempBgImage = [[UIImageView alloc]init];
    [tempView addSubview:tempBgImage];
    tempBgImage.image = [UIImage imageNamed:@"level_normal"];
    [tempBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tempView.mas_right).offset(-16);
        make.top.equalTo(tempView.mas_top).offset(20);
        make.width.equalTo(@32);
        make.height.equalTo(@17);
    }];
  
    
    
   
    if (self.temArray.count == 2) {
        for (KG_MachineStationModel *temDic  in self.temArray) {
            if ([safeString(temDic.name) isEqualToString:@"温度"]) {
                tempNumLabel.text = safeString([NSString stringWithFormat:@"%.2f",[safeString(temDic.valueAlias) floatValue]]);
                      if ([safeString(temDic.valueAlias) doubleValue] == 0) {
                          tempNumLabel.text = @"__";
                      }
                tempBgImage.image = [UIImage imageNamed:[self getLevelImage:safeString(temDic.alarmLevel)]];
                if(![safeString(temDic.alarmLevel) isEqualToString:@"0"]) {
                    tempLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
                    tempNumLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
                    tempTitleLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
                }else {
                    tempLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
                    tempNumLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
                    tempTitleLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
                }
                break;
            }
        }
    }
    UIButton *tempStatusBtn1 = [[UIButton alloc]init];
    [tempView addSubview:tempStatusBtn1];
    [tempStatusBtn1 setTitle:@"" forState:UIControlStateNormal];
    [tempStatusBtn1 addTarget:self action:@selector(tempStatusMethod:) forControlEvents:UIControlEventTouchUpInside];
    [tempStatusBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tempView.mas_right);
        make.top.equalTo(tempView.mas_top);
        make.width.equalTo(@40);
        make.height.equalTo(tempView.mas_height);
    }];
    
    
    UIButton *tempStatusBtn = [[UIButton alloc]init];
    [tempView addSubview:tempStatusBtn];
    [tempStatusBtn setImage:[UIImage imageNamed:@"temp_status"] forState:UIControlStateNormal];
    [tempStatusBtn addTarget:self action:@selector(tempStatusMethod:) forControlEvents:UIControlEventTouchUpInside];
    [tempStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tempView.mas_right).offset(-21);
        make.top.equalTo(tempBgImage.mas_bottom).offset(14);
        make.width.equalTo(@25);
        make.height.equalTo(@20);
    }];
    
    
    
    
    
    UIView *humidityView = [[UIView alloc]init];
    [thiscell addSubview:humidityView];
    [humidityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(thiscell.mas_right).offset(-14);
        make.top.equalTo(bgView.mas_bottom).offset(10);
        make.width.equalTo(@((SCREEN_WIDTH -28-10)/2));
        make.height.equalTo(@92);
    }];
    UIImageView *humidityCenterImage = [[UIImageView alloc]init];
    [humidityView addSubview:humidityCenterImage];
    humidityCenterImage.image = [UIImage imageNamed:@"shidu_bgimage"];
    [humidityCenterImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(humidityView.mas_left);
        make.top.equalTo(humidityView.mas_top);
        make.width.equalTo(humidityView.mas_width);
        make.height.equalTo(humidityView.mas_height);
    }];
    UIImageView *humidityImage = [[UIImageView alloc]init];
    [humidityView addSubview:humidityImage];
    [humidityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(humidityView.mas_left).offset(18);
        make.top.equalTo(humidityView.mas_top).offset(22);
        make.width.equalTo(@10);
        make.height.equalTo(@14);
    }];
    humidityImage.image = [UIImage imageNamed:@"humidity_icon"];
    
    UILabel *humidityLabel = [[UILabel alloc]init];
    humidityLabel.text = @"湿度";
    [humidityView addSubview:humidityLabel];
    humidityLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    humidityLabel.numberOfLines = 1;
    humidityLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    humidityLabel.font = [UIFont my_font:14];
    humidityLabel.textAlignment = NSTextAlignmentLeft;
    [humidityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(humidityImage.mas_right).offset(4);
        make.top.equalTo(humidityView.mas_top).offset(19);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    
    UILabel *humidityNumLabel = [[UILabel alloc]init];
    humidityNumLabel.text = @"40.3";
    [humidityView addSubview:humidityNumLabel];
    humidityNumLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    humidityNumLabel.numberOfLines = 1;
    humidityNumLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    humidityNumLabel.font = [UIFont my_font:14];
    humidityNumLabel.textAlignment = NSTextAlignmentLeft;
    [humidityNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(humidityView.mas_left).offset(30);
        make.top.equalTo(humidityLabel.mas_bottom).offset(9);
        make.width.equalTo(@42);
        make.height.equalTo(@25);
    }];
    humidityNumLabel.text = [NSString stringWithFormat:@"%.2f", [safeString(self.dataModel.station[@"humidity"]) floatValue]];
   
    if ([safeString(self.dataModel.station[@"humidity"]) doubleValue] == 0) {
        humidityNumLabel.text = @"__";
    }
    
    UILabel *humidityTitleLabel = [[UILabel alloc]init];
    humidityTitleLabel.text = @"%";
    [humidityView addSubview:humidityTitleLabel];
    humidityTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    humidityTitleLabel.numberOfLines = 1;
    humidityTitleLabel.font = [UIFont systemFontOfSize:10];
    humidityTitleLabel.font = [UIFont my_font:10];
    humidityTitleLabel.textAlignment = NSTextAlignmentLeft;
    [humidityTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(humidityNumLabel.mas_right);
        make.top.equalTo(humidityNumLabel.mas_top).offset(3);
        make.width.equalTo(@20);
        make.height.equalTo(@14);
    }];
    UIImageView *humidityBgImage = [[UIImageView alloc]init];
    [humidityView addSubview:humidityBgImage];
    humidityBgImage.image = [UIImage imageNamed:@"level_normal"];
    [humidityBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(humidityView.mas_right).offset(-16);
        make.top.equalTo(humidityView.mas_top).offset(20);
        make.width.equalTo(@32);
        make.height.equalTo(@17);
    }];
//    humidityBgImage.image = [UIImage imageNamed:[self getLevelImage:safeString(self.dataModel.station[@"alarmStatus"])]];
    if (self.temArray.count == 2) {
        for (KG_MachineStationModel *temDic  in self.temArray) {
            if ([safeString(temDic.name) isEqualToString:@"湿度"]) {
                humidityNumLabel.text = safeString([NSString stringWithFormat:@"%.2f",[safeString(temDic.valueAlias) floatValue]]);
                if ([safeString(temDic.valueAlias) doubleValue] == 0) {
                    humidityNumLabel.text = @"__";
                }
                humidityBgImage.image = [UIImage imageNamed:[self getLevelImage:temDic.alarmLevel]];
                if(![safeString(temDic.alarmLevel) isEqualToString:@"0"]) {
                    humidityLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
                    humidityNumLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
                    humidityTitleLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
                }else {
                    humidityLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
                    humidityNumLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
                    humidityTitleLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
                }
                break;
            }
        }
    }
//    UIImageView *humidityStatusImage = [[UIImageView alloc]init];
//    [humidityView addSubview:humidityStatusImage];
//    humidityStatusImage.image = [UIImage imageNamed:@"temp_status"];
//    [humidityStatusImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(humidityView.mas_right).offset(-21);
//        make.top.equalTo(humidityBgImage.mas_bottom).offset(14);
//        make.width.equalTo(@25);
//        make.height.equalTo(@20);
//    }];
    
    UIButton *humidityStatusBtn1 = [[UIButton alloc]init];
    [humidityView addSubview:humidityStatusBtn1];
    [humidityStatusBtn1 setTitle:@"" forState:UIControlStateNormal];
    [humidityStatusBtn1 addTarget:self action:@selector(humityStatusMethod:) forControlEvents:UIControlEventTouchUpInside];
    [humidityStatusBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(humidityView.mas_right);
        make.top.equalTo(humidityView.mas_top);
        make.width.equalTo(@40);
        make.height.equalTo(humidityView.mas_height);
    }];
    
    UIButton *humidityStatusBtn = [[UIButton alloc]init];
    [humidityView addSubview:humidityStatusBtn];
    [humidityStatusBtn setImage:[UIImage imageNamed:@"temp_status"] forState:UIControlStateNormal];
    [humidityStatusBtn addTarget:self action:@selector(humityStatusMethod:) forControlEvents:UIControlEventTouchUpInside];
    [humidityStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(humidityView.mas_right).offset(-21);
        make.top.equalTo(humidityBgImage.mas_bottom).offset(14);
        make.width.equalTo(@25);
        make.height.equalTo(@20);
    }];
    
    //环境
    self.envView = [[KG_EnvView alloc]init];
    self.envView.layer.cornerRadius = 10.f;
    self.envView.layer.masksToBounds = YES;
    
    [thiscell addSubview:self.envView];
    
    NSInteger count = 0;
    if(self.dataModel.enviromentDetails.count){
        self.envView.envArray = self.dataModel.enviromentDetails;
        
        count = self.dataModel.enviromentDetails.count;
        
    }
    self.envView.didsel = ^(NSString * _Nonnull typeString, NSDictionary * _Nonnull dic) {
        [self pushNextStep:typeString withDataDic:dic];
    };
    
    [self.envView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(thiscell.mas_right).offset(-16);
        make.left.equalTo(thiscell.mas_left).offset(16);
        make.top.equalTo(humidityView.mas_bottom).offset(6);
        make.height.equalTo(@(count *50+50));
    }];
    if (count >0) {
        
        [self.envView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(thiscell.mas_right).offset(-16);
            make.left.equalTo(thiscell.mas_left).offset(16);
            make.top.equalTo(humidityView.mas_bottom).offset(6);
            make.height.equalTo(@(count *50+50));
        }];
    }
    
    
    //动力
    
    self.powerView = [[KG_PowView alloc]init];
    self.powerView.layer.cornerRadius = 10.f;
    self.powerView.layer.masksToBounds = YES;
    
    [thiscell addSubview:self.powerView];
    
    NSInteger powCount  = 0;
    if(self.dataModel.powerDetails.count){
        self.powerView.powArray = self.dataModel.powerDetails;
        powCount = self.dataModel.powerDetails.count;
        
    }
    self.powerView.didsel = ^(NSString * _Nonnull typeString, NSDictionary * _Nonnull dic) {
        [self pushNextStep:typeString withDataDic:dic];
    };
    [self.powerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(thiscell.mas_right).offset(-16);
        make.left.equalTo(thiscell.mas_left).offset(16);
        make.top.equalTo(self.envView.mas_bottom).offset(10);
        make.height.equalTo(@(powCount *50+50));
    }];
    //安防
    self.secView = [[KG_SecView alloc]init];
    self.secView.backgroundColor = [UIColor whiteColor];
    self.secView.layer.cornerRadius = 10.f;
    self.secView.layer.masksToBounds = YES;
    [thiscell addSubview:self.secView];
    
    NSInteger secCount = 0;
    if(self.dataModel.securityDetails.count){
        self.secView.secArray = self.dataModel.securityDetails;
        secCount = self.dataModel.securityDetails.count;
        
    }
    self.secView.didsel = ^(NSString * _Nonnull typeString, NSDictionary * _Nonnull dic) {
        [self pushNextStep:typeString withDataDic:dic];
    };
    [self.secView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(thiscell.mas_right).offset(-16);
        make.left.equalTo(thiscell.mas_left).offset(16);
        make.top.equalTo(self.powerView.mas_bottom).offset(10);
        make.height.equalTo(@(secCount *50+50));
    }];
    
    
    //    //安防情况
    //    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(0,1500 , WIDTH_SCREEN, FrameWidth(74))];
    //    view5.backgroundColor = [UIColor whiteColor];
    //    [thiscell addSubview:view5];
    //
    //    UILabel *title5 = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(74))];
    //    title5.text = @"安防情况";
    //    title5.font = FontSize(18);
    //    [view5 addSubview:title5];//station_right
    //
    //    UIView *view6 = [[UIView alloc]initWithFrame:CGRectMake(0, view5.frame.origin.y + view5.frame.size.height + 1 , WIDTH_SCREEN, FrameWidth(520))];
    //    view6.backgroundColor = [UIColor whiteColor];
    //    [thiscell addSubview:view6];
    //
    //    UIView *view7 = [[UIView alloc]init];
    //
    //
    //    _objects10 = [NSMutableArray arrayWithObjects:@"temperature",@"humidity",@"immersion",@"ratproof",@"smoke",@"ups",@"electric",@"diesel",@"battery",@"电子围栏",@"红外对射",@"门禁",nil];
    //    CGFloat neworign_y = 0;
    //    if(_objects1.count > 0){
    //        for (int i=0; i<_objects1.count; ++i) {
    //            neworign_y = FrameWidth(40) + i * FrameWidth(60);
    //
    //            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(1), neworign_y - FrameWidth(15), FrameWidth(580), FrameWidth(60))];
    //            UILabel *nameLabel = [[UILabel alloc]initWithFrame:backView.bounds];
    //
    //            //            nameLabel.userInteractionEnabled = YES;
    //
    //            nameLabel.font = FontSize(17);
    //
    //            nameLabel.textColor = listGrayColor;
    //            CommonExtension * com10 = [CommonExtension new];
    //            com10.delegate = self;
    //            com10.parentViewTag = i + 100;
    //            [com10 addTouchViewParentTagClass:backView];
    //
    //            nameLabel.text = [NSString stringWithFormat:@"             %@",_objects1[i][@"name"]] ;//;
    //            [view7 addSubview:backView];
    //            [backView addSubview:nameLabel];
    //
    //
    //
    //
    //            NSString *imgIcon =  @"station_tongyong";
    //            NSString *btnIcon =  @"正常";
    //
    //
    //            NSUInteger index = [_objects10  indexOfObject:_objects1[i][@"name"]];
    //            switch (index) {
    //                case 0:
    //                    imgIcon =  @"station_wendu";
    //                    break;
    //                case 1:
    //                    imgIcon =  @"station_shidu";
    //                    break;
    //                case 2:
    //                    imgIcon =  @"station_shuijin";
    //                    break;
    //                case 3:
    //                    imgIcon =  @"station_fangshu";
    //                    break;
    //                case 4:
    //                    imgIcon =  @"station_yangan";
    //                    break;
    //                case 5:
    //                    imgIcon =  @"station_UPS";
    //                    break;
    //                case 6:
    //                    imgIcon =  @"station_shidian";
    //                    break;
    //                case 7:
    //                    imgIcon =  @"station_diesel";
    //                    break;
    //                case 8:
    //                    imgIcon =  @"station_xudian";
    //                    break;
    //                case 9:
    //                    imgIcon =  @"station_dianzi";
    //                    break;
    //                case 10:
    //                    imgIcon =  @"station_hongwai";
    //                    break;
    //                case 11:
    //                    imgIcon =  @"station_menjin";
    //                    break;
    //
    //                default:
    //                    break;
    //            }
    //
    //
    //            UIImageView *imgIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgIcon]];
    //            [imgIconView setFrame:CGRectMake(FrameWidth(30), neworign_y - FrameWidth(5), FrameWidth(40), FrameWidth(40))];
    //
    //            [view7 addSubview:imgIconView];
    //
    //            UIButton *typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(504), neworign_y, FrameWidth(60), FrameWidth(28))];
    //            typeBtn.layer.cornerRadius = 2;
    //            typeBtn.titleLabel.font = _btnFont;
    //
    //            if([_objects1[i][@"status"] isEqual:[NSNull null]]||[_objects1[i][@"status"] intValue ] == 0){
    //                btnIcon =  @"正常";
    //                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
    //            }else if([_objects1[i][@"status"] intValue ] == 1){
    //                btnIcon =  @"告警";
    //                [typeBtn setBackgroundColor:FrameColor(242, 108, 107)];
    //            }else if([_objects1[i][@"status"] intValue ] == 2){
    //                btnIcon =  @"--";
    //                [typeBtn setHidden:true];
    //                UILabel * noStatus = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(475), neworign_y, FrameWidth(60), FrameWidth(28))];
    //                noStatus.text = btnIcon;
    //                [view7 addSubview:noStatus];
    //            }else if([_objects1[i][@"status"] intValue ] == 3){
    //                btnIcon =  @"正常";//预警
    //                [typeBtn setBackgroundColor:FrameColor(252,201,84)];
    //            }else {
    //                btnIcon =  @"正常";
    //                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
    //            }
    //
    //
    //            [typeBtn setTitle: btnIcon   forState:UIControlStateNormal];
    //            typeBtn.titleLabel.textColor = [UIColor whiteColor];
    //            [view7 addSubview:typeBtn];
    //
    //        }
    //    }
    //    [view7 setFrame:CGRectMake(FrameWidth(25), FrameWidth(20), FrameWidth(590), FrameWidth(70)+neworign_y)];
    //
    //    [view6 setFrame:CGRectMake(0, view6.frame.origin.y, WIDTH_SCREEN, FrameWidth(40)+view7.frame.size.height)];
    //    view7.layer.cornerRadius = 5;
    //    view7.layer.borderWidth = 1;
    //    view7.layer.borderColor = QianGray.CGColor;
    //    [view6 addSubview:view7];
    //
    //
    //    //动力情况
    //    UIView *view8 = [[UIView alloc]initWithFrame:CGRectMake(0, view6.frame.origin.y + view6.frame.size.height + 5 , WIDTH_SCREEN, FrameWidth(74))];
    //    view8.backgroundColor = [UIColor whiteColor];
    //    [thiscell addSubview:view8];
    //
    //    UILabel *title8 = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(74))];
    //    title8.text = @"动力情况";
    //    title8.font = FontSize(18);
    //    [view8 addSubview:title8];//station_right
    //
    //    UIView *view9 = [[UIView alloc]initWithFrame:CGRectMake(0, view8.frame.origin.y + view8.frame.size.height + 1 , WIDTH_SCREEN, FrameWidth(520))];
    //    view9.backgroundColor = [UIColor whiteColor];
    //    [thiscell addSubview:view9];
    //
    //    UIView *view10 = [[UIView alloc]init];
    //
    //
    //    CGFloat neworign_y10 = 0;
    //    if(_objects2.count > 0){
    //        //NSInteger rowCount = _objects2.count;
    //        for (int i=0; i<_objects2.count; ++i) {
    //            neworign_y10 = FrameWidth(40) + i * FrameWidth(60);
    //
    //
    //            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(1), neworign_y10 - FrameWidth(15), FrameWidth(580), FrameWidth(60))];
    //            UILabel *nameLabel = [[UILabel alloc]initWithFrame:backView.bounds];
    //
    //            //            nameLabel.userInteractionEnabled = YES;
    //
    //            nameLabel.font = FontSize(17);
    //            nameLabel.textColor = listGrayColor;
    //
    //            CommonExtension * com10 = [CommonExtension new];
    //            com10.delegate = self;
    //            com10.parentViewTag = i + 200;
    //            [com10 addTouchViewParentTagClass:backView];
    //
    //            nameLabel.text = [NSString stringWithFormat:@"             %@",_objects2[i][@"name"]] ;//;
    //            [view10 addSubview:backView];
    //            [backView addSubview:nameLabel];
    //
    //
    //            UIImageView *rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(550), neworign_y10, FrameWidth(15), FrameWidth(26))];
    //            rightImg.image = [UIImage imageNamed:@"station_right"];
    //            [view10 addSubview:rightImg];//station_right
    //
    //            NSString *imgIcon =  @"station_tongyong";
    //            NSString *btnIcon =  @"正常";
    //            NSUInteger index = [_objects10  indexOfObject:_objects2[i][@"code"]];
    //            switch (index) {
    //                case 0:
    //                    imgIcon =  @"station_wendu";
    //                    break;
    //                case 1:
    //                    imgIcon =  @"station_shidu";
    //                    break;
    //                case 2:
    //                    imgIcon =  @"station_shuijin";
    //                    break;
    //                case 3:
    //                    imgIcon =  @"station_fangshu";
    //                    break;
    //                case 4:
    //                    imgIcon =  @"station_yangan";
    //                    break;
    //                case 5:
    //                    imgIcon =  @"station_UPS";
    //                    break;
    //                case 6:
    //                    imgIcon =  @"station_shidian";
    //                    break;
    //                case 7:
    //                    imgIcon =  @"station_diesel";
    //                    break;
    //                case 8:
    //                    imgIcon =  @"station_xudian";
    //                    break;
    //                case 9:
    //                    imgIcon =  @"station_dianzi";
    //                    break;
    //                case 10:
    //                    imgIcon =  @"station_hongwai";
    //                    break;
    //                case 11:
    //                    imgIcon =  @"station_menjin";
    //                    break;
    //
    //                default:
    //                    break;
    //            }
    //
    //
    //
    //
    //            UIImageView *imgIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgIcon]];
    //            [imgIconView setFrame:CGRectMake(FrameWidth(30), neworign_y10 - FrameWidth(5), FrameWidth(40), FrameWidth(40))];
    //            [view10 addSubview:imgIconView];
    //
    //            UIButton *typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(475), neworign_y10, FrameWidth(60), FrameWidth(28))];
    //            typeBtn.layer.cornerRadius = 2;
    //            typeBtn.titleLabel.font = _btnFont;
    //
    //            if([_objects2[i][@"status"] isEqual:[NSNull null]]||[_objects2[i][@"status"] intValue ] == 0){
    //                btnIcon =  @"正常";
    //                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
    //            }else if([_objects2[i][@"status"] intValue ] == 1){
    //                btnIcon =  @"告警";
    //                [typeBtn setBackgroundColor:FrameColor(242, 108, 107)];
    //            }else if([_objects2[i][@"status"] intValue ] == 2){
    //                btnIcon =  @"--";
    //                [typeBtn setHidden:true];
    //                UILabel * noStatus = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(475), neworign_y10, FrameWidth(60), FrameWidth(28))];
    //                noStatus.text = btnIcon;
    //                [view10 addSubview:noStatus];
    //            }else if([_objects2[i][@"status"] intValue ] == 3){
    //                btnIcon =  @"正常";//预警
    //                [typeBtn setBackgroundColor:FrameColor(252,201,84)];
    //            }else {
    //                btnIcon =  @"正常";
    //                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
    //            }
    //
    //
    //            [typeBtn setTitle: btnIcon   forState:UIControlStateNormal];
    //            typeBtn.titleLabel.textColor = [UIColor whiteColor];
    //            [view10 addSubview:typeBtn];
    //
    //
    //
    //
    //
    //        }
    //    }
    //    [view10 setFrame:CGRectMake(FrameWidth(25), FrameWidth(20), FrameWidth(590), FrameWidth(70)+neworign_y10)];
    //
    //    [view9 setFrame:CGRectMake(0, view9.frame.origin.y, WIDTH_SCREEN, FrameWidth(40)+view10.frame.size.height)];
    //    view10.layer.cornerRadius = 5;
    //    view10.layer.borderWidth = 1;
    //    view10.layer.borderColor = QianGray.CGColor;
    //    [view9 addSubview:view10];
    //
    //
    //    //设备情况
    //    UIView *equipview = [[UIView alloc]initWithFrame:CGRectMake(0, view9.frame.origin.y + view9.frame.size.height + 5 , WIDTH_SCREEN, FrameWidth(74))];
    //    equipview.backgroundColor = [UIColor whiteColor];
    //    [thiscell addSubview:equipview];
    //
    //    UILabel *equiptitle8 = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(74))];
    //    equiptitle8.text = @"设备情况";
    //    equiptitle8.font = FontSize(18);
    //    [equipview addSubview:equiptitle8];//station_right
    //
    //    UIView *equipview9 = [[UIView alloc]initWithFrame:CGRectMake(0, equipview.frame.origin.y + equipview.frame.size.height + 1 , WIDTH_SCREEN, FrameWidth(520))];
    //    equipview9.backgroundColor = [UIColor whiteColor];
    //    [thiscell addSubview:equipview9];
    //
    //    UIView *equipview10 = [[UIView alloc]init];
    //
    //
    //    CGFloat equipneworign_y10 = 0;
    //    if(_objects3.count > 0){
    //        for (int i=0; i<_objects3.count; ++i) {
    //            equipneworign_y10 = FrameWidth(40) + i * FrameWidth(60);
    //
    //            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(1), equipneworign_y10 - FrameWidth(15), FrameWidth(580), FrameWidth(60))];
    //            UILabel *nameLabel = [[UILabel alloc]initWithFrame:backView.bounds];
    //
    //            //            nameLabel.userInteractionEnabled = YES;
    //
    //            nameLabel.font = FontSize(17);
    //            nameLabel.textColor = listGrayColor;
    //
    //            CommonExtension * com10 = [CommonExtension new];
    //            com10.delegate = self;
    //            com10.parentViewTag = i + 300;
    //            [com10 addTouchViewParentTagClass:backView];
    //
    //            nameLabel.text = [NSString stringWithFormat:@"             %@",_objects3[i][@"name"]] ;//;
    //            [equipview10 addSubview:backView];
    //            [backView addSubview:nameLabel];
    //
    //
    //
    //            UIImageView *rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(550), equipneworign_y10, FrameWidth(15), FrameWidth(26))];
    //            rightImg.image = [UIImage imageNamed:@"station_right"];
    //            [equipview10 addSubview:rightImg];//station_right
    //
    //            NSString *imgIcon =  @"station_tongyong";
    //            NSString *btnIcon =  @"正常";
    //            NSUInteger index = [_objects10  indexOfObject:_objects3[i][@"code"]];
    //            switch (index) {
    //                case 0:
    //                    imgIcon =  @"station_wendu";
    //                    break;
    //                case 1:
    //                    imgIcon =  @"station_shidu";
    //                    break;
    //                case 2:
    //                    imgIcon =  @"station_shuijin";
    //                    break;
    //                case 3:
    //                    imgIcon =  @"station_fangshu";
    //                    break;
    //                case 4:
    //                    imgIcon =  @"station_yangan";
    //                    break;
    //                case 5:
    //                    imgIcon =  @"station_UPS";
    //                    break;
    //                case 6:
    //                    imgIcon =  @"station_shidian";
    //                    break;
    //                case 7:
    //                    imgIcon =  @"station_diesel";
    //                    break;
    //                case 8:
    //                    imgIcon =  @"station_xudian";
    //                    break;
    //                case 9:
    //                    imgIcon =  @"station_dianzi";
    //                    break;
    //                case 10:
    //                    imgIcon =  @"station_hongwai";
    //                    break;
    //                case 11:
    //                    imgIcon =  @"station_menjin";
    //                    break;
    //
    //                default:
    //                    break;
    //            }
    //
    //
    //
    //
    //            UIImageView *equipimgIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgIcon]];
    //            [equipimgIconView setFrame:CGRectMake(FrameWidth(30), equipneworign_y10 - FrameWidth(5), FrameWidth(40), FrameWidth(40))];
    //
    //            [equipview10 addSubview:equipimgIconView];
    //            /*
    //             UIButton * typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(475), neworign_y10, FrameWidth(60), FrameWidth(30))];
    //             [typeBtn setBackgroundImage:[UIImage imageNamed:btnIcon] forState:UIControlStateNormal];
    //             [view10 addSubview:typeBtn];
    //             */
    //            UIButton *typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(475), equipneworign_y10, FrameWidth(60), FrameWidth(28))];
    //            typeBtn.layer.cornerRadius = 2;
    //            typeBtn.titleLabel.font = _btnFont;
    //
    //            if([_objects3[i][@"status"] isEqual:[NSNull null]]||[_objects3[i][@"status"] intValue ] == 0){
    //                btnIcon =  @"正常";
    //                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
    //            }else if([_objects3[i][@"status"] intValue ] == 1){
    //                btnIcon =  @"告警";
    //                [typeBtn setBackgroundColor:FrameColor(242, 108, 107)];
    //            }else if([_objects3[i][@"status"] intValue ] == 2){
    //                btnIcon =  @"--";
    //                [typeBtn setHidden:true];
    //                UILabel * noStatus = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(475), equipneworign_y10, FrameWidth(60), FrameWidth(28))];
    //                noStatus.text = btnIcon;
    //                [equipview10 addSubview:noStatus];
    //            }else if([_objects3[i][@"status"] intValue ] == 3){
    //                btnIcon =  @"正常";//预警
    //                [typeBtn setBackgroundColor:FrameColor(252,201,84)];
    //            }else {
    //                btnIcon =  @"正常";
    //                [typeBtn setBackgroundColor:FrameColor(120, 203, 161)];
    //            }
    //
    //            [typeBtn setTitle: btnIcon   forState:UIControlStateNormal];
    //            typeBtn.titleLabel.textColor = [UIColor whiteColor];
    //            [equipview10 addSubview:typeBtn];
    //
    //        }
    //    }
    //    [equipview10 setFrame:CGRectMake(FrameWidth(25), FrameWidth(20), FrameWidth(590), FrameWidth(70)+equipneworign_y10)];
    //
    //    [equipview9 setFrame:CGRectMake(0, equipview9.frame.origin.y, WIDTH_SCREEN, FrameWidth(40)+equipview10.frame.size.height)];
    //    equipview10.layer.cornerRadius = 5;
    //     equipview10.layer.borderWidth = 1;
    //    equipview10.layer.borderColor = QianGray.CGColor;
    //    [equipview9 addSubview:equipview10];
    //
    //    self.weatherDic
    //天气
    UIView *bottomView =  [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secView.mas_bottom).offset(10);
        make.left.equalTo(self.secView.mas_left);
        make.right.equalTo(self.secView.mas_right);
        make.height.equalTo(@149);
    }];
    UIImageView *bottomBgImage = [[UIImageView alloc] init];
    bottomBgImage.image =[UIImage imageNamed:@"weather_sunny"];
    if (self.weatherDic.count ) {
        
        bottomBgImage.image = [UIImage imageNamed:[CommonExtension getWeatherImage:safeString(self.weatherDic[@"condition"])]];
        if ([safeString(self.weatherDic[@"condition"]) containsString:@"雨"]){
             bottomBgImage.image = [UIImage imageNamed:safeString(@"雨")];
        }else if ([safeString(self.weatherDic[@"condition"]) containsString:@"雪"]){
             bottomBgImage.image = [UIImage imageNamed:safeString(@"雪")];
        }
        if (bottomBgImage.image == nil) {
             bottomBgImage.image =[UIImage imageNamed:@"weather_sunny"];
        }
    }
    
    [bottomView addSubview:bottomBgImage];
    
    [bottomBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_bottom);
        make.left.equalTo(bottomView.mas_left);
        make.right.equalTo(bottomView.mas_right);
        make.top.equalTo(bottomView.mas_top);
    }];
    
    UIImageView *locImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loc_white"]];
    [bottomView addSubview:locImage];
    [locImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(17);
        make.width.equalTo(@15);
        make.height.equalTo(@18);
        make.top.equalTo(bottomView.mas_top).offset(17);
    }];
    
    
    UIFont *btnFont = [UIFont my_font:12];
    
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.font = [UIFont systemFontOfSize:16];
    addressLabel.font = [UIFont my_font:16];
    addressLabel.text = [_address  isEqual:[NSNull null]]?@"xxx":_address;
    addressLabel.numberOfLines = 0;
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [bottomView addSubview:addressLabel];
    addressLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locImage.mas_right).offset(5);
        make.centerY.equalTo(locImage.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@22);
    }];
    
    
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
        weat = [NSString stringWithFormat:@"%@",self.weatherDic[@"condition"]];
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
    [bottomView addSubview:tqImg];
    
    
    UILabel *qwLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(155),tqImg.lx_y + tqImg.lx_height/2.5 , FrameWidth(130), FrameWidth(60))];
    qwLabel.font = FontSize(46);
    qwLabel.font = [UIFont my_font:46];
    qwLabel.text = [self.weatherDic[@"temp"] isEqualToString:@"－－"]?@"--":[NSString stringWithFormat:@"%@",self.weatherDic[@"temp"]];
    qwLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    CGSize size =[qwLabel.text sizeWithAttributes:@{NSFontAttributeName:FontSize(35)}];
    [qwLabel sizeToFit];
    //@"13°";
    [bottomView addSubview:qwLabel];
    [qwLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(17);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-11);
//        make.width.equalTo(@56);
        make.height.equalTo(@65);
    }];
    
    UIImageView *wenduImage = [[UIImageView alloc]init];
    [bottomView addSubview:wenduImage];
    wenduImage.image = [UIImage imageNamed:@"wendu_icon"];
    wenduImage.contentMode = UIViewContentModeScaleAspectFit;
    [wenduImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_bottom).offset(-42);
        make.left.equalTo(qwLabel.mas_right);
        make.width.equalTo(@15);
        make.height.equalTo(@22);
    }];
    
    UILabel *tqLabel = [[UILabel alloc]initWithFrame:CGRectMake(size.width+FrameWidth(20), FrameWidth(20), FrameWidth(90), FrameWidth(30))];
    tqLabel.font = FontSize(14);
    tqLabel.font = [UIFont my_font:14];
    tqLabel.text = self.weatherDic[@"condition"];
    tqLabel.textAlignment = NSTextAlignmentCenter;
    tqLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [qwLabel addSubview:tqLabel];
    [tqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wenduImage.mas_right).offset(7);
        make.width.lessThanOrEqualTo(@60);
        make.height.equalTo(@20);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-43);
    }];
    [tqImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tqLabel.mas_right).offset(5);
        make.width.height.equalTo(@15);
        make.centerY.equalTo(tqLabel.mas_centerY);
    }];
    
    if(self.weatherDic.count) {
        tqImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_icon",safeString(self.weatherDic[@"condition"])]];
    }
    
    
    
    UILabel *fxLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(360), FrameWidth(40), FrameWidth(240), FrameWidth(25))];
    fxLabel.font = btnFont;
    fxLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    fxLabel.textAlignment = NSTextAlignmentLeft;
    NSString *WindD = [self.weatherDic[@"WindD"] isEqualToString:@""]?@"－－":self.weatherDic[@"windDir"];
    fxLabel.text = [NSString stringWithFormat:@"%@%@",@"风向:",WindD];
    //_stationDetail[@"weather"][@"WindD"];
    [bottomView addSubview:fxLabel];
    
    UILabel *fsLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(360), fxLabel.frame.origin.y *2, FrameWidth(240), FrameWidth(25))];
    fsLabel.font = btnFont;
    fsLabel.textAlignment = NSTextAlignmentLeft;
    fsLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    NSString *windSpeed = [self.weatherDic[@"windSpeed"] isEqualToString:@""]?@"－－":self.weatherDic[@"windSpeed"];
    fsLabel.text = [windSpeed isEqualToString:@"－－"]?[NSString stringWithFormat:@"%@%@%@",@"风速：   ",windSpeed,@""]:[NSString stringWithFormat:@"%@%@%@",@"风速: ",windSpeed,@"m/s"];
    [bottomView addSubview:fsLabel];
    
    UILabel *njdLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(360), fxLabel.frame.origin.y *3, FrameWidth(240), FrameWidth(25))];
    njdLabel.font = btnFont;
    njdLabel.textAlignment = NSTextAlignmentLeft;
    NSString *humidity = [self.weatherDic[@"humidity"] isEqualToString:@""]?@"－－":self.weatherDic[@"humidity"];
    njdLabel.text = [humidity isEqualToString:@"－－"]?[NSString stringWithFormat:@"%@%@%@",@"湿度：   ",humidity,@""]:[NSString stringWithFormat:@"%@%@%@",@"湿度: ",humidity,@"%"];
    //@"能见度：50m";
    njdLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [bottomView addSubview:njdLabel];
    
    UILabel *QNHLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(360), fxLabel.frame.origin.y *4, FrameWidth(240), FrameWidth(25))];
    QNHLabel.font = btnFont;
    QNHLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    NSString *QNH = [self.weatherDic[@"pressure"] isEqualToString:@""]?@"－－":self.weatherDic[@"pressure"];
    QNHLabel.text = [QNH isEqualToString:@"－－"]?[NSString stringWithFormat:@"%@%@%@",@"QNH：  ",QNH,@""]:[NSString stringWithFormat:@"%@%@%@",@"QNH:",QNH,@"百帕"];
    QNHLabel.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:QNHLabel];
    //风速
    [fsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-18);
        make.centerY.equalTo(wenduImage.mas_centerY);
        make.height.equalTo(@18);
        make.width.equalTo(@90);
    }];
    //QNH
    [QNHLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-18);
        make.top.equalTo(fsLabel.mas_bottom).offset(7);
        make.height.equalTo(@18);
        make.width.equalTo(@90);
    }];
    //风向
    [fxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fsLabel.mas_left);
        make.centerY.equalTo(wenduImage.mas_centerY);
        make.height.equalTo(@18);
        make.width.equalTo(@80);
    }];
    //湿度
    [njdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fxLabel.mas_right);
        make.top.equalTo(fxLabel.mas_bottom).offset(7);
        make.height.equalTo(@18);
        make.width.equalTo(@80);
    }];
    allHeight =  10 +10 +self.roomHeight +10+10 + 92 + self.dataModel.enviromentDetails.count *50 +50 + self.dataModel.powerDetails.count*50 + 50 +10+10  + self.dataModel.securityDetails.count *50 +50 +10 + 149 +50 + NAVIGATIONBAR_HEIGHT -64 ;
    return thiscell;
    
    
}
//获取某个台站天气接口：
//请求地址：/intelligent/api/weather/{lat}/{lon}/
//     其中，lat 是台站维度，lon是台站经度
//请求方式：GET
//请求返回：
//   如：http://10.33.33.147:8089/intelligent/api/weather/36.317888/120.111424/

- (void)queryWeatherData:(NSString *)lat withLon:(NSString *)lon {
    
    
    //    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/allStationList"];
    //    FrameRequestURL = @"http://10.33.33.147:8089/intelligent/api/weather/36.317888/120.111424/";
    //    FrameRequestURL = [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/api/weather/%@/%@/",lat,lon];
    //    NSLog(@"%@",FrameRequestURL);
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/weather/%@/%@/",lat,lon]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.weatherDic = result[@"value"];
        [self.tableview reloadData];
        
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

//ups 油机房 设备机房 配电室
- (void)buttonClickMethod:(UIButton *)button {
    
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
    
    [[NSUserDefaults standardUserDefaults] setObject:_objects0[nlabel.tag - 1][@"code"] forKey:@"zhihuanImage"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableview reloadData];
    
    [self getTemHuiData:_objects0[nlabel.tag - 1][@"stationCode"] withCode:_objects0[nlabel.tag - 1][@"code"]];
    
    
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

-(void)stationAction {
    
    
    NSArray *array = [UserManager shareUserManager].stationList;
    
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *stationDic in array) {
        [list addObject:stationDic[@"station"]];
    }
    self.stationArray = [KG_ZhiTaiStationModel mj_objectArrayWithKeyValuesArray:list];
    [self getStationList];
    
    
    
}


-(void)getStationList{
    
    UIViewController *vc = [UIViewController new];
    //按钮背景 点击消失
    UIButton * bgBtn = [[UIButton alloc]init];
    [vc.view addSubview:bgBtn];
    [bgBtn setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    bgBtn.alpha = 0.1;
    [bgBtn addTarget:self action:@selector(closeFrame) forControlEvents:UIControlEventTouchUpInside];
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vc.view.mas_top);
        make.left.equalTo(vc.view.mas_left);
        make.right.equalTo(vc.view.mas_right);
        make.bottom.equalTo(vc.view.mas_bottom);
    }];
    
    [vc.view addSubview:bgBtn];
    vc.view.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT -64 +44, SCREEN_WIDTH,  SCREEN_HEIGHT);
    //_vc.view.layer.cornerRadius = 4.0;
    vc.view.layer.masksToBounds = YES;
    UIImageView *topImage = [[UIImageView alloc]init];
    topImage.image = [UIImage imageNamed:@"slider_up"];
    
    [vc.view addSubview:topImage];
    //设置滚动
    self.stationTabView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -162- 16, FrameWidth(20), 162 ,294)];
    self.stationTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [vc.view addSubview:self.stationTabView];
    self.stationTabView.dataSource = self;
    self.stationTabView.delegate = self;
    self.stationTabView.separatorStyle = NO;
    [self.stationTabView reloadData];
    float xDep = NAVIGATIONBAR_HEIGHT;
    
    [self.stationTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vc.view.mas_top).offset(xDep);
        make.right.equalTo(vc.view.mas_right).offset(-16);
        make.width.equalTo(@162);
        make.height.equalTo(@311);
    }];
    self.stationTabView.layer.cornerRadius = 8.f;
    self.stationTabView.layer.masksToBounds = YES;
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stationTabView.mas_top).offset(-7);
        make.right.equalTo(vc.view.mas_right).offset(-28);
        make.width.equalTo(@25);
        make.height.equalTo(@7);
    }];
    
    
    
    
    
    
    [self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentLeft overlayDismissed:nil];
    
}
-(void)closeFrame{//消失
    
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
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
            
            //            [self setupTable];
        }
        
    }else if(tableView == self.stationTabView) {
        KG_ZhiTaiStationModel *model = self.stationArray[indexPath.row];
        NSLog(@"1");
        [UserManager shareUserManager].currentStationDic = [model mj_keyValues];
        [self.rightButton setTitle:safeString(model.name) forState:UIControlStateNormal];
        [[UserManager shareUserManager] saveStationData:[model mj_keyValues]];
        _station_name = safeString(model.name);
        _station_code = safeString(model.code);
        [self queryStationDetailData];
        [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
    }
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

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)temArray
{
    if (!_temArray) {
        _temArray = [[NSMutableArray alloc] init];
    }
    return _temArray;
}


- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
        
    }
    return _dataDic;
}

- (void)pushNextStep:(NSString *)string withDataDic:(NSDictionary *)dic {
    
    if([safeString(dic[@"name"]) isEqualToString:@"视频"]){
        
        StationVideoListController  *StationVideo = [[StationVideoListController alloc] init];
        StationVideo.station_code = _station_code;
        StationVideo.station_name = _station_name;
        [self.navigationController pushViewController:StationVideo animated:YES];
        return;
    }
    NSMutableArray *listArr = [NSMutableArray array];
    [listArr removeAllObjects];
    if ([string isEqualToString:@"sec"]) {
        
        [listArr addObjectsFromArray:self.dataModel.securityDetails];
    }else if ([string isEqualToString:@"pow"]) {
        [listArr addObjectsFromArray:self.dataModel.powerDetails];
    }else if ([string isEqualToString:@"env"]) {
        [listArr addObjectsFromArray:self.dataModel.enviromentDetails];
    }
    
    KG_CommonDetailViewController  *StationMachine = [[KG_CommonDetailViewController alloc] init];
    StationMachine.category = safeString(dic[@"code"]);
    StationMachine.machine_name = safeString(dic[@"name"]);
    StationMachine.station_name = _station_name;
    StationMachine.station_code = _station_code;
    StationMachine.engine_room_code = @"";
    StationMachine.mList = listArr;
    [self.navigationController pushViewController:StationMachine animated:YES];
    
    
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    NSLog(@"contentOffset====%f",self.tableview.contentOffset.y);
    if (self.tableview.contentOffset.y > 0) {
        float orY= self.tableview.contentOffset.y/167;
      
        self.navigationView.backgroundColor = [UIColor colorWithRed:10.f/255.f green:51.f/255.f blue:167/255.f alpha:orY];
    }else {
        self.navigationView.backgroundColor = [UIColor clearColor];
    }
    
    if (scrollView.contentOffset.y <-120) {
        NSLog(@"11111111%f",scrollView.contentOffset.y);
        if(!self.pushToUpPage) {
            self.pushToUpPage = YES;
            KG_SecondFloorViewController *vc = [[KG_SecondFloorViewController alloc]init];
            vc.BackToLastPage = ^{
                self.pushToUpPage = NO;
            };
            vc.dataModel = self.dataModel;
            CATransition* transition = [CATransition animation];
            
            transition.duration =0.4f;
            
            transition.type = kCATransitionMoveIn;
            
            transition.subtype = kCATransitionFromBottom;
            
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            
            
            [self.navigationController pushViewController:vc animated:NO];
        }
    }
    
}

//CA_EXTERN CATransitionType const kCATransitionFade
//    API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
//CA_EXTERN CATransitionType const kCATransitionMoveIn
//    API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
//CA_EXTERN CATransitionType const kCATransitionPush
//    API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
//CA_EXTERN CATransitionType const kCATransitionReveal
//    API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

/* Common transition subtypes. */
- (void)pop

{
    
    CATransition* transition = [CATransition animation];
    
    transition.duration =0.4f;
    
    transition.type = kCATransitionReveal;
    
    transition.subtype = kCATransitionFromBottom;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
    
}

//- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated
//{
////    if(viewController == self){
////        [self loadData];
////
////    }
//   //每次当navigation中的界面切换，设为空。本次赋值只在程序初始化时执行一次
//   static UIViewController *lastController = nil;
//
//   //若上个view不为空
//   if (lastController != nil)
//   {
//       //若该实例实现了viewWillDisappear方法，则调用
//       if ([lastController respondsToSelector:@selector(viewWillDisappear:)])
//       {
//           [lastController viewWillDisappear:animated];
//       }
//   }
//
//   //将当前要显示的view设置为lastController，在下次view切换调用本方法时，会执行viewWillDisappear
//   lastController = viewController;
//
//   [viewController viewWillAppear:animated];
//
//}
//

-(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}


//获取某个测点当前时间到前12个小时的历史数据接口：
//请求地址：/intelligent/atcSafeguard/getMeasureTag/{measureTag}
//     其中，measureTag是测点编码
//请求方式：GET
//请求返回：
//   如：http://10.33.33.147:8089/intelligent/atcSafeguard/getMeasureTag/HCPDS-WSD01


- (void)tempStatusMethod:(UIButton *)button {
    if(self.temArray.count == 2) {
        KG_MachineStationModel *tempDic = [self.temArray firstObject];
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/getMeasureTag/%@",safeString(tempDic.code)]];
        
        [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
            
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            NSArray *oldchartX = result[@"value"][@"EChartsX"];
            NSArray *chartY = result[@"value"][@"EChartsY"];
            NSMutableArray *chartX = [NSMutableArray arrayWithCapacity:0];
            for (NSString *cX in oldchartX) {
                if (safeString(cX).length >13) {
                    NSString *newcX = [safeString(cX) substringToIndex:13];
                    [chartX addObject:newcX];
                }
            }
            if(code  <= -1){
                
            }
            _webAlertView = nil;
            [_webAlertView removeFromSuperview];
            self.webAlertView.hidden = NO;
            NSString *sX = @"";
            NSString *sY = @"";
            if (chartX.count) {
                sX = [self arrayToJSONString:chartX];
            }
            if (chartY.count) {
                sY = [self arrayToJSONString:chartY];
            }
            NSString *url = [NSString stringWithFormat:@"EChartsX=%@&EChartsY=%@",safeString(sX),safeString(sY)];
          

            self.webAlertView.tempUrlStr =url ;
//          http://222.173.103.125:8099
     
         
         } failure:^(NSURLSessionDataTask *error)  {
            [MBProgressHUD hideHUD];
            FrameLog(@"请求失败，返回数据 : %@",error);
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
            if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
                [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
                [FrameBaseRequest logout];
                LoginViewController *login = [[LoginViewController alloc] init];
                [self.slideMenuController showViewController:login];
                return;
                
            }else if(responses.statusCode == 502){
                
            }
            //        [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        }];
    }else {
        [FrameBaseRequest showMessage:@"该温度测点不存在"];
        return;
    }
   
}

- (void)humityStatusMethod:(UIButton *)button {
    if(self.temArray.count == 2) {
        KG_MachineStationModel *humityDic = [self.temArray lastObject];

        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/getMeasureTag/%@",safeString(humityDic.code)]];

               [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {

                   NSInteger code = [[result objectForKey:@"errCode"] intValue];
                   if(code  <= -1){

                   }
                   NSArray *oldchartX = result[@"value"][@"EChartsX"];
                   NSArray *chartY = result[@"value"][@"EChartsY"];
                   NSMutableArray *chartX = [NSMutableArray arrayWithCapacity:0];
                   for (NSString *cX in oldchartX) {
                       if (safeString(cX).length >13) {
                           NSString *newcX = [safeString(cX) substringToIndex:13];
                           [chartX addObject:newcX];
                       }
                   }
                   _webAlertView = nil;
                   [_webAlertView removeFromSuperview];
                   self.webAlertView.hidden = NO;
                   NSString *sX = @"";
                   NSString *sY = @"";
                   if (chartX.count) {
                       sX = [self arrayToJSONString:chartX];
                   }
                   if (chartY.count) {
                       sY = [self arrayToJSONString:chartY];
                   }
                   NSString *url = [NSString stringWithFormat:@"EChartsX=%@&EChartsY=%@",safeString(sX),safeString(sY)];

                   self.webAlertView.humityUrlStr =url ;

               } failure:^(NSURLSessionDataTask *error)  {
                   [MBProgressHUD hideHUD];
                   FrameLog(@"请求失败，返回数据 : %@",error);
                   NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
                   if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
                       [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
                       [FrameBaseRequest logout];
                       LoginViewController *login = [[LoginViewController alloc] init];
                       [self.slideMenuController showViewController:login];
                       return;

                   }else if(responses.statusCode == 502){

                   }
                   return ;
               }];
    }else {
        [FrameBaseRequest showMessage:@"该湿度测点不存在"];
        return;
    }
}

- (KG_CommonWebAlertView *)webAlertView {
    if (!_webAlertView) {
        _webAlertView = [[KG_CommonWebAlertView alloc]init];
        [JSHmainWindow addSubview:_webAlertView];
        [_webAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];
    }
    return _webAlertView;
}

//数组转为json字符串
- (NSString *)arrayToJSONString:(NSArray *)array {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonTemp;
}
//
//- (void)humityStatusMethod:(UIButton *)button {
//
//
//
//    /** 创建新的队列组 **/
//    dispatch_group_t group = dispatch_group_create();
//
//    dispatch_group_enter(group);
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//
//         if(self.temArray.count == 2) {
//                KG_MachineStationModel *tempDic = [self.temArray firstObject];
//                NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/getMeasureTag/%@",safeString(tempDic.code)]];
//
//                [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
//
//                    NSInteger code = [[result objectForKey:@"errCode"] intValue];
//                    NSArray *oldchartX = result[@"value"][@"EChartsX"];
//                    NSArray *chartY = result[@"value"][@"EChartsY"];
//                    NSMutableArray *chartX = [NSMutableArray arrayWithCapacity:0];
//                    for (NSString *cX in oldchartX) {
//                        if (safeString(cX).length >13) {
//                            NSString *newcX = [safeString(cX) substringToIndex:13];
//                            [chartX addObject:newcX];
//                        }
//                    }
//                    if(code  <= -1){
//
//                    }
//
//                    NSString *sX = @"";
//                    NSString *sY = @"";
//                    if (chartX.count) {
//                        sX = [self arrayToJSONString:chartX];
//                    }
//                    if (chartY.count) {
//                        sY = [self arrayToJSONString:chartY];
//                    }
//                    NSString *url = [NSString stringWithFormat:@"EChartsHY=%@",safeString(sY)];
//
//
//                    self.hxStr = url;
//                    dispatch_group_leave(group);
//
//                } failure:^(NSURLSessionDataTask *error)  {
//                    dispatch_group_leave(group);
//                    [MBProgressHUD hideHUD];
//                    FrameLog(@"请求失败，返回数据 : %@",error);
//                    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//                    if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//                        [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
//                        [FrameBaseRequest logout];
//                        LoginViewController *login = [[LoginViewController alloc] init];
//                        [self.slideMenuController showViewController:login];
//                        return;
//
//                    }else if(responses.statusCode == 502){
//
//                    }
//                    //        [FrameBaseRequest showMessage:@"网络链接失败"];
//                    return ;
//                }];
//            }else {
//                [FrameBaseRequest showMessage:@"该温度测点不存在"];
//                return;
//            }
//
//
//    });
//
//
//    dispatch_group_enter(group);
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        if(self.temArray.count == 2) {
//              KG_MachineStationModel *humityDic = [self.temArray lastObject];
//
//              NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/getMeasureTag/%@",safeString(humityDic.code)]];
//
//                     [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
//
//                         NSInteger code = [[result objectForKey:@"errCode"] intValue];
//                         if(code  <= -1){
//
//                         }
//                         NSArray *oldchartX = result[@"value"][@"EChartsX"];
//                         NSArray *chartY = result[@"value"][@"EChartsY"];
//                         NSMutableArray *chartX = [NSMutableArray arrayWithCapacity:0];
//                         for (NSString *cX in oldchartX) {
//                             if (safeString(cX).length >13) {
//                                 NSString *newcX = [safeString(cX) substringToIndex:13];
//                                 [chartX addObject:newcX];
//                             }
//                         }
//
//                         NSString *sX = @"";
//                         NSString *sY = @"";
//                         if (chartX.count) {
//                             sX = [self arrayToJSONString:chartX];
//                         }
//                         if (chartY.count) {
//                             sY = [self arrayToJSONString:chartY];
//                         }
//                         NSString *url = [NSString stringWithFormat:@"EChartsTX=%@&EChartsTY=%@",safeString(sX),safeString(sY)];
//
//                         self.txStr = url;
//                         dispatch_group_leave(group);
//                     } failure:^(NSURLSessionDataTask *error)  {
//                         dispatch_group_leave(group);
//                         [MBProgressHUD hideHUD];
//                         FrameLog(@"请求失败，返回数据 : %@",error);
//                         NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//                         if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//                             [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
//                             [FrameBaseRequest logout];
//                             LoginViewController *login = [[LoginViewController alloc] init];
//                             [self.slideMenuController showViewController:login];
//                             return;
//
//                         }else if(responses.statusCode == 502){
//
//                         }
//                         return ;
//                     }];
//          }else {
//              [FrameBaseRequest showMessage:@"该湿度测点不存在"];
//              return;
//          }
//
//
//    });
//
//
//
//    dispatch_group_enter(group);
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        //        NSString *  FrameRequestURL = @"http://10.33.33.147:8089/intelligent/atcStation/355b1f15d75e49c7863eb5f422851e3c";
//        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcStation/355b1f15d75e49c7863eb5f422851e3c"]];
//        [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
//            NSInteger code = [[result objectForKey:@"errCode"] intValue];
//            if(code  <= -1){
//                [FrameBaseRequest showMessage:result[@"errMsg"]];
//                return ;
//            }
//            dispatch_group_leave(group);
//
//        } failure:^(NSURLSessionDataTask *error)  {
//            FrameLog(@"请求失败，返回数据 : %@",error);
//
//            /** 离开当前任务组 **/
//            dispatch_group_leave(group);
//            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//            if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
//                return;
//
//            }else if(responses.statusCode == 502){
//
//            }
//            [FrameBaseRequest showMessage:@"网络链接失败"];
//            return ;
//
//        }];
//
//
//    });
//
//
//
//
//    /** 队列组所有任务都结束以后，通知队列组在主线程进行其他操作 **/
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        //界面刷新
//        NSLog(@"请求完成");
//        [self refreshView];
//    });
//
//
//}

- (void)refreshView {
    
    _webAlertView = nil;
    [_webAlertView removeFromSuperview];
    self.webAlertView.hidden = NO;
    self.webAlertView.totalUrlStr = [NSString stringWithFormat:@"%@&%@&title=%@",self.txStr,self.hxStr,@"1温湿度趋势"];
}
@end

