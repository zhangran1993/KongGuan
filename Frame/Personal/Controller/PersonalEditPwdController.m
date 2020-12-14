//
//  PersonalEditPwdController.m
//  Frame
//
//  Created by hibayWill on 2018/3/17.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PersonalEditPwdController.h"


#import "FrameNavigationController.h"

#import "FrameBaseRequest.h"
#import "NSString+MD5.h"

@interface PersonalEditPwdController (){
    int timeCont;
    NSTimer *timer;
}

@property(strong,nonatomic)UITextField *oldPwdText;
@property(strong,nonatomic)UITextField *oneNewPwdText;
@property(strong,nonatomic)UITextField *sureNewPwdText;
@property(strong,nonatomic)UIButton *sureItems;


@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;

@end

@implementation PersonalEditPwdController

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
    
    self.title = @"修改密码";
    [self backBtn];
    [self loadBgView];
    
}
-(void)loadBgView{
    timeCont = 60;
    
    //背景色
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@60);
    }];
    
    UILabel *accountLabel = [[UILabel alloc]init];
    [self.view addSubview:accountLabel];
    accountLabel.text = @"用户名";
    accountLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    accountLabel.font = [UIFont systemFontOfSize:14];
    [accountLabel sizeToFit];
    accountLabel.numberOfLines = 1;
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT +28.5);
        make.height.equalTo(@13);
    }];
    
    UILabel *accountDetailLabel = [[UILabel alloc]init];
    [self.view addSubview:accountDetailLabel];
    accountDetailLabel.text = @"-";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"name"]) {
        
        accountDetailLabel.text = [userDefaults objectForKey:@"name"];
        
    }
    accountDetailLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    accountDetailLabel.font = [UIFont systemFontOfSize:14];
    [accountDetailLabel sizeToFit];
    accountDetailLabel.numberOfLines = 1;
    [accountDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(90.5);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT +28.5);
        make.height.equalTo(@13);
    }];
    
    
    //旧密码
    UIView *oldPwdView = [[UIView alloc] initWithFrame:CGRectMake(0,  60 + Height_NavBar, WIDTH_SCREEN, 50)];
    oldPwdView.backgroundColor = [UIColor whiteColor];
    UILabel *oldPwdTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 50, 50)];
    oldPwdTitleLabel.font = FontSize(14);
    oldPwdTitleLabel.text = @"原密码";
    oldPwdTitleLabel.textColor = [UIColor  colorWithHexString:@"#24252A"];
    [oldPwdView addSubview:oldPwdTitleLabel];
    
    _oldPwdText = [[UITextField alloc]initWithFrame:CGRectMake(90.5, 0, FrameWidth(300), 50)];
    _oldPwdText.font = FontSize(14);
    _oldPwdText.secureTextEntry = YES;
    _oldPwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写原密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],NSFontAttributeName:FontSize(14)}];
    _oldPwdText.tag = 1;
    _oldPwdText.delegate = self;
    [oldPwdView addSubview:_oldPwdText];
    [self.view addSubview:oldPwdView];
    
    
    //新密码
    UIView *newPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 60 + 60 + Height_NavBar, WIDTH_SCREEN, 50)];
    newPwdView.backgroundColor = [UIColor whiteColor];
    UILabel *newPwdTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 50,50)];
    newPwdTitleLabel.font = FontSize(14);
    newPwdTitleLabel.text = @"新密码";
    newPwdTitleLabel.textColor = [UIColor  colorWithHexString:@"#24252A"];
    [newPwdView addSubview:newPwdTitleLabel];
    
    _oneNewPwdText = [[UITextField alloc]initWithFrame:CGRectMake(90.5, 0, FrameWidth(300), 50)];
    _oneNewPwdText.font = FontSize(14);
    _oneNewPwdText.secureTextEntry = YES;
    _oneNewPwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写新密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],NSFontAttributeName:FontSize(14)}];
    _oneNewPwdText.tag = 2;
    _oneNewPwdText.delegate = self;
    [newPwdView addSubview:_oneNewPwdText];
    [self.view addSubview:newPwdView];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [newPwdView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newPwdView.mas_left).offset(16);
        make.right.equalTo(newPwdView.mas_right).offset(-16);
        make.top.equalTo(newPwdTitleLabel.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    
    //确认密码
    UIView *sureNewPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 60 + 60 + Height_NavBar +50 , WIDTH_SCREEN, 50)];
    sureNewPwdView.backgroundColor = [UIColor whiteColor];
    UILabel *sureNewPwdTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 60,50)];
    sureNewPwdTitleLabel.font = FontSize(14);
    sureNewPwdTitleLabel.text = @"确认密码";
    sureNewPwdTitleLabel.textColor = [UIColor  colorWithHexString:@"#24252A"];
    [sureNewPwdView addSubview:sureNewPwdTitleLabel];
    
    _sureNewPwdText = [[UITextField alloc]initWithFrame:CGRectMake(90.5, 0, FrameWidth(300), 50)];
    _sureNewPwdText.font = FontSize(14);
    _sureNewPwdText.secureTextEntry = YES;
    _sureNewPwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再次输入新密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],NSFontAttributeName:FontSize(14)}];
 
    _sureNewPwdText.tag = 2;
    _sureNewPwdText.delegate = self;
    [sureNewPwdView addSubview:_sureNewPwdText];
    [self.view addSubview:sureNewPwdView];
    
