//
//  PersonalMsgController.m
//  Frame
//
//  Created by hibayWill on 2018/3/31.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PersonalMsgController.h"
#import "FrameBaseRequest.h"
#import "PersonalMsgListController.h"


#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <MJExtension.h>

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface PersonalMsgController (){
    int       timeCont;
    NSTimer   *timer;
}

/** 存放数据模型的数组 */
//@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;
//@property(strong,nonatomic)UITableView *stationTabView;
@property(strong,nonatomic)    UILabel       *newsNumLabel;
@property(strong,nonatomic)    UILabel       *yujingNumLabel;
@property(strong,nonatomic)    UILabel       *gonggaoNumLabel;

@property (nonatomic, strong)  UILabel       *titleLabel;
@property (nonatomic, strong)  UIView        *navigationView;
@property (nonatomic, strong)  UIButton      *rightButton;

@end

@implementation PersonalMsgController
//static NSString * const FrameCellID = @"ChooseStationCell";
//static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviTopView];
    
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
    
    [self backBtn];
    [self loadBgView];
    
}
-(void)loadBgView{
    self.title = @"消息通知";
    //背景色
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    //预警消息
    UIView *yujingView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar +10 ,WIDTH_SCREEN,80)];
    yujingView.backgroundColor = [UIColor whiteColor];
   
    //点击效果
    UIButton *yujinglViewButton = [[UIButton alloc] initWithFrame:yujingView.bounds];
    [yujinglViewButton addTarget:self action:@selector(AlarmView) forControlEvents:UIControlEventTouchUpInside];
    [yujinglViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [yujinglViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [yujingView addSubview:yujinglViewButton];
    
    [yujingView setUserInteractionEnabled:YES];
    [yujingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AlarmView)]];
    [self.view addSubview:yujingView];
    
    UIImageView *yujingImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20,40, 40)];
   
    yujingImg.image = [UIImage imageNamed:@"kg_messCenter_yujing"];
    [yujingView addSubview:yujingImg];
    
    UILabel *yujingTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 40 + 14, 17, 200, 22)];
    yujingTitleLabel.text = @"预警消息";
    yujingTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    yujingTitleLabel.font = FontSize(16);
    yujingTitleLabel.font = [UIFont my_font:16];
    [yujingView addSubview:yujingTitleLabel];
    
    _yujingNumLabel = [[UILabel alloc]init];
    // CGSize size = [@"告警消息" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(16),NSFontAttributeName,nil]];
    _yujingNumLabel.frame = CGRectMake(20 +40 -4, 20 , 8, 8);
    //_yujingNumLabel.frame = CGRectMake(FrameWidth(260), FrameWidth(30), FrameWidth(25), FrameWidth(25));
    _yujingNumLabel.font = FontSize(10);
    _yujingNumLabel.font = [UIFont my_font:10];
    _yujingNumLabel.layer.cornerRadius = 4;
    _yujingNumLabel.clipsToBounds = YES;
    _yujingNumLabel.textColor = [UIColor whiteColor];
    _yujingNumLabel.textAlignment = NSTextAlignmentCenter;
    _yujingNumLabel.backgroundColor = [UIColor redColor];
    [_yujingNumLabel setHidden:YES];
    [yujingView addSubview:_yujingNumLabel];
    
    UILabel *yujingDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 +40 +14, 17+22 +3, SCREEN_WIDTH - 16- 74,22)];
    yujingDescLabel.numberOfLines = 1;
    yujingDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    yujingDescLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    yujingDescLabel.font =FontSize(14);
    yujingDescLabel.font = [UIFont my_font:14];
    yujingDescLabel.text = @"预警消息列表在此处显示";
    [yujingView addSubview:yujingDescLabel];
    
    //告警消息
    UIView *WarnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + Height_NavBar +10+80 +1,WIDTH_SCREEN, 80)];
    WarnView.backgroundColor = [UIColor whiteColor];
    
    //点击效果
    UIButton *patrolViewButton = [[UIButton alloc] initWithFrame:WarnView.bounds];
    [patrolViewButton addTarget:self action:@selector(WarnView) forControlEvents:UIControlEventTouchUpInside];
    [patrolViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [patrolViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [WarnView addSubview:patrolViewButton];
    
    [self.view addSubview:WarnView];
    
    UIImageView *WarnImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20,40, 40)];
   
    WarnImg.image = [UIImage imageNamed:@"kg_messCenter_gongjing"];
    [WarnView addSubview:WarnImg];
    
    UILabel *WarnTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 40 + 14, 17, 200, 22)];
    WarnTitleLabel.text = @"告警消息";
    WarnTitleLabel.font = FontSize(16);
    WarnTitleLabel.font = [UIFont my_font:16];
    WarnTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    [WarnView addSubview:WarnTitleLabel];
    
    _newsNumLabel = [[UILabel alloc]init];
    CGSize size = [@"告警消息" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(16),NSFontAttributeName,nil]];
    _newsNumLabel.frame = CGRectMake(20 +40 -4, 20 , 8, 8);
    //_newsNumLabel.frame = CGRectMake(FrameWidth(260), FrameWidth(30), FrameWidth(25), FrameWidth(25));
    _newsNumLabel.font = FontSize(10);
    _newsNumLabel.font = [UIFont my_font:10];
    _newsNumLabel.layer.cornerRadius = 4;
    _newsNumLabel.clipsToBounds = YES;
    _newsNumLabel.textColor = [UIColor whiteColor];
    _newsNumLabel.textAlignment = NSTextAlignmentCenter;
    _newsNumLabel.backgroundColor = [UIColor redColor];
    [_newsNumLabel setHidden:YES];
    [WarnView addSubview:_newsNumLabel];
    
    UILabel *WarnDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 +40 +14, 17+22 +3, SCREEN_WIDTH - 16- 74,22)];
    WarnDescLabel.numberOfLines = 1;
    WarnDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    WarnDescLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    WarnDescLabel.font =FontSize(14);
    WarnDescLabel.font = [UIFont my_font:14];
    WarnDescLabel.text = @"告警消息列表在此处显示";
    [WarnView addSubview:WarnDescLabel];
    
   
    //公告消息
    UIView *RadioView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + Height_NavBar +10+80 +1 +80 +1,WIDTH_SCREEN, 80)];
  
    RadioView.backgroundColor = [UIColor whiteColor];
    
    //点击效果
    UIButton *RadioViewButton = [[UIButton alloc] initWithFrame:WarnView.bounds];
    [RadioViewButton addTarget:self action:@selector(Radio) forControlEvents:UIControlEventTouchUpInside];
    [RadioViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [RadioViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [RadioView addSubview:RadioViewButton];
    
    [self.view addSubview:RadioView];
    
    UIImageView *RadioImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20,40, 40)];
   
    RadioImg.image = [UIImage imageNamed:@"kg_messCenter_gonggao"];
    [RadioView addSubview:RadioImg];
    
    UILabel *RadioTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 40 + 14, 17, 200, 22)];
    RadioTitleLabel.text = @"公告消息";
    RadioTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    RadioTitleLabel.font = FontSize(16);
    RadioTitleLabel.font = [UIFont my_font:16];
    [RadioView addSubview:RadioTitleLabel];
    
    _gonggaoNumLabel = [[UILabel alloc]init];
    // CGSize size = [@"告警消息" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(16),NSFontAttributeName,nil]];
    _gonggaoNumLabel.frame = CGRectMake(20 +40 -4, 20 , 8, 8);
    //_gonggaoNumLabel.frame = CGRectMake(FrameWidth(260), FrameWidth(30), FrameWidth(25), FrameWidth(25));
    _gonggaoNumLabel.font = FontSize(10);
    _gonggaoNumLabel.font = [UIFont my_font:10];
    _gonggaoNumLabel.layer.cornerRadius = FrameWidth(13);
    _gonggaoNumLabel.clipsToBounds = YES;
    _gonggaoNumLabel.textColor = [UIColor whiteColor];
    _gonggaoNumLabel.textAlignment = NSTextAlignmentCenter;
    _gonggaoNumLabel.backgroundColor = [UIColor redColor];
    [_gonggaoNumLabel setHidden:YES];
    [RadioView addSubview:_gonggaoNumLabel];
    
    UILabel *RadioDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 +40 +14, 17+22 +3, SCREEN_WIDTH - 16- 74,22)];
    RadioDescLabel.numberOfLines = 1;
    RadioDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    RadioDescLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    RadioDescLabel.font = FontSize(14);
    RadioDescLabel.font = [UIFont my_font:14];
    RadioDescLabel.text = @"公告消息列表在此处显示";
    [RadioView addSubview:RadioDescLabel];
    return ;
    
}

