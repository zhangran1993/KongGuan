//
//  KG_ResultPromptCell.m
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ResultPromptCell.h"

@interface KG_ResultPromptCell (){
    
    
}

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UIImageView *rightIcon;
@end

@implementation KG_ResultPromptCell

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
    self.titleLabel.text = @"标准规范";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(self.mas_top).offset(12);
        make.height.equalTo(@28);
        make.width.equalTo(@28);
    }];
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-18);
        make.width.equalTo(@38);
        make.height.equalTo(@20);
        make.top.equalTo(self.mas_top).offset(15);
    }];
   
    
    self.rightIcon = [[UIImageView alloc]init];
    [self addSubview:self.rightIcon];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    self.rightIcon.image = [UIImage imageNamed:@"right_iconImage"];
    
    UIView *lineImage = [[UIView alloc]init];
    [self addSubview:lineImage];
    lineImage.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(59);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleLabel.text = safeString(dataDic[@"title"]);
    
    self.rightIcon.image = [UIImage imageNamed:safeString(dataDic[@"icon"])];
    
    
}
@end
