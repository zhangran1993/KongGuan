//
//  PersonalSendOpinionController.m
//  Frame
//
//  Created by hibayWill on 2018/3/17.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PersonalSendOpinionController.h"
#import "FrameBaseRequest.h"

#import <UIImageView+WebCache.h>
#import <AFNetworking.h>

@interface PersonalSendOpinionController ()<UITextViewDelegate,UITextFieldDelegate>{
    NSTimer *timer;
}

@property(nonatomic)int *num;
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)UITextField *titletext;
@property(strong,nonatomic)UITextView *desctext;
@property(strong,nonatomic)UIImageView *image1;
@property(strong,nonatomic)UIImageView *image2;
@property(strong,nonatomic)UIImageView *image3;
@property(strong,nonatomic)UIButton *imgbtn1;
@property(strong,nonatomic)UIButton *imgbtn2;
@property(strong,nonatomic)UIButton *imgbtn3;
@property(strong,nonatomic)UIView *addressView;
@property(strong,nonatomic)UIButton *addressbtn;


@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;


@end

@implementation PersonalSendOpinionController

//static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [self backBtn];
    self.title = @"意见反馈";

    [self.navigationController setNavigationBarHidden:YES];
    [self createNaviTopView];
    [self loadBgView];
    [super viewDidLoad];
    if(_imageurls.count <= 0){
        _imgArray = [[NSMutableArray alloc] initWithCapacity:3];
    }else{
        _imgArray = [_imageurls mutableCopy];
    }
    [self setImage];
    
    
}
-(void)loadBgView{
    // int thisViewwidth = getScreen.size.width/2;
    //背景色
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    //文字内容
    UILabel  *opinionLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, +Height_NavBar ,FrameWidth(220),40)];
    opinionLabel.textAlignment = NSTextAlignmentLeft;
    opinionLabel.text = @"请描述具体问题";
    opinionLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    opinionLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    [self.view addSubview:opinionLabel];
