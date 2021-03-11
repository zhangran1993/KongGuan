//
//  KG_ComminSelContentCell.m
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ComminSelContentCell.h"

@implementation KG_ComminSelContentCell

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
   
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"环境情况";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
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
    
}
@end
