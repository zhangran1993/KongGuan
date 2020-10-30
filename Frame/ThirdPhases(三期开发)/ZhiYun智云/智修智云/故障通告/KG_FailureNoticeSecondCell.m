//
//  KG_FailureNoticeSecondCell.m
//  Frame
//
//  Created by zhangran on 2020/10/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_FailureNoticeSecondCell.h"

@interface KG_FailureNoticeSecondCell () {
    
    
}

@property (nonatomic ,strong)  UIButton      *leftBtn;
@property (nonatomic ,strong)  UIImageView   *leftBgImage;

@property (nonatomic ,strong)  UIButton      *rightBtn;
@property (nonatomic ,strong)  UIImageView   *rightBgImage;

@end

@implementation KG_FailureNoticeSecondCell

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
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    [self addSubview:iconImage];
    iconImage.image = [UIImage imageNamed:@"kg_guzhang_messTongImage"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@16);
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(17);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"通讯录";
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImage.mas_centerY);
        make.left.equalTo(iconImage.mas_right).offset(8);
        make.height.equalTo(@25);
        make.width.equalTo(@150);
    }];
    
    
    
    UIView *leftView = [[UIView alloc]init];
    [self addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.equalTo(@166);
        make.top.equalTo(self.mas_top).offset(50);
        make.height.equalTo(@62);
    }];
    
    self.leftBtn = [[UIButton alloc]init];
    [leftView addSubview:self.leftBtn];
    [self.leftBtn setTitle:@"" forState:UIControlStateNormal];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_left);
        make.right.equalTo(leftView.mas_right);
        make.top.equalTo(leftView.mas_top);
        make.bottom.equalTo(leftView.mas_bottom);
    }];
    
    self.leftBgImage = [[UIImageView alloc]init];
    [leftView addSubview:self.leftBgImage];
    self.leftBgImage.image = [UIImage imageNamed:@"kg_zhibanbanzuImage"];
    [self.leftBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_left);
        make.right.equalTo(leftView.mas_right);
        make.top.equalTo(leftView.mas_top);
        make.bottom.equalTo(leftView.mas_bottom);
    }];
    UILabel *leftLabel = [[UILabel alloc]init];
    [leftView addSubview:leftLabel];
    leftLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    leftLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    leftLabel.text = @"值班班组";
    leftLabel.textAlignment = NSTextAlignmentRight;
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView.mas_centerY);
        make.right.equalTo(leftView.mas_right).offset(-42);
        make.height.equalTo(@40);
        make.width.equalTo(@150);
    }];
    
    
    
    UIView *rightView = [[UIView alloc]init];
    [self addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.width.equalTo(@166);
        make.top.equalTo(self.mas_top).offset(50);
        make.height.equalTo(@62);
    }];
    self.rightBtn = [[UIButton alloc]init];
    [rightView addSubview:self.rightBtn];
    [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [self.rightBtn addTarget:self action:@selector(rightBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightView.mas_left);
        make.right.equalTo(rightView.mas_right);
        make.top.equalTo(rightView.mas_top);
        make.bottom.equalTo(rightView.mas_bottom);
    }];
    
    self.rightBgImage = [[UIImageView alloc]init];
    [rightView addSubview:self.rightBgImage];
    self.rightBgImage.image = [UIImage imageNamed:@"kg_guzhang_changjiaImage"];
    [self.rightBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightView.mas_left);
        make.right.equalTo(rightView.mas_right);
        make.top.equalTo(rightView.mas_top);
        make.bottom.equalTo(rightView.mas_bottom);
    }];
    
    UILabel *rightLabel = [[UILabel alloc]init];
    [rightView addSubview:rightLabel];
    rightLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    rightLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    rightLabel.text = @"厂家";
    rightLabel.textAlignment = NSTextAlignmentLeft;
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rightView.mas_centerY);
        make.left.equalTo(rightView.mas_left).offset(60);
        make.height.equalTo(@40);
        make.width.equalTo(@150);
    }];
    
}
//左
- (void)leftBtnMethod:(UIButton *)btn {
    
    if (self.pushToNextStep) {
        self.pushToNextStep(@"left");
    }
}

//右
- (void)rightBtnMethod:(UIButton *)btn {
    
    if (self.pushToNextStep) {
        self.pushToNextStep(@"right");
    }
}
@end
