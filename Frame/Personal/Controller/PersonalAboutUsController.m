//
//  PersonalAboutUsController.m
//  Frame
//
//  Created by hibayWill on 2018/3/17.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PersonalAboutUsController.h"
#import "PersonalAPPIntroduceController.h"
#import "PersonalFollowUsController.h"
#import "PersonalSendOpinionController.h"
#import "FrameBaseRequest.h"

@interface PersonalAboutUsController (){
    int timeCont;
    NSTimer *timer;
}

@property(strong,nonatomic)UIButton *setMsgButton;


@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;

@end

@implementation PersonalAboutUsController

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
    
    self.title = @"关于";
    [self backBtn];
    [self loadBgView];
    
}
-(void)loadBgView{
    timeCont = 60;
    
    //背景色
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    //logo和版本
    UIImageView *logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kg_logo"]];
    
    logoImg.frame = CGRectMake(WIDTH_SCREEN/2-FrameWidth(60), FrameWidth(60)+ Height_NavBar, FrameWidth(120), FrameWidth(120));
    
    UILabel *vsersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_SCREEN/2-FrameWidth(250)/2,FrameWidth(200)+Height_NavBar ,FrameWidth(250), 20)];
    vsersionLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
    vsersionLabel.textAlignment = NSTextAlignmentCenter;
    vsersionLabel.font = FontSize(14);
    vsersionLabel.text = [NSString stringWithFormat:@"%@%@",@"智慧台站",AppVersion];
    [self.view addSubview:vsersionLabel];
    
    [self.view addSubview:logoImg];
//    //版本评分
//    UIView *gradeView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(310)+Height_NavBar, WIDTH_SCREEN, FrameWidth(80))];
//    gradeView.backgroundColor = [UIColor whiteColor];
//    [gradeView setUserInteractionEnabled:YES];
//    [gradeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicktograde)]];
//    UILabel *gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, WIDTH_SCREEN/2,FrameWidth(80))];
//    gradeLabel.text = @"版本评分";
//    gradeLabel.font = FontSize(17);
//    [gradeView addSubview:gradeLabel];
//
//    UIImageView *gradeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_gray_right"]];
//
//    gradeImg.frame = CGRectMake(WIDTH_SCREEN-FrameWidth(35), FrameWidth(25), FrameWidth(15), FrameWidth(20));
//    [gradeView addSubview:gradeImg];
//    [self.view addSubview:gradeView];
    //APP介绍
    UIView *introduceView = [[UIView alloc] initWithFrame:CGRectMake(0, 187 + Height_NavBar, WIDTH_SCREEN, 50)];
    introduceView.backgroundColor = [UIColor whiteColor];
    [introduceView setUserInteractionEnabled:YES];
    [introduceView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(APPIntroduce)]];
    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, WIDTH_SCREEN/2,50)];
    introduceLabel.text = @"APP介绍";
    introduceLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    introduceLabel.font = FontSize(14);
    [introduceView addSubview:introduceLabel];
//
    UIView *introduceLineView = [[UIView alloc]initWithFrame:CGRectMake(16, 49, SCREEN_WIDTH - 16- 16, 1)];
    [introduceView addSubview:introduceLineView];
    introduceLineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    
    
    UIImageView *introduceImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_rightImage"]];
    introduceImg.frame = CGRectMake(WIDTH_SCREEN - 18 -9.5 , (50-18)/2, 18, 18);
    [introduceView addSubview:introduceImg];
    [self.view addSubview:introduceView];
    
