//
//  KG_CommonWebAlertView.m
//  Frame
//
//  Created by zhangran on 2020/8/12.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CommonWebAlertView.h"
#import <WebKit/WebKit.h>

@interface KG_CommonWebAlertView ()<WKNavigationDelegate> {

    
}

@property (nonatomic,strong) WKWebView* webView;

@property (strong, nonatomic) UIProgressView *progressView;

@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation KG_CommonWebAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setupDataSubviews];
    }
    return self;
}

//初始化数据
- (void)initData {
    self.dataArray = [NSArray arrayWithObjects:@"", nil];
}

//创建视图
-(void)setupDataSubviews
{
    //按钮背景 点击消失
    self.bgBtn = [[UIButton alloc]init];
    [self addSubview:self.bgBtn];
    [self.bgBtn setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.bgBtn.alpha = 0.46;
    [self.bgBtn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    UIView *centerView = [[UIView alloc] init];
    centerView.frame = CGRectMake(16,172,SCREEN_WIDTH -32,SCREEN_WIDTH -32);
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.cornerRadius = 10;
    centerView.layer.masksToBounds = YES;
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(SCREEN_WIDTH -32));
        make.height.equalTo(@(SCREEN_WIDTH -32));
    }];
    
    _webView = [[WKWebView alloc] init];
    _webView.navigationDelegate = self;
    _webView .backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _webView.contentMode = UIViewContentModeScaleAspectFill;
    [centerView addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left);
        make.right.equalTo(centerView.mas_right);
        make.top.equalTo(centerView.mas_top);
        make.bottom.equalTo(centerView.mas_bottom);
    }];
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT+10, (SCREEN_WIDTH-32),2)];
    [centerView addSubview:_progressView];
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    
    
}
- (void)buttonClickMethod:(UIButton *)button {
    self.hidden = YES;
    [self removeFromSuperview];
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
    
//   NSString *url =  [self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
    NSString *ss= @"http://222.173.103.125:8083/monitorApp/#/humidity?";
   
    NSString* encodedString = [self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ss,encodedString]];
    
    NSString * encodedString1 = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.urlStr,NULL,NULL,kCFStringEncodingUTF8);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    // if you have set either WKWebView delegate also set these to nil here
    [_webView setNavigationDelegate:nil];
    [_webView setUIDelegate:nil];
    [super dealloc ];
}
- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
}

- (void)setTempUrlStr:(NSString *)tempUrlStr {
    _tempUrlStr = tempUrlStr;
    NSString *ss= @"http://222.173.103.125:8083/monitorApp/#/temperature?";
    
    NSString* encodedString = [self.tempUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ss,encodedString]];
    
    NSString * encodedString1 = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.urlStr,NULL,NULL,kCFStringEncodingUTF8);
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
}

- (void)setHumityUrlStr:(NSString *)humityUrlStr {
    _humityUrlStr = humityUrlStr;
//    [self createData];
    NSString *ss= @"http://222.173.103.125:8083/monitorApp/#/humidity?";
    
    NSString* encodedString = [self.humityUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ss,encodedString]];
    
    
    NSString * encodedString1 = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.urlStr,NULL,NULL,kCFStringEncodingUTF8);
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
    
}

- (void)setTotalUrlStr:(NSString *)totalUrlStr {
    _totalUrlStr = totalUrlStr;
//    [self createData];
    NSString *ss= @"http://222.173.103.125:8083/monitorApp/#/tempHumDetail?";
    
    NSString* encodedString = [self.totalUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ss,encodedString]];
    
    
    NSString * encodedString1 = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.urlStr,NULL,NULL,kCFStringEncodingUTF8);
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
    
}


@end
