//
//  PersonalEditMobileController.m
//  Frame
//
//  Created by hibayWill on 2018/3/16.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PersonalEditMobileController.h"
#import "FrameNavigationController.h"

#import "FrameBaseRequest.h"

@interface PersonalEditMobileController (){
    int timeCont;
    NSTimer *timer;
    int timeCont1;
    NSTimer *timer1;
    NSString * verif1;
    NSString * verif0;
}

@property(strong,nonatomic)UILabel *oldMobileLabel;
@property(strong,nonatomic)UITextField *oldVerifText;
@property(strong,nonatomic)UITextField *mobileText;
@property(strong,nonatomic)UITextField *verifText;
@property(strong,nonatomic)UIButton *oldChangeButton;
@property(strong,nonatomic)UIButton *changeButton;
@property(strong,nonatomic)UIButton *sureItems;
@property(copy,nonatomic)NSString * nowMobile;

@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;


@end

@implementation PersonalEditMobileController

//static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES];
    [self createNaviTopView];
    self.title = @"更换手机";
    [self backBtn];
    [self loadBgView];
}
-(void)loadBgView{
    timeCont = 60;
    timeCont1 = 60;
    
    //背景色
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    //已绑定手机号
    UIView *oldMobileView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(20)+Height_NavBar, WIDTH_SCREEN, FrameWidth(80))];
    oldMobileView.backgroundColor = [UIColor whiteColor];
    UILabel *oldMobileTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, WIDTH_SCREEN/2,FrameWidth(80))];
    oldMobileTitleLabel.font = FontSize(17);
    oldMobileTitleLabel.text = @"已绑定的手机号码";
    [oldMobileView addSubview:oldMobileTitleLabel];
    
    _oldMobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_SCREEN/2, FrameWidth(20), WIDTH_SCREEN/2-20,20)];
    _oldMobileLabel.font = FontSize(17);
    _oldMobileLabel.textAlignment = NSTextAlignmentRight;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _oldMobileLabel.text = [userDefaults objectForKey:@"tel"];
    [oldMobileView addSubview:_oldMobileLabel];
    [self.view addSubview:oldMobileView];
    //旧手机号验证码
    UIView *oldVerifView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(110), WIDTH_SCREEN, FrameWidth(80))];
    oldVerifView.backgroundColor = [UIColor whiteColor];
    UILabel *oldVerifLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20),0, WIDTH_SCREEN/2,FrameWidth(80))];
    oldVerifLabel.font = FontSize(17);
    oldVerifLabel.text = @"验证码";
    [oldVerifView addSubview:oldVerifLabel];
    
    _oldVerifText = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(180), 0, FrameWidth(300), FrameWidth(80))];
    _oldVerifText.font = FontSize(16);
    _oldVerifText.keyboardType = UIKeyboardTypeNumberPad;
    _oldVerifText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:FontSize(16),NSForegroundColorAttributeName:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:0.8]}];

    
