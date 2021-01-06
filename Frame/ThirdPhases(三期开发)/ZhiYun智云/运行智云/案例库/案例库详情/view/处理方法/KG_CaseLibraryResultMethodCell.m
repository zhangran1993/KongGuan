//
//  KG_CaseLibraryResultMethodCell.m
//  Frame
//
//  Created by zhangran on 2020/10/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CaseLibraryResultMethodCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_CaseLibraryResultMethodCell () {
    
    
}

@property (nonatomic ,strong) UIImageView     *iconImage;

@property (nonatomic ,strong) UIImageView     *lengImage;

@property (nonatomic ,strong) UILabel         *titleLabel;

@end

@implementation KG_CaseLibraryResultMethodCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


- (void)initView {
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@200);
    }];
    
    
    self.lengImage = [[UIImageView alloc]init];
    self.lengImage.image = [UIImage imageNamed:@"kg_leng_icon"];
    [self addSubview:self.lengImage];
    [self.lengImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
       
        make.top.equalTo(self.iconImage.mas_bottom).offset(20);
        make.width.height.equalTo(@7);
    }];
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(29);
        make.top.equalTo(self.iconImage.mas_bottom).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
    }];
    
    
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.titleLabel.text = safeString(dataDic[@"method"]);
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString: [WebNewHost stringByAppendingString:safeString(dataDic[@"picture"])]] ];
    
}
@end
