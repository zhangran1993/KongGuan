//
//  KG_NewLoginViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/19.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NewLoginViewController.h"
#import "KG_RunManagerViewController.h"
@interface KG_NewLoginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)  UILabel      *promptLabel;
@property (nonatomic,strong)  UILabel      *userLabel;
@property (nonatomic,strong)  UITextField  *userTextField;
@property (nonatomic,strong)  UILabel      *passLabel;
@property (nonatomic,strong)  UITextField  *passTextField;
@property (nonatomic,strong)  UIView       *navigationView;
@property (nonatomic,strong)  UIButton     *loginBtn;

@property (nonatomic,copy)    NSString     *userString;
@property (nonatomic,copy)    NSString     *passString;

@property (nonatomic,strong) NSDictionary *  currentStationDic;
@end

@implementation KG_NewLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self initData];
    [self setupDataSubviews];
   
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    self.tabBarController.tabBar.hidden = NO;
    
}

//初始化数据
- (void)initData {
    
}

//创建视图
-(void)setupDataSubviews
{
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navigationView];
    
    /** 返回按钮 **/
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.bottom.equalTo(self.navigationView.mas_bottom);
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
    UIImageView *loginBgImage = [[UIImageView alloc]init];
    [self.view addSubview:loginBgImage];
    loginBgImage.image = [UIImage imageNamed:@"login_bgImage"];
    [loginBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(44);
        make.top.equalTo(backBtn.mas_bottom).offset(20);
        make.width.equalTo(@81);
        make.height.equalTo(@40);
    }];
    
    self.promptLabel = [[UILabel alloc]init];
    [self.view addSubview:self.promptLabel];
    self.promptLabel.text = @"你好，欢迎登录智慧台站";
    self.promptLabel.textColor = [UIColor colorWithHexString:@"#142038"];
    self.promptLabel.font = [UIFont boldSystemFontOfSize:22];
    self.promptLabel.textAlignment = NSTextAlignmentLeft;
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(43);
        make.top.equalTo(loginBgImage.mas_bottom).offset(25);
        make.height.equalTo(@30);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
   
    self.userLabel = [[UILabel alloc]init];
    [self.view addSubview:self.userLabel];
    self.userLabel.text = @"用户名";
    self.userLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.userLabel.font = [UIFont systemFontOfSize:14];
    self.userLabel.textAlignment = NSTextAlignmentLeft;
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(45);
        make.top.equalTo(self.promptLabel.mas_bottom).offset(70);
        make.height.equalTo(@20);
        make.width.equalTo(@120);
    }];
    
    self.userTextField = [[UITextField alloc]init];
    [self.view addSubview:self.userTextField];
    self.userTextField.delegate = self;
    self.userTextField.placeholder = @"请输入用户名";
    [self.userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userLabel.mas_bottom);
        make.height.equalTo(@49);
        make.left.equalTo(self.view.mas_left).offset(45);
        make.right.equalTo(self.view.mas_right).offset(-40);
    }];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"loginName"]) {
        self.userTextField.text = safeString([userDefaults objectForKey:@"loginName"]);
        self.userString = safeString([userDefaults objectForKey:@"loginName"]);
    }
      //    params[@"registrationId"] = [userDefaults objectForKey:@"registrationID"];
    
    [self.userTextField addTarget:self action:@selector(textEdit:) forControlEvents:UIControlEventEditingChanged];
    UIView *lineView = [[UIView alloc]init];
    [self.view addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(44);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.equalTo(@1);
        make.top.equalTo(self.userTextField.mas_bottom);
    }];
    
    self.passLabel = [[UILabel alloc]init];
    [self.view addSubview:self.passLabel];
    self.passLabel.text = @"密码";
    self.passLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.passLabel.font = [UIFont systemFontOfSize:14];
    self.passLabel.textAlignment = NSTextAlignmentLeft;
    [self.passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(45);
        make.top.equalTo(lineView.mas_bottom).offset(36);
        make.height.equalTo(@20);
        make.width.equalTo(@120);
    }];
    self.passTextField = [[UITextField alloc]init];
    [self.view addSubview:self.passTextField];
    self.passTextField.delegate = self;
    self.passTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passTextField.placeholder = @"请输入密码";
    self.passTextField.secureTextEntry = YES;
    [self.passTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passLabel.mas_bottom);
        make.height.equalTo(@49);
        make.left.equalTo(self.view.mas_left).offset(45);
        make.right.equalTo(self.view.mas_right).offset(-40);
    }];
    [self.passTextField addTarget:self action:@selector(textEdit:) forControlEvents:UIControlEventEditingChanged];
    UIView *lineView1 = [[UIView alloc]init];
    [self.view addSubview:lineView1];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(44);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.equalTo(@1);
        make.top.equalTo(self.passTextField.mas_bottom);
    }];
    
    self.loginBtn = [[UIButton alloc]init];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn addTarget:self action:@selector(loginMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    [self.loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    self.loginBtn.alpha =0.29;
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35);
        make.right.equalTo(self.view.mas_right).offset(-34);
        make.height.equalTo(@54);
        make.top.equalTo(lineView1.mas_bottom).offset(78);
    }];
    self.loginBtn.layer.cornerRadius = 30;
    self.loginBtn.layer.masksToBounds = YES;
}
//登录