//    //修改密码
//    UIButton *submitButton = [[UIButton alloc] initWithFrame: CGRectMake((WIDTH_SCREEN-FrameWidth(470))/2, FrameWidth(470),FrameWidth(470), FrameWidth(80))];
//    [submitButton setTitle:@"修改密码" forState:UIControlStateNormal];
//    [submitButton addTarget:self action:@selector(submitAll) forControlEvents:UIControlEventTouchUpInside];
//    [submitButton.layer setCornerRadius:FrameWidth(40)]; //设置矩形四个圆角半径
//    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
//    submitButton.titleLabel.font = FontSize(16);
//    [submitButton.layer setBackgroundColor:[UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1].CGColor];//边框颜色
//    [self.view addSubview:submitButton];
//
    
     
}

//在输入完成时，调用下面那个方法来判断输入的字符串是否含有表情
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([FrameBaseRequest stringContainsEmoji:textField.text]) {
        UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入内容含有表情，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertContor animated:NO completion:nil];
        
        textField.text = @"";
        [textField becomeFirstResponder];
    }else {
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    //[verification endEditing:YES];
    //[userName endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

-(void)submitAll{
    NSLog(@"submitAll");
    [_oldPwdText  resignFirstResponder];
    [_oneNewPwdText  resignFirstResponder];
    [_sureNewPwdText  resignFirstResponder];
    if(_oldPwdText.text.length <= 0 ){
        [FrameBaseRequest showMessage:@"请填写原密码"];
        return ;
    }
    if(_oneNewPwdText.text.length <= 0 ){
        [FrameBaseRequest showMessage:@"请输入新密码"];
        return ;
    }
    if(_sureNewPwdText.text.length <= 0 ){
        [FrameBaseRequest showMessage:@"请再次输入新密码"];
        return ;
    }
    if(![_sureNewPwdText.text isEqualToString:  _oneNewPwdText.text] ){
        [FrameBaseRequest showMessage:@"两次新密码不一致"];
        return ;
    }
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定修改？" preferredStyle:UIAlertControllerStyleAlert];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"origin"] = [_oldPwdText.text MD5];
        params[@"newPwd"] = [_oneNewPwdText.text MD5];
        
        NSString *FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/api/modifypwd"];
        
        FrameRequestURL = [FrameRequestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [FrameBaseRequest putWithUrl:FrameRequestURL param:params success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                
                return ;
            }
            [self logout];
            
        } failure:^(NSError *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
//            if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
//                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//                [FrameBaseRequest logout];
//                UIViewController *viewCtl = self.navigationController.viewControllers[0];
//                [self.navigationController popToViewController:viewCtl animated:YES];
//                return;
//            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        }];
    }]];
    
    [self presentViewController:alertContor animated:NO completion:nil];
    
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
-(void)logout{
    NSLog(@"logout");
    //清除信息
   
    [FrameBaseRequest logout];
    
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"修改成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //返回
        UIViewController *viewCtl = self.navigationController.viewControllers[0];
        [self.navigationController popToViewController:viewCtl animated:YES];
    }]];
    [self presentViewController:alertContor animated:NO completion:nil];
    
    return ;
}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    self.titleLabel.text = @"修改密码";
    
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
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.titleLabel.font = FontSize(16);
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.navigationView addSubview:self.rightButton];
    [self.rightButton addTarget:self action:@selector(submitAll) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.equalTo(@22);
        make.right.equalTo(self.navigationView.mas_right).offset(-16);
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


