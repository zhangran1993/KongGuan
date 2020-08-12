//
//  KG_ZhiTaiViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ZhiTaiViewController.h"
#import "KG_ZhiTaiModel.h"
#import "KG_ZhiTaiEquipView.h"
#import "KG_DMEView.h"
#import "KG_DMERightView.h"
#import "KG_ZhiTaiView.h"
#import "KG_JifangView.h"
#import "KG_RoomInfoView.h"
#import "KG_ZhiTaiBottomView.h"
#import "KG_ZhiTaiRightAlertView.h"
#import "KG_ZhiTaiBottomView.h"
#import "LoginViewController.h"
#import "KG_ZhiTaiStationModel.h"
#import "UIViewController+CBPopup.h"
#import "StationMachineDetailMoreController.h"
#import "StationVideoListController.h"
#import "KG_CommonDetailViewController.h"
#import "UIViewController+YQSlideMenu.h"
#import "KG_SecondFloorViewController.h"
#import <UIButton+WebCache.h>
#import "KG_NiTaiTuNoDataView.h"
@interface KG_ZhiTaiViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    UIView *_sliderView;
    UIScrollView *_scrollView;
}


/**  标题栏 */
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong)  UIView *navigationView;

@property (nonatomic, strong)  UIView *runView;


@property (nonatomic, strong)  UIImageView *radarImage;
@property (nonatomic, strong)  UILabel *radarNumLalbel;

@property (nonatomic, strong)  UIImageView *xindaoImage;
@property (nonatomic, strong)  UILabel *xindaoNumLalbel;

@property (nonatomic, strong)  KG_ZhiTaiModel *dataModel;
@property (nonatomic, strong)  KG_ZhiTaiEquipView *equipView;

@property (nonatomic, strong)  KG_NiTaiTuNoDataView *niTaiTuNoDataView;
@property (nonatomic, strong)  UIScrollView *bgScrollView;

@property (nonatomic, strong) KG_JifangView *jifangView;
@property (nonatomic, strong) KG_RoomInfoView *roomView;
@property (nonatomic, strong) KG_ZhiTaiBottomView *bottomView;//智态VTF
@property (nonatomic, assign) int currIndex; //设备选择
@property (nonatomic, strong) NSString * jifangString; //机房选择
@property (nonatomic, strong)  NSArray *categoryArray;
@property (nonatomic, strong)  NSMutableArray *bottomArray;
@property (nonatomic, strong)  NSMutableDictionary *bottomDic;
@property (nonatomic, strong)  UIView *sliderBgView;
@property (nonatomic, strong)  UIView *bottomBgView;
@property (nonatomic, strong) UIButton *rightButton;
@property(strong,nonatomic)   NSArray *stationArray;
@property(strong,nonatomic)   UITableView *stationTabView;

@property (nonatomic, strong) NSDictionary *dmeDic;
@property (nonatomic, strong) KG_DMEView *demView;
@property (nonatomic, strong) KG_DMERightView *demRightView;
@property (nonatomic, strong) NSDictionary *dvorDic;
@property (nonatomic, strong) KG_ZhiTaiView *dvorView;

@property (nonatomic, strong)  UIImageView *topImageView;
@property (strong, nonatomic) UIButton *leftIconImage;

@property (nonatomic, assign) int  scrollHei;
@end

@implementation KG_ZhiTaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(20),NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    self.dataModel = [[KG_ZhiTaiModel alloc]init];
    self.currIndex = 0;
    self.jifangString = @"";
    
    [self createScrollView];
    [self createNaviTopView];
    
    [self getData];
    
    
}



- (void)createScrollView
{
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSLog(@"SCREEN_HEIGHT %f",SCREEN_HEIGHT);
    NSLog(@"HEIGHT_SCREEN %f",HEIGHT_SCREEN);
    
    self.bgScrollView.delegate = self;
    self.bgScrollView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    self.bgScrollView.scrollEnabled = YES;
   
    self.bgScrollView.contentSize = CGSizeMake(0, 600 + 183 +112 + 50 +100 +100);
    
    
    
    [self.view addSubview:self.bgScrollView];
    self.bgScrollView.showsVerticalScrollIndicator = YES;
    self.bgScrollView.showsHorizontalScrollIndicator = YES;
    if(@available(iOS 11.0, *)) {
        self.bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
       }
    self.topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100+31+NAVIGATIONBAR_HEIGHT)];
    [self.bgScrollView addSubview:self.topImageView];
   
