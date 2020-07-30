//
//  KG_DMEView.m
//  Frame
//
//  Created by zhangran on 2020/4/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_DMERightView.h"
#import "KG_DMETransFirstView.h"
#import "KG_DMETransSecondView.h"
#import "KG_DMEMonitorFirstView.h"
#import "KG_DMEMonitorSecondView.h"
@interface KG_DMERightView (){
    
}
@property (nonatomic, strong) UIImageView *topImage ;
@property (nonatomic, strong) UILabel *topTitleLabel;
@property (nonatomic, strong) UIImageView *topStatusImage ;
@property (nonatomic, strong) UIImageView *topArrowImage ;
@property (nonatomic, strong) UIImageView *topLineImage ;

@property (nonatomic, strong) KG_DMETransFirstView *transFirstView;
@property (nonatomic, strong) KG_DMETransSecondView *transSecondView;
@property (nonatomic, strong) KG_DMEMonitorFirstView *monitorFirstView;
@property (nonatomic, strong) KG_DMEMonitorSecondView *monitorSecondView;
@property (nonatomic, strong) NSDictionary *detailDic;
@property (nonatomic, strong) UILabel        *statusNumLabel;
@end

@implementation KG_DMERightView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupDataSubviews];
        
    }
    return self;
}
- (void)rightMethod {
    if (self.clickToDetail) {
        self.clickToDetail(self.detailDic);
    }
}

