//
//  KG_RunWeiHuCell.m
//  Frame
//
//  Created by zhangran on 2020/5/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunWeiHuCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_RunWeiHuCell (){
    
    
}

@property (nonatomic,strong) UILabel *titleLabel ;

@property (nonatomic,strong) UIImageView *iconImage;



@end

@implementation KG_RunWeiHuCell

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
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    self.iconImage.layer.cornerRadius =1.5f;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#2B8EFF"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
        make.height.width.equalTo(@3);
        
    }];
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"5月10日综合楼停电维护";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(8);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
   
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleLabel.text = safeString(dataDic[@"title"]);
    if ([safeString(dataDic[@"tipsStatus"]) boolValue]) {
        self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#03C3B6"];
    }else {
        self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#424242"];
    }
}
@end
