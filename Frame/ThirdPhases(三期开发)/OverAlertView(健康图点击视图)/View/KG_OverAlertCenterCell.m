//
//  KG_OverAlertCenterCell.m
//  Frame
//
//  Created by zhangran on 2020/3/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_OverAlertCenterCell.h"

@interface KG_OverAlertCenterCell () {
    
}

@end
@implementation KG_OverAlertCenterCell

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
        self.contentView.backgroundColor = self.backgroundColor;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.starImage = [[UIImageView alloc]init];
    [self addSubview:self.starImage];
    self.starImage.layer.cornerRadius = 2.5f;
    self.starImage.layer.masksToBounds = YES;
    self.starImage.backgroundColor = [UIColor colorWithHexString:@"#FFAF02"];
    [self.starImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(17);
        make.width.height.equalTo(@5);
    }];
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#60859B"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starImage.mas_right).offset(7);
        make.centerY.equalTo(self.starImage.mas_centerY);
        make.width.lessThanOrEqualTo(@100);
        make.height.equalTo(@22);
    }];
    
    
    
    self.starImage1 = [[UIImageView alloc]init];
    [self addSubview:self.starImage1];
    self.starImage1.backgroundColor = [UIColor colorWithHexString:@"#FFAF02"];
    self.starImage1.layer.cornerRadius = 2.5f;
    self.starImage1.layer.masksToBounds = YES;
    self.titleLabel1 = [[UILabel alloc]init];
    [self addSubview:self.titleLabel1];
    self.titleLabel1.numberOfLines = 1;
    self.titleLabel1.font = [UIFont systemFontOfSize:12];
    self.titleLabel1.textColor = [UIColor colorWithHexString:@"#60859B"];
    self.titleLabel1.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(self.mas_right).offset(-22);
           make.centerY.equalTo(self.starImage.mas_centerY);
           make.width.equalTo(@63);
           make.height.equalTo(@22);
       }];
    [self.starImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.titleLabel1.mas_left).offset(-7);
           make.centerY.equalTo(self.starImage.mas_centerY);
           make.width.height.equalTo(@5);
       }];
}
@end
