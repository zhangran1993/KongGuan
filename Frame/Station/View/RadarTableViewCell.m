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
    img.backgroundColor  = [UIColor colorWithHexString:@"#95A8D7"];
    img.layer.cornerRadius = 3;
    img.layer.masksToBounds = YES;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@6);
        make.height.equalTo(@6);
        make.left.equalTo(@23);
        make.top.equalTo(@24);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.mas_left).offset(50);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.detailLabel.numberOfLines = 1;
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo (self.mas_right).offset(-20);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.lessThanOrEqualTo(@200);
    }];
    
}

@end
