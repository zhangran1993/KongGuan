//
//  KG_InstrumentDetailContentFourthCell.m
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_InstrumentDetailContentFourthCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@implementation KG_InstrumentDetailContentFourthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviewsView];
    }
    return self;
}


- (void)createSubviewsView {
    
    
    self.contentImage =  [[UIImageView alloc]init];
    [self addSubview:self.contentImage];
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@200);
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top);
    }];
    
    
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@"kg_leng_icon"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@6);
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.contentImage.mas_bottom).offset(20);
    }];
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"";
    [self.titleLabel sizeToFit];
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentImage.mas_left).offset(13);
        make.right.equalTo(self.contentImage.mas_right);
        make.top.equalTo(self.contentImage.mas_bottom).offset(12);
    }];
    
    self.totalNumLabel = [[UILabel alloc]init];
    [self addSubview:self.totalNumLabel];
    self.totalNumLabel.textColor = [UIColor colorWithHexString:@"#AFB2BD"];
    self.totalNumLabel.font = [UIFont systemFontOfSize:14];
    self.totalNumLabel.font = [UIFont my_font:14];
    self.totalNumLabel.textAlignment = NSTextAlignmentRight;
    self.totalNumLabel.text = @"/4";
    [self.totalNumLabel sizeToFit];
    self.totalNumLabel.numberOfLines = 1;
    [self.totalNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
        make.height.equalTo(@20);
    }];
    
    
    self.numLabel = [[UILabel alloc]init];
    [self addSubview:self.numLabel];
    self.numLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.numLabel.font = [UIFont systemFontOfSize:14];
    self.numLabel.font = [UIFont my_font:14];
    self.numLabel.textAlignment = NSTextAlignmentRight;
    self.numLabel.text = @"";
    [self.numLabel sizeToFit];
    self.numLabel.numberOfLines = 1;
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.totalNumLabel.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
        make.height.equalTo(@20);
    }];

}

- (void)rightMethod:(UIButton *)button {
    
    
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.titleLabel.text = safeString(dataDic[@"name"]);
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,safeString(dataDic[@"picture"])]]];
    
}
@end
