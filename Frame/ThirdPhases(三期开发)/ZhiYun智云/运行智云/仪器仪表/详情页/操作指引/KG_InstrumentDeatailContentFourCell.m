//
//  KG_InstrumentDetailContentFourthCell.m
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_InstrumentDeatailContentFourCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@implementation KG_InstrumentDeatailContentFourCell

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
    
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    bgView.layer.cornerRadius = 4;
    bgView.layer.masksToBounds = YES;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    self.iconImage = [[UIImageView alloc]init];
    [bgView addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@"kg_leng_icon"];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@6);
        make.left.equalTo(bgView.mas_left).offset(16);
        make.centerY.equalTo(bgView.mas_centerY);
    }];
    
    
    
    
    self.titleLabel = [[UILabel alloc]init];
    [bgView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"";
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(7);
        make.right.equalTo(bgView.mas_right).offset(-60);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@45);
    }];
    
    self.rightBtn = [[UIButton alloc]init];
    [bgView addSubview:self.rightBtn];
    [self.rightBtn setImage: [UIImage imageNamed:@"common_right"] forState:UIControlStateNormal];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
//    [self.rightBtn addTarget:self action:@selector(rightMethod:) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)rightMethod:(UIButton *)button {
    
    
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.titleLabel.text = safeString(dataDic[@"title"]);
    
}
@end