//    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageView.image  =[UIImage imageNamed:@"machine_rs"];
    
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100+31+NAVIGATIONBAR_HEIGHT)];
    [self.bgScrollView addSubview:topImage];
    topImage.image  =[UIImage imageNamed:@"zhihuan_bgimage"];
    topImage.contentMode = UIViewContentModeScaleAspectFill;
    if(IS_IPHONE_X_SERIES) {
        topImage.image  =[UIImage imageNamed:@"zhihuan_bgfullimage"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES];
    [self getData];
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
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    self.jifangString = @"";
}
- (void)createNaviTopView {
    
  
    
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
    self.titleLabel.text = @"智态";
    
    /** 返回按钮 **/
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
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
    self.rightButton.layer.borderColor = [[UIColor colorWithHexString:@"#FFFFFF"]CGColor];
    self.rightButton.layer.borderWidth = 0.5f;
    self.rightButton.layer.cornerRadius = 12.5f;
    self.rightButton.layer.masksToBounds = YES;
    
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    if (currDic.count) {
        [self.rightButton setTitle:safeString(currDic[@"alias"]) forState:UIControlStateNormal];
    }
    [self.rightButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0,0 )];
    [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0,0 )];
    self.rightButton.frame = CGRectMake(0,0,81,22);
    [self.view addSubview:self.rightButton];
    [self.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@81);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.height.equalTo(@22);
        make.right.equalTo(self.view.mas_right).offset(-16);
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
- (void)backButtonClick:(UIButton *)button {
//    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    [self leftCenterButtonClick];
}
/**
 弹出个人中心
 */
- (void)leftCenterButtonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyingHeadNotification" object:self];
    [self.slideMenuController showMenu];
}

