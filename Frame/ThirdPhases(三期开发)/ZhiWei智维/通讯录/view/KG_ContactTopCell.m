//
//  KG_ContactTopCell.m
//  Frame
//
//  Created by zhangran on 2020/8/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ContactTopCell.h"

@implementation KG_ContactTopCell

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
    
    self.selIconImage = [[UIImageView alloc]init];
    [self addSubview:self.selIconImage];
    self.selIconImage.image = [UIImage imageNamed:@"kg_topCircle"];
    [self.selIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(28);
        make.height.width.equalTo(@10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selIconImage.mas_right).offset(9);
        make.right.equalTo(self.mas_right).offset(-60);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height);
    }];
    self.titleLabel.text = @"站领导（4）";
    
    self.rightImage = [[UIImageView alloc]init];
    [self addSubview:self.rightImage];
    self.rightImage.image = [UIImage imageNamed:@"kg_rightArrow"];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.width.equalTo(@18);
        make.centerY.equalTo(self.mas_centerY);
    }];
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(31);
        make.height.equalTo(@1);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",safeString(dataDic[@"orgName"]),safeString(dataDic[@"userSize"])];
}
@end