//
//    //关注我们
//    UIView *followView = [[UIView alloc] initWithFrame:CGRectMake(0, 187 + Height_NavBar + 50, WIDTH_SCREEN, 50)];
//    followView.backgroundColor = [UIColor whiteColor];
//    [followView setUserInteractionEnabled:YES];
//    [followView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(follow)]];
//    UILabel *followLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, WIDTH_SCREEN/2,50)];
//    followLabel.text = @"关注我们";
//    followLabel.font = FontSize(17);
//    [followView addSubview:followLabel];
//
//    UIImageView *followImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_gray_right"]];
//
//    followImg.frame = CGRectMake(WIDTH_SCREEN-FrameWidth(35), FrameWidth(28), FrameWidth(15), FrameWidth(20));
//    [followView addSubview:followImg];
//    [self.view addSubview:followView];
    //意见反馈
    UIView *opinionView = [[UIView alloc] initWithFrame:CGRectMake(0, 187 + Height_NavBar + 50, WIDTH_SCREEN, 50)];
    opinionView.backgroundColor = [UIColor whiteColor];
    [opinionView setUserInteractionEnabled:YES];
    [opinionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(opinion)]];
    UILabel *opinionLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, WIDTH_SCREEN/2,50)];
    opinionLabel.text = @"意见反馈";
    opinionLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    opinionLabel.font = FontSize(14);
    [opinionView addSubview:opinionLabel];
    
    UIImageView *opinionImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_rightImage"]];
    
    opinionImg.frame = CGRectMake(WIDTH_SCREEN - 18 -9.5 , (50-18)/2, 18, 18);
    [opinionView addSubview:opinionImg];
    [self.view addSubview:opinionView];
    UIView *opinionLineView = [[UIView alloc]initWithFrame:CGRectMake(16, 49, SCREEN_WIDTH - 16- 16, 1)];
    [opinionView addSubview:opinionLineView];
    opinionLineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    
    //服务协议
    UIView *serviceAgreeView = [[UIView alloc] initWithFrame:CGRectMake(0, 187 + Height_NavBar + 50 +50, WIDTH_SCREEN, 50)];
    serviceAgreeView.backgroundColor = [UIColor whiteColor];
    [serviceAgreeView setUserInteractionEnabled:YES];
    [serviceAgreeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicktograde)]];
    UILabel *serviceAgreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, WIDTH_SCREEN/2,50)];
    serviceAgreeLabel.text = @"服务协议";
    serviceAgreeLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    serviceAgreeLabel.font = FontSize(14);
    [serviceAgreeView addSubview:serviceAgreeLabel];
    
    UIImageView *serviceAgreeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_rightImage"]];
    
    serviceAgreeImg.frame = CGRectMake(WIDTH_SCREEN - 18 -9.5 , (50-18)/2, 18, 18);
    [serviceAgreeView addSubview:serviceAgreeImg];
    [self.view addSubview:serviceAgreeView];
    
    
}
-(void)clicktograde {
    [FrameBaseRequest showMessage:@"暂未提供服务"];
    //PersonalAPPIntroduceController *APPIntroduce = [[PersonalAPPIntroduceController alloc] init];
    //[self.navigationController pushViewController:APPIntroduce animated:YES];
}
-(void)APPIntroduce {
    PersonalAPPIntroduceController *APPIntroduce = [[PersonalAPPIntroduceController alloc] init];
    [self.navigationController pushViewController:APPIntroduce animated:YES];
}
-(void)follow {
    PersonalFollowUsController *FollowUs = [[PersonalFollowUsController alloc] init];
    [self.navigationController pushViewController:FollowUs animated:YES];
    
}

-(void)opinion {
    PersonalSendOpinionController *SendOpinion = [[PersonalSendOpinionController alloc] init];
    [self.navigationController pushViewController:SendOpinion animated:YES];
}




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
    //[self dismissViewControllerAnimated:YES completion:nil];
    //return ;
    //[self.navigationController pushViewController:[[FrameLoginController alloc]init] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor clearColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor clearColor];
    topImage.image = [self createImageWithColor:[UIColor clearColor]];
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationView];
    
    /** 添加标题栏 **/
    [self.navigationView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationView.mas_centerX);
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar+9);
    }];
    self.titleLabel.text = @"关于我们";
    
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