- (void)createTopView{
    
    
    if(safeString(self.dataModel.stationInfo.thumbnail).length >0 ){
         [self.topImageView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,safeString(self.dataModel.stationInfo.thumbnail)]] placeholderImage:[UIImage imageNamed:@"machine_rs"] ];
    }else {
         [self.topImageView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,safeString(self.dataModel.stationInfo.picture)]] placeholderImage:[UIImage imageNamed:@"machine_rs"] ];
    }
   
  
    [self.runView removeFromSuperview];
    self.runView = nil;
    int runHeight = 88;
    if (self.dataModel.mainEquipmentDetails.count >2) {
        runHeight = 112;
    }
    
    self.runView= [[UIView alloc]initWithFrame:CGRectMake(16, NAVIGATIONBAR_HEIGHT +24+6, SCREEN_WIDTH -32, runHeight +233)];
    [self.bgScrollView addSubview:self.runView];
    self.runView.backgroundColor = [UIColor whiteColor];
    self.runView.layer.cornerRadius = 9;
    self.runView.layer.masksToBounds = YES;
    //    [self.runView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.bgScrollView.mas_top).offset(NAVIGATIONBAR_HEIGHT +24);
    //        make.left.equalTo(self.bgScrollView.mas_left).offset(16);
    //        make.right.equalTo(self.bgScrollView.mas_right).offset(-16);
    //        make.height.equalTo(@(runHeight +233));
    //    }];
    
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
    
    
    
    //智态运行状况
    UILabel *zhihuanRunLabel = [[UILabel alloc]init];
    [self.runView addSubview:zhihuanRunLabel];
    zhihuanRunLabel.text = @"智态运行情况";
    zhihuanRunLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    zhihuanRunLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    zhihuanRunLabel.numberOfLines = 1;
    zhihuanRunLabel.textAlignment = NSTextAlignmentLeft;
    [zhihuanRunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runView.mas_left).offset(17);
        make.top.equalTo(self.runView.mas_top).offset(17);
        make.height.equalTo(@24);
        make.width.equalTo(@140);
    }];
    
    self.equipView = [[KG_ZhiTaiEquipView alloc]init];
    [self.runView addSubview:self.equipView];
    
    int equipHegiht = 40;
    if (self.dataModel.mainEquipmentDetails.count >2) {
        equipHegiht = 80;
    }
    [self.equipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zhihuanRunLabel.mas_bottom).offset(5);
        make.left.equalTo(self.runView.mas_left);
        make.right.equalTo(self.runView.mas_right);
        make.height.equalTo(@(equipHegiht));
    }];
    self.equipView.powArray =self.dataModel.mainEquipmentDetails;
    
    
    
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
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [self.runView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runView.mas_left).offset(16);
        make.top.equalTo(self.equipView.mas_bottom);
        make.height.equalTo(@1);
        make.right.equalTo(self.runView.mas_right).offset(-24);
    }];
    UIView *jifangView =  [[UIView alloc]init];
    jifangView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.runView addSubview:jifangView];
    [jifangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runView.mas_left).offset(16);
        make.top.equalTo(lineView.mas_bottom);
        make.height.equalTo(@49);
        make.right.equalTo(self.runView.mas_right).offset(-16);
    }];
    NSArray *roomDetail = self.dataModel.roomDetails;
    //机房
    if (roomDetail.count == 0) {
//        [self.bottomBgView removeFromSuperview];
        self.bgScrollView.contentSize = CGSizeMake(0,0);
           
        return;
    }
    
    NSDictionary *roomInfo =self.dataModel.roomDetails[self.currIndex][@"roomInfo"];
       
      
    self.roomView = [[KG_RoomInfoView alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH -32, 50)];
    [jifangView addSubview:self.roomView];
    
    self.roomView.powArray = self.dataModel.roomDetails;
    [self.roomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jifangView.mas_left);
        make.bottom.equalTo(jifangView.mas_bottom);
        make.top.equalTo(jifangView.mas_top);
        make.right.equalTo(jifangView.mas_right);
    }];
    self.roomView.selIndex = self.currIndex;
    self.roomView .didsel = ^(int index) {
        
        self.currIndex = index;
        
        [self createTopView];
        
    };
    
    
    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [self.runView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runView.mas_left).offset(16);
        make.top.equalTo(lineView.mas_bottom).offset(49);
        make.height.equalTo(@1);
        make.right.equalTo(self.runView.mas_right).offset(-24);
    }];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#F3F7FC"];
    [self.runView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runView.mas_left).offset(16);
        make.top.equalTo(lineView1.mas_bottom).offset(17);
        make.height.equalTo(@150);
        make.right.equalTo(self.runView.mas_right).offset(-16);
    }];
    
    UIImageView *picImage = [[UIImageView alloc]init];
    [self.runView addSubview:picImage];
    [picImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.centerY.equalTo(bgView.mas_centerY);
        make.height.equalTo(@120);
        make.width.equalTo(@183);
    }];
   
    if(safeString(roomInfo[@"thumbnail"]).length >0 ){
         [picImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,roomInfo[@"thumbnail"]]] placeholderImage:[UIImage imageNamed:@"station_indexbg"] ];
    }else {
        [picImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,roomInfo[@"picture"]]] placeholderImage:[UIImage imageNamed:@"station_indexbg"] ];
    }
    
    
    
    
    
}
//选择某个标题
- (void)selectButton:(NSInteger)index
{
    
    [UIView animateWithDuration:0.3 animations:^{
        float sliderV_X = ( index )*10;
        //float sliderVX = WIDTH_SCREEN - FrameWidth(sliderV_X);
        
        float sliderX = 6+ sliderV_X;//WIDTH_SCREEN - FrameWidth(i*18+30);
        _sliderView.frame = CGRectMake(sliderX, 22, 6, 6);
        //NSLog(@"selectButton  %f",sliderX);
        [self.sliderBgView insertSubview:_sliderView atIndex:10];
        NSArray *listArr =self.bottomDic[self.jifangString] ;
        
        int he  = (int)[listArr[index][@"subEquipmentList"] count] *40 +40+20;
        
        
        if (he>600) {
            self.bgScrollView.contentSize = CGSizeMake(0, he + 183 +112 + 50 +100 +100);
        }else {
            if ([self.dataModel.stationInfo.code isEqualToString:@"HCDHT"] ) {
                self.bgScrollView.contentSize = CGSizeMake(0, 600 + 183 +112 + 50 +100 +100);
            }else {
                if (he + 183 +112 + 50 +100 +100 <SCREEN_HEIGHT) {
                    self.bgScrollView.contentSize = CGSizeMake(0,SCREEN_HEIGHT);
                }else {
                    self.bgScrollView.contentSize = CGSizeMake(0, he + 183 +112 + 50 +100 +100);
                }
                
            }
        }
        
        
    }];
    /*
     [selectButton setTitleColor:backColor forState:UIControlStateNormal];
     selectButton = _buttonArray[index];
     [selectButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
     
     */
}