//创建视图
-(void)setupDataSubviews
{
    
    
    self.topImage = [[UIImageView alloc]init];
    [self addSubview:self.topImage];
    self.topImage.image = [UIImage imageNamed:@"dvor_icon"];
    [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.height.width.equalTo(@20);
        make.top.equalTo(self.mas_top).offset(17);
    }];
    UIButton *rightBtn  = [[UIButton alloc]init];
    [self addSubview:rightBtn];
   
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.width.height.equalTo(@100);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@54);
    }];
    [rightBtn addTarget:self action:@selector(rightMethod) forControlEvents:UIControlEventTouchUpInside];
    
    self.topTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.topTitleLabel];
    self.topTitleLabel.text = @"DME";
    self.topTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.topTitleLabel.numberOfLines = 1;
    self.topTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.topTitleLabel.font = [UIFont systemFontOfSize:16];
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topImage.mas_right).offset(2);
        make.height.equalTo(@22);
        make.width.lessThanOrEqualTo(@200);
        make.centerY.equalTo(self.topImage.mas_centerY);
    }];
    
    self.topArrowImage = [[UIImageView alloc]init];
    [self addSubview:self.topArrowImage];
    self.topArrowImage.image = [UIImage imageNamed:@"common_right"];
    [self.topArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-11);
        make.height.width.equalTo(@18);
        make.centerY.equalTo(self.topImage.mas_centerY);
    }];
    
    
    self.topStatusImage = [[UIImageView alloc]init];
    [self addSubview:self.topStatusImage];
    self.topStatusImage.image = [UIImage imageNamed:@"level_normal"];
    [self.topStatusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topArrowImage.mas_left).offset(-1);
        make.height.equalTo(@17);
        make.width.equalTo(@32);
        make.centerY.equalTo(self.topImage.mas_centerY);
    }];
    
    
    self.statusNumLabel = [[UILabel alloc]init];
    [self addSubview:self.statusNumLabel];
    self.statusNumLabel.layer.cornerRadius = 5.f;
    self.statusNumLabel.layer.masksToBounds = YES;
    self.statusNumLabel.text = @"1";
    self.statusNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.statusNumLabel.font = [UIFont systemFontOfSize:10];
    self.statusNumLabel.numberOfLines = 1;
    
    self.statusNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.statusNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topStatusImage.mas_right).offset(-5);
        make.bottom.equalTo(self.topStatusImage.mas_top).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    
    self.topLineImage = [[UIImageView alloc]init];
    [self addSubview:self.topLineImage];
    self.topLineImage.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    
    [self.topLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_top).offset(54);
    }];
    
    
    //顶部
    UIImageView *topIconImage = [[UIImageView alloc]init];
    [self addSubview:topIconImage];
    topIconImage.backgroundColor = [UIColor clearColor];
    topIconImage.image = [UIImage imageNamed:@"DME_icon"];
    [topIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(4);
        make.top.equalTo(self.topLineImage.mas_bottom).offset(17);
        make.height.equalTo(@42);
        make.width.equalTo(@20);
    }];
    
    UIImageView *leftShuImage = [[UIImageView alloc]init];
    [self addSubview:leftShuImage];
    leftShuImage.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [leftShuImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topIconImage.mas_left).offset(-1);
        make.top.equalTo(topIconImage.mas_bottom).offset(2);
        make.height.equalTo(@7.5);
        make.width.equalTo(@2);
    }];
    
    UIImageView *leftHengImage = [[UIImageView alloc]init];
    [self addSubview:leftHengImage];
    leftHengImage.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [leftHengImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftShuImage.mas_left);
        make.top.equalTo(topIconImage.mas_bottom).offset(6);
        make.height.equalTo(@1);
        make.width.equalTo(@16);
    }];
    
    UIImageView *leftShuImage1 = [[UIImageView alloc]init];
    [self addSubview:leftShuImage1];
    leftShuImage1.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [leftShuImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftHengImage.mas_left);
        make.top.equalTo(leftHengImage.mas_top);
        make.height.equalTo(@10);
        make.width.equalTo(@1);
    }];
    
    UIImageView *leftIconImage = [[UIImageView alloc]init];
    [self addSubview:leftIconImage];
    leftIconImage.image = [UIImage imageNamed:@"DME_dwon"];
    [leftIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftShuImage1.mas_centerX);
        make.top.equalTo(leftShuImage1.mas_bottom);
        make.height.equalTo(@14);
        make.width.equalTo(@14);
    }];
    //灰色竖线
    UIImageView *leftGrayShuImage = [[UIImageView alloc]init];
    [self addSubview:leftGrayShuImage];
    leftGrayShuImage.backgroundColor = [UIColor colorWithHexString:@"#C7C7C7"];
    [leftGrayShuImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftShuImage1.mas_centerX);
        make.top.equalTo(leftIconImage.mas_bottom);
        make.height.equalTo(@76);
        make.width.equalTo(@1);
    }];
    //灰色横线
    UIImageView *leftGrayHengImage = [[UIImageView alloc]init];
    [self addSubview:leftGrayHengImage];
    leftGrayHengImage.backgroundColor = [UIColor colorWithHexString:@"#C7C7C7"];
    [leftGrayHengImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftGrayShuImage.mas_right);
        make.bottom.equalTo(leftGrayShuImage.mas_bottom);
        make.height.equalTo(@1);
        make.width.equalTo(@5);
    }];
    
    UIImageView *centerArrow1 = [[UIImageView alloc]init];
    [self addSubview:centerArrow1];
    centerArrow1.image = [UIImage imageNamed:@"arrow_left"];
    [centerArrow1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftGrayHengImage.mas_left).offset(-2);
        make.centerY.equalTo(leftGrayHengImage.mas_centerY);
        make.height.equalTo(@9);
        make.width.equalTo(@6);
    }];
    
    UIImageView *leftGrayHengImage1 = [[UIImageView alloc]init];
    [self addSubview:leftGrayHengImage1];
    leftGrayHengImage1.backgroundColor = [UIColor colorWithHexString:@"#C7C7C7"];
    [leftGrayHengImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerArrow1.mas_left);
        make.centerY.equalTo(leftGrayHengImage.mas_centerY);
        make.height.equalTo(@1);
        make.width.equalTo(@8);
    }];
    
    self.transFirstView = [[KG_DMETransFirstView alloc]init];
    [self addSubview:self.transFirstView];
    self.transSecondView = [[KG_DMETransSecondView alloc]init];
    [self addSubview:self.transSecondView];
    self.monitorFirstView = [[KG_DMEMonitorFirstView alloc]init];
    [self addSubview:self.monitorFirstView];
    self.monitorSecondView = [[KG_DMEMonitorSecondView alloc]init];
    [self addSubview:self.monitorSecondView];
    
    
    [self.monitorFirstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftGrayHengImage1.mas_left);
        make.height.equalTo(@80);
        make.width.equalTo(@98);
        make.top.equalTo(leftIconImage.mas_bottom).offset(8);
    }];
    
   
    
  
    
    [self.transSecondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.monitorSecondView.mas_left);
        make.height.equalTo(@80);
        make.width.equalTo(@98);
        make.top.equalTo(self.monitorFirstView.mas_bottom).offset(30);
    }];
    
    
    UIImageView *rightShuImage = [[UIImageView alloc]init];
    [self addSubview:rightShuImage];
    rightShuImage.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [rightShuImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftShuImage.mas_right).offset(9);
        make.top.equalTo(leftShuImage.mas_top);
        make.height.equalTo(@7.5);
        make.width.equalTo(@2);
    }];
    
    UIImageView *rightHengImage = [[UIImageView alloc]init];
    [self addSubview:rightHengImage];
    rightHengImage.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [rightHengImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightShuImage.mas_right);
        make.top.equalTo(topIconImage.mas_bottom).offset(6);
        make.height.equalTo(@1);
        make.width.equalTo(@16);
    }];
    
    UIImageView *rightShuImage1 = [[UIImageView alloc]init];
    [self addSubview:rightShuImage1];
    rightShuImage1.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [rightShuImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightHengImage.mas_right);
        make.top.equalTo(rightHengImage.mas_top);
        make.height.equalTo(@10);
        make.width.equalTo(@1);
    }];
    
    UIImageView *rightIconImage = [[UIImageView alloc]init];
    [self addSubview:rightIconImage];
    rightIconImage.image = [UIImage imageNamed:@"DME_dwon"];
    [rightIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightShuImage1.mas_centerX);
        make.top.equalTo(rightShuImage1.mas_bottom);
        make.height.equalTo(@14);
        make.width.equalTo(@14);
    }];
    //灰色竖线
    UIImageView *rightGrayShuImage = [[UIImageView alloc]init];
    [self addSubview:rightGrayShuImage];
    rightGrayShuImage.backgroundColor = [UIColor colorWithHexString:@"#C7C7C7"];
    [rightGrayShuImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightShuImage1.mas_centerX);
        make.top.equalTo(rightIconImage.mas_bottom);
        make.height.equalTo(@76);
        make.width.equalTo(@1);
    }];
    //灰色横线
    UIImageView *rightGrayHengImage = [[UIImageView alloc]init];
    [self addSubview:rightGrayHengImage];
    rightGrayHengImage.backgroundColor = [UIColor colorWithHexString:@"#C7C7C7"];
    [rightGrayHengImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightGrayShuImage.mas_right);
        make.bottom.equalTo(rightGrayShuImage.mas_bottom);
        make.height.equalTo(@1);
        make.width.equalTo(@5);
    }];
    
    UIImageView *centerArrow2 = [[UIImageView alloc]init];
    [self addSubview:centerArrow2];
    centerArrow2.image = [UIImage imageNamed:@"arrow_right"];
    [centerArrow2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightGrayHengImage.mas_right).offset(2);
        make.centerY.equalTo(rightGrayHengImage.mas_centerY);
        make.height.equalTo(@9);
        make.width.equalTo(@6);
    }];
    
    UIImageView *rightGrayHengImage1 = [[UIImageView alloc]init];
    [self addSubview:rightGrayHengImage1];
    rightGrayHengImage1.backgroundColor = [UIColor colorWithHexString:@"#C7C7C7"];
    [rightGrayHengImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerArrow2.mas_right);
        make.centerY.equalTo(rightGrayHengImage.mas_centerY);
        make.height.equalTo(@1);
        make.width.equalTo(@10);
    }];
    [self.monitorSecondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightGrayHengImage1.mas_right);
        make.height.equalTo(@80);
        make.width.equalTo(@98);
        make.top.equalTo(leftIconImage.mas_bottom).offset(8);
    }];
    
    //中间竖线
    UIImageView *centerShuImage = [[UIImageView alloc]init];
    [self addSubview:centerShuImage];
    centerShuImage.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [centerShuImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIconImage.mas_right).offset(13);
        make.top.equalTo(topIconImage.mas_bottom);
        make.width.equalTo(@1);
        make.height.equalTo(@(202 - 6));
    }];
    [self.transFirstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerShuImage.mas_left).offset(-40);
        make.height.equalTo(@80);
        make.width.equalTo(@98);
        make.top.equalTo(self.monitorFirstView.mas_bottom).offset(30);
    }];
    
    //底部右边绿色竖线
    UIImageView *centerBottomGreenLine = [[UIImageView alloc]init];
    [self addSubview:centerBottomGreenLine];
    centerBottomGreenLine.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [centerBottomGreenLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerShuImage.mas_right).offset(6);
        make.top.equalTo(topIconImage.mas_bottom).offset(202);
        make.height.equalTo(@1);
        make.right.equalTo(self.transSecondView.mas_left);
    }];
    //底部右边绿色竖线
    UIImageView *centerBottomGreenXieLine = [[UIImageView alloc]init];
    [self addSubview:centerBottomGreenXieLine];
    centerBottomGreenXieLine.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [centerBottomGreenXieLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerShuImage.mas_left).offset(-0.5);
        make.bottom.equalTo(centerShuImage.mas_bottom).offset(3.5);
        make.height.equalTo(@1);
        make.width.equalTo(@9.5);
    }];
    centerBottomGreenXieLine.transform=CGAffineTransformMakeRotation(M_PI_4);
    
    UIImageView *bottomGreen1 = [[UIImageView alloc]init];
    [self addSubview:bottomGreen1];
    bottomGreen1.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [bottomGreen1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.transFirstView.mas_right);
        make.top.equalTo(self.transSecondView.mas_bottom).offset(-26);
        make.height.equalTo(@1);
        make.width.equalTo(@13);
    }];
    
    UIImageView *bottomGreen2 = [[UIImageView alloc]init];
    [self addSubview:bottomGreen2];
    bottomGreen2.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [bottomGreen2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomGreen1.mas_right);
        make.top.equalTo(bottomGreen1.mas_top);
        make.height.equalTo(@16);
        make.width.equalTo(@1);
    }];
    
    UIImageView *bottomGreen3 = [[UIImageView alloc]init];
    [self addSubview:bottomGreen3];
    bottomGreen3.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [bottomGreen3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomGreen2.mas_right);
        make.bottom.equalTo(bottomGreen2.mas_bottom);
        make.height.equalTo(@1);
        make.width.equalTo(@13);
    }];
    
    UIImageView *beijiImage = [[UIImageView alloc]init];
    [self addSubview:beijiImage];
    beijiImage.image = [UIImage imageNamed:@"kg_beiji_right"];
    [beijiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomGreen3.mas_right);
        make.centerY.equalTo(bottomGreen3.mas_centerY);
        make.height.equalTo(@11);
        make.width.equalTo(@29);
    }];
    
    
    
    
    //底部蓝色左横线
    UIImageView *bottomBlueLeftLine = [[UIImageView alloc]init];
    [self addSubview:bottomBlueLeftLine];
    bottomBlueLeftLine.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomBlueLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.monitorFirstView.mas_left);
        make.top.equalTo(self.monitorFirstView.mas_bottom).offset(-14);
        make.height.equalTo(@1);
        make.width.equalTo(@14);
    }];
    
    //底部蓝色左竖线
    UIImageView *bottomBlueShuLeftLine = [[UIImageView alloc]init];
    [self addSubview:bottomBlueShuLeftLine];
    bottomBlueShuLeftLine.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomBlueShuLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomBlueLeftLine.mas_left);
        make.top.equalTo(self.monitorFirstView.mas_bottom).offset(-14);
        make.height.equalTo(@199);
        make.width.equalTo(@1);
    }];
    
    //底部蓝色右横线
    UIImageView *bottomBlueRightLine = [[UIImageView alloc]init];
    [self addSubview:bottomBlueRightLine];
    bottomBlueRightLine.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomBlueRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.monitorSecondView.mas_right);
        make.top.equalTo(self.monitorFirstView.mas_bottom).offset(-14);
        make.height.equalTo(@1);
        make.width.equalTo(@14);
    }];
    
    //底部蓝色右竖线
    UIImageView *bottomBlueShuRightLine = [[UIImageView alloc]init];
    [self addSubview:bottomBlueShuRightLine];
    bottomBlueShuRightLine.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomBlueShuRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBlueRightLine.mas_right);
        make.top.equalTo(self.monitorFirstView.mas_bottom).offset(-14);
        make.height.equalTo(@198);
        make.width.equalTo(@1);
    }];
    
    
    //左边
    UIImageView *bottomLeftLine1 = [[UIImageView alloc]init];
    [self addSubview:bottomLeftLine1];
    bottomLeftLine1.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomLeftLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.transFirstView.mas_centerX);
        make.top.equalTo(self.transFirstView.mas_bottom);
        make.height.equalTo(@68);
        make.width.equalTo(@1);
    }];
    UIImageView *bottomLeftLine2 = [[UIImageView alloc]init];
    [self addSubview:bottomLeftLine2];
    bottomLeftLine2.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomLeftLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomLeftLine1.mas_left);
        make.bottom.equalTo(bottomLeftLine1.mas_bottom);
        make.height.equalTo(@1);
        make.width.equalTo(@43);
    }];
    
    UIImageView *bottomLeftLine3 = [[UIImageView alloc]init];
    [self addSubview:bottomLeftLine3];
    bottomLeftLine3.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomLeftLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomLeftLine2.mas_right);
        make.bottom.equalTo(bottomLeftLine2.mas_bottom).offset(7);
        make.height.equalTo(@1);
        make.width.equalTo(@106);
    }];
    //右边
    UIImageView *bottomRightLine1 = [[UIImageView alloc]init];
    [self addSubview:bottomRightLine1];
    bottomRightLine1.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomRightLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.transSecondView.mas_centerX);
        make.top.equalTo(self.transSecondView.mas_bottom);
        make.height.equalTo(@68);
        make.width.equalTo(@1);
    }];
    UIImageView *bottomRightLine2 = [[UIImageView alloc]init];
    [self addSubview:bottomRightLine2];
    bottomRightLine2.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomRightLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomRightLine1.mas_left);
        make.bottom.equalTo(bottomRightLine1.mas_bottom);
        make.height.equalTo(@1);
        make.width.equalTo(@45);
    }];
    UIImageView *bottomRight3 = [[UIImageView alloc]init];
    [self addSubview:bottomRight3];
    bottomRight3.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomRight3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomBlueRightLine.mas_right);
        make.bottom.equalTo(bottomRightLine2.mas_bottom).offset(7);
        make.height.equalTo(@1);
        make.width.equalTo(@108);
    }];
    
    UIView * transBottomView = [[UIView alloc]init];
    [self addSubview:transBottomView];
    transBottomView.backgroundColor = [UIColor colorWithHexString:@"#0032AF"];
    [transBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.transFirstView.mas_bottom).offset(63);
        make.height.equalTo(@26);
        make.width.equalTo(@98);
    }];
    UILabel *transBotLabel = [[UILabel alloc]init];
    [transBottomView addSubview:transBotLabel];
    transBotLabel.text = @"通信";
    transBotLabel.numberOfLines = 1;
    transBotLabel.textAlignment = NSTextAlignmentCenter;
    transBotLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    transBotLabel.font = [UIFont systemFontOfSize:12];
    [transBotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transBottomView.mas_top);
        make.left.equalTo(transBottomView.mas_left);
        make.right.equalTo(transBottomView.mas_right);
        make.bottom.equalTo(transBottomView.mas_bottom);
    }];
    
    UIImageView *bottomBlue1= [[UIImageView alloc]init];
    [self addSubview:bottomBlue1];
    bottomBlue1.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomBlue1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(transBottomView.mas_right);
        make.bottom.equalTo(transBottomView.mas_bottom).offset(-5);
        make.height.equalTo(@1);
        make.width.equalTo(@16);
    }];
    
    UIImageView *bottomBlue2= [[UIImageView alloc]init];
    [self addSubview:bottomBlue2];
    bottomBlue2.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomBlue2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomBlue1.mas_right);
        make.top.equalTo(bottomBlue1.mas_top);
        make.height.equalTo(@34);
        make.width.equalTo(@1);
    }];
    
    UIImageView *botBgImage = [[UIImageView alloc]init];
    [self addSubview:botBgImage];
    botBgImage.image = [UIImage imageNamed:@"zhongduan_icon"];
    [botBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(transBottomView.mas_centerX);
        make.top.equalTo(transBottomView.mas_bottom).offset(15);
        make.height.equalTo(@34);
        make.width.equalTo(@33);
    }];
    UIImageView *bottomBlue3= [[UIImageView alloc]init];
    [self addSubview:bottomBlue3];
    bottomBlue3.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomBlue3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomBlue2.mas_right);
        make.bottom.equalTo(bottomBlue2.mas_bottom);
        make.height.equalTo(@1);
        make.width.equalTo(@48);
    }];
    
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSArray *array = dataDic[@"equipmentDetails"];
    if (array.count == 1) {
        NSDictionary *dd =[array firstObject][@"equipment"];
        NSDictionary * Detail = @{ @"tagList":dd[@"measureTagList"],
                                   @"stationName":safeString(dd[@"stationName"]) ,
                                   @"machine_name":safeString(dd[@"name"]),
                                   @"name":safeString(dd[@"name"]),
                                   @"stationCode":safeString(dd[@"stationCode"]),
                                   @"code":safeString(dd[@"code"]),
                                   @"engineRoomCode":safeString(dd[@"engineRoomCode"]),
                                   @"category":safeString(dd[@"category"])
                                   
        };
        self.detailDic = Detail;
    }
    NSArray *list = [array firstObject][@"equipment"][@"measureTagList"];
    NSDictionary *totalDic = self.dataDic[@"totalDetail"];
    self.topStatusImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",totalDic[@"totalLevel"]]]];
    self.statusNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",totalDic[@"totalLevel"]]];
    self.statusNumLabel.text = [NSString stringWithFormat:@"%@",totalDic[@"totalNum"]];
    if([totalDic[@"totalLevel"] intValue] ==0) {
        self.statusNumLabel.hidden = YES;
    }else {
        self.statusNumLabel.hidden = NO;
    }
     
     

    //工作机
    for (NSDictionary *dic in list) {
        if ([dic[@"name"] isEqualToString:@"工作机"]) {
            for (NSDictionary *dataDic in list) {
                if ([dataDic[@"name"] containsString:@"备机状态"]) {
                    self.transFirstView.rebeiDic = dataDic;
                    self.transSecondView.rebeiDic = dataDic;
                }
            }
            self.transFirstView.workDic = dic;
             self.transSecondView.workDic = dic;
        }else if ([dic[@"name"] containsString:@"监测器旁路状态"]) {
            
            self.monitorFirstView.pangluDic =dic;
            self.monitorSecondView.pangluDic =dic;
        }else if ([dic[@"name"] containsString:@"发射机告警"]) {
            self.transFirstView.fasheDic = dic;
            self.transSecondView.fasheDic = dic;
        }else if ([dic[@"name"] containsString:@"监测器告警"]) {
            self.monitorFirstView.checkDic =dic;
            self.monitorSecondView.checkDic =dic;
        }
    }
    
