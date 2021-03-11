//
//  KG_PersonInfoNameCell.m
//  Frame
//
//  Created by zhangran on 2020/12/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_PersonInfoNameCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_PersonInfoNameCell () {
    
}


@end

@implementation KG_PersonInfoNameCell

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
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.font = [UIFont my_font:16];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.equalTo(@120);
        make.height.equalTo(self.mas_height);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    self.detailLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.detailLabel.font = [UIFont systemFontOfSize:16];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.detailLabel.numberOfLines = 1;
    self.detailLabel.font = [UIFont my_font:16];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.width.equalTo(@220);
        make.height.equalTo(self.mas_height);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.lineView = [[UIView alloc]init];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
}
@end
