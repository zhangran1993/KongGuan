//
//  KG_NewZhiWeiViewController.m
//  Frame
//
//  Created by zhangran on 2020/11/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NewZhiWeiViewController.h"
#import <UIButton+WebCache.h>
#import "KG_HistoryTaskViewController.h"
#import "KG_ZhiTaiStationModel.h"
#import "UIViewController+CBPopup.h"
#import "KG_MineViewController.h"
@interface KG_NewZhiWeiViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)  UILabel                 *titleLabel;
@property (nonatomic, strong)  UIView                  *navigationView;
@property (nonatomic, strong)  UIButton                *rightButton;

@property (nonatomic, strong)  UIButton                *leftIconImage;

@property(strong,nonatomic)    NSArray                 *stationArray;
@property(strong,nonatomic)    UITableView             *stationTabView;
@property (nonatomic, strong)  UISegmentedControl      *segmentedControl;


@property (nonatomic, strong)  UITableView             *xunshiTableView;
@property (nonatomic, strong)  NSMutableArray          *dataArray;

@property (nonatomic, strong)  UITableView             *weihuTableView;

@property (nonatomic, strong)  UITableView             *baozhangTableView;

@end

@implementation KG_NewZhiWeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UserManager shareUserManager].zhiweiSegmentCurIndex = 0;
    //默认一进来选择第一个
    [self createNaviTopView];
}

-(void)viewWillAppear:(BOOL)animated{
  
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
   
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    
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
    self.titleLabel.text = @"智维";
    
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
        
        [self.leftIconImage sd_setImageWithURL:[NSURL URLWithString:[WebNewHost stringByAppendingString:[userDefaults objectForKey:@"icon"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_blueIcon"]];
        
    }else {
        
        [self.leftIconImage setImage:[UIImage imageNamed:@"head_blueIcon"] forState:UIControlStateNormal];
    }
      
    UIButton *histroyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    histroyBtn.titleLabel.font = FontSize(12);
    
    
    [histroyBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [histroyBtn setImage:[UIImage imageNamed:@"history_icon"] forState:UIControlStateNormal];
    histroyBtn.frame = CGRectMake(0,0,81,22);
    [self.view addSubview:histroyBtn];
    [histroyBtn addTarget:self action:@selector(historyAction) forControlEvents:UIControlEventTouchUpInside];
    [histroyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@24);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.height.equalTo(@24);
        make.right.equalTo(self.view.mas_right).offset(-16);
    }];
    
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.titleLabel.font = FontSize(12);
    self.rightButton.layer.borderColor = [[UIColor colorWithHexString:@"#DFDFDF"]CGColor];
    self.rightButton.layer.borderWidth = 0.5f;
    self.rightButton.layer.cornerRadius = 12.5f;
    self.rightButton.layer.masksToBounds = YES;
    
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"黄城导航台" forState:UIControlStateNormal];
    self.rightButton.frame = CGRectMake(0,0,81,22);
    [self.rightButton setImage:[UIImage imageNamed:@"ZhiWei_rightIcon"] forState:UIControlStateNormal];
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0,0 )];
    [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0,0 )];
    [self.view addSubview:self.rightButton];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    if (currDic.count) {
        [self.rightButton setTitle:safeString(currDic[@"alias"]) forState:UIControlStateNormal];
    }
    [self.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@81);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.height.equalTo(@22);
        make.right.equalTo(histroyBtn.mas_left).offset(-6);
    }];
    [self.leftIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationView.mas_left).offset(16);
        make.width.height.equalTo(@34);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    //单台站不可点击
    self.rightButton.userInteractionEnabled = NO;
    [self createSegmentView];
}

- (void)rightAction {
    
    [self stationAction];
}

- (void)historyAction {
    
    KG_HistoryTaskViewController *vc = [[KG_HistoryTaskViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backButtonClick:(UIButton *)button {
    
    [self leftCenterButtonClick];
 
}

/**
 弹出个人中心
 */
- (void)leftCenterButtonClick {
    
//    KG_MineViewController  *vc = [[KG_MineViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyingHeadNotification" object:self];
////    [self.slideMenuController showMenu];
    
    KG_MineViewController  *vc = [[KG_MineViewController alloc]init];
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;            //改变视图控制器出现的方式
    transition.subtype = kCATransitionFromLeft;     //出现的位置
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:vc animated:NO];
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

- (void)createSegmentView {
    
    NSString *xunshiString = [UserManager shareUserManager].xunshiTypeStr;
    
    if (xunshiString.length == 0) {
        xunshiString = @"常规巡视";
        
    }
    NSArray *array = @[safeString(@"常规巡视") ,@"例行维护",@"特殊保障"];
  
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@40);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:array];
    self.segmentedControl.frame = CGRectMake(16, 8, SCREEN_WIDTH - 32,30);
    [self.segmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]}forState:UIControlStateSelected];
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2F5ED1"],NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]}forState:UIControlStateNormal];
    [self.view addSubview:self.segmentedControl];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.tintColor = [UIColor whiteColor];
    self.segmentedControl.layer.borderWidth = 1;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    self.segmentedControl.layer.borderColor = [UIColor colorWithHexString:@"#2F5ED1"].CGColor; //     边框颜色
    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]]
                                forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#2F5ED1"]]
                                forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
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

- (void)change:(UISegmentedControl *)sender {
    NSLog(@"测试");
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"1");
    }else if (sender.selectedSegmentIndex == 1){
        NSLog(@"2");
    }else if (sender.selectedSegmentIndex == 2){
        NSLog(@"3");
    }else if (sender.selectedSegmentIndex == 3){
        NSLog(@"4");
    }
    [UserManager shareUserManager].zhiweiSegmentCurIndex = sender.selectedSegmentIndex;
    switch (sender.selectedSegmentIndex) {
        case 0:
           
            break;
        case 1:
            
            break;
        case 2:
          
            break;
        default:
            break;
    }
}

@end
