//
//  KG_XunJianReportCell.m
//  Frame
//
//  Created by zhangran on 2020/4/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunJianReportCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@implementation KG_XunJianReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = self.backgroundColor;
        [self createUI];
    }
    return self;
}

- (void)createUI {
   
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    self.iconImage.layer.cornerRadius = 3.f;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(19);
        make.width.height.equalTo(@6);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"环境情况";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.font = [UIFont my_font:17];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(self.mas_height);
    }];
    
    
    self.lineImage = [[UIImageView alloc]init];
    [self addSubview:self.lineImage];
    self.lineImage.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [self.lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(16);
        make.height.equalTo(@0.5);
        make.right.equalTo(self.mas_right).offset(-16);
    }];
    
    self.rightImage = [[UIImageView alloc]init];
    [self addSubview:self.rightImage];
    
    self.rightImage.image = [UIImage imageNamed:@"content_right"];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@15);
    }];
    
    
}
@end