//    问题主题


    //问题描述
    UIView *opiniondescView = [[UIView alloc] initWithFrame:CGRectMake(16, FrameWidth(180) +Height_NavBar, WIDTH_SCREEN, 130)];
    opiniondescView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:opiniondescView];
    [opiniondescView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.top.equalTo(opinionLabel.mas_bottom);
        make.height.equalTo(@130);
    }];
    
    _desctext = [[UITextView alloc]initWithFrame:CGRectMake(5, 10, WIDTH_SCREEN-10, opiniondescView.frame.size.height-20)];
    _desctext.font = FontSize(14);
    _desctext.tag = 100;
    _desctext.delegate = self;
    _desctext.textColor = [UIColor lightGrayColor];
    _desctext.layer.borderWidth = 0;
    _desctext.text = @"异常发生的时间、网络状况、具体位置及表现等";
    if(self.thisdesc){
        _desctext.text = self.thisdesc;
        _desctext.textColor = [UIColor blackColor];
    }
    [opiniondescView addSubview:_desctext];
    [_desctext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(opiniondescView.mas_left);
        make.right.equalTo(opiniondescView.mas_right);
        make.top.equalTo(opiniondescView.mas_top);
        make.height.equalTo(opiniondescView.mas_height);
    }];
    
    //上传问题截图
    
    UILabel  *opinionImgLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(23),FrameWidth(530)+Height_NavBar ,FrameWidth(220), 20)];
    opinionImgLabel.textAlignment = NSTextAlignmentLeft;
    opinionImgLabel.text = @"图片补充：(相关图能帮程序员哥哥解决问题哦~)";
    opinionImgLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    opinionImgLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    [self.view addSubview:opinionImgLabel];
    [opinionImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16.5);
        make.right.equalTo(self.view.mas_right).offset(-16.5);
        make.top.equalTo(opiniondescView.mas_bottom).offset(15.5);
        make.height.equalTo(@18);
    }];
    
    
    
    //图片上传
    UIView *ImgView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(580)+Height_NavBar, WIDTH_SCREEN, FrameWidth(135))];
    [self.view addSubview:ImgView];
    ImgView.backgroundColor = [UIColor whiteColor];
    [ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(opinionImgLabel.mas_bottom).offset(12);
        make.height.equalTo(@100);
    }];
    
    
    _image1 = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(15), FrameWidth(15), FrameWidth(100), FrameWidth(100))];
    [ImgView addSubview:_image1];
    [_image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ImgView.mas_left).offset(16);
        make.width.equalTo(@100);
        make.top.equalTo(ImgView.mas_top);
        make.height.equalTo(@100);
    }];
    
     
    
    _image2 = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(130), FrameWidth(15), FrameWidth(100), FrameWidth(100))];
    [ImgView addSubview:_image2];
    [_image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_image1.mas_right).offset(10);
        make.width.equalTo(@100);
        make.top.equalTo(ImgView.mas_top);
        make.height.equalTo(@100);
    }];
    
   
    _image3 = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(245), FrameWidth(15), FrameWidth(100), FrameWidth(100))];
    [ImgView addSubview:_image3];
    [_image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_image2.mas_right).offset(10);
        make.width.equalTo(@100);
        make.top.equalTo(ImgView.mas_top);
        make.height.equalTo(@100);
    }];
    
    
    _image1.image = [UIImage imageNamed:@"0"];
    _image1.clipsToBounds = YES;
    [_image1 setUserInteractionEnabled:YES];
    _image1.tag = 1;
    [_image1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getImageFromIpc:)]];
    [_image2 setUserInteractionEnabled:YES];
    _image2.tag = 2;
    [_image2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getImageFromIpc:)]];
    
    [_image3 setUserInteractionEnabled:YES];
    _image3.tag = 3;
    [_image3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getImageFromIpc:)]];
    
    /*
    _imgbtn1 = [[UIButton alloc]initWithFrame:CGRectMake(getScreen.size.width/3-30, 0, 25, 25)];
    _imgbtn2 = [[UIButton alloc]initWithFrame:CGRectMake(getScreen.size.width/3-30, 0, 25, 25)];
    _imgbtn3 = [[UIButton alloc]initWithFrame:CGRectMake(getScreen.size.width/3-30, 0, 25, 25)];
    
    
    [_imgbtn1 setImage:[UIImage imageNamed:@"delete_pic"] forState:UIControlStateNormal];
    [_imgbtn2 setImage:[UIImage imageNamed:@"delete_pic"] forState:UIControlStateNormal];
    [_imgbtn3 setImage:[UIImage imageNamed:@"delete_pic"] forState:UIControlStateNormal];
    _imgbtn1.tag = 1;
    _imgbtn2.tag = 2;
    _imgbtn3.tag = 3;
    [_imgbtn1 addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [_imgbtn2 addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [_imgbtn3 addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    
    [_image1 addSubview:_imgbtn1];
    [_image2 addSubview:_imgbtn2];
    [_image3 addSubview:_imgbtn3];
    [_imgbtn1 setHidden:true];
    [_imgbtn2 setHidden:true];
    [_imgbtn3 setHidden:true];
    */
   
    UILabel *contactLabel = [[UILabel alloc]init];
    [self.view addSubview:contactLabel];
    contactLabel.text = @"联系方式：(选填)";
    contactLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    contactLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    contactLabel.textAlignment = NSTextAlignmentLeft;
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.top.equalTo(ImgView.mas_bottom).offset(16);
        make.width.equalTo(@200);
        make.height.equalTo(@13.5);
    }];
    
    UIView *opinionView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(90)+Height_NavBar, WIDTH_SCREEN, FrameWidth(80))];
    opinionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:opinionView];
    opinionView.layer.cornerRadius = 6.f;
    opinionView.layer.masksToBounds = YES;
    opinionView.layer.borderWidth = 1;
    opinionView.layer.borderColor = [[UIColor colorWithHexString:@"#DBDCE7"] CGColor];
    [opinionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.top.equalTo(contactLabel.mas_bottom).offset(12);
        make.height.equalTo(@44);
        
    }];
    
    _titletext = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(20), 0, FrameWidth(500), FrameWidth(80))];
    _titletext.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请注明是QQ/微信/手机号的哪一种" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#BABCC4"],NSFontAttributeName:FontSize(14)}];
   