//监听滚动事件判断当前拖动到哪一个了
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"contentOffset====%f",self.bgScrollView.contentOffset.y);
    if (self.bgScrollView.contentOffset.y > 0) {
        float orY= self.bgScrollView.contentOffset.y/167;
        
        self.navigationView.backgroundColor = [UIColor colorWithRed:10.f/255.f green:51.f/255.f blue:167/255.f alpha:orY];
    }else {
        self.navigationView.backgroundColor = [UIColor clearColor];
    }
    
   
    if (scrollView.contentOffset.y <-120) {
        NSLog(@"11111111%f",scrollView.contentOffset.y);
        KG_SecondFloorViewController *vc = [[KG_SecondFloorViewController alloc]init];
        vc.idStr = self.dataModel.stationInfo.id;
        vc.codeStr = self.dataModel.stationInfo.code;
        CATransition* transition = [CATransition animation];
        
        transition.duration =0.4f;
        
        transition.type = kCATransitionMoveIn;
        
        transition.subtype = kCATransitionFromBottom;
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        
        [self.navigationController pushViewController:vc animated:NO];
    }
   
    if(scrollView.contentOffset.y == 0) {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self selectButton:index];
    }
    
    
    

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
- (void)rightButtonClicked:(UIButton *)button {
     NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    StationVideoListController  *StationVideo = [[StationVideoListController alloc] init];
    StationVideo.station_code = safeString(currDic[@"code"]);
    StationVideo.station_name = safeString(currDic[@"stationName"]);;
    [self.navigationController pushViewController:StationVideo animated:YES];
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
//获取某个台站智慧态势详情页接口：
//请求地址：/intelligent/api/stationSitInfo/{stationCode}
//     其中，stationCode是台站编码，如S1

- (void)getData {
    
    NSDictionary *curr = [UserManager shareUserManager].currentStationDic;
    if (curr.count ==0) {
        return;
    }
    
//    NSString *  FrameRequestURL  =  [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/api/stationSitInfo/%@",curr[@"code"]];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/stationSitInfo/%@",curr[@"code"]]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [self.dataModel mj_setKeyValues:result[@"value"]];
        
        [self queryCategoryData];
        [self createTopView];
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else {
            [FrameBaseRequest showMessage:@"网络链接失败"];
        }
        
        return ;
        
    }];
}

- (void)initWithController
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    NSLog(@"SCREEN_HEIGHT %f",SCREEN_HEIGHT);
    NSLog(@"HEIGHT_SCREEN %f",HEIGHT_SCREEN);
    scrollView.frame = CGRectMake(0, 51, SCREEN_WIDTH,600);
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.bottomBgView addSubview:scrollView];
    _scrollView = scrollView;
    for (int i = 0; i < self.dataModel.mainEquipmentDetails.count; i++) {
        
        if (i== 0) {
//            if (1) {
//
//
//                self.demRightView = [[KG_DMERightView alloc]init];
//                self.demRightView.backgroundColor = [UIColor whiteColor];
//                self.demRightView.layer.cornerRadius = 10;
//                self.demRightView.layer.masksToBounds = YES;
//                self.demRightView.frame = CGRectMake(SCREEN_WIDTH*i +16, 0, SCREEN_WIDTH -32, 550);
//                self.demRightView.clickToDetail = ^(NSDictionary * _Nonnull dataDic) {
//
//                    KG_CommonDetailViewController  *StationMachine = [[KG_CommonDetailViewController alloc] init];
//                    StationMachine.category = safeString(dataDic[@"category"]);
//                    StationMachine.machine_name = safeString(dataDic[@"machine_name"]);
//                    StationMachine.station_name = safeString(dataDic[@"stationName"]);;
//                    StationMachine.station_code = safeString(dataDic[@"stationCode"]);
//                    StationMachine.engine_room_code = safeString(dataDic[@"engineRoomCode"]);
//
//                    [self.navigationController pushViewController:StationMachine animated:YES];
//                };
//                [_scrollView addSubview:self.demRightView];
//
//
//            }else {
                self.demView = [[KG_DMEView alloc]init];
                self.demView.backgroundColor = [UIColor whiteColor];
                self.demView.layer.cornerRadius = 10;
                self.demView.layer.masksToBounds = YES;
                self.demView.frame = CGRectMake(SCREEN_WIDTH*i +16, 0, SCREEN_WIDTH -32, 550);
                self.demView.clickToDetail = ^(NSDictionary * _Nonnull dataDic) {
                    
                    KG_CommonDetailViewController  *StationMachine = [[KG_CommonDetailViewController alloc] init];
                    StationMachine.category = safeString(dataDic[@"category"]);
                    StationMachine.machine_name = safeString(dataDic[@"machine_name"]);
                    StationMachine.station_name = safeString(dataDic[@"stationName"]);;
                    StationMachine.station_code = safeString(dataDic[@"stationCode"]);
                    StationMachine.engine_room_code = safeString(dataDic[@"engineRoomCode"]);
                    StationMachine.zhitaiDic = self.dmeDic;
                    [self.navigationController pushViewController:StationMachine animated:YES];
                };
                [_scrollView addSubview:self.demView];
                
          
            
        }else {
            self.dvorView = [[KG_ZhiTaiView alloc]init];
            self.dvorView.backgroundColor = [UIColor whiteColor];
            self.dvorView.layer.cornerRadius = 10;
            self.dvorView.layer.masksToBounds = YES;
            self.dvorView.frame = CGRectMake(SCREEN_WIDTH*i +16, 0, SCREEN_WIDTH -32, 600);
            self.dvorView.clickToDetail = ^(NSDictionary * _Nonnull dataDic) {
                KG_CommonDetailViewController  *StationMachine = [[KG_CommonDetailViewController alloc] init];
                StationMachine.category = safeString(dataDic[@"category"]);
                StationMachine.machine_name = safeString(dataDic[@"machine_name"]);
                StationMachine.station_name = safeString(dataDic[@"stationName"]);;
                StationMachine.station_code = safeString(dataDic[@"stationCode"]);
                StationMachine.engine_room_code = safeString(dataDic[@"engineRoomCode"]);
                StationMachine.zhitaiDic = self.dvorDic;
                [self.navigationController pushViewController:StationMachine animated:YES];
                
                
            };
            [_scrollView addSubview:self.dvorView];
            
        }
        
        NSLog(@"_scrollView.frameHeight %f",_scrollView.frameHeight);
        
        
    }
    
}

