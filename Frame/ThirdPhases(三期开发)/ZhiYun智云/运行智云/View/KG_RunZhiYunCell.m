//
//  KG_RunZhiYunCell.m
//  Frame
//
//  Created by zhangran on 2020/5/15.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunZhiYunCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_RunZhiYunCell (){
    
}

@end

@implementation KG_RunZhiYunCell

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
        make.top.equalTo(self.mas_top).offset(15);
        make.width.height.equalTo(@56);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.titlelLabel = [[UILabel alloc]init];
    [self addSubview:self.titlelLabel];
    self.titlelLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.titlelLabel.font = [UIFont systemFontOfSize:12];
    self.titlelLabel.font = [UIFont my_font:12];
    self.titlelLabel.textAlignment =  NSTextAlignmentCenter;
    [self.titlelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@17);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titlelLabel.text = safeString(dataDic[@"title"]);
    
    if([safeString(dataDic[@"title"]) isEqualToString:@"线缆图谱"]) {
       self.titlelLabel.textColor = [UIColor colorWithHexString:@"#D0CFCF"];
        
    }else {
        self.titlelLabel.textColor = [UIColor colorWithHexString:@"#626470"];
      
    }
    
    self.iconImage.image = [UIImage imageNamed:safeString(dataDic[@"icon"])];
    
}
@end
