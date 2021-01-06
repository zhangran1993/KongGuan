//
//  KG_SparePartsStatisticsCollectionViewCell.m
//  Frame
//
//  Created by zhangran on 2020/11/13.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SparePartsStatisticsCollectionViewCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_SparePartsStatisticsCollectionViewCell (){
    
}


@end

@implementation KG_SparePartsStatisticsCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


- (void)initView {
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#B0B6C6"];
    self.titleLabel.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.titleLabel.layer.borderColor = [[UIColor colorWithHexString:@"#EDEEF5"] CGColor];
    self.titleLabel.layer.borderWidth = 0.5;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.layer.cornerRadius =4.f;
    self.titleLabel.layer.masksToBounds = YES;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}
- (void)setCurrSelDic:(NSDictionary *)currSelDic {
    _currSelDic = currSelDic;
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleLabel.text = safeString(dataDic[@"categoryName"]);
    
    if ([safeString(dataDic[@"categoryName"]) isEqualToString:safeString(self.currSelDic[@"categoryName"])]) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.titleLabel.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
        self.titleLabel.layer.borderColor = [[UIColor colorWithHexString:@"#2F5ED1"] CGColor];
        self.titleLabel.layer.borderWidth = 0.5;
    }else {
        
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#B0B6C6"];
        self.titleLabel.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.titleLabel.layer.borderColor = [[UIColor colorWithHexString:@"#EDEEF5"] CGColor];
        self.titleLabel.layer.borderWidth = 0.5;
    }
}

@end
