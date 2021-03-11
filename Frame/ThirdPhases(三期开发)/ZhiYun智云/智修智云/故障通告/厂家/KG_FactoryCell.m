//
//  KG_InstrumentDetailContentFourthCell.m
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_FactoryCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@implementation KG_FactoryCell

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
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"";
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.equalTo(@250);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@45);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.font = [UIFont my_font:14];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.detailLabel.text = @"";
    self.detailLabel.numberOfLines = 2;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-21);
        make.width.equalTo(@250);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@45);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
    }];
 
 
}

- (void)rightMethod:(UIButton *)button {
    
    
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;

    self.titleLabel.text = [NSString stringWithFormat:@"%@%@", safeString(dataDic[@"company"]), safeString(dataDic[@"person"])];
   
    self.detailLabel.text = safeString(dataDic[@"telNumber"]);
    
}
@end
