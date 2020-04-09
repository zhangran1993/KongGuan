//
//  KG_NiControlSearchViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NiControlSearchViewController.h"

@interface KG_NiControlSearchViewController ()

@end

@implementation KG_NiControlSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];

    [self createSearchUI];
    
}

- (void)createSearchUI {
    
    
    UIView *searchView = [[UIView alloc]init];
    [self.view addSubview:searchView];
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@30);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, 100, 40)];
   
    titleLabel.text = @"";
   
    
    titleLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [searchView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.width.equalTo(@100);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@44);
    }];
}

@end
