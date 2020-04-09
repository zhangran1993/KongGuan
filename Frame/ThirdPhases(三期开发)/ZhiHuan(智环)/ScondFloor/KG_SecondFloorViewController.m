//
//  KG_SecondFloorViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SecondFloorViewController.h"

@interface KG_SecondFloorViewController ()
//台站名
@property (retain, nonatomic) IBOutlet UILabel *stationName;
//左边 的坐标
@property (retain, nonatomic) IBOutlet UILabel *leftLocTitle;
//右边的坐标
@property (retain, nonatomic) IBOutlet UILabel *rightLocTitle;
//中间的背景图
@property (retain, nonatomic) IBOutlet UIImageView *centerBgImag;
//台站状态
@property (retain, nonatomic) IBOutlet UILabel *stationStatusLabel;
//状态图片
@property (retain, nonatomic) IBOutlet UIImageView *statusImage;
//健康指数
@property (retain, nonatomic) IBOutlet UILabel *healthLabel;
//星星
@property (retain, nonatomic) IBOutlet UIImageView *healthStarImage;
//健康分数
@property (retain, nonatomic) IBOutlet UILabel *healthNumLabel;
//台站背景图
@property (retain, nonatomic) IBOutlet UIImageView *StationBgImage;
//底部图片
@property (retain, nonatomic) IBOutlet UIImageView *bottomImage;

@property (retain, nonatomic) IBOutlet UILabel *bottomLeftTitle;
@property (retain, nonatomic) IBOutlet UILabel *bottomCenterTitle;
@property (retain, nonatomic) IBOutlet UILabel *bottomRightTitle;

//底部左边
@property (retain, nonatomic) IBOutlet UIImageView *fangcangImage;
@property (retain, nonatomic) IBOutlet UILabel *fangcangTitle;
//底部中间
@property (retain, nonatomic) IBOutlet UIImageView *yuanchangImage;
@property (retain, nonatomic) IBOutlet UILabel *yuanchangTitle;
//底部右下
@property (retain, nonatomic) IBOutlet UIImageView *bjiImage;
@property (retain, nonatomic) IBOutlet UILabel *bjiTitle;
//loc
@property (retain, nonatomic) IBOutlet UIImageView *locImage;
@property (retain, nonatomic) IBOutlet UILabel *locTitle;


@end

@implementation KG_SecondFloorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)layout {
    
    [self.StationBgImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT-64+30);
    }];
    
    [self.bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.StationBgImage.mas_bottom).offset(-35);
        make.width.equalTo(@321);
        make.height.equalTo(@169);
    }];
    
    [self.bottomLeftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomImage.mas_top).offset(22);
        make.left.equalTo(self.bottomImage.mas_left).offset(32);
        make.width.equalTo(@69);
        make.height.equalTo(@17);
    }];
    
    [self.bottomCenterTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomImage.mas_top).offset(21);
        make.centerX.equalTo(self.bottomImage.mas_centerX);
        make.width.equalTo(@75);
        make.height.equalTo(@20);
    }];
    
    [self.bottomRightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomImage.mas_top).offset(22);
        make.right.equalTo(self.bottomImage.mas_right).offset(-32);
        make.width.equalTo(@60);
        make.height.equalTo(@17);
    }];
    
    
    [self.fangcangImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLeftTitle.mas_bottom).offset(36);
        make.left.equalTo(self.bottomImage.mas_left).offset(40);
        make.width.equalTo(@14);
        make.height.equalTo(@10);
    }];
    [self.fangcangTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fangcangImage.mas_centerY);
        make.left.equalTo(self.fangcangImage.mas_right).offset(8);
        make.width.equalTo(@30);
        make.height.equalTo(@17);
    }];
    
    
    [self.yuanchangImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fangcangImage.mas_centerY);
        make.right.equalTo(self.bottomImage.mas_centerX).offset(-10);
        make.width.equalTo(@14);
        make.height.equalTo(@10);
    }];
    [self.yuanchangTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fangcangImage.mas_centerY);
        make.left.equalTo(self.bottomImage.mas_centerX).offset(1);
        make.width.equalTo(@30);
        make.height.equalTo(@17);
    }];
    
    [self.bjiTitle mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self.fangcangImage.mas_centerY);
           make.right.equalTo(self.bottomImage.mas_right).offset(-42);
           make.width.equalTo(@30);
           make.height.equalTo(@17);
       }];
       
    
    [self.bjiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fangcangImage.mas_centerY);
        make.right.equalTo(self.bjiTitle.mas_left).offset(-10);
        make.width.equalTo(@14);
        make.height.equalTo(@10);
    }];
    
    [self.locImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomImage.mas_left).offset(82);
        make.top.equalTo(self.fangcangImage.mas_bottom).offset(39);
        make.width.equalTo(@12);
        make.height.equalTo(@16);
    }];
    
    [self.locTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locImage.mas_right).offset(10);
        make.centerY.equalTo(self.locImage.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@17);
       }];
}

- (void)dealloc {
    [_stationName release];
    [_leftLocTitle release];
    [_rightLocTitle release];
    [_centerBgImag release];
    [_stationStatusLabel release];
    [_statusImage release];
    [_healthLabel release];
    [_healthNumLabel release];
    [_healthStarImage release];
    [_StationBgImage release];
    [_bottomImage release];
    [_bottomLeftTitle release];
    [_bottomCenterTitle release];
    [_bottomRightTitle release];
    [_fangcangImage release];
    [_fangcangTitle release];
    [_yuanchangImage release];
    [_yuanchangTitle release];
    [_bjiImage release];
    [_bjiTitle release];
    [_locImage release];
    [_locTitle release];
    [super dealloc];
}
@end
