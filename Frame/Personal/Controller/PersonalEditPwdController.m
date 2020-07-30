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
    //旧密码
    UIView *oldPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(20)+ Height_NavBar, WIDTH_SCREEN, FrameWidth(80))];
    oldPwdView.backgroundColor = [UIColor whiteColor];
    UILabel *oldPwdTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, WIDTH_SCREEN/2,FrameWidth(80))];
    oldPwdTitleLabel.font = FontSize(15);
    oldPwdTitleLabel.text = @"旧密码";
    oldPwdTitleLabel.textColor = [UIColor  grayColor];
    [oldPwdView addSubview:oldPwdTitleLabel];
    _oldPwdText = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(180), 0, FrameWidth(300), FrameWidth(80))];
    _oldPwdText.font = FontSize(15);
    _oldPwdText.secureTextEntry = YES;
    _oldPwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写旧密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],NSFontAttributeName:FontSize(15)}];
    //[textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [_oldPwdText setValue:FontSize(15) forKeyPath:@"_placeholderLabel.font"];
    //[_oldPwdText setValue:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:0.8] forKeyPath:@"_placeholderLabel.textColor"];
    _oldPwdText.tag=1;
    _oldPwdText.delegate = self;
    [oldPwdView addSubview:_oldPwdText];
    [self.view addSubview:oldPwdView];
    
    
    //新密码
    UIView *newPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(110)+ Height_NavBar, WIDTH_SCREEN, FrameWidth(80))];
    newPwdView.backgroundColor = [UIColor whiteColor];
    UILabel *newPwdTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, WIDTH_SCREEN/2,FrameWidth(80))];
    newPwdTitleLabel.font = FontSize(15);
    newPwdTitleLabel.text = @"新密码";
    newPwdTitleLabel.textColor = [UIColor  grayColor];
    [newPwdView addSubview:newPwdTitleLabel];
    _oneNewPwdText = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(180), 0, FrameWidth(300), FrameWidth(80))];
    _oneNewPwdText.font = FontSize(15);
    _oneNewPwdText.secureTextEntry = YES;
    _oneNewPwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写新密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],NSFontAttributeName:FontSize(15)}];
    //[textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [_oneNewPwdText setValue:FontSize(15) forKeyPath:@"_placeholderLabel.font"];
    //[_oneNewPwdText setValue:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:0.8] forKeyPath:@"_placeholderLabel.textColor"];
    _oneNewPwdText.tag=2;
    _oneNewPwdText.delegate = self;
    [newPwdView addSubview:_oneNewPwdText];
    [self.view addSubview:newPwdView];
    
    //确认密码
    UIView *sureNewPwdView = [[UIView alloc] initWithFrame:CGRectMake(0,FrameWidth(200)+ Height_NavBar, WIDTH_SCREEN, FrameWidth(80))];
    sureNewPwdView.backgroundColor = [UIColor whiteColor];
    UILabel *sureNewPwdTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, WIDTH_SCREEN/2,FrameWidth(80))];
    sureNewPwdTitleLabel.font = FontSize(15);
    sureNewPwdTitleLabel.text = @"确认密码";
    sureNewPwdTitleLabel.textColor = [UIColor  grayColor];
    [sureNewPwdView addSubview:sureNewPwdTitleLabel];
    _sureNewPwdText = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(180), 0, FrameWidth(300), FrameWidth(80))];
    _sureNewPwdText.font = FontSize(15);
    _sureNewPwdText.secureTextEntry = YES;
    _sureNewPwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再次输入新密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],NSFontAttributeName:FontSize(15)}];
    //[textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [_sureNewPwdText setValue:FontSize(15) forKeyPath:@"_placeholderLabel.font"];
    //[_sureNewPwdText setValue:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:0.8] forKeyPath:@"_placeholderLabel.textColor"];
    _sureNewPwdText.tag=2;
    _sureNewPwdText.delegate = self;
    [sureNewPwdView addSubview:_sureNewPwdText];
    [self.view addSubview:sureNewPwdView];
    //修改密码
    UIButton *submitButton = [[UIButton alloc] initWithFrame: CGRectMake((WIDTH_SCREEN-FrameWidth(470))/2, FrameWidth(470),FrameWidth(470), FrameWidth(80))];
    [submitButton setTitle:@"修改密码" forState:UIControlStateNormal];
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
        [FrameBaseRequest showMessage:@"请填写旧密码"];
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


