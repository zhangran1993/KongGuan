//
//  KG_MineFirstCell.m
//  Frame
//
//  Created by zhangran on 2020/12/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_MineFirstCell.h"

@interface KG_MineFirstCell () {
    
    
}

@property (nonatomic, strong)   UIImageView       *bgImage;

@property (nonatomic, strong)   UIImageView       *iconImage;

@property (nonatomic, strong)   UIButton          *rightButton;

@property (nonatomic, strong)   UILabel           *titleLabel;

@property (nonatomic, strong)   UILabel           *detailLabel;

@property (nonatomic, strong)   UIView            *circleView;

@property (nonatomic, strong)   UIView            *bgView;

@property (nonatomic, strong)   UIView            *shuView;
 
@property (nonatomic, strong)   UIButton          *staRightBtn;

@end


@implementation KG_MineFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    
    self.bgImage = [[UIImageView alloc]init];
    [self addSubview:self.bgImage];
    self.bgImage.image = [UIImage imageNamed:@"center_bg_image"];
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@180);
    }];
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(self.mas_top).offset(66);
        make.height.width.equalTo(@74);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(16);
        make.top.equalTo(self.iconImage.mas_top).offset(6);
        make.height.equalTo(@28);
        make.width.equalTo(@120);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.height.equalTo(@28);
        make.right.equalTo(self.mas_right).offset(-29);
    }];
    
    
    self.staRightBtn = [[UIButton alloc]init];
    [self addSubview:self.staRightBtn];
    [self.staRightBtn setImage:[UIImage imageNamed:@"center_rightImage"] forState:UIControlStateNormal];
    [self.staRightBtn addTarget:self action:@selector(stationClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.staRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.detailLabel.mas_centerY);
    }];
    
    self.circleView = [[UIView alloc]init];
    [self addSubview:self.circleView];
    self.circleView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.circleView.layer.cornerRadius = 10;
    self.circleView.layer.masksToBounds = YES;
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImage.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@30);
    }];
    
    
    UIView *shuView = [[UIView alloc]init];
    [self addSubview:shuView];
    shuView.layer.cornerRadius = 2.f;
    shuView.layer.masksToBounds = YES;
    shuView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.equalTo(@4);
        make.height.equalTo(@14);
        make.top.equalTo(self.bgImage.mas_bottom).offset(3);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.text = @"消息中心";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font =[UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuView.mas_right).offset(8);
        make.centerY.equalTo(shuView.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@22);
    }];
    
    UIButton *rightButton = [[UIButton alloc]init];
    [self addSubview:rightButton];
    [rightButton setImage:[UIImage imageNamed:@"center_rightImage"] forState:UIControlStateNormal];\
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.right.equalTo(self.mas_right).offset(-11);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    
    UIButton *guzhangBtn = [[UIButton alloc]init];
    [self addSubview:guzhangBtn];
    [guzhangBtn setImage:[UIImage imageNamed:@"center_yujing_image"] forState:UIControlStateNormal];
    [guzhangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(38);
        make.top.equalTo(self.bgImage.mas_bottom).offset(51+3-10);
        make.width.height.equalTo(@60);
    }];
    
    UILabel *guzhangLabel = [[UILabel alloc]init];
    [self addSubview:guzhangLabel];
    guzhangLabel.text = @"预警消息";
    guzhangLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    guzhangLabel.numberOfLines = 1;
    guzhangLabel.textAlignment = NSTextAlignmentCenter;
    guzhangLabel.font = [UIFont systemFontOfSize:14];
    [guzhangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(guzhangBtn.mas_centerX);
        make.top.equalTo(guzhangBtn.mas_bottom).offset(4);
        make.height.equalTo(@22);
        make.width.equalTo(@80);
    }];
    
    UIButton *beijianBtn = [[UIButton alloc]init];
    [self addSubview:beijianBtn];
    [beijianBtn setImage:[UIImage imageNamed:@"center_gaojing_image"] forState:UIControlStateNormal];
    [beijianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.bgImage.mas_bottom).offset(51+3-10);
        make.width.height.equalTo(@60);
    }];
    
    UILabel *beijianLabel = [[UILabel alloc]init];
    [self addSubview:beijianLabel];
    beijianLabel.text = @"告警消息";
    beijianLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    beijianLabel.numberOfLines = 1;
    beijianLabel.textAlignment = NSTextAlignmentCenter;
    beijianLabel.font = [UIFont systemFontOfSize:14];
    [beijianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(beijianBtn.mas_centerX);
        make.top.equalTo(beijianBtn.mas_bottom).offset(4);
        make.height.equalTo(@22);
        make.width.equalTo(@80);
    }];
    
    UIButton *levelBtn = [[UIButton alloc]init];
    [self addSubview:levelBtn];
    [levelBtn setImage:[UIImage imageNamed:@"center_gonggao_image"] forState:UIControlStateNormal];
    [levelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-40);
        make.top.equalTo(self.bgImage.mas_bottom).offset(51+3-10);
        make.width.height.equalTo(@60);
    }];
    
    UILabel *levelLabel = [[UILabel alloc]init];
    [self addSubview:levelLabel];
    levelLabel.text = @"公告消息";
    levelLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    levelLabel.numberOfLines = 1;
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.font = [UIFont systemFontOfSize:14];
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(levelBtn.mas_centerX);
        make.top.equalTo(levelBtn.mas_bottom).offset(4);
        make.height.equalTo(@22);
        make.width.equalTo(@80);
    }];

}

//所属台站点击
- (void)stationClickMethod:(UIButton *)button {
    
    
    
}
@end