- (void)loginMethod:(UIButton *)button {
    NSLog(@"%@%@",self.userString,self.passString);
    [self.view endEditing:YES];
    if(self.userString.length == 0 || self.passString.length == 0){
        return;
    }
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/api/login"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = self.userString;
    NSString * pwd = self.passString;//registrationID
    
    NSString *password = [[[[pwd MD5]  stringByAppendingString:params[@"username"]] MD5] MD5];
    
    params[@"password"] = password;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //    params[@"registrationId"] = [userDefaults objectForKey:@"registrationID"];
    params[@"registrationId"] = @"1d13c2dc-fb3a-441f-976d-7a7537018245";
    params[@"specificStationCode"] = safeString(self.detailModel.stationCode);
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            NSString *errStr = safeString(result[@"errMsg"]);
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"" message:errStr preferredStyle:UIAlertControllerStyleAlert];
            
            WS(weakSelf)
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:action2];
            
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
            
            return ;
        }
        int stationAuth = [result[@"value"][@"stationAuth"] intValue];
        if (stationAuth ==0) {
           [FrameBaseRequest showMessage:@"您没有该台站的登录权限，请选择您权限内的台站"];
            return;
        }
        NSLog(@"resultresult %@",result);
        NSDictionary *userDic = result[@"value"][@"userInfo"];
        
        [userDefaults setObject:safeString(userDic[@"userSource"]) forKey:@"userSource"];
        [userDefaults setObject:safeString(userDic[@"customerId"]) forKey:@"customerId"];
        [userDefaults setObject:safeString(userDic[@"companyId"]) forKey:@"companyId"];
        [userDefaults setObject:safeString(userDic[@"hang"]) forKey:@"hang"];
        [userDefaults setObject:safeString(userDic[@"specificStationCode"]) forKey:@"specificStationCode"];
        [userDefaults setObject:[CommonExtension returnWithString:userDic[@"icon"]]  forKey:@"icon"];
        [userDefaults setObject:[CommonExtension returnWithString:userDic[@"id"]]  forKey:@"id"];
        [userDefaults setObject:[CommonExtension returnWithString:userDic[@"name"]]  forKey:@"name"];
      
        [userDefaults setObject:userDic[@"role"]  forKey:@"role"];
       
        [userDefaults setObject:[CommonExtension returnWithString:userDic[@"tel"]]  forKey:@"tel"];
        [userDefaults setObject:[CommonExtension returnWithString:userDic[@"userAccount"]]  forKey:@"userAccount"];
        [userDefaults setObject:self.passString forKey:@"password"];
        [userDefaults setObject:self.userString forKey:@"loginName"];
               
        //如果和上一个用户不一样，就清掉这个缓存
        if(![userDic[@"userAccount"] isEqualToString:[userDefaults objectForKey:@"lastAserAccount"]]){
            [userDefaults removeObjectForKey:@"station"];
            [self quertFrameData];
            [userDefaults setObject:[CommonExtension returnWithString:userDic[@"userAccount"]]  forKey:@"lastAserAccount"];
             [[NSUserDefaults standardUserDefaults] synchronize];
        }else {
              [userDefaults setObject:[CommonExtension returnWithString:userDic[@"userAccount"]]  forKey:@"lastAserAccount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
            [UserManager shareUserManager].loginSuccess = YES;
            int num = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshYunxingData" object:self];
            for (UIViewController *VC in self.navigationController.viewControllers) {
                if ([VC isKindOfClass:[KG_RunManagerViewController class]]) {
                    num ++;
                    [self.navigationController.tabBarController setSelectedIndex:2];
                    
                    [self.navigationController popToViewController:VC animated:YES];
                }
            }
            
            if (num == 0 &&self.navigationController.viewControllers.count >0) {
                [self.navigationController.tabBarController setSelectedIndex:2];
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers firstObject] animated:YES];
            }
            
        }
       
      
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
  
}
- (void)backButtonClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textEdit:(UITextField *)textField {
    if ([textField isEqual:self.userTextField]) {
        self.userString = textField.text;
    }else {
        self.passString = textField.text;
    }
    if (self.userString.length >0 &&self.passString.length >0) {
        self.loginBtn.alpha = 1;
    }else {
        self.loginBtn.alpha = 0.29;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)quertFrameData{
    //    NSString *FrameRequestURL = @"http://10.33.33.147:8089/intelligent/api/stationList";
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/stationList"]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUDForView:JSHmainWindow];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
        [UserManager shareUserManager].stationList = result[@"value"];
        
        [self createData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUDForView:JSHmainWindow];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            return;
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

- (void)createData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"station"]){
        self.currentStationDic = [userDefaults objectForKey:@"station"];
    }else {
        self.currentStationDic = [[UserManager shareUserManager].stationList firstObject][@"station"];
    }
    NSString *specificStationCode = @"";
    if([userDefaults objectForKey:@"specificStationCode"]){
        specificStationCode = [userDefaults objectForKey:@"specificStationCode"];
    }
    if (specificStationCode.length >0) {
        for (NSDictionary *stationDic in [UserManager shareUserManager].stationList) {
            if ([safeString(stationDic[@"station"][@"code"])  isEqualToString:specificStationCode]) {
                self.currentStationDic = stationDic[@"station"];
                break;
            }
        }
    }
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithDictionary:self.currentStationDic];
    for (NSString*s in [dataDic allKeys]) {
        if ([dataDic[s] isEqual:[NSNull null]]) {
            [dataDic setObject:@"" forKey:s];
        }
    }
    [userDefaults setObject:dataDic forKey:@"station"];
    
    [UserManager shareUserManager].currentStationDic = self.currentStationDic;
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    [UserManager shareUserManager].loginSuccess = YES;
    
    int num = 0;
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[KG_RunManagerViewController class]]) {
            num ++;
            [self.navigationController.tabBarController setSelectedIndex:2];
            
            [self.navigationController popToViewController:VC animated:YES];
        }
    }
    
    if (num == 0 &&self.navigationController.viewControllers.count >0) {
        [self.navigationController.tabBarController setSelectedIndex:2];
//          [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshZhiHuanData" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshYunxingData" object:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers firstObject] animated:YES];
       
    }
}

@end
