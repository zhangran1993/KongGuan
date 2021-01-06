//
//  KG_BeiJianDetailCell.m
//  Frame
//
//  Created by zhangran on 2020/7/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianDetailCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_BeiJianDetailCell (){
    
}


@end

@implementation KG_BeiJianDetailCell

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
    self.iconImage.layer.cornerRadius = 3;
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
    self.titleLabel.font = [UIFont my_font:14];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(7);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(self.mas_height);
        
    }];
    
    
    
     self.detailLabel = [[UILabel alloc]init];
     [self addSubview:self.detailLabel];
     self.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
     self.detailLabel.font = [UIFont systemFontOfSize:14];
     self.detailLabel.font = [UIFont my_font:14];
     self.detailLabel.numberOfLines = 2;
     self.detailLabel.textAlignment = NSTextAlignmentRight;
     [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(self.mas_right).offset(-16);
         make.centerY.equalTo(self.mas_centerY);
         make.width.equalTo(@200);
         make.height.equalTo(self.mas_height);
         
     }];
    
    UIView *lineView =[[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(16);
        make.height.equalTo(@0.5);
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic =dataDic;
}
@end
