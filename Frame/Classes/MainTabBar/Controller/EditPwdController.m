//
//  EditPwdController.m
//  Frame
//
//  Created by hibayWill on 2018/3/31.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "EditPwdController.h"
#import "FrameBaseRequest.h"
#import "NSString+MD5.h"

@interface EditPwdController (){
    int timeCont;
    NSTimer *timer;
}

@property(strong,nonatomic)UITextField *mobileText;
@property(strong,nonatomic)UITextField *verifText;
@property(strong,nonatomic)UIButton *changeButton;
@property(strong,nonatomic)UITextField *pwdText;
@property(strong,nonatomic)UITextField *pwdTextSure;
@property(strong,nonatomic)UIButton *sureItems;
@property(copy,nonatomic)NSString * nowMobile;
@property(copy,nonatomic)NSString * verif;
@end

@implementation EditPwdController

//static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(20),NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    [super viewDidLoad];
    self.title = @"忘记密码";
    [self backBtn];
    [self loadBgView];
    
}
-(void)loadBgView{
    timeCont = 60;
    
    
    //背景色
    self.view.backgroundColor =  BGColor ;
    //已绑定手机号
    UIView *MobileView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(15), WIDTH_SCREEN, FrameWidth(80))];
    MobileView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:MobileView];
    
    UILabel *MobileViewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, FrameWidth(130),FrameWidth(80))];
    MobileViewTitleLabel.font = FontSize(15);
    MobileViewTitleLabel.text = @"手机号码";
    [MobileView addSubview:MobileViewTitleLabel];
    
    _mobileText = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(150), 0,FrameWidth(480), FrameWidth(80))];
    _mobileText.font = FontSize(15);
    _mobileText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:FontSize(15)}];
    //[textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [_mobileText setValue:FontSize(15) forKeyPath:@"_placeholderLabel.font"];
    [_mobileText setValue:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:0.8] forKeyPath:@"_placeholderLabel.textColor"];
    _mobileText.tag=1;
    _mobileText.delegate = self;
    [MobileView addSubview:_mobileText];
    
    
    

    //手机号验证码
    UIView *VerifView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(15)+MobileView.frame.origin.y+MobileView.frame.size.height, WIDTH_SCREEN, FrameWidth(80))];
    VerifView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:VerifView];
    UILabel *VerifLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(20), FrameWidth(150),20)];
    VerifLabel.font = FontSize(15);
    VerifLabel.text = @"验证码";
    [VerifView addSubview:VerifLabel];
    
    _verifText = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(150), 0, FrameWidth(300), FrameWidth(80))];
    _verifText.font = FontSize(15);
    _verifText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:FontSize(15)}];
//    [_verifText setValue:FontSize(15) forKeyPath:@"_placeholderLabel.font"];
    [_verifText setValue:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:0.8] forKeyPath:@"_placeholderLabel.textColor"];
    _verifText.tag=1;
    _verifText.delegate = self;
    [VerifView addSubview:_verifText];
    
    _changeButton = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(465), FrameWidth(10), FrameWidth(150), FrameWidth(55))];
    [_changeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _changeButton.titleLabel.font = FontSize(14);
    [_changeButton setTitleColor:[UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
    _changeButton.layer.borderColor = [[UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1] CGColor];
    _changeButton.layer.borderWidth = 1;
    _changeButton.layer.cornerRadius = 5.0f;//设置为图片宽度的一半出来为圆形
    [_changeButton addTarget:self action:@selector(setupTimer:) forControlEvents:UIControlEventTouchUpInside];
    _changeButton.tag = 2;
    [VerifView addSubview:_changeButton];
    
    
    
    //新密码
    UIView *newPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(15)+VerifView.frame.origin.y+VerifView.frame.size.height, WIDTH_SCREEN, FrameWidth(80))];
    newPwdView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:newPwdView];
    
    UILabel *newPwdTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, FrameWidth(130),FrameWidth(80))];
    newPwdTitleLabel.font = FontSize(15);
    newPwdTitleLabel.text = @"新密码";
    [newPwdView addSubview:newPwdTitleLabel];
    
    _pwdText = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(150), 0,FrameWidth(480), FrameWidth(80))];
    
    _pwdTextSure.font = FontSize(15);
    _pwdText.secureTextEntry = YES;
    _pwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:FontSize(15)}];
//    [_pwdText setValue:FontSize(15) forKeyPath:@"_placeholderLabel.font"];
    [_pwdText setValue:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:0.8] forKeyPath:@"_placeholderLabel.textColor"];
    _pwdText.tag=1;
    _pwdText.delegate = self;
    [newPwdView addSubview:_pwdText];
    
    //确认密码
    UIView *newPwdSureView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(15)+newPwdView.frame.origin.y+newPwdView.frame.size.height, WIDTH_SCREEN, FrameWidth(80))];
    newPwdSureView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:newPwdSureView];
    
    UILabel *newPwdSureTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, FrameWidth(130),FrameWidth(80))];
    newPwdSureTitleLabel.font = FontSize(15);
    newPwdSureTitleLabel.text = @"确认密码";
    [newPwdSureView addSubview:newPwdSureTitleLabel];
    
    _pwdTextSure = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(150), 0,FrameWidth(480), FrameWidth(80))];
    _pwdTextSure.font = FontSize(15);
    _pwdTextSure.secureTextEntry = YES;
    _pwdTextSure.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再次输入新密码" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:FontSize(15)}];
