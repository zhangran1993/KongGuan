//
//  FilePreviewViewController.m
//  Frame
//
//  Created by centling on 2018/12/5.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "FilePreviewViewController.h"
#import <QuickLook/QuickLook.h>
#import "UIView+LX_Frame.h"
#import <SVProgressHUD.h>
#import "FrameBaseRequest.h"
@interface FilePreviewViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate,NSURLSessionDelegate>
/**总数据*/
@property(nonatomic,strong) NSMutableData *data;
/**总长度*/
@property(nonatomic,assign)NSInteger totalLength;
// 浏览
@property (strong, nonatomic) QLPreviewController * qlpreView;
@end

@implementation FilePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.fileName = @"1542435730739.doc";
//    self.fileName = @"ios_tutorial.pdf";
    if (self.url.length > 0) {
        NSArray *arr = [self.url componentsSeparatedByString:@"/"];
        self.fileName = [arr lastObject];
    }
    
    [self setupUI];
}


- (void)setupUI {
    [self navigation];
    [self backBtn];
    [self previewArea];
}


/**
 预览文件
 */
- (void)previewArea {
    //  判断文件存不存在
    // 文件名
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:self.fileName];
    if(![fileManager fileExistsAtPath:filePath]) {
        NSLog(@"文件不存在");
        //    http://61.133.111.94:82/LYYD/Temp/Materials/165/633.jpg
        //    https://www.tutorialspoint.com/ios/ios_tutorial.pdf
//        self.fileURLString =@"https://www.tutorialspoint.com/ios/ios_tutorial.pdf";
        NSURL *url = [NSURL URLWithString:self.fileURLString];
        //创建管理类NSURLSessionConfiguration
        NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
        //初始化session并制定代理
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithURL:url];
        // 开始
        [task resume];
        [self svprogressHUDShow];
    }else{
        NSLog(@"文件存在");
        [self loadQLPreviewController:YES];
    }
}



/**
 加载QLPreviewController
 @param isRefresh 是否主动刷新
 */
- (void)loadQLPreviewController:(BOOL)isRefresh{
    self.qlpreView = [[QLPreviewController alloc]init];
//    CGRectMake(0, ZNAVViewH, WIDTH_SCREEN, HEIGHT_SCREEN
    self.qlpreView.view.frame = self.view.bounds;
    self.qlpreView.delegate= self;
    self.qlpreView.dataSource = self;
    [self addChildViewController:self.qlpreView];
    [self.qlpreView didMoveToParentViewController:self];
    [self.view addSubview:self.qlpreView.view];
    self.qlpreView.view.lx_y = ZNAVViewH;
    self.qlpreView.view.lx_height = self.view.lx_height - ZNAVViewH;
    if (isRefresh) {
      [self.qlpreView reloadData];
    }
}


#pragma mark *下载完成调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    NSLog(@"%@",[NSThread currentThread]);
    //将下载后的数据存入文件(firstObject 无数据返回nil，不会导致程序崩溃)
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    destPath = [destPath stringByAppendingPathComponent:self.fileName];
    NSLog(@"ccc  %@",destPath);
    //将下载的二进制文件转成入文件
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDownLoad =  [manager createFileAtPath:destPath contents:self.data attributes:nil];
    if (isDownLoad) {
        NSLog(@"OK");
        [self svprogressHUDhide];
    }else{
        NSLog(@"Sorry");
        [self svprogressHUDhide];
        [FrameBaseRequest showMessage:@"文件下载失败请稍后重试"];
        [self backAction];
        return;
    }
    [self loadQLPreviewController:NO];
}


#pragma mark  ====  接收到数据调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    //允许继续响应
    completionHandler(NSURLSessionResponseAllow);
    //获取文件的总大小
    self.totalLength = response.expectedContentLength;
}

#pragma mark  ===== 接收到数据调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    //将每次接收到的数据拼接起来
    if (!self.data) {
        self.data = [[NSMutableData alloc] initWithData:data];
    } else {
         [self.data appendBytes:data.bytes length:data.length];
    }
    //计算当前下载的长度
    NSInteger nowlength = self.data.length;
    NSLog(@"下载进度%ld",nowlength);
    //  可以用些 三方动画
    //    CGFloat value = nowlength*1.0/self.totalLength;
}



#pragma mark =======  QLPreviewController  代理
#pragma mark ==== 返回文件的个数
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

#pragma mark ==== 即将要退出浏览文件时执行此方法
- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
}


#pragma mark ===== 在此代理处加载需要显示的文件
- (NSURL *)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx {
    //获取指定文件 路径
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSURL *storeUrl = [NSURL fileURLWithPath: [docDir stringByAppendingPathComponent:self.fileName]];
    return storeUrl;
}

- (void)svprogressHUDShow {
    [SVProgressHUD showWithStatus:@"请稍后..."];
}

-(void)svprogressHUDhide{
    [SVProgressHUD dismiss];
}


-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigation {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}


@end
