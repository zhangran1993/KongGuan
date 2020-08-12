//
//  KG_ZhiTaiView.m
//  Frame
//
//  Created by zhangran on 2020/4/9.
//  Copyright © 2020 hibaysoft. All rights reserved.

#import "KG_ZhiTaiView.h"
#import "KG_CenterCell.h"
#import "KG_MonitorFirstView.h"
#import "KG_MonitorSecondView.h"
#import "KG_TransFirstView.h"
#import "KG_TransSecondView.h"
#import "KG_TransBottomView.h"
#import "KG_TransBottomCell.h"
@interface  KG_ZhiTaiView(){
    
}
@property (nonatomic, strong) UIImageView *topImage ;
@property (nonatomic, strong) UILabel *topTitleLabel;
@property (nonatomic, strong) UIImageView *topStatusImage ;
@property (nonatomic, strong) UIImageView *topArrowImage ;
@property (nonatomic, strong) UIImageView *topLineImage ;



@property (nonatomic, strong) KG_MonitorFirstView *monitorFirstView;
@property (nonatomic, strong) KG_MonitorSecondView *monitorSecondView;
@property (nonatomic, strong) KG_TransFirstView *transFirstView;
@property (nonatomic, strong) KG_TransSecondView *transSecondView;
@property (nonatomic, strong) KG_TransBottomView *transBottomView;

@property (nonatomic, strong) NSDictionary *detailDic;


@property (nonatomic, strong) UIImageView *centerBottomGreenLine;
@property (nonatomic, strong) UIImageView *centerBottomGreenXieLine;


@property (nonatomic, strong) UIImageView *bottomGreen1;
@property (nonatomic, strong) UIImageView *bottomGreen2;
@property (nonatomic, strong) UIImageView *bottomGreen3;
@property (nonatomic, strong) UIImageView *beijiImage;

@property (nonatomic, strong) UIImageView *centerTopGreenShuLine;
@property (nonatomic, strong) UIImageView *centerTopGreenLine;



