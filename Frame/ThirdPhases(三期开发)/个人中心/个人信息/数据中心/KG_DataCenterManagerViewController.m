//
//  KG_WatchPdfViewController.m
//  Frame
//
//  Created by zhangran on 2020/8/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_DataCenterManagerViewController.h"
#import <WebKit/WebKit.h>
@interface KG_DataCenterManagerViewController ()<WKNavigationDelegate,UIDocumentInteractionControllerDelegate>
@property (nonatomic,strong) WKWebView* webView;
@property (strong, nonatomic) UIProgressView *progressView;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIButton                *rightButton;
@end

@implementation KG_DataCenterManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self createNaviTopView];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT+10, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT-10)];
    _webView.navigationDelegate = self;
    _webView .backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:_webView];
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT+10, CGRectGetWidth(self.view.frame),2)];
    [self.view addSubview:_progressView];
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    [self createData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    NSLog(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_webView.estimatedProgress animated:YES];
        if(_webView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
   

}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"webViewDidFail");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"webViewDidFailProvisional");
    dispatch_async(dispatch_get_main_queue(), ^{
//       [MyController showAlert:@"网络连接异常,请检查网络" view:self.view];
        [FrameBaseRequest showMessage:@"网络连接异常,请检查网络"];
    });
   

    
}

- (void)createData{
    [self loadExamplePage:_webView];
}

- (void)loadExamplePage:(WKWebView*)webView {
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebHost,@"/html5"]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url]; // 网络地址
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"1111111" ofType:@"pdf"]; // 本地
    //    NSURL *url = [NSURL fileURLWithPath:path];
    //    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)dealloc {
    [super dealloc];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    // if you have set either WKWebView delegate also set these to nil here
    [_webView setNavigationDelegate:nil];
    [_webView setUIDelegate:nil];
}

- (void) backBtnClicked {
    NSArray * types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache];
    NSSet *websiteDataTypes = [NSSet setWithArray:types];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +10)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 10)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [self createImageWithColor:[UIColor whiteColor]];
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar+10)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navigationView];
    
    /** 添加标题栏 **/
    [self.navigationView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationView.mas_centerX);
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar+9);
        make.left.equalTo(self.navigationView.mas_left).offset(60);
        make.right.equalTo(self.navigationView.mas_right).offset(-60);
        
    }];
    self.titleLabel.text = @"数据中心";
    
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
    
//    self.rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    self.rightButton.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
//    [self.rightButton setImage:[UIImage imageNamed:@"icon_yunMore"] forState:UIControlStateNormal];
//    [self.rightButton addTarget:self action:@selector(shareFile) forControlEvents:UIControlEventTouchUpInside];
// 
//    [self.navigationView addSubview:self.rightButton];
//    
//    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@44);
//        make.centerY.equalTo(self.titleLabel.mas_centerY);
//        make.right.equalTo(self.navigationView.mas_right).offset(-20);
//    }];
//    
    
    
}

- (void)createUI {
    
    
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
        titleLabel.numberOfLines = 2;
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


-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareFile {
    
//    UIDocumentInteractionController*  documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://vip.ow365.cn/?i=21701&furl=%@%@",WebNewHost,safeString(self.dataDic[@"url"])]]];
//
//    documentController.delegate = self;
//
//    documentController.UTI = @"com.microsoft.word.doc";
//
//    [documentController presentOpenInMenuFromRect:CGRectMake(760, 20, 100, 100) inView:self.view animated:YES];

}

@end
