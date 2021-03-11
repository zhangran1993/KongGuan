//
//  KG_RunReportFuJianCell.m
//  Frame
//
//  Created by zhangran on 2020/6/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunReportFuJianCell.h"

@interface KG_RunReportFuJianCell (){
    
}

@property (nonatomic ,strong) UIImageView *iconImage;

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UIImageView *rightImage;
@end

@implementation KG_RunReportFuJianCell

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
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    
    self.iconImage = [[UIImageView alloc]init];
    self.iconImage.image = [UIImage imageNamed:@"fujianImage"];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.width.height.equalTo(@9);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(5);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(self.mas_height);
    }];
    
    self.rightImage = [[UIImageView alloc]init];
    self.rightImage.image = [UIImage imageNamed:@"jiaojieban_rightIcon"];
    [self addSubview:self.rightImage];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    self.titleLabel.text = safeString(dic[@"name"]);
}
@end
