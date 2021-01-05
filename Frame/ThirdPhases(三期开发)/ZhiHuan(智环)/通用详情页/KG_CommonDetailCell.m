//
//  KG_CommonDetailCell.m
//  Frame
//
//  Created by zhangran on 2020/4/29.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CommonDetailCell.h"

@interface KG_CommonDetailCell (){
    
}


@end
@implementation KG_CommonDetailCell

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
    
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@6);
        make.left.equalTo(self.mas_left).offset(23);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#95A8D7"];
    self.iconImage.layer.cornerRadius = 3.f;
    self.iconImage.layer.masksToBounds = YES;
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"旁路供电";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.iconImage.mas_right).offset(9);
        make.width.equalTo(@200);
        make.height.equalTo(self.mas_height);
    }];
    
    self.rightLabel = [[UILabel alloc]init];
    [self addSubview:self.rightLabel];
    self.rightLabel.text = @"否";
    self.rightLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    self.rightLabel.font = [UIFont my_font:14];
    self.rightLabel.numberOfLines = 1;
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).offset(-17);
        make.width.equalTo(@200);
        make.height.equalTo(self.mas_height);
    }];
    
    
}
@end