//    [_pwdTextSure setValue:FontSize(15) forKeyPath:@"_placeholderLabel.font"];
    [_pwdTextSure setValue:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:0.8] forKeyPath:@"_placeholderLabel.textColor"];
    _pwdTextSure.tag=1;
    _pwdTextSure.delegate = self;
    [newPwdSureView addSubview:_pwdTextSure];
    
    _mobileText.keyboardType = UIKeyboardTypeNumberPad;
    _verifText.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    _pwdText.keyboardType = UIKeyboardTypeASCIICapable;
    _pwdTextSure.keyboardType = UIKeyboardTypeASCIICapable;
    //_pwdTextSure.keyboardType = UIKeyboardTypeASCIICapable;
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame: CGRectMake((WIDTH_SCREEN-FrameWidth(470))/2, FrameWidth(470), FrameWidth(470), FrameWidth(80))];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitAll) forControlEvents:UIControlEventTouchUpInside];
    [submitButton.layer setCornerRadius:FrameWidth(40)]; //设置矩形四个圆角半径
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
    submitButton.titleLabel.font = FontSize(16);
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
        
    }else {
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.text.length > 11){
        _mobileText.text =[ _mobileText.text substringWithRange:NSMakeRange(0,11)];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    
    if(textField == _mobileText){
        if (pointLength > 11){
            return NO;
        }else{
            return YES;
        }
    }else{
        if (pointLength > 20){
            return NO;
        }else{
            return YES;
        }
    }
    
    
    
    
    
}

//倒计时
-(void)setupTimer:(UIButton *)button{
    [self.view endEditing:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if([_mobileText.text isEqualToString:@""]){
        [FrameBaseRequest showMessage:@"请输入手机号"];
        
        return ;
    }
    if(![self validateMobile:(NSString *)_mobileText.text]){
        [FrameBaseRequest showMessage:@"手机号格式错误"];
        
        return ;
    }
    params[@"mobile"] = _mobileText.text;
    _nowMobile = [_mobileText.text copy];
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/api/sms/%@/%@",WebHost,_nowMobile,@"old"];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
        }
        if(code == 0){
            _changeButton.userInteractionEnabled = NO;
            _verif = [result[@"value"][@"smsCode"] copy];//[[result objectForKey:@"value"] objectForKey:@"smsCode"];
            [_changeButton setTitle:[NSString stringWithFormat:@"%d秒",timeCont] forState:UIControlStateNormal];
            timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
           
            
        }
    } failure:^(NSURLSessionDataTask *error)  {
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
}

- (void)updateLabel{
    timeCont --;
    
    if (timeCont < 0) {
        _changeButton.userInteractionEnabled = YES;
        [_changeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        timeCont = 60;
        [timer invalidate];
        return;
    }
    [_changeButton setTitle:[NSString stringWithFormat:@"%d秒",timeCont] forState:UIControlStateNormal];
}
//提交
-(void)submitAll{
    [self.view endEditing:YES];
    if([_mobileText.text isEqualToString:@""]){
        [FrameBaseRequest showMessage:@"请输入手机号"];
        return ;
    }
    if([_verifText.text isEqualToString:@""]){
        [FrameBaseRequest showMessage:@"请输入验证码"];
        return ;
    }
    if([_pwdText.text isEqualToString:@""]){
        [FrameBaseRequest showMessage:@"请输入新密码"];
        return ;
    }
    if([_pwdTextSure.text isEqualToString:@""]){
        [FrameBaseRequest showMessage:@"请再次输入新密码"];
        return ;
    }
    if(![self validateMobile:(NSString *)_mobileText.text]){
        [FrameBaseRequest showMessage:@"手机号格式错误"];
        return ;
    }
    
    if(![_pwdTextSure.text isEqualToString:_pwdText.text]){
        [FrameBaseRequest showMessage:@"两次密码不一致"];
        return ;
    }
    if(![_nowMobile isEqualToString:_mobileText.text]){
        [FrameBaseRequest showMessage:@"请重新获取验证码"];
        return ;
    }
    if(![_verif isEqualToString:_verifText.text]){
        [FrameBaseRequest showMessage:@"验证码错误"];
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *pwd = [_pwdText.text MD5];
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/api/forget/%@/%@",WebHost,_mobileText.text,pwd];
    [FrameBaseRequest putWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if(code == 0){
            [FrameBaseRequest showMessage:result[@"value"]];
            [self backAction];
            return ;
        }
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
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
    
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    //return ;
    //[self.navigationController pushViewController:[[FrameLoginController alloc]init] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validateMobile:(NSString *)mobile{
    
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (mobile.length != 11){
        return NO;
    }else{
        NSString *mobileRegex = @"^((1[0-9][0-9]))\\d{8}$";
        NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileRegex];
        BOOL n = [mobileTest evaluateWithObject:mobile];
        return n;
    }
    
}



@end

