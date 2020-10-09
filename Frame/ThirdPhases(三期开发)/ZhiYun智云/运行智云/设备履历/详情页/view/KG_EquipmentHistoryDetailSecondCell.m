//
//  KG_InstrumentationContentCell.m
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipmentHistoryDetailSecondCell.h"

@interface KG_EquipmentHistoryDetailSecondCell (){
    
}



@end

@implementation KG_EquipmentHistoryDetailSecondCell

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
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    self.iconImage.layer.cornerRadius = 3.f;
    self.iconImage.layer.masksToBounds = YES;
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@6);
        make.left.equalTo(self.mas_left).offset(16);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"";
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(7);
        make.width.equalTo(@120);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@45);
    }];
    
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.detailLabel.text = @"";
    self.detailLabel.numberOfLines = 2;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.width.equalTo(@250);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@45);
    }];
    
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor  =[UIColor colorWithHexString:@"#EFF0F7"];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@0.5);
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    
}
@end