- (void)initOtherController {
    NSArray *listArr =self.bottomDic[self.jifangString] ;
    if(listArr.count == 0) {
        [self.bottomBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        return;
    }
    self.scrollHei =0;
    for (int i = 0; i <listArr.count; i++) {
        
        int he  = (int)[listArr[i][@"subEquipmentList"] count] *40 +40+20;
        if (he >self.scrollHei) {
            self.scrollHei = he;
        }
    }
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    NSLog(@"SCREEN_HEIGHT %f",SCREEN_HEIGHT);
    NSLog(@"HEIGHT_SCREEN %f",HEIGHT_SCREEN);
    scrollView.frame = CGRectMake(0, 51, SCREEN_WIDTH,self.scrollHei +60);
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*listArr.count, 0);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.bottomBgView addSubview:scrollView];
    _scrollView = scrollView;
    
    for (int i = 0; i <listArr.count; i++) {
        KG_ZhiTaiBottomView *viewcon = [[KG_ZhiTaiBottomView alloc] init];
        viewcon.secArray = listArr[i][@"subEquipmentList"];
        int hh = (int)[listArr[i][@"subEquipmentList"] count] *40 +40+20;
       
        viewcon.frame = CGRectMake(SCREEN_WIDTH*i +16, 0, SCREEN_WIDTH-32, hh+60);
        viewcon.titleString =safeString(listArr[i][@"name"]) ;
        NSArray *listArr =self.bottomDic[self.jifangString] ;
        
        NSLog(@"_scrollView.frameHeight %f",_scrollView.frameHeight);
        viewcon.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        viewcon.currDic = listArr[i];
        [_scrollView addSubview:viewcon];
        viewcon.clickToDetail = ^(NSDictionary * _Nonnull dataDic) {
            NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
            if (currDic.count == 0) {
                return ;
            }
            KG_CommonDetailViewController  *StationMachine = [[KG_CommonDetailViewController alloc] init];
            StationMachine.category = safeString(dataDic[@"category"]);
            StationMachine.machine_name = safeString(dataDic[@"machine_name"]);
            StationMachine.station_name = safeString(dataDic[@"stationName"]);;
            StationMachine.station_code = safeString(currDic[@"code"]);
            StationMachine.engine_room_code = safeString(dataDic[@"code"]);
            StationMachine.isSystemEquipment = [dataDic[@"isSystemEquipment"] boolValue];
            StationMachine.isFromZhiTai = YES;
            [self.navigationController pushViewController:StationMachine animated:YES];
        };
        
    }
}

