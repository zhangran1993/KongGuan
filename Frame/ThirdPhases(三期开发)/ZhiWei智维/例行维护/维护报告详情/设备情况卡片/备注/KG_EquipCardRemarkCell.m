//
//  KG_EquipCardRemarkCell.m
//  Frame
//
//  Created by zhangran on 2020/6/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipCardRemarkCell.h"

@interface KG_EquipCardRemarkCell () {
    
}
@property (nonatomic ,strong) UIView *remarkView;

@property (nonatomic ,strong) UILabel *remarkTextLabel;


@end

@implementation KG_EquipCardRemarkCell

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
    self.remarkView = [[UIView alloc]init];
    [self addSubview:self.remarkView];
    [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    UILabel *remarkTitle = [[UILabel alloc]init];
    [self.remarkView addSubview:remarkTitle];
    remarkTitle.text = @"备注";
    remarkTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    remarkTitle.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    remarkTitle.numberOfLines = 1;
    [remarkTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remarkView.mas_left).offset(16.5);
        make.top.equalTo(self.remarkView.mas_top).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@15);
    }];
    
    self.remarkTextLabel = [[UILabel alloc]init];
    [self.remarkView addSubview:self.remarkTextLabel];
    self.remarkTextLabel.text = @"设备数据库正常，驻波比正";
    self.remarkTextLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.remarkTextLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [self.remarkTextLabel sizeToFit];
    self.remarkTextLabel.numberOfLines = 0;
    [self.remarkTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remarkView.mas_left).offset(16.5);
        make.right.equalTo(self.remarkView.mas_right).offset(-16.5);
        make.top.equalTo(remarkTitle.mas_bottom).offset(14);
        
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self.remarkView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remarkView.mas_left).offset(16);
        make.right.equalTo(self.remarkView.mas_right).offset(-16);
        make.height.equalTo(@1);
        make.top.equalTo(self.remarkTextLabel.mas_bottom).offset(12.5);
    }];
    
   
}

@end