//    _oldVerifText.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入验证码"attributes:@{}];

    _oldVerifText.tag=1;
    _oldVerifText.delegate = self;
    [oldVerifView addSubview:_oldVerifText];
    
    _oldChangeButton = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(465), FrameWidth(10), FrameWidth(148), FrameWidth(55))];
    [_oldChangeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _oldChangeButton.titleLabel.font = FontSize(14);
    [_oldChangeButton setTitleColor:[UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
    //[_oldChangeButton setBackgroundImage:[UIImage imageNamed:@"personal_verifbutton"] forState:UIControlStateNormal];
    _oldChangeButton.layer.borderColor = [[UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1] CGColor];
    _oldChangeButton.layer.borderWidth = 1;
    _oldChangeButton.layer.cornerRadius = 5.0f;//设置为图片宽度的一半出来为圆形
    [_oldChangeButton addTarget:self action:@selector(setupTimer:) forControlEvents:UIControlEventTouchUpInside];
    _oldChangeButton.tag = 2;
    [oldVerifView addSubview:_oldChangeButton];
    [self.view addSubview:oldVerifView];
    
    //新手机号
    UIView *mobileView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(200) + Height_NavBar, WIDTH_SCREEN, FrameWidth(80))];
    mobileView.backgroundColor = [UIColor whiteColor];
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, WIDTH_SCREEN/2,FrameWidth(80))];
    mobileLabel.font = FontSize(17);
    mobileLabel.text = @"新手机号码";
    [mobileView addSubview:mobileLabel];
    
    _mobileText = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(180), 0, FrameWidth(300), FrameWidth(80))];
    _mobileText.font = FontSize(16);
    //_mobileText.keyboardType = UIKeyboardTypeDecimalPad;
    _mobileText.keyboardType = UIKeyboardTypeNumberPad;
    _mobileText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新的手机号" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:FontSize(16),NSForegroundColorAttributeName:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:0.8]}];

    

    _mobileText.tag=3;
    _mobileText.delegate = self;
    [mobileView addSubview:_mobileText];
    
    [self.view addSubview:mobileView];
    
    
    
    //新验证码
    UIView *verifView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(290) + Height_NavBar, WIDTH_SCREEN, FrameWidth(80))];
    verifView.backgroundColor = [UIColor whiteColor];
    UILabel *verifLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, WIDTH_SCREEN/2,FrameWidth(80))];
    verifLabel.font = FontSize(17);
    verifLabel.text = @"新验证码";
    [verifView addSubview:verifLabel];
    
    _verifText = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(180), 0, FrameWidth(300), FrameWidth(80))];
    _verifText.font = FontSize(16);
    _verifText.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    _verifText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:FontSize(16),NSForegroundColorAttributeName:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:0.8]}];

  
    _verifText.tag=4;
    _verifText.delegate = self;
    [verifView addSubview:_verifText];
    
    _changeButton = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(465), FrameWidth(10),FrameWidth(148), FrameWidth(55))];
    //[_changeButton setBackgroundImage:[UIImage imageNamed:@"personal_verifbutton"] forState:UIControlStateNormal];
    [_changeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _changeButton.titleLabel.font = FontSize(14);
    [_changeButton setTitleColor:[UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
    _changeButton.layer.borderColor = [[UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1] CGColor];
    _changeButton.layer.borderWidth = 1;
    _changeButton.layer.cornerRadius = 5.0f;//设置为图片宽度的一半出来为圆形
    _changeButton.tag = 5;
    [_changeButton addTarget:self action:@selector(setupTimer:) forControlEvents:UIControlEventTouchUpInside];
    
    [verifView addSubview:_changeButton];
    [self.view addSubview:verifView];
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame: CGRectMake((WIDTH_SCREEN-FrameWidth(470))/2, FrameWidth(470), FrameWidth(470), FrameWidth(80))];
    [submitButton setTitle:@"更换手机号码" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitAll) forControlEvents:UIControlEventTouchUpInside];
    [submitButton.layer setCornerRadius:FrameWidth(40)]; //设置矩形四个圆角半径
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
    submitButton.titleLabel.font = FontSize(17);
    [submitButton.layer setBackgroundColor:[UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1].CGColor];//边框颜色
    [self.view addSubview:submitButton];
    
}

//在输入完成时，调用下面那个方法来判断输入的字符串是否含有表情
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([FrameBaseRequest stringContainsEmoji:textField.text]) {
        UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"输入内容含有表情，请重新输入" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertContor animated:NO completion:nil];
        
        textField.text = @"";
        [textField becomeFirstResponder];
    }else {
    }
}


