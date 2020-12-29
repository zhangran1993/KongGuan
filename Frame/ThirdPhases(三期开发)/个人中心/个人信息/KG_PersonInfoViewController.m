//
//  KG_MineViewController.m
//  Frame
//
//  Created by zhangran on 2020/12/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_PersonInfoViewController.h"
#import "KG_PersonInfoHeadIconCell.h"
#import "KG_PersonInfoNameCell.h"
#import "KG_PersonInfoStationCell.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <WebKit/WebKit.h>
#import "PersonalChooseStationController.h"
@interface KG_PersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,WKNavigationDelegate>{
    
}

@property (nonatomic,strong)   WKWebView             *webView;

@property (nonatomic, strong)  UITableView           *tableView;

@property (nonatomic, strong)  NSArray               *dataArray;

@property (nonatomic, strong)  UILabel               *titleLabel;

@property (nonatomic, strong)  UIView                *navigationView;

@property (nonatomic, strong)  UIButton              *rightButton;

@property (nonatomic, copy)    NSString              *headStr;

@end

@implementation KG_PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    [self createNaviTopView];

    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [self.view addSubview:headView];
    headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = headView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
//    [self loadWebView];
    
}

- (void)loadWebView {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebHost,@"/html5"]];
    NSLog(@"WebHostWebHost%@",url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView = [[WKWebView alloc] init];
//    self.webView.delegate= self;
    [self.view addSubview:self.webView];
    self.webView.navigationDelegate = self;
    self.webView .backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.webView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    
    [self.webView loadRequest:request];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
    
    if([ self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        
        if(@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        }else{
            
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    NSLog(@"StationDetailController viewWillDisappear");
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else if (indexPath.row == 1) {
        return 60;
    }else if (indexPath.row == 2) {
        return 60;
    }else if (indexPath.row == 3) {
        return 60;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        KG_PersonInfoHeadIconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_PersonInfoHeadIconCell"];
        if (cell == nil) {
            cell = [[KG_PersonInfoHeadIconCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_PersonInfoHeadIconCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.selHeadIcon = ^{
            [self showActionSheet];
            
        };
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"icon"]){
            NSString *iconStr = [userDefaults objectForKey:@"icon"];
            if([iconStr isEqualToString:@"head_icon"]) {
                cell.headImage.image = [UIImage imageNamed:@"head_blueIcon"];
            }else {
                
                [cell.headImage sd_setImageWithURL:[NSURL URLWithString: [WebNewHost stringByAppendingString:[userDefaults objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"head_blueIcon"]];
            }
        }else {
            cell.headImage.image = [UIImage imageNamed:@"head_blueIcon"];
        }
        if (self.headStr.length >0) {
             
             if([self.headStr isEqualToString:@"head_icon"]) {
                 cell.headImage.image = [UIImage imageNamed:@"head_blueIcon"];
             }else {
                 [cell.headImage sd_setImageWithURL:[NSURL URLWithString:self.headStr] placeholderImage:[UIImage imageNamed:@"head_blueIcon"]];
             }
            
        }
        return cell;
        
    }else if (indexPath.row == 1) {
        KG_PersonInfoNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_PersonInfoNameCell"];
        if (cell == nil) {
            cell = [[KG_PersonInfoNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_PersonInfoNameCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = @"姓名";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *name = [userDefaults objectForKey:@"name"];
        cell.detailLabel.text = name;
        return cell;
        
    }else if (indexPath.row == 2) {
        KG_PersonInfoNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_PersonInfoNameCell"];
        if (cell == nil) {
            cell = [[KG_PersonInfoNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_PersonInfoNameCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = @"角色";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSArray * positions = [userDefaults objectForKey:@"role"];
        NSString *position = @"";
        if(![positions  isEqual: @[]] ){
            position = positions[0];
            for (int i = 1; i < positions.count; i++) {
                position = [NSString stringWithFormat:@"%@、%@",position,positions[i]];
            }
        }
        cell.detailLabel.text = position;
        return cell;
        
    }else if (indexPath.row == 3) {
        KG_PersonInfoStationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_PersonInfoStationCell"];
        if (cell == nil) {
            cell = [[KG_PersonInfoStationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_PersonInfoStationCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
       
        cell.detailLabel.text = self.stationStr;
        return cell;
        
    }
    return nil;
}

- (NSString *)CurTimeMilSec:(NSString*)pstrTime {
    NSDateFormatter *pFormatter= [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *pCurrentDate = [pFormatter dateFromString:pstrTime];
    return [NSString stringWithFormat:@"%.f",[pCurrentDate timeIntervalSince1970] * 1000];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 3) {
        PersonalChooseStationController *vc = [[PersonalChooseStationController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
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
    self.titleLabel.text = @"个人信息";
    
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
    
    if (self.refreshData) {
        self.refreshData();
    }
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

- (void)getImageFromIpc {
    
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
    NSString *FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/api/modifyImg"];
    
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
        self.headStr = [WebNewHost stringByAppendingString:response];
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"_Nonnull error：%@",error);
        
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return;
        //上传失败
    }];
    
    return ;
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

- (void)showActionSheet {
    UIActionSheet *myActionSheet;
    myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改头像", @"恢复默认头像", nil];
    [myActionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [self getImageFromIpc];
            break;
            
        case 1:
            //            [self getImageFromIpc];
            NSLog(@"恢复默认头像");
             [self upDateHeadIcon:[UIImage imageNamed:@"head_icon"]];
            break;
            
        default:
            break;
    }
}
//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
//{
//    for (UIView *subViwe in actionSheet.subviews) {
//        if ([subViwe isKindOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton*)subViwe;
//            button.titleLabel.font=[UIFont systemFontOfSize:16];
//            [button setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
//
//        }
//    }
//}

-(void)willPresentActionSheet:(UIActionSheet*)actionSheet

{
    
    SEL selector =NSSelectorFromString(@"_alertController");
    
    if([actionSheet respondsToSelector:selector])//ios8 以后采用UIAlertController来代替uiactionsheet和UIAlertView
        
    {
        
        UIAlertController*alertController = [actionSheet valueForKey:@"_alertController"];
        
        if([alertController isKindOfClass:[UIAlertController class]])
            
        {
            
            alertController.view.tintColor= [UIColor colorWithHexString:@"#004EC4"];
           
        }
        
    }
    
}

@end

