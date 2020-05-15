//
//  KG_CommonGaoJingCell.m
//  Frame
//
//  Created by zhangran on 2020/5/6.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CommonGaoJingCell.h"

@interface KG_CommonGaoJingCell (){
    
}


@end
@implementation KG_CommonGaoJingCell

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
        make.width.height.equalTo(@13);
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.iconImage.image = [UIImage imageNamed:@"center_right"];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"旁路供电";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.iconImage.mas_right).offset(9);
        make.width.equalTo(@200);
        make.height.equalTo(self.mas_height);
    }];

    
    
}
@end