//倒计时
-(void)setupTimer:(UIButton *)button{
    [self.view endEditing:YES];
    
    if(_oldChangeButton == button){
        [self smsVerif:_oldMobileLabel.text button:button];
        return ;
    }
    
    if([_mobileText.text isEqualToString:@""]){
        [FrameBaseRequest showMessage:@"请输入新的手机号"];

        return ;
    }
    if(![self validateMobile:_mobileText.text]||[FrameBaseRequest stringContainsEmoji:_mobileText.text]){
        [FrameBaseRequest showMessage:@"手机号码格式错误"];
        
        return ;
    }
    [self smsVerif:_mobileText.text button:button];
   
}
-(void)smsVerif:(NSString *)mobile button:(UIButton *)button{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *type = @"new";
    if(_oldChangeButton == button){
        type = @"old";
    }
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/api/sms/%@/%@",WebNewHost,mobile,type];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
        }
        
        if(code == 0){
            button.userInteractionEnabled = NO;
            if(_oldChangeButton == button){
                verif0 = [result[@"value"][@"smsCode"] copy];//[[result objectForKey:@"value"] objectForKey:@"smsCode"];
                [button setTitle:[NSString stringWithFormat:@"%d秒",timeCont] forState:UIControlStateNormal];
                timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            }else{
                _nowMobile = [mobile copy];
                verif1 = [result[@"value"][@"smsCode"] copy];//[[result objectForKey:@"value"] objectForKey:@"smsCode"];
                [button setTitle:[NSString stringWithFormat:@"%d秒",timeCont1] forState:UIControlStateNormal];
                timer1 = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateLabel1) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer1 forMode:NSRunLoopCommonModes];
            }
            
        }
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//            [FrameBaseRequest logout];
//            UIViewController *viewCtl = self.navigationController.viewControllers[0];
//            [self.navigationController popToViewController:viewCtl animated:YES];
//            return;
//        }else if(responses.statusCode == 502){
//            
//        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
- (void)updateLabel{
    
    UIButton *btnGetCode = _oldChangeButton;
    timeCont --;
    
    if (timeCont < 0) {
        btnGetCode.userInteractionEnabled = YES;
        [btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        timeCont = 60;
        [timer invalidate];
        return;
    }
    [btnGetCode setTitle:[NSString stringWithFormat:@"%d秒",timeCont] forState:UIControlStateNormal];
}
- (void)updateLabel1{
    
    UIButton *btnGetCode = _changeButton;
    timeCont1 --;
    
    if (timeCont1 < 0) {
        btnGetCode.userInteractionEnabled = YES;
        [btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        timeCont1 = 60;
        [timer1 invalidate];
        return;
    }
    [btnGetCode setTitle:[NSString stringWithFormat:@"%d秒",timeCont1] forState:UIControlStateNormal];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    //[verification endEditing:YES];
    //[userName endEditing:YES];
}
-(void)submitAll{
    [self.view endEditing:YES];
    if([_oldVerifText.text isEqualToString:@""]||[verif0 isEqualToString:@""]){
        
        [FrameBaseRequest showMessage:@"请输入验证码"];
        return ;
    }
    if([_verifText.text isEqualToString:@""]||[verif1 isEqualToString:@""]){
        
        [FrameBaseRequest showMessage:@"请输入验证码"];//新
        return ;
    }
    if(![verif0 isEqualToString:_oldVerifText.text]){
        
        [FrameBaseRequest showMessage:@"验证码不正确，请输入正确的验证码"];
        return ;
    }
    if(![verif1 isEqualToString:_verifText.text]){
        
        [FrameBaseRequest showMessage:@"验证码不正确,请输入正确的验证码"];//新
        return ;
    }
    if(![_nowMobile isEqualToString:_mobileText.text]){
        [FrameBaseRequest showMessage:@"请重新获取验证码验证码"];
        return ;
    }
    
    
    
    if(_oldMobileLabel.text.length <= 0 ){
        UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"已绑定手机号码不能为空" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertContor animated:NO completion:nil];
        return ;
        
    }
    if(_mobileText.text.length <= 0 ){
        UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"新手机号码不能为空" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertContor animated:NO completion:nil];
        return ;
        
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"origin"] = _oldMobileLabel.text;
    params[@"new"] = _mobileText.text;
    
    NSString *FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/api/modifytel"];
    [FrameBaseRequest putWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:_mobileText.text forKey:@"tel"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self backAction];
        
    } failure:^(NSError *error)  {
//        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//            [FrameBaseRequest logout];
//            UIViewController *viewCtl = self.navigationController.viewControllers[0];
//            [self.navigationController popToViewController:viewCtl animated:YES];
//            return;
//        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
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
    [self.view endEditing:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
    //return ;
    //[self.navigationController pushViewController:[[FrameLoginController alloc]init] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13,14,15,18,17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1([2-9])\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
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
    self.titleLabel.text = @"更换手机";
    
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