-(void)getNewsNum{
    //获取预警消息数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/api/getNotReadNum/warning"];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if(code == 0){
            _yujingNumLabel.text = [NSString stringWithFormat:@"%@",result[@"value"][@"num"]];//;
            [[NSUserDefaults standardUserDefaults] setInteger:[_yujingNumLabel.text integerValue] forKey:@"unReadNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if(![[NSString stringWithFormat:@"%@",result[@"value"][@"num"]] isEqualToString:@"0"]){
                [_yujingNumLabel setHidden:NO];
                return ;
            }
        }
        [_yujingNumLabel setHidden:YES];
        
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [_yujingNumLabel setHidden:YES];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//            [FrameBaseRequest logout];
//            return;
//        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
    //获取公告消息数
    NSString *FrameRequestURL1 = [WebNewHost stringByAppendingString:@"/intelligent/api/getNotReadNum/notice"];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL1 param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if(code == 0){
            _gonggaoNumLabel.text = [NSString stringWithFormat:@"%@",result[@"value"][@"num"]];//;
            [[NSUserDefaults standardUserDefaults] setInteger:[_gonggaoNumLabel.text integerValue] forKey:@"unReadNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if(![[NSString stringWithFormat:@"%@",result[@"value"][@"num"]] isEqualToString:@"0"]){
                [_gonggaoNumLabel setHidden:NO];
                return ;
            }
        }
        [_gonggaoNumLabel setHidden:YES];
        
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [_gonggaoNumLabel setHidden:YES];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//            [FrameBaseRequest logout];
//            return;
//        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
    //获取告警消息数
    NSString *FrameRequestURL2 = [WebNewHost stringByAppendingString:@"/intelligent/api/getNotReadNum/alarm"];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL2 param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if(code == 0){
            _newsNumLabel.text = [NSString stringWithFormat:@"%@",result[@"value"][@"num"]];//;
            [[NSUserDefaults standardUserDefaults] setInteger:[_newsNumLabel.text integerValue] forKey:@"unReadNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if(![[NSString stringWithFormat:@"%@",result[@"value"][@"num"]] isEqualToString:@"0"]){
                [_newsNumLabel setHidden:NO];
                return ;
            }
        }
        [_newsNumLabel setHidden:YES];
        
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [_newsNumLabel setHidden:YES];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//            [FrameBaseRequest logout];
//            return;
//        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
-(void)Radio{
    PersonalMsgListController  * PersonalMsg = [[PersonalMsgListController alloc] init];
    PersonalMsg.thistitle = @"公告消息";
    [self.navigationController pushViewController: PersonalMsg animated:YES];
    
}
-(void)WarnView{
    //PersonalMsgListController
    PersonalMsgListController  * PersonalMsg = [[PersonalMsgListController alloc] init];
    PersonalMsg.thistitle = @"告警消息";
    [self.navigationController pushViewController: PersonalMsg animated:YES];
}
-(void)AlarmView{
    //PersonalMsgListController
    PersonalMsgListController  * PersonalMsg = [[PersonalMsgListController alloc] init];
    PersonalMsg.thistitle = @"预警消息";
    [self.navigationController pushViewController: PersonalMsg animated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    [self getNewsNum];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*返回*/
-(void)backBtn{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation2"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController popViewControllerAnimated:YES];
   
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [self createImageWithColor:[UIColor whiteColor]];
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
    self.titleLabel.text = @"我的消息";
    
    /** 返回按钮 **/
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.navigationView.mas_left);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = IMAGE(@"back_black");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
   
}

- (void)backButtonClick:(UIButton *)button {
   
     [self.navigationController popViewControllerAnimated:YES];
    
    
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

@end


