//
//  PersonalInfoController.m
//  Frame
//
//  Created by hibayWill on 2018/3/16.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PersonalInfoController.h"
#import "PersonalEditMobileController.h"

#import "FrameBaseRequest.h"

#import "UIView+LX_Frame.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>

@interface PersonalInfoController (){
    
}
@property NSString *imgUrl;
@property(strong,nonatomic)UIImageView *headImage;


@end

@implementation PersonalInfoController

//static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的信息";
    [self backBtn];
}

-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout=UIRectEdgeBottom;
    
    [self loadBgView];
}

-(void)loadBgView{
    NSLog(@"===%f",self.view.lx_y);
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    CGFloat viewX = self.view.lx_y;
    if (viewX == ZNAVViewH) {
        viewX = 0;
    }
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,viewX, WIDTH_SCREEN, FrameWidth(125))];
    headView.backgroundColor = [UIColor whiteColor];
    [headView setUserInteractionEnabled:YES];
    [headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getImageFromIpc:)]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSArray * positions = [userDefaults objectForKey:@"role"];
    NSString *position =  @"";
    if(![positions  isEqual: @[]] ){
        position = positions[0];
        for (int i = 1; i < positions.count; i++) {
            position = [NSString stringWithFormat:@"%@、%@",position,positions[i]];
        }
        //position = [userDefaults objectForKey:@"role"][0];
    }
    NSString *tel = [userDefaults objectForKey:@"tel"];
    
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(15), FrameWidth(95), FrameWidth(95))];
    [_headImage sd_setImageWithURL:[NSURL URLWithString: [WebHost stringByAppendingString:[userDefaults objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"personal_head"]];
    
    _headImage.layer.masksToBounds=YES;
    _headImage.layer.cornerRadius=FrameWidth(95)/2;
    _headImage.tag = 1;
    [headView addSubview:_headImage];
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_SCREEN/2, headView.frame.size.height/2-15, WIDTH_SCREEN/2-45,30)];
    headLabel.textAlignment = NSTextAlignmentRight;
    headLabel.textColor = [UIColor lightGrayColor];
    headLabel.text = @"更换头像";
    headLabel.font = FontSize(15);
    
    
    //headLabel.textColor = [UIColor blueColor];
    [headView addSubview:headLabel];
    
    UIImageView *headRight = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH_SCREEN-30, headView.frame.size.height/2-10, 12, 20)];
    headRight.image = [UIImage imageNamed:@"personal_gray_right"];
    [headView addSubview:headRight];
    [self.view addSubview:headView];
    
    
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake( 0,CGRectGetMaxY(headView.frame),WIDTH_SCREEN, FrameWidth(80))];
    nameView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(25), WIDTH_SCREEN/2,20)];
    //nameTitleLabel.textAlignment = NSTextAlignmentRight;
    nameTitleLabel.text = @"姓名";
    nameTitleLabel.font = FontSize(15);
    nameTitleLabel.textColor = [UIColor lightGrayColor];
    [nameView addSubview:nameTitleLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_SCREEN/2, FrameWidth(25), WIDTH_SCREEN/2-20,20)];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.text = name;
    nameLabel.font = FontSize(15);
    nameLabel.textColor = [UIColor lightGrayColor];
    [nameView addSubview:nameLabel];
    
    [self.view addSubview:nameView];
    
    
    UIView *mobileView = [[UIView alloc] initWithFrame:CGRectMake( 0, FrameWidth(260),WIDTH_SCREEN, FrameWidth(80))];
    mobileView.backgroundColor = [UIColor whiteColor];
    
    UILabel *mobileTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(25), WIDTH_SCREEN/2,20)];
    //mobileTitleLabel.textAlignment = NSTextAlignmentRight;
    mobileTitleLabel.text = @"手机";
    mobileTitleLabel.font = FontSize(15);
    mobileTitleLabel.textColor = [UIColor lightGrayColor];
    [mobileView addSubview:mobileTitleLabel];
    
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_SCREEN/2, FrameWidth(25), WIDTH_SCREEN/2-45,20)];
    mobileLabel.textAlignment = NSTextAlignmentRight;
    mobileLabel.text = tel;
    mobileLabel.font = FontSize(15);
    mobileLabel.textColor = [UIColor lightGrayColor];
    [mobileLabel setUserInteractionEnabled:YES];
    [mobileLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeMobile)]];
    [mobileView addSubview:mobileLabel];
    
    UIImageView *mobileRight = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH_SCREEN-30, mobileView.frame.size.height/2-10, 12, 20)];
    mobileRight.image = [UIImage imageNamed:@"personal_gray_right"];
    [mobileView addSubview:mobileRight];
    
    [self.view addSubview:mobileView];
    
    
    UIView *positionView = [[UIView alloc] initWithFrame:CGRectMake( 0, FrameWidth(355),WIDTH_SCREEN, FrameWidth(80))];
    positionView.backgroundColor = [UIColor whiteColor];
    
    UILabel *positionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(25), WIDTH_SCREEN/2,20)];
    //positionTitleLabel.textAlignment = NSTextAlignmentRight;
    positionTitleLabel.text = @"角色";
    positionTitleLabel.font = FontSize(15);
    positionTitleLabel.textColor = [UIColor lightGrayColor];
    [positionView addSubview:positionTitleLabel];
    
    UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(30), FrameWidth(25), FrameWidth(590),20)];
    positionLabel.font = FontSize(15);
    positionLabel.textAlignment = NSTextAlignmentRight;
    positionLabel.text = position;
    positionLabel.textColor = [UIColor lightGrayColor];
    [positionView addSubview:positionLabel];
    
    [self.view addSubview:positionView];
    
    
    return ;
    
    
    
}
-(void)changeMobile{
    PersonalEditMobileController *EditMobile = [[PersonalEditMobileController alloc] init];
    [self.navigationController pushViewController:EditMobile animated:YES];
}


- (void)getImageFromIpc:(UITapGestureRecognizer *)sender {
    
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
    NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/api/modifyImg"];
    
    //photo.压缩
    NSData * datapng = UIImageJPEGRepresentation(photo, 0.3);
    //请求设置
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //[manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Accept"];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",  @"text/html", @"image/jpeg",  @"image/png", @"application/octet-stream", @"text/json",@"multipart/form-data",@"application/x-www-form-urlencoded", nil];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:FrameRequestURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:datapng//datapng
                                    name:@"file"
                                fileName:@"file.jpg"
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        NSLog(@"请求中：%@",uploadProgress);
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        NSLog(@"请求success %@",responseObject );
        
        if(![[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errCode"]]  isEqual: @"0"]){
            NSLog(@"请求失败%@",[responseObject objectForKey:@"errMsg"]);
            
        }
        NSString *response = [responseObject objectForKey:@"value"];
        NSLog(@"OK请求成功：%@",response);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:response forKey:@"icon"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        _imgUrl = [WebHost stringByAppendingString:response];
        
        [_headImage sd_setImageWithURL:[NSURL URLWithString: _imgUrl] placeholderImage:[UIImage imageNamed:@"personal_head"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyingHeadNotification" object:self];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"_Nonnull error：%@",error);
        
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return;
        //上传失败
    }];
    
    return ;
    
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation2"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


