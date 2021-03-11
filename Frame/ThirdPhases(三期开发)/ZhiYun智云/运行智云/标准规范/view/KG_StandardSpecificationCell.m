//
//  KG_StandardSpecificationCell.m
//  Frame
//
//  Created by zhangran on 2020/8/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_StandardSpecificationCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_StandardSpecificationCell (){
    
}

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UIImageView *rightImage;

@end

@implementation KG_StandardSpecificationCell

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
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [self addSubview:self.iconImage];
    self.iconImage.layer.cornerRadius = 3.f;
    self.iconImage.layer.masksToBounds = YES;
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@6);
        
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(9);
        make.height.equalTo(self.mas_height);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-40);
    }];
    
    self.rightImage = [[UIImageView alloc]init];
    self.rightImage.image = [UIImage imageNamed:@"common_right"];
    [self addSubview:self.rightImage];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.mas_centerY);
    }];
       
    
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@0.5);
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;

    self.titleLabel.text = safeString(dataDic[@"name"]);
}

@end
