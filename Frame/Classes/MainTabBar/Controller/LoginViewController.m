//
//  LoginViewController.m
//  Frame
//
//  Created by net on 2018/3/16.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "EditPwdController.h"
#import "FrameBaseRequest.h"
#import "PersonalPatrolItems.h"
#import "NSString+MD5.h"
#import "KG_LoginVIew.h"
#import "KG_LoginSelStationViewController.h"
@interface LoginViewController ()<UITextViewDelegate>
//@property (nonatomic,assign) NSInteger isshow;
@property (weak, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (retain, nonatomic) IBOutlet UIView *UserView;
@property (retain, nonatomic) IBOutlet UIView *PwdView;
@property (retain, nonatomic) IBOutlet UIButton *LoginBtn;
@property (retain, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) KG_LoginVIew *loginView;

@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"LoginViewController viewWillAppear");
    
    self.title = @" ";
   
//    [self.navigationController setNavigationBarHidden:YES];
     
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"alpha0"]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"alpha0"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTranslucent:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:YES]; //设置隐藏
//     self.navigationController.navigationBar.tintColor = [UIColor clearColor];
//
//
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"alpha0"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
//    self.navigationItem.leftBarButtonItem = leftItem;
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
   
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [_UserView release];
//    [_PwdView release];
//    [_LoginBtn release];
//    [_bgView release];
    [super dealloc];
}
-(void)viewWillDisappear:(BOOL)animated{
//     [self.navigationController setNavigationBarHidden:NO animated:animated];
    NSLog(@"LoginViewController viewWillDisappear");
}

- (void)viewDidLoad {
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES animated:true];
    self.tabBarController.tabBar.hidden = YES;
    [self createLoginView];
//    //背景的阴影
//    _bgView.layer.cornerRadius = 15;
//    _bgView.layer.shadowColor = [UIColor colorWithRed:64/255.0 green:159/255.0 blue:243/255.0 alpha:0.35].CGColor;
//    
//    _bgView.layer.shadowOpacity = 1.0f;
//    //阴影的圆角
//    _bgView.layer.shadowRadius = 8.f;
//    //阴影偏移量
//    _bgView.layer.shadowOffset = CGSizeMake(0,0);
//    
//    
//    _UserView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
//    
//    _UserView.layer.borderWidth = 1.3;
//    _UserView.layer.cornerRadius = 8;
//    
//    _PwdView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
//    
//    _PwdView.layer.borderWidth = 1.3;
//    _PwdView.layer.cornerRadius = 8;
//    
//    
//    
//    _userText.delegate = self;
//    _userText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的帐号或手机号" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#dbdbdb"],NSFontAttributeName:FontSize(16)
//                                                                                              
//    }];
////    [_userText setValue:FontSize(16) forKeyPath:@"_placeholderLabel.font"];
//    //_userText.text = @"ceshi";
//    _pwdText.delegate = self;
//    _pwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的密码" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#dbdbdb"],NSFontAttributeName:FontSize(16)}];
////    [_pwdText setValue:FontSize(16) forKeyPath:@"_placeholderLabel.font"];
//    
//    _LoginBtn.layer.cornerRadius = 8;
//    [_LoginBtn setBackgroundColor:[UIColor colorWithHexString:@"#409ff3"]];
}
- (IBAction)forgetPwd:(id)sender {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:NO];
    EditPwdController *EditPwd = [[EditPwdController alloc] init];
    [self.navigationController pushViewController:EditPwd animated:YES];
    
    return;
}

- (void)createLoginView {
    
    [self.view addSubview:self.loginView];
    weakify(self)
    self.loginView.runClick = ^{
        [FrameBaseRequest showMessage:@"运行中心暂未开放，敬请期待"];
        
    };
    self.loginView.stationClick = ^{
        strongify(self);
        KG_LoginSelStationViewController *VC = [[KG_LoginSelStationViewController alloc]init];
              [self.navigationController pushViewController:VC animated:YES];
        
    };
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
-(void)backAction{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 1 && string.length == 0) {
        return YES;
    } else if (textField.text.length >= 20) {
        textField.text = [textField.text substringToIndex:20];
//        [FrameBaseRequest showMessage:@"最多输入20位字符"];
        return NO;
    }
    return YES;
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_userText  endEditing:YES];
    [_pwdText  endEditing:YES];
}

- (IBAction)LoginOk:(id)sender {
    [_userText  endEditing:YES];
    [_pwdText  endEditing:YES];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/api/login"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = _userText.text;
    NSString * pwd = _pwdText.text;//registrationID
    
    NSString *password=[[[[pwd MD5]  stringByAppendingString:params[@"username"]] MD5] MD5];
    
    params[@"password"] = password;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
//    params[@"registrationId"] = [userDefaults objectForKey:@"registrationID"];
    params[@"registrationId"] = @"1d13c2dc-fb3a-441f-976d-7a7537018245";
    params[@"specificStationCode"] = @"HCDHT";
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            [FrameBaseRequest showMessage:[result objectForKey:@"errMsg"]];
            return ;
        }
        NSLog(@"resultresult %@",result);
        NSDictionary *userDic = result[@"value"][@"userInfo"];
        //[userDefaults setObject:result[@"value"][@"contactLevel"] forKey:@"contactLevel"];
        //[userDefaults setObject:result[@"value"][@"customerId"] forKey:@"customerId"];
        //[userDefaults setObject:result[@"value"][@"email"] forKey:@"email"];
        //[userDefaults setObject:result[@"value"][@"enabled"] forKey:@"enabled"];
        //[userDefaults setObject:result[@"value"][@"expert"] forKey:@"expert"];
        [userDefaults setObject:safeString(userDic[@"hang"]) forKey:@"hang"];
        [userDefaults setObject:[CommonExtension returnWithString:userDic[@"icon"]]  forKey:@"icon"];
        [userDefaults setObject:[CommonExtension returnWithString:userDic[@"id"]]  forKey:@"id"];
        [userDefaults setObject:[CommonExtension returnWithString:userDic[@"name"]]  forKey:@"name"];
        //[userDefaults setObject:result[@"value"][@"orgId"] forKey:@"orgId"];
        //[userDefaults setObject:result[@"value"][@"orgName"] forKey:@"orgName"];
        //[userDefaults setObject:result[@"value"][@"remark"] forKey:@"remark"];
        [userDefaults setObject:userDic[@"role"]  forKey:@"role"];
        //[userDefaults setObject:result[@"value"][@"sync"] forKey:@"sync"];
        [userDefaults setObject:[CommonExtension returnWithString:userDic[@"tel"]]  forKey:@"tel"];
        [userDefaults setObject:[CommonExtension returnWithString:userDic[@"userAccount"]]  forKey:@"userAccount"];
        [userDefaults setObject:password forKey:@"password"];
        //如果和上一个用户不一样，就清掉这个缓存
        if(![userDic[@"userAccount"] isEqualToString:[userDefaults objectForKey:@"lastAserAccount"]]){
            [userDefaults removeObjectForKey:@"station"];
            [userDefaults setObject:[CommonExtension returnWithString:userDic[@"userAccount"]]  forKey:@"lastAserAccount"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = NO;
//         [self.navigationController setNavigationBarHidden:NO animated:true];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController.tabBarController setSelectedIndex:2];
        
        //[self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
        [UserManager shareUserManager].loginSuccess = YES;
        
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
    return ;
}

- (KG_LoginVIew *)loginView {
    if (!_loginView) {
        _loginView = [[KG_LoginVIew alloc]init];
    }
    return _loginView;
}
@end
