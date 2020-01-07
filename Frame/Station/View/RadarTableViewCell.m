//
//  RadarTableViewCell.m
//  Frame
//
//  Created by zhangran on 2020/1/7.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "RadarTableViewCell.h"

@implementation RadarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        
        [self createUI];
    }
    
    return self;
}


- (void)createUI{
    
    UIImageView *img = [[UIImageView alloc]init];
    [self addSubview:img];
    img.backgroundColor  = [UIColor colorWithRed:95.f/255.f green:175.f/255.f blue:251.f/255.f alpha:1.f];
    img.layer.cornerRadius = 4;
    img.layer.masksToBounds = YES;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@8);
        make.height.equalTo(@8);
        make.left.equalTo(@20);
        make.top.equalTo(@21);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.mas_left).offset(50);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.numberOfLines = 1;
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.titleLabel.mas_right).offset(30);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.lessThanOrEqualTo(@200);
    }];
    
}

@end