-(KG_ZhiTaiBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView  = [[KG_ZhiTaiBottomView alloc]initWithFrame:CGRectMake(16, self.runView.frame.origin.y +self.runView.frame.size.height +50, SCREEN_WIDTH -32, 400)];
        
    }
    return _bottomView;
}

-(KG_JifangView *)jifangView{
    if (!_jifangView) {
        self.jifangView = [[KG_JifangView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 50)];
        
    }
    return _jifangView;
}


//StationMachineController  *StationMachine = [[StationMachineController alloc] init];
//       StationMachine.category = safeString(dic[@"code"]);
//       StationMachine.machine_name = safeString(dic[@"name"]);
//       StationMachine.station_name = _station_name;
//       StationMachine.station_code = _station_code;
//       StationMachine.engine_room_code = @"";
//       StationMachine.mList = listArr;
//       [self.navigationController pushViewController:StationMachine animated:YES];
//
//- (KG_ZhiTaiRightAlertView *)upsAlertView {
//    if (!_upsAlertView) {
//        _upsAlertView = [[KG_UpsAlertView alloc]init];
//        [JSHmainWindow addSubview:self.upsAlertView];
//        [self.upsAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.bottom.left.equalTo(self.view);
//            make.top.equalTo(self.view.mas_top).offset(-NAVIGATIONBAR_HEIGHT);
//
//        }];
//        _upsAlertView.dataArray = self.rightArray;
//        _upsAlertView.didsel = ^(NSDictionary * _Nonnull selDic) {
//            _category =safeString(selDic[@"categoryCode"]);
//            [self getMachineDetailList];
//        };
//
//    }
//    return _upsAlertView;
//}

- (void)queryCategoryData {
    
//    NSString *  FrameRequestURL  =  [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/atcDictionary?type_code=equipmentCategory"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=equipmentCategory"]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.categoryArray = result[@"value"];
        [self getBottomArrayData];
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
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
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
}
- (NSMutableArray *)bottomArray
{
    if (!_bottomArray) {
        _bottomArray = [[NSMutableArray alloc] init];
    }
    return _bottomArray;
}
- (NSMutableDictionary *)bottomDic
{
    if (!_bottomDic) {
        _bottomDic = [[NSMutableDictionary alloc] init];
    }
    return _bottomDic;
}

