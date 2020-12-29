//
//  KG_PersonInfoStationCell.m
//  Frame
//
//  Created by zhangran on 2020/12/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_PersonInfoStationCell.h"

@interface KG_PersonInfoStationCell () {
    
}


@end
@implementation KG_PersonInfoStationCell

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
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 1;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.equalTo(@120);
        make.height.equalTo(self.mas_height);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.titleLabel.text = @"所属台站";
    
  
    self.rightImage = [[UIImageView alloc]init];
    self.rightImage.image = [UIImage imageNamed:@"center_rightImage"];
    [self addSubview:self.rightImage];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-11);
        
    }];
    
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.detailLabel.font = [UIFont systemFontOfSize:16];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.detailLabel.numberOfLines = 1;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImage.mas_left).offset(-4);
        make.width.equalTo(@220);
        make.height.equalTo(self.mas_height);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
      
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    
}

@end
