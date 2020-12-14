//
//  KG_ServiceAgreementViewController.m
//  Frame
//
//  Created by zhangran on 2020/12/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ServiceAgreementViewController.h"
#import <WebKit/WebKit.h>

@interface KG_ServiceAgreementViewController ()<WKNavigationDelegate> {

    
}

@property (nonatomic,strong)   WKWebView         *webView;

@property (strong, nonatomic)  UIProgressView    *progressView;

@end

@implementation KG_ServiceAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadView];
}

- (void)loadView {
    
      self.webView = [[WKWebView alloc] init];
      self.webView.navigationDelegate = self;
      self.webView .backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
      self.webView.contentMode = UIViewContentModeScaleAspectFill;
      [self.view addSubview:self.webView];
      [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.view.mas_left);
          make.right.equalTo(self.view.mas_right);
          make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT);
          make.bottom.equalTo(self.view.mas_bottom);
      }];
      self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT+10, (SCREEN_WIDTH-32),2)];
      [self.view addSubview:self.progressView];
      
      [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    
    
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
