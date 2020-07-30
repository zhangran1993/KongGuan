//
//  KG_EquipCardSecondCell.m
//  Frame
//
//  Created by zhangran on 2020/6/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipCardSecondCell.h"

@interface KG_EquipCardSecondCell (){
    
    
}

@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation KG_EquipCardSecondCell

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
    self.titleLabel.text = @"-";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-100);
        make.height.equalTo(self.mas_height);
    }];
 
}

-  (void)setStr:(NSString *)str {
    _str = str;
  
    self.titleLabel.text = safeString(str);
}
@end