- (void)getBottomArrayData {
    [self.bottomDic removeAllObjects];
    if (self.dataModel.roomDetails.count == 0) {
        
        [self.bottomBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        return;
        
    }
    NSArray *array = self.dataModel.roomDetails[self.currIndex][@"equipmentInfo"];
    
    for (NSDictionary *dic in self.categoryArray) {
        NSMutableArray *list = [NSMutableArray array];
        for (NSDictionary *detailDic in array) {
            if ([dic[@"code"] isEqualToString:detailDic[@"category"]]) {
                [list addObject:detailDic];
            }
        }
        if (list.count) {
            [self.bottomDic setValue:list forKey:dic[@"name"]];
        }
        
    }
    NSLog(@"1");
    
    
    [self refreshData];
}
- (void)refreshData {
    
    self.jifangView.dataDic = self.bottomDic;
    if (self.jifangString.length == 0 &&self.bottomDic.count) {
        NSArray *jifangArr = [self.bottomDic allKeys];
        int num = 0;
        if (jifangArr.count) {
            for (NSString *ss in jifangArr) {
                if ([ss isEqualToString:self.jifangString]) {
                    num ++;
                }
            }
        }
        if (num == 0) {
            self.jifangString = [[self.bottomDic allKeys] firstObject];
        }
        
    }
    NSArray *listArr =self.bottomDic[self.jifangString] ;
    if(listArr.count) {
        int he  = (int)[[listArr firstObject][@"subEquipmentList"] count] *40 +40+20;
        
        
        if (he>600) {
            self.bgScrollView.contentSize = CGSizeMake(0, he + 183 +112 + 50 +100 +100);
        }else {
            if ([self.dataModel.stationInfo.code isEqualToString:@"HCDHT"] ) {
                self.bgScrollView.contentSize = CGSizeMake(0, 600 + 183 +112 + 50 +100 +100);
            }else {
                if (he + 183 +112 + 50 +100 +100 <SCREEN_HEIGHT) {
                    self.bgScrollView.contentSize = CGSizeMake(0,SCREEN_HEIGHT);
                }else {
                    self.bgScrollView.contentSize = CGSizeMake(0, he + 183 +112 + 50 +100 +100);
                }
            }
           
        }
    }
    
    
    
           
    
    
    self.jifangView.didsel = ^(NSString *str) {
        
        
        self.jifangString = str;
        [self getBottomArrayData];
    };
    //
    
    
    //滑块
    for(UIView *view in [self.bottomBgView subviews])
    {
        [view removeFromSuperview];
    }
    _bottomBgView = nil;
    [_bottomBgView removeFromSuperview];
    _sliderView = nil;
    [_sliderView removeFromSuperview];
    self.sliderBgView = [[UIView alloc]init];
    if (_bottomBgView == nil) {
        if (self.scrollHei >600) {
            _bottomBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.runView.frame.origin.y +self.runView.frame.size.height, SCREEN_WIDTH,self.scrollHei)];
        }else {
            if ([self.dataModel.stationInfo.code isEqualToString:@"HCDHT"] ) {
                            _bottomBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.runView.frame.origin.y +self.runView.frame.size.height, SCREEN_WIDTH, 600)];
                       }else {

                           _bottomBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.runView.frame.origin.y +self.runView.frame.size.height, SCREEN_WIDTH, self.scrollHei +60)];
                       }
           
        }
        
        _bottomBgView.backgroundColor = [UIColor clearColor];
        [self.bgScrollView addSubview:self.bottomBgView];
        
    }
    
    UIView *daohangView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 51)];
    daohangView.backgroundColor = [UIColor clearColor];
    [self.bottomBgView addSubview:daohangView];
    
    [daohangView addSubview:self.jifangView];
    
    
    
    [self.jifangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(daohangView.mas_left);
        make.bottom.equalTo(daohangView.mas_bottom);
        make.top.equalTo(daohangView.mas_top);
        make.right.equalTo(daohangView.mas_right);
    }];
    [self.bottomBgView addSubview:self.sliderBgView];
    [self.sliderBgView setFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 51)];
    self.sliderBgView.backgroundColor = [UIColor clearColor];
    
   if([self.dataModel.stationInfo.code isEqualToString:@"DDDHT"]){
       //        [self.bottomBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
       [self.bottomBgView addSubview:self.niTaiTuNoDataView];
       self.niTaiTuNoDataView.didsel = ^(NSInteger index) {
           NSDictionary *dd = nil;
          
           KG_CommonDetailViewController  *StationMachine = [[KG_CommonDetailViewController alloc] init];
           if (index == 0) {
               dd = self.dvorDic ;
           }else {
               dd = self.dmeDic ;
           }
           NSArray *arr =dd[@"equipmentDetails"];
           if (arr.count) {
               NSDictionary *dataDic = [arr firstObject][@"equipment"];
               
               StationMachine.category = safeString(dataDic[@"category"]);
               StationMachine.machine_name = safeString(dataDic[@"roomName"]);
               StationMachine.station_name = safeString(dataDic[@"stationName"]);;
               StationMachine.station_code = safeString(dataDic[@"stationCode"]);
               StationMachine.engine_room_code = safeString(dataDic[@"engineRoomCode"]);
               
           }
           
        
           StationMachine.zhitaiDic = dd;
           
           [self.navigationController pushViewController:StationMachine animated:YES];
       };
       [self queryDMEData];
       [self queryDVORData];
       return;
   }else {
       [_niTaiTuNoDataView removeFromSuperview];
       _niTaiTuNoDataView = nil;
   }
    
    
    
    NSArray *sliderArray = self.bottomDic[self.jifangString] ;
    float sliderV_X = 6;
    float sliderVX =  sliderV_X;
    UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(sliderVX,  22, 6, 6)];
    
    sliderV.layer.cornerRadius = 3;
    sliderV.backgroundColor = [UIColor colorWithHexString:@"#005DC4"];
    [self.sliderBgView insertSubview:sliderV atIndex:1];
    //[titleView addSubview:sliderV];
    _sliderView=sliderV;
    for (int i = 0; i <sliderArray.count; i++) {
        //滑块
        float sliderV_X =6+ i*10;
        //float sliderVX = WIDTH_SCREEN - FrameWidth(sliderV_X);
        
        float sliderX = sliderV_X;//WIDTH_SCREEN - FrameWidth(i*18+30);
        UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(sliderX, 22, 6, 6)];
        sliderV.layer.cornerRadius = 3;
        sliderV.alpha= 0.19;
        sliderV.backgroundColor = [UIColor colorWithHexString:@"#005DC4"];
        [self.sliderBgView insertSubview:sliderV atIndex:0];
        
    }
    
    if ([self.dataModel.stationInfo.code isEqualToString:@"HCDHT"] ) {
        
        [self initWithController];
        [self queryDMEData];
        [self queryDVORData];
        
        
    }else {
        
        [self initOtherController];
    }
}
- (void)queryDMEData {
    NSString *code = @"";
    int isSystem = 0;
    if(self.dataModel.mainEquipmentDetails.count == 2) {
        for (NSDictionary *dic in self.dataModel.mainEquipmentDetails) {
            if ([safeString(dic[@"name"]) containsString:@"DME"]) {
                code = dic[@"code"];
                isSystem = [dic[@"isSystemEquipment"] intValue];
                break;
            }
        }
       
    }
//    NSString *  FrameRequestURL  =  [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/api/sitDeviceInfo/%@/%d",code,isSystem];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/sitDeviceInfo/%@/%d",code,isSystem]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.dmeDic = result[@"value"];
        if ([self.dataModel.stationInfo.code isEqualToString:@"DDDHT"]) {
          
            if (self.dmeDic.count) {
                self.niTaiTuNoDataView.dmeDic = self.dmeDic;
            }
            
        }else {
            if (self.dmeDic.count) {
                self.demView.dataDic = self.dmeDic;
            }
        }
      
        
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
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
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}
- (void)queryDVORData {
    NSString *code = @"";
    int isSystem = 0;
    if(self.dataModel.mainEquipmentDetails.count == 2) {
        for (NSDictionary *dic in self.dataModel.mainEquipmentDetails) {
            if ([safeString(dic[@"name"]) containsString:@"DVOR"]) {
                code = dic[@"code"];
                isSystem = [dic[@"isSystemEquipment"] intValue];
                break;
            }
        }
        
    }
//    NSString *  FrameRequestURL  =  [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/api/sitDeviceInfo/%@/%d",code,isSystem];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/sitDeviceInfo/%@/%d",code,isSystem]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.dvorDic = result[@"value"];
        if ([self.dataModel.stationInfo.code isEqualToString:@"DDDHT"]) {
            
            if (self.dvorDic.count) {
                self.niTaiTuNoDataView.dvorDic = self.dvorDic;
            }
            
        }else {
            if (self.dvorDic.count) {
                self.dvorView.dataDic = self.dvorDic;
            }
        }
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
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
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
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

#pragma mark - UITableviewDatasource 数据源方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.stationTabView){
        
        return 40;
    }
    return FrameWidth(210);
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.stationTabView){
        return self.stationArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.2 去缓存池中取Cell
    if(tableView == self.stationTabView){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        KG_ZhiTaiStationModel *model = self.stationArray[indexPath.row];
        cell.textLabel.text = safeString(model.name) ;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        
        return cell;
        
    }
    
    
    
    return nil;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_ZhiTaiStationModel *model = self.stationArray[indexPath.row];
    NSLog(@"1");
    self.currIndex = 0;
    self.jifangString = @"";
    
    for(UIView *view in [self.bgScrollView subviews])
    {
        [view removeFromSuperview];
    }
    [self.rightButton setTitle:safeString(model.name) forState:UIControlStateNormal];
    [self getNewData:safeString(model.code)];
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
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

- (void)getNewData:(NSString *)code {
    
    
//    NSString *  FrameRequestURL  =  [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/api/stationSitInfo/%@",code];
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/stationSitInfo/%@",code]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [self.dataModel mj_setKeyValues:result[@"value"]];
        
        [self queryCategoryData];
        [self createTopView];
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
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
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}
- (KG_NiTaiTuNoDataView *)niTaiTuNoDataView {
    if (!_niTaiTuNoDataView) {
        _niTaiTuNoDataView = [[KG_NiTaiTuNoDataView alloc]init];
        [_niTaiTuNoDataView setFrame:CGRectMake(16, 51, SCREEN_WIDTH -32, 154)];
        
       _niTaiTuNoDataView.layer.cornerRadius = 10;
       _niTaiTuNoDataView.layer.shadowColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:243/255.0 alpha:1.0].CGColor;
       _niTaiTuNoDataView.layer.shadowOffset = CGSizeMake(0,2);
       _niTaiTuNoDataView.layer.shadowOpacity = 1;
       _niTaiTuNoDataView.layer.shadowRadius = 2;
    }
    
    return _niTaiTuNoDataView;
}
@end
