//
//  KG_MyMessageDetailCell.m
//  Frame
//
//  Created by zhangran on 2020/12/15.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_GonggaoDetailCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_GonggaoDetailCell () {
    
}



@end

@implementation KG_GonggaoDetailCell

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
    self.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    
    UIView *timeBgView = [[UIView alloc]init];
    [self addSubview:timeBgView];
    timeBgView.backgroundColor = [UIColor colorWithHexString:@"#ABAFB9"];
    timeBgView.layer.cornerRadius = 3.f;
    timeBgView.layer.masksToBounds = YES;
    
    
    self.timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.backgroundColor = [UIColor colorWithHexString:@"#ABAFB9"];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    [self.timeLabel sizeToFit];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(18);
        make.height.equalTo(@20);
    }];
    
    [timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(18);
        make.height.equalTo(@20);
        make.left.equalTo(self.timeLabel.mas_left).offset(-5);
        make.right.equalTo(self.timeLabel.mas_right).offset(5);
    }];
    
    self.centerView = [[UIView alloc]init];
    [self.contentView addSubview:self.centerView];
    self.centerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(50);
        make.right.equalTo(self.mas_right).offset(-16);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
//    self.iconImage = [[UIImageView alloc]init];
//    [self.centerView addSubview:self.iconImage];
//    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.centerView.mas_left).offset(17);
//        make.top.equalTo(self.centerView.mas_top).offset(13);
//        make.width.equalTo(@14);
//        make.height.equalTo(@16);
//    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.font = [UIFont my_font:16];
    [self.titleLabel sizeToFit];
    self.titleLabel.numberOfLines = 1;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(50);
        make.height.equalTo(@40);
//        make.width.equalTo(@200);
    }];
    
    self.redDotImage = [[UIImageView alloc]init];
    [self.centerView addSubview:self.redDotImage];
    self.redDotImage.backgroundColor = [UIColor colorWithHexString:@"#FB394C"];
    self.redDotImage.layer.cornerRadius =6.f;
    self.redDotImage.layer.masksToBounds = YES;
    [self.redDotImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(-15);
        make.top.equalTo(self.centerView.mas_top).offset(6);
        make.height.width.equalTo(@12);
    }];
    
    self.lineView = [[UIView alloc]init];
    [self.centerView addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(17);
        make.top.equalTo(self.centerView.mas_top).offset(40);
        make.right.equalTo(self.centerView.mas_right).offset(-17);
        make.height.equalTo(@0.5);
    }];
    
    
    self.detailLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.font = [UIFont my_font:14];
    self.detailLabel.numberOfLines = 0;
    [self.detailLabel sizeToFit];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.right.equalTo(self.centerView.mas_right).offset(-41);
        make.top.equalTo(self.lineView.mas_bottom).offset(12);
        
    }];
    
    self.rightImage = [[UIImageView alloc]init];
    [self.centerView addSubview:self.rightImage];
    self.rightImage.image = [UIImage imageNamed:@"center_rightImage"];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.centerView.mas_right).offset(-11);
        make.centerY.equalTo(self.detailLabel.mas_centerY);
        make.width.height.equalTo(@18);
    }];
    
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    
}

@end
