//
//  KG_MineFourthCell.m
//  Frame
//
//  Created by zhangran on 2020/12/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_MineFourthCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface  KG_MineFourthCell () {
    
}

@property (nonatomic,strong)  UIImageView    *iconImage;

@property (nonatomic,strong)  UILabel        *titleLabel;

@property (nonatomic,strong)  UIImageView    *rightImage;

@end

@implementation KG_MineFourthCell

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
    
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@"logout_image"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(19);
        make.width.height.equalTo(@22);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.text = @"退出登录";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font =[UIFont my_font:14];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(22);
        make.height.equalTo(self.mas_height);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.width.equalTo(@200);
    }];
    
    self.rightImage =  [[UIImageView alloc]init];
    [self addSubview:self.rightImage];
    self.rightImage.image = [UIImage imageNamed:@"center_rightImage"];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).offset(-11);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

@end