//    @property (nonatomic, strong) KG_DMETransFirstView *transFirstView;
//    @property (nonatomic, strong) KG_DMETransSecondView *transSecondView;
//    @property (nonatomic, strong) KG_DMEMonitorFirstView *monitorFirstView;
//    @property (nonatomic, strong) KG_DMEMonitorSecondView *monitorSecondView;
}

- (NSString *)getLevelImage:(NSString *)level {
    NSString *levelString = @"level_normal";
    
    if ([level isEqualToString:@"0"]) {
        levelString = @"level_normal";
    }else if ([level isEqualToString:@"4"]) {
        levelString = @"level_prompt";
    }else if ([level isEqualToString:@"3"]) {
        levelString = @"level_ciyao";
    }else if ([level isEqualToString:@"2"]) {
        levelString = @"level_important";
    }else if ([level isEqualToString:@"1"]) {
        levelString = @"level_jinji";
    }
    
    //紧急
    return levelString;
}

- (UIColor *)getTextColor:(NSString *)level {
    UIColor *textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    if ([level isEqualToString:@"0"]) {
        textColor = [UIColor colorWithHexString:@"FFFFFF"];
    }else if ([level isEqualToString:@"4"]) {
        textColor = [UIColor colorWithHexString:@"2986F1"];
    }else if ([level isEqualToString:@"3"]) {
        textColor = [UIColor colorWithHexString:@"FFA800"];
    }else if ([level isEqualToString:@"2"]) {
        textColor = [UIColor colorWithHexString:@"FC7D0E"];
    }else if ([level isEqualToString:@"1"]) {
        textColor = [UIColor colorWithHexString:@"F62546"];
    }
    
    //紧急
    return textColor;
}

@end
