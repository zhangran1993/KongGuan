//
//  KG_CenterCommonCell.m
//  Frame
//
//  Created by zhangran on 2020/12/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_AccountSafeCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_AccountSafeCell (){
    
}

@property (nonatomic ,strong)   UIImageView     *iconImage;


@property (nonatomic ,strong)   UILabel         *titleLabel;


@property (nonatomic ,strong)   UILabel         *detailLabel;


@property (nonatomic ,strong)   UIImageView     *rightImage;

@end

@implementation KG_AccountSafeCell

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
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.height.equalTo(@14);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(42);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height);
    }];
    
   
    
    self.rightImage = [[UIImageView alloc]init];
    [self addSubview:self.rightImage];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-9.5);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.font = [UIFont my_font:14];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImage.mas_left).offset(-5);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height);
    }];
    self.detailLabel.hidden = YES;
    
    
}

- (void)setStr:(NSString *)str {
    _str = str;
    self.titleLabel.text = str;
    if ([str isEqualToString:@"新消息通知"]) {
        
        self.iconImage.image = [UIImage imageNamed:@"kg_messnoti"];
    }else if ([str isEqualToString:@"字体大小"]) {
        
        self.iconImage.image = [UIImage imageNamed:@"kg_fontsize"];
    }else if ([str isEqualToString:@"清除缓存"]) {
       
        self.iconImage.image = [UIImage imageNamed:@"kg_clearcache"];
    }
    
}

@end
