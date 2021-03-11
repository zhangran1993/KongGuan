//
//  KG_SetFontSystemLeftCell.m
//  Frame
//
//  Created by zhangran on 2020/12/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SetFontSystemLeftCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_SetFontSystemLeftCell () {
    
}

@property (nonatomic ,strong) UIImageView                 *headIcon;


@property (nonatomic ,strong) UIImageView                 *rightSlider;


@property (nonatomic ,strong) UILabel                     *titleLabel;

@property (nonatomic ,strong) UIView                      *titleBgView;



@end

@implementation KG_SetFontSystemLeftCell

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
  
    self.headIcon = [[UIImageView alloc]init];
    [self.contentView addSubview:self.headIcon];
    self.headIcon.image = [UIImage imageNamed:@"kg_font_rightIcon"];
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.width.equalTo(@42);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.rightSlider = [[UIImageView alloc]init];
    [self.contentView addSubview:self.rightSlider];
    self.rightSlider.image = [UIImage imageNamed:@"kg_font_rightSlider"];
    [self.rightSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headIcon.mas_left).offset(-6);
        make.width.equalTo(@8);
        make.height.equalTo(@11);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.titleBgView = [[UIView alloc]init];
    [self.contentView addSubview:self.titleBgView];
    self.titleBgView.layer.cornerRadius = 6.f;
    self.titleBgView.layer.masksToBounds = YES;
    self.titleBgView.backgroundColor = [UIColor colorWithHexString:@"#AED1F9"];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"预览字体大小";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font =[UIFont my_font:16];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightSlider.mas_left).offset(-10);
        make.height.equalTo(@43);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    
    
    [self.titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightSlider.mas_left);
        make.height.equalTo(@43);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.titleLabel.mas_left).offset(-10);
    }];
    
    
}

- (void)setFontSize:(int)fontSize {
    _fontSize = fontSize;
    
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

@end
