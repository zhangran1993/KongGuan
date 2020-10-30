//
//  KG_InstrumentDetailContentFourthCell.m
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipmentHistoryDetailFourthCell.h"

@implementation KG_EquipmentHistoryDetailFourthCell

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
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"";
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-60);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@45);
    }];
    
    self.rightBtn = [[UIButton alloc]init];
    [self addSubview:self.rightBtn];
    [self.rightBtn setImage: [UIImage imageNamed:@"common_right"] forState:UIControlStateNormal];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
//    [self.rightBtn addTarget:self action:@selector(rightMethod:) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)rightMethod:(UIButton *)button {
    
    
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.titleLabel.text = safeString(dataDic[@"name"]);
    if(safeString(dataDic[@"name"]).length == 0) {
        self.titleLabel.text = safeString(dataDic[@"title"]);
        if(safeString(dataDic[@"title"]).length == 0) {
            self.titleLabel.text = safeString(dataDic[@"taskName"]);
        }
    }
    
   
    
}
@end
