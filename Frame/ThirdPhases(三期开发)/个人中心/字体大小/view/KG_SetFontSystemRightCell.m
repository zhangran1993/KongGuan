//
//  KG_SetFontSystemLeftCell.m
//  Frame
//
//  Created by zhangran on 2020/12/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SetFontSystemRightCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_SetFontSystemRightCell () {
    
}

@property (nonatomic ,strong) UIImageView                 *headIcon;


@property (nonatomic ,strong) UIImageView                 *rightSlider;


@property (nonatomic ,strong) UIView                      *titleBgView;



@end

@implementation KG_SetFontSystemRightCell

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
    NSString *font = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalTextFont];
    

    self.headIcon = [[UIImageView alloc]init];
    [self.contentView addSubview:self.headIcon];
    self.headIcon.image = [UIImage imageNamed:@"kg_font_leftIcon"];
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.height.width.equalTo(@42);
        make.top.equalTo(self.mas_top).offset(0.5);
    }];
    
    self.rightSlider = [[UIImageView alloc]init];
    [self.contentView addSubview:self.rightSlider];
    self.rightSlider.image = [UIImage imageNamed:@"kg_font_leftSlider"];
    [self.rightSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headIcon.mas_right).offset(6);
        make.width.equalTo(@8);
        make.height.equalTo(@11);
        make.centerY.equalTo(self.headIcon.mas_centerY);
    }];
    
    self.titleBgView = [[UIView alloc]init];
    [self.contentView addSubview:self.titleBgView];
    self.titleBgView.layer.cornerRadius = 6.f;
    self.titleBgView.layer.masksToBounds = YES;
    self.titleBgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"拖动下面的滑块，可设置字体大小";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont my_font:16];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel sizeToFit];
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightSlider.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-56);
        make.top.equalTo(self.rightSlider.mas_top).offset(1);
    }];
    
    
    [self.titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightSlider.mas_right);
        make.bottom.equalTo(self.titleLabel.mas_bottom).offset(14);
        make.top.equalTo(self.titleLabel.mas_top).offset(-13.5);
        make.right.equalTo(self.titleLabel.mas_right).offset(10);
    }];
//    
//  [self performSelector:@selector(fontSet) withObject:nil afterDelay:10.f];
//    [self performSelector:@selector(fontSet1) withObject:nil afterDelay:15.f];
//    [self performSelector:@selector(fontSet2) withObject:nil afterDelay:20.f];
}


- (void)setFontSize:(int)fontSize {
    _fontSize = fontSize;
    
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

@end