@end
@implementation KG_ZhiTaiView


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
    self.topImage.image = [UIImage imageNamed:@"导航DVOR"];
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
    self.topTitleLabel.text = @"DVOR";
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
    self.topLineImage = [[UIImageView alloc]init];
    [self addSubview:self.topLineImage];
    self.topLineImage.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    
    [self.topLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_top).offset(54);
    }];
    
    
    //内容部分
    //顶部天线
    UIImageView *centerTianXianImage = [[UIImageView alloc]init];
    [self addSubview:centerTianXianImage];
    centerTianXianImage.backgroundColor = [UIColor clearColor];
    centerTianXianImage.image = [UIImage imageNamed:@"tianxian_top"];
    [centerTianXianImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(((SCREEN_WIDTH-32)/2-92));
        make.top.equalTo(self.topLineImage.mas_bottom).offset(13);
        make.height.equalTo(@12);
        make.width.equalTo(@14);
    }];
    
    //顶部右边横线
    UIImageView *centerTopLine = [[UIImageView alloc]init];
    [self addSubview:centerTopLine];
    centerTopLine.backgroundColor = [UIColor colorWithHexString:@"#C7C7C7"];
    [centerTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerTianXianImage.mas_right);
        make.centerY.equalTo(centerTianXianImage.mas_centerY);
        make.height.equalTo(@1);
        make.right.equalTo(self.mas_right).offset(-((SCREEN_WIDTH -32)/2));
    }];
    
    //一共 7个状态 1234567 来表示
    UIImageView *statusImage1 = [[UIImageView alloc]init];
    [self addSubview:statusImage1];
    statusImage1.image = [UIImage imageNamed:@"tianxian_green"];
    [statusImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(32);
        make.top.equalTo(centerTianXianImage.mas_bottom).offset(7);
        make.height.equalTo(@9);
        make.width.equalTo(@8);
    }];
    
    UIImageView *statusImage2 = [[UIImageView alloc]init];
    [self addSubview:statusImage2];
    statusImage2.image = [UIImage imageNamed:@"tianxian_green"];
    [statusImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusImage1.mas_right).offset(1);
        make.centerY.equalTo(statusImage1.mas_centerY);
        make.height.equalTo(@9);
        make.width.equalTo(@8);
    }];
    
    UIImageView *statusImage3 = [[UIImageView alloc]init];
    [self addSubview:statusImage3];
    statusImage3.image = [UIImage imageNamed:@"tianxian_green"];
    [statusImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusImage2.mas_right).offset(21);
        make.centerY.equalTo(statusImage1.mas_centerY);
        make.height.equalTo(@9);
        make.width.equalTo(@8);
    }];
    
    UIImageView *statusImage4 = [[UIImageView alloc]init];
    [self addSubview:statusImage4];
    statusImage4.image = [UIImage imageNamed:@"tianxian_green"];
    [statusImage4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusImage3.mas_right).offset(1);
        make.centerY.equalTo(statusImage1.mas_centerY);
        make.height.equalTo(@9);
        make.width.equalTo(@8);
    }];
    
    UIImageView *statusImage5 = [[UIImageView alloc]init];
    [self addSubview:statusImage5];
    statusImage5.image = [UIImage imageNamed:@"tianxian_green"];
    [statusImage5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusImage4.mas_right).offset(1);
        make.centerY.equalTo(statusImage1.mas_centerY);
        make.height.equalTo(@9);
        make.width.equalTo(@8);
    }];
    
    UIImageView *statusImage6 = [[UIImageView alloc]init];
    [self addSubview:statusImage6];
    statusImage6.image = [UIImage imageNamed:@"tianxian_green"];
    [statusImage6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusImage4.mas_right).offset(25);
        make.centerY.equalTo(statusImage1.mas_centerY);
        make.height.equalTo(@9);
        make.width.equalTo(@8);
    }];
    
    UIImageView *statusImage7 = [[UIImageView alloc]init];
    [self addSubview:statusImage7];
    statusImage7.image = [UIImage imageNamed:@"tianxian_green"];
    [statusImage7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusImage6.mas_right).offset(1);
        make.centerY.equalTo(statusImage1.mas_centerY);
        make.height.equalTo(@9);
        make.width.equalTo(@8);
    }];
    
    //7个状态下面的灰色区域
    
    UIView *grayView = [[UIView alloc]init];
    [self addSubview:grayView];
    grayView.backgroundColor = [UIColor colorWithHexString:@"#C7CBD2"];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(statusImage1.mas_bottom);
        make.height.equalTo(@11);
        make.width.equalTo(@126);
    }];
    
    //顶部右边灰色竖线r
    UIImageView *centerTopShuLine = [[UIImageView alloc]init];
    [self addSubview:centerTopShuLine];
    centerTopShuLine.backgroundColor = [UIColor colorWithHexString:@"#C7C7C7"];
    [centerTopShuLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerTopLine.mas_right);
        make.top.equalTo(centerTopLine.mas_top);
        make.height.equalTo(@139);
        make.width.equalTo(@1);
    }];
    
    //右边灰色竖线下面的小灰点
    UIImageView *centerTopShuLineGrayDot = [[UIImageView alloc]init];
    [self addSubview:centerTopShuLineGrayDot];
    centerTopShuLineGrayDot.backgroundColor = [UIColor colorWithHexString:@"#C7C7C7"];
    [centerTopShuLineGrayDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerTopShuLine.mas_centerX);
        make.bottom.equalTo(centerTopShuLine.mas_bottom).offset(4);
        make.height.equalTo(@5);
        make.width.equalTo(@5);
    }];
    centerTopShuLineGrayDot.layer.cornerRadius = 2.5f;
    centerTopShuLineGrayDot.layer.masksToBounds = YES;
    //顶部右边绿色横线
    self.centerTopGreenLine= [[UIImageView alloc]init];
    [self addSubview:self.centerTopGreenLine];
    self.centerTopGreenLine.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [self.centerTopGreenLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayView.mas_right);
        make.centerY.equalTo(grayView.mas_centerY);
        make.height.equalTo(@1);
        make.right.equalTo(centerTopShuLine.mas_left).offset(-10);
    }];
    //顶部右边绿色竖线
    self.centerTopGreenShuLine = [[UIImageView alloc]init];
    [self addSubview:self.centerTopGreenShuLine];
    self.centerTopGreenShuLine.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [self.centerTopGreenShuLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerTopGreenLine.mas_right).offset(-1);
        make.top.equalTo(self.centerTopGreenLine.mas_bottom);
        make.height.equalTo(@233);
        make.width.equalTo(@1);
    }];
    
    //底部右边绿色竖线
    self.centerBottomGreenLine = [[UIImageView alloc]init];
    [self addSubview:self.centerBottomGreenLine];
    self.centerBottomGreenLine.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [self.centerBottomGreenLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerTopGreenLine.mas_left).offset(-14);
        make.top.equalTo(self.centerTopGreenLine.mas_bottom).offset(238);
        make.height.equalTo(@1);
        make.right.equalTo(self.centerTopGreenShuLine.mas_left).offset(-6);
    }];
    //底部右边绿色竖线
    self.centerBottomGreenXieLine = [[UIImageView alloc]init];
    [self addSubview:self.centerBottomGreenXieLine];
    self.centerBottomGreenXieLine.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [self.centerBottomGreenXieLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerTopGreenShuLine.mas_left).offset(2);
        make.bottom.equalTo(self.centerTopGreenShuLine.mas_bottom).offset(3);
        make.height.equalTo(@1);
        make.width.equalTo(@10);
    }];
    self.centerBottomGreenXieLine.transform=CGAffineTransformMakeRotation(3*M_PI_4);
    
    
    
    self.monitorFirstView = [[KG_MonitorFirstView alloc]init];
    self.monitorFirstView.backgroundColor = [UIColor whiteColor];
    self.monitorSecondView = [[KG_MonitorSecondView alloc]init];
    self.monitorSecondView.backgroundColor = [UIColor whiteColor];
    self.transFirstView = [[KG_TransFirstView alloc]init];
    self.transFirstView.backgroundColor = [UIColor whiteColor];
    self.transSecondView = [[KG_TransSecondView alloc]init];
    self.transSecondView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.monitorFirstView];
    [self addSubview:self.monitorSecondView];
    [self addSubview:self.transFirstView];
    [self addSubview:self.transSecondView];
    [self.monitorFirstView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(32);
        make.top.equalTo(grayView.mas_bottom).offset(14);
        make.width.equalTo(@98);
        make.height.equalTo(@134);
    }];
    
    [self.monitorSecondView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-34);
        make.top.equalTo(grayView.mas_bottom).offset(14);
        make.width.equalTo(@98);
        make.height.equalTo(@134);
    }];
    [self.transFirstView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(32);
        make.top.equalTo(self.monitorFirstView.mas_bottom).offset(29);
        make.width.equalTo(@98);
        make.height.equalTo(@80);
    }];
    
    [self.transSecondView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-34);
        make.top.equalTo(self.monitorFirstView.mas_bottom).offset(29);
        make.width.equalTo(@98);
        make.height.equalTo(@80);
    }];
    
    
    
    //中间灰色横线
    UIImageView *centerGrayLine1 = [[UIImageView alloc]init];
    [self addSubview:centerGrayLine1];
    centerGrayLine1.backgroundColor = [UIColor colorWithHexString:@"#C7C7C7"];
    [centerGrayLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.monitorFirstView.mas_right);
        make.top.equalTo(grayView.mas_bottom).offset(107);
        make.height.equalTo(@1);
        make.width.equalTo(@15);
    }];
    
    UIImageView *centerArrow1 = [[UIImageView alloc]init];
    [self addSubview:centerArrow1];
    centerArrow1.image = [UIImage imageNamed:@"arrow_left"];
    [centerArrow1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerGrayLine1.mas_right);
        make.centerY.equalTo(centerGrayLine1.mas_centerY);
        make.height.equalTo(@9);
        make.width.equalTo(@6);
    }];
    //中间灰色横线
    UIImageView *centerGrayLine2 = [[UIImageView alloc]init];
    [self addSubview:centerGrayLine2];
    centerGrayLine2.backgroundColor = [UIColor colorWithHexString:@"#C7C7C7"];
    [centerGrayLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerArrow1.mas_right).offset(2);
        make.centerY.equalTo(centerGrayLine1.mas_centerY);
        make.height.equalTo(@1);
        make.right.equalTo(centerTopShuLine.mas_right).offset(21);
    }];
    
    UIImageView *centerArrow2 = [[UIImageView alloc]init];
    [self addSubview:centerArrow2];
    centerArrow2.image = [UIImage imageNamed:@"arrow_right"];
    [centerArrow2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerGrayLine2.mas_right);
        make.centerY.equalTo(centerGrayLine1.mas_centerY);
        make.height.equalTo(@9);
        make.width.equalTo(@6);
    }];
    
    //中间灰色横线
    UIImageView *centerGrayLine3 = [[UIImageView alloc]init];
    [self addSubview:centerGrayLine3];
    centerGrayLine3.backgroundColor = [UIColor colorWithHexString:@"#C7C7C7"];
    [centerGrayLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerArrow2.mas_right);
        make.centerY.equalTo(centerGrayLine1.mas_centerY);
        make.height.equalTo(@1);
        make.right.equalTo(self.monitorSecondView.mas_left);
    }];
    
    //底部蓝色左横线
    UIImageView *bottomBlueLeftLine = [[UIImageView alloc]init];
    [self addSubview:bottomBlueLeftLine];
    bottomBlueLeftLine.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomBlueLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(self.monitorFirstView.mas_bottom).offset(-14);
        make.height.equalTo(@1);
        make.width.equalTo(@14);
    }];
    
    //底部蓝色左竖线
    UIImageView *bottomBlueShuLeftLine = [[UIImageView alloc]init];
    [self addSubview:bottomBlueShuLeftLine];
    bottomBlueShuLeftLine.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomBlueShuLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(self.monitorFirstView.mas_bottom).offset(-14);
        make.height.equalTo(@240);
        make.width.equalTo(@1);
    }];
    
    //底部蓝色右横线
    UIImageView *bottomBlueRightLine = [[UIImageView alloc]init];
    [self addSubview:bottomBlueRightLine];
    bottomBlueRightLine.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomBlueRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-19);
        make.top.equalTo(self.monitorFirstView.mas_bottom).offset(-14);
        make.height.equalTo(@1);
        make.width.equalTo(@15);
    }];
    
    //底部蓝色右竖线
    UIImageView *bottomBlueShuRightLine = [[UIImageView alloc]init];
    [self addSubview:bottomBlueShuRightLine];
    bottomBlueShuRightLine.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomBlueShuRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-19);
        make.top.equalTo(self.monitorFirstView.mas_bottom).offset(-14);
        make.height.equalTo(@240);
        make.width.equalTo(@1);
    }];
    
    
    //左边
    UIImageView *bottomLeftLine1 = [[UIImageView alloc]init];
    [self addSubview:bottomLeftLine1];
    bottomLeftLine1.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomLeftLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.transFirstView.mas_centerX);
        make.top.equalTo(self.transFirstView.mas_bottom);
        make.height.equalTo(@88);
        make.width.equalTo(@1);
    }];
    
    self.transBottomView = [[KG_TransBottomView alloc]init];
    self.transBottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.transBottomView];
    [self.transBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@130);
        make.height.equalTo(@80);
        make.top.equalTo(self.transSecondView.mas_bottom).offset(63);
    }];
    
    UIImageView *bottomLeftLine2 = [[UIImageView alloc]init];
    [self addSubview:bottomLeftLine2];
    bottomLeftLine2.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomLeftLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomLeftLine1.mas_left);
        make.bottom.equalTo(bottomLeftLine1.mas_bottom);
        make.height.equalTo(@1);
        make.right.equalTo(self.transBottomView.mas_left);
    }];
    
    UIImageView *bottomLeftLine3 = [[UIImageView alloc]init];
    [self addSubview:bottomLeftLine3];
    bottomLeftLine3.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomLeftLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomLeftLine2.mas_right);
        make.bottom.equalTo(bottomLeftLine2.mas_bottom).offset(30 );
        make.height.equalTo(@1);
        make.left.equalTo(bottomBlueShuLeftLine.mas_right);
    }];
    //右边
    UIImageView *bottomRightLine1 = [[UIImageView alloc]init];
    [self addSubview:bottomRightLine1];
    bottomRightLine1.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomRightLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.transSecondView.mas_centerX);
        make.top.equalTo(self.transSecondView.mas_bottom);
        make.height.equalTo(@88);
        make.width.equalTo(@1);
    }];
    UIImageView *bottomRightLine2 = [[UIImageView alloc]init];
    [self addSubview:bottomRightLine2];
    bottomRightLine2.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomRightLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomRightLine1.mas_left);
        make.bottom.equalTo(bottomRightLine1.mas_bottom);
        make.height.equalTo(@1);
        make.left.equalTo(self.transBottomView.mas_right);
    }];
    UIImageView *bottomRight3 = [[UIImageView alloc]init];
    [self addSubview:bottomRight3];
    bottomRight3.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomRight3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomBlueRightLine.mas_right);
        make.bottom.equalTo(bottomRightLine2.mas_bottom).offset(30);
        make.height.equalTo(@1);
        make.left.equalTo(self.transBottomView.mas_right);
    }];
    
    self.bottomGreen1 = [[UIImageView alloc]init];
    [self addSubview:self.bottomGreen1];
    self.bottomGreen1.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [self.bottomGreen1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.transSecondView.mas_left);
        make.top.equalTo(self.transSecondView.mas_bottom).offset(-26);
        make.height.equalTo(@1);
        make.width.equalTo(@13);
    }];
    
    self.bottomGreen2 = [[UIImageView alloc]init];
    [self addSubview:self.bottomGreen2];
    self.bottomGreen2.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [self.bottomGreen2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomGreen1.mas_left);
        make.top.equalTo(self.bottomGreen1.mas_top);
        make.height.equalTo(@16);
        make.width.equalTo(@1);
    }];
    
    self.bottomGreen3 = [[UIImageView alloc]init];
    [self addSubview:self.bottomGreen3];
    self.bottomGreen3.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [self.bottomGreen3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomGreen2.mas_left);
        make.bottom.equalTo(self.bottomGreen2.mas_bottom);
        make.height.equalTo(@1);
        make.width.equalTo(@13);
    }];
    
    self.beijiImage = [[UIImageView alloc]init];
    [self addSubview:self.beijiImage];
    self.beijiImage.image = [UIImage imageNamed:@"beiji_icon"];
    [self.beijiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomGreen3.mas_left);
        make.centerY.equalTo(self.bottomGreen3.mas_centerY);
        make.height.equalTo(@11);
        make.width.equalTo(@29);
    }];
    
    
    
    UIImageView *bottomBlue1= [[UIImageView alloc]init];
    [self addSubview:bottomBlue1];
    bottomBlue1.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomBlue1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.transBottomView.mas_right);
        make.bottom.equalTo(self.transBottomView.mas_bottom).offset(-12);
        make.height.equalTo(@1);
        make.width.equalTo(@14);
    }];
    
    UIImageView *bottomBlue2= [[UIImageView alloc]init];
    [self addSubview:bottomBlue2];
    bottomBlue2.backgroundColor = [UIColor colorWithHexString:@"#7693DB"];
    [bottomBlue2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomBlue1.mas_right);
        make.top.equalTo(bottomBlue1.mas_top);
        make.height.equalTo(@39);
        make.width.equalTo(@1);
    }];
    
    UIImageView *botBgImage = [[UIImageView alloc]init];
    [self addSubview:botBgImage];
    botBgImage.image = [UIImage imageNamed:@"zhongduan_icon"];
    [botBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.transBottomView.mas_centerX);
        make.top.equalTo(self.transBottomView.mas_bottom).offset(15);
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
        make.width.equalTo(@55);
    }];
    
    
    
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

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSArray *array = dataDic[@"equipmentDetails"];
    NSArray *list = [array firstObject][@"equipment"][@"measureTagList"];
    if (array.count == 1) {
        NSDictionary *dd =[array firstObject][@"equipment"];
        NSDictionary * Detail = @{ @"tagList":dd[@"measureTagList"],
                                   @"stationName":safeString(dd[@"stationName"]) ,
                                   @"machine_name":safeString(dd[@"name"]),
                                   @"name":safeString(dd[@"name"]),
                                   @"code":safeString(dd[@"code"]),
                                   @"engineRoomCode":safeString(dd[@"engineRoomCode"]),
                                   @"category":safeString(dd[@"category"]),
                                   @"stationCode":safeString(dd[@"stationCode"])
        };
        self.detailDic = Detail;
    }
    
    
    //工作机
    for (NSDictionary *dic in list) {
        if ([dic[@"name"] containsString:@"监视器1自身状态"]) {
            
            self.monitorFirstView.checkDic = dic;
        }else if ([dic[@"name"] containsString:@"监视器1数据状态"]) {
            self.monitorFirstView.dataDic = dic;
        }else if ([dic[@"name"] containsString:@"监视器工作状态"]) {
            self.monitorFirstView.workDic = dic;
        }else if ([dic[@"name"] containsString:@"监视器1状态"]) {
            self.monitorFirstView.equipStatusDic = dic;
        }else if ([dic[@"name"] containsString:@"监视器2自身状态"]) {
            
            self.monitorSecondView.checkDic = dic;
        }else if ([dic[@"name"] containsString:@"监视器2数据状态"]) {
            self.monitorSecondView.dataDic = dic;
        }else if ([dic[@"name"] containsString:@"监视器工作状态"]) {
            self.monitorSecondView.workDic = dic;
        }else if ([dic[@"name"] containsString:@"监视器2状态"]) {
            self.monitorSecondView.equipStatusDic = dic;
        }else if ([dic[@"name"] containsString:@"系统状态"]) {
            self.transBottomView.bottomDic = dic;
        }else if ([dic[@"name"] containsString:@"工作机"]) {
            
            for (NSDictionary *dd in list) {
                if ([dd[@"name"] containsString:@"备机状态"]) {
                    self.transFirstView.hotDic = dd;
                    self.transSecondView.hotDic = dd;
                    
                }
                
            }
            self.transFirstView.workDic = dic;
            self.transSecondView.workDic = dic;
        }else if ([dic[@"name"] containsString:@"发射机1状态"]) {
            self.transFirstView.statusDic = dic;
        }else if ([dic[@"name"] containsString:@"发射机2状态"]) {
            self.transSecondView.statusDic = dic;
        }
        
    }
    
    
    NSDictionary *beiDic = nil;
    NSDictionary *workDic = nil;
    for (NSDictionary *dic in list) {
        if ([dic[@"name"] isEqualToString:@"工作机"]) {
            for (NSDictionary *dataDic in list) {
                if ([dataDic[@"name"] containsString:@"备机状态"]) {
                    beiDic = dataDic;
                }
            }
            workDic = dic;
        }
    }
    
    //监视器A
    if([safeString(workDic[@"valueAlias"]) isEqualToString:@"B机"]){
       
        
        [self.centerBottomGreenLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.transSecondView.mas_left);
            make.top.equalTo(self.centerTopGreenLine.mas_bottom).offset(238);
            make.height.equalTo(@1);
            make.left.equalTo(self.centerTopGreenLine.mas_right).offset(6);
        }];
        
        [self.centerBottomGreenXieLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.centerTopGreenShuLine.mas_right).offset(-2);
            make.bottom.equalTo(self.centerTopGreenShuLine.mas_bottom).offset(3.5);
            make.height.equalTo(@1);
            make.width.equalTo(@9);
        }];
        self.centerBottomGreenXieLine.transform=CGAffineTransformMakeRotation(M_PI_4);
        
        [self.bottomGreen1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.transFirstView.mas_right);
            make.top.equalTo(self.transSecondView.mas_bottom).offset(-26);
            make.height.equalTo(@1);
            make.width.equalTo(@13);
        }];
        
        [self.bottomGreen2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomGreen1.mas_right);
            make.top.equalTo(self.bottomGreen1.mas_top);
            make.height.equalTo(@16);
            make.width.equalTo(@1);
        }];
        
        self.bottomGreen3.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
        [self.bottomGreen3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomGreen2.mas_right);
            make.bottom.equalTo(self.bottomGreen2.mas_bottom);
            make.height.equalTo(@1);
            make.width.equalTo(@13);
        }];
        
        self.beijiImage.image = [UIImage imageNamed:@"kg_beiji_right"];
        [self.beijiImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomGreen3.mas_right);
            make.centerY.equalTo(self.bottomGreen3.mas_centerY);
            make.height.equalTo(@11);
            make.width.equalTo(@29);
        }];
        
        
        
        
        
    }
    
}
@end
