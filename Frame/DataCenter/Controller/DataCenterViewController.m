//
//  DataCenterViewController.m
//  Frame
//
//  Created by centling on 2018/11/29.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "DataCenterViewController.h"
#import <WebKit/WebKit.h>
#import "DIYNoDataView.h"
#import "UIView+LX_Frame.h"
@interface DataCenterViewController ()<WKNavigationDelegate,DIYNoDataViewDelegate>
@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong)DIYNoDataView *backView;
@property (nonatomic, strong) UIView *loadBgView;
@property (nonatomic, strong) UIImageView *loadImageV;
@property (weak, nonatomic) CALayer *progresslayer;
@property (nonatomic) BOOL isLoadSuccess;
@end

@implementation DataCenterViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [self showNavigation];
    
    if(!self.loadBgView&& !_isLoadSuccess){
        
       [self loadingView];
        
    }else{
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.loadBgView removeFromSuperview];
    self.loadBgView = nil;
    
}

//展示navigation背景色
-(void)showNavigation{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}


- (void)viewDidLoad {
    _isLoadSuccess = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(20),NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.'
    self.webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - ZNAVViewH )];
    self.webview.backgroundColor = [UIColor whiteColor];
    self.webview.navigationDelegate = self;
    self.webview.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.webview];
    [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self setEmptyDataSetView];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNotificationAction) name:kNetworkStatusNotification object:nil];
}


/**
 监听网络
 */
- (void)resetNotificationAction {
    if (!IsNetwork) {
      
    } else {
        [self loadData];
    }
}



/**
 无数据占位图
 */
- (void)setEmptyDataSetView {
    self.backView = [[DIYNoDataView alloc]initWithFrame:CGRectMake(0, 80, self.webview.lx_width, self.webview.lx_height-80)];
    self.backView.hidden = YES;
    self.backView.delegate = self;
    self.backView.userInteractionEnabled = YES;
    [self.webview addSubview:self.backView ];
}


- (void)DIYNoDataViewButtonClcik {
    [self loadData];
}




- (void)loadData {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebHost,@"/html5"]];
    NSLog(@"WebHostWebHost%@",url);
    if (!url) {
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
}

#pragma mark - WKNavigationDelegate

//  页面开始加载web内容时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.backView.button.hidden = YES;
    self.backView.hidden = YES;
    
    
    
    //状态栏菊花
    /*
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];//背景色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];//遮罩透明
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//菊花控件
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//旋转小图标的 颜色
    [SVProgressHUD showWithStatus:@"加载中…"];
     */
}

//  页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.backView.button.hidden = YES;
    self.backView.hidden = YES;
    [self.loadBgView removeFromSuperview];
    self.loadBgView = nil;
    _isLoadSuccess = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"changechange %@",change);
        if(self.loadBgView ){
            
            NSLog(@"self.loadBgViewself.loadBgViewself.loadBgView");
            
        }else{
            if([change[@"kind"]integerValue] > [change[@"new"] integerValue]){
                NSLog(@"loadingViewloadingView %@",change);
                [self loadingView];
            }else{
                _isLoadSuccess = YES;
                [self.loadBgView removeFromSuperview];
                self.loadBgView = nil;
            }
        }
    }
}

//  页面加载失败时调用 ( 【web视图加载内容时】发生错误)
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.loadBgView removeFromSuperview];
    self.loadBgView = nil;
    self.backView.hidden = NO;
    self.backView.noDataImage.image = [UIImage imageNamed:@"error_net"];
    self.backView.tipsLabel.text = scrollViewNoNetworkText;
    self.backView.button.hidden = NO;
    _isLoadSuccess = YES;
}

-(void)loadingView{
    self.loadBgView = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(255), FrameWidth(400), WIDTH_SCREEN - FrameWidth(510), WIDTH_SCREEN - FrameWidth(510))];
    self.loadBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.loadBgView.layer.cornerRadius = 10;
    [self.webview addSubview:self.loadBgView];
    self.loadImageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.loadBgView.frameWidth/4, FrameWidth(8), self.loadBgView.frameWidth/2, self.loadBgView.frameWidth/2)];
    self.loadImageV.image = [UIImage imageNamed:@"webloading"];
    [self.loadBgView addSubview:self.loadImageV];
    
    UILabel * msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(10), self.loadBgView.frameWidth-FrameWidth(30), self.loadBgView.frameWidth - FrameWidth(20), FrameWidth(20))];
    msgLabel.font = FontSize(14);
    msgLabel.text = @"加载中…";
    msgLabel.textColor = [UIColor whiteColor];
    [self.loadBgView addSubview:msgLabel];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        
        self.loadImageV.transform = CGAffineTransformRotate(self.loadBgView.transform, M_PI_4*4);
        //动画设置
    } completion:^(BOOL finished) {
        
        //动画结束执行的操作
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
