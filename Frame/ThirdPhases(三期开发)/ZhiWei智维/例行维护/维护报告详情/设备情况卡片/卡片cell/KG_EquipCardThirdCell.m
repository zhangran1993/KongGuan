//
//  KG_EquipCardThirdCell.m
//  Frame
//
//  Created by zhangran on 2020/6/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipCardThirdCell.h"

@interface KG_EquipCardThirdCell (){
    
}

@property (nonatomic ,strong) UILabel *titleLabel;

@end

@implementation KG_EquipCardThirdCell

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
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"";
    self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        
    }];
   
}

-  (void)setStr:(NSString *)str {
    _str = str;
  
    self.titleLabel.text = safeString(str);
}
@end