//    [_titletext setValue:FontSize(17) forKeyPath:@"_placeholderLabel.font"];
//    [_titletext setValue:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:0.6] forKeyPath:@"_placeholderLabel.textColor"];
    _titletext.tag=2;
    _titletext.delegate = self;
    [opinionView addSubview:_titletext];
    [_titletext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(opinionView.mas_left);
        make.right.equalTo(opinionView.mas_right);
        make.height.equalTo(opinionView.mas_height);
        make.top.equalTo(opinionView.mas_top);
    }];
  
    //问题提交
    UIButton *submitButton = [[UIButton alloc] initWithFrame: CGRectMake((WIDTH_SCREEN-FrameWidth(470))/2, FrameWidth(820)+Height_NavBar, FrameWidth(470), FrameWidth(80))];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [submitButton.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
    submitButton.titleLabel.font = FontSize(16);
    [submitButton setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    [self.view addSubview:submitButton];
    
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-TABBAR_HEIGHT-30);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.equalTo(@44);
    }];
    return;
    
}
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([FrameBaseRequest stringContainsEmoji:textField.text]) {
        UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"输入内容含有表情，请重新输入" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertContor animated:NO completion:nil];
        
        textField.text = @"";
    }
    return [textField resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //UITextField *pwd = [self.view viewWithTag:101];
    [_titletext endEditing:YES];
    [_desctext endEditing:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    
    if (pointLength > 200){
        return NO;
    }else{
        return YES;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textViewDidEndEditing");
    if(_desctext.text.length < 1){
        _desctext.text = @"请填写10字以上的问题描述以便我们提供更好的帮助";
        _desctext.textColor = [UIColor lightGrayColor];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    
    NSLog(@"textViewDidChange");
    if([_desctext.text rangeOfString:@"\n"].length >0){
        
    }
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    NSLog(@"textViewDidChangeSelection");
    if ([FrameBaseRequest stringContainsEmoji:textView.text]) {
        UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"输入内容含有表情，请重新输入" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertContor animated:NO completion:nil];
        
        textView.text = @"";
        [textView becomeFirstResponder];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing");
    if([_desctext.text isEqualToString:@"请填写10字以上的问题描述以便我们提供更好的帮助"]){
        _desctext.text = @"";
        _desctext.textColor = [UIColor blackColor];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)backValue:(NSString *)string color:(UIColor *)color
{
    
}

-(void)submit{
    if(_submitNum == 1){
        return ;
    }
    [_titletext endEditing:YES];
    [_desctext endEditing:YES];
    
    if([_titletext.text isEqualToString:@""]){
        
        [FrameBaseRequest showMessage:@"请填写主题"];
        return ;
    }
    
    if([_desctext.text isEqualToString:@"请填写10字以上的问题描述以便我们提供更好的帮助"]||[_desctext.text isEqualToString:@""]){
        
        [FrameBaseRequest showMessage:@"请填写内容"];
        return ;
    }
    if(_desctext.text.length < 10){
        [FrameBaseRequest showMessage:@"内容不能少于10字"];
        return ;
    }
    
    NSInteger imgcount = [_imgArray count];
    
    
    if(imgcount<= 0){
        //[FrameBaseRequest showMessage:@"请上传图片！"];
        //return ;
        
    }
    //_titletext.text = [_titletext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //_desctext.text = [_desctext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    int hasEmoji = 0;
     if ([FrameBaseRequest stringContainsEmoji:_titletext.text]) {
         hasEmoji = 1;
         //_titletext.text = @"";
         //[_titletext becomeFirstResponder];
     }
    if ([FrameBaseRequest stringContainsEmoji:_desctext.text]) {
        hasEmoji = 1;
        //_desctext.text = @"";
        //[_desctext becomeFirstResponder];
    }
    if(hasEmoji == 1){
        [FrameBaseRequest showMessage:@"不能包含特殊字符"];
        return ;
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"title"] = _titletext.text;
    params[@"content"] = _desctext.text;
    params[@"pictureOne"] = @"";
    params[@"pictureTwo"] = @"";
    params[@"pictureThree"] = @"";
    for (int i = 0; i<imgcount; i++) {
        if(i == 0){
            params[@"pictureOne"] = [_imgArray objectAtIndex:0];
        }
        if(i == 1){
            params[@"pictureTwo"] = [_imgArray objectAtIndex:1];
        }
        if(i == 2){
            params[@"pictureThree"] = [_imgArray objectAtIndex:2];
        }
    }
    
    NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/api/atcFeedback"];
    _submitNum = 1;
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        _submitNum = 0;
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if(code == 0){
            [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
            [self backAction];
        }
        
    } failure:^(NSError *error)  {
        _submitNum = 0;
        FrameLog(@"请求失败，返回数据 : %@",error);
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
    //[self.navigationController popToViewController:self animated:YES];
}

/*返回*/
-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
}

-(void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*选择图片*/
- (void)getImageFromIpc:(UITapGestureRecognizer *)sender {
    NSInteger imgcount = [_imgArray count];
    UIView *viewClicked=[sender view];
    if(imgcount==3){
        [self Delete:viewClicked.tag];
        return;
    }
    if(viewClicked.tag != _image1.tag&&imgcount==0){
        [self Delete:viewClicked.tag];
        return;
    }
    if(viewClicked.tag != _image2.tag&&imgcount==1){
        [self Delete:viewClicked.tag];
        return;
    }
    if(viewClicked.tag != _image3.tag&&imgcount==2){
        [self Delete:viewClicked.tag];
        return;
    }
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"请设置允许本应用访问相册！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertContor animated:NO completion:nil];
        return;
    }
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self upDateHeadIcon:info[UIImagePickerControllerOriginalImage]];
        
        
    }];
}

- (void)upDateHeadIcon:(UIImage *)photo{
    //请求地址
    NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/upload/app/feedback"];

    //photo.压缩
    NSData * datapng = UIImageJPEGRepresentation(photo, 0.3);
    //请求设置
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",  @"text/html", @"image/jpeg",  @"image/png", @"application/octet-stream", @"text/json",@"multipart/form-data",@"application/x-www-form-urlencoded", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:FrameRequestURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:datapng
                                    name:@"file"
                                fileName:@"file.jpg"
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //NSLog(@"请求失败中：%@",uploadProgress);
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        if(![[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errCode"]]  isEqual: @"0"]){
            NSLog(@"请求失败%@",[responseObject objectForKey:@"errMsg"]);
            [FrameBaseRequest showMessage:[responseObject objectForKey:@"errMsg"]];
        }
        NSString *response = [[responseObject objectForKey:@"value"] objectForKey:@"url"];
        [_imgArray addObject:[WebHost stringByAppendingString:response]];
        [self setImage];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        
        NSLog(@"error ：%@",error);
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return;
        //上传失败
    }];
}
-(void)setImage{
    
    NSInteger imgcount = [_imgArray count];
    NSLog(@"_imgArray%@",_imgArray);
    NSLog(@"imgcount%ld",(long)imgcount);
    [_imgbtn1 setHidden:true];
    [_imgbtn2 setHidden:true];
    [_imgbtn3 setHidden:true];
    if(imgcount == 0){
        _image1.image = [UIImage imageNamed:@"personal_photo"];
        _image2.image = nil;
        _image3.image = nil;
    }else if(imgcount == 1){
        [_image1 sd_setImageWithURL:[NSURL URLWithString: [_imgArray objectAtIndex:0]]];
        _image2.image = [UIImage imageNamed:@"personal_photo"];
        _image3.image = nil;
        [self performSelector:@selector(show1) withObject:nil afterDelay:3.0f];
        [_image1 setHidden:false];
        
    }else if(imgcount == 2){
        [_image1 sd_setImageWithURL:[NSURL URLWithString: [_imgArray objectAtIndex:0]]];
        [_image2 sd_setImageWithURL:[NSURL URLWithString: [_imgArray objectAtIndex:1]]];
        _image3.image = [UIImage imageNamed:@"personal_photo"];
        [self performSelector:@selector(show2) withObject:nil afterDelay:3.0f];
        [_image1 setHidden:false];
        [_image2 setHidden:false];
    }else if(imgcount == 3){
        [_image1 sd_setImageWithURL:[NSURL URLWithString: [_imgArray objectAtIndex:0]]];
        [_image2 sd_setImageWithURL:[NSURL URLWithString: [_imgArray objectAtIndex:1]]];
        [_image3 sd_setImageWithURL:[NSURL URLWithString: [_imgArray objectAtIndex:2]]];
        [self performSelector:@selector(show3) withObject:nil afterDelay:3.0f];
        [_image1 setHidden:false];
        [_image2 setHidden:false];
        [_image3 setHidden:false];
    }
}

-(void)show1{
    
    [_imgbtn1 setHidden:false];
}
-(void)show2{
    [_imgbtn1 setHidden:false];
    [_imgbtn2 setHidden:false];
}
-(void)show3{
    [_imgbtn1 setHidden:false];
    [_imgbtn2 setHidden:false];
    [_imgbtn3 setHidden:false];
}

-(void)delete:(UIButton*)sender{
    NSInteger imgcount = [_imgArray count];
    if(imgcount >= sender.tag){
        [_imgArray removeObjectAtIndex:sender.tag-1];
        [self setImage];
        
    }
}

-(void)Delete:(NSInteger)tg{
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"删除该张图片？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSInteger imgcount = [_imgArray count];
        if(imgcount >= tg){
            [_imgArray removeObjectAtIndex:tg-1];
            [self setImage];
            
        }
        return ;
    }]];
    [self presentViewController:alertContor animated:NO completion:nil];
    
}

-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)theTize//图片压缩到指定CGSize大小
{
    UIGraphicsBeginImageContext(theTize);
    [image drawInRect:CGRectMake(0, 0, theTize.width, theTize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
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
    self.titleLabel.text = @"意见反馈";
    
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

