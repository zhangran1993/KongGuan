//
//  KG_NoDataPromptView.m
//  Frame
//
//  Created by zhangran on 2020/11/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NoDataPromptView.h"


@interface KG_NoDataPromptView () {
    
}
 
@property (nonatomic, strong)       UIView       *noDataView;

@end

@implementation KG_NoDataPromptView

- (instancetype)init
{
    self = [super init];
    if (self) {
       
        [self setupDataSubviews];
    }
    return self;
}

- (void)setupDataSubviews {
    
    self.noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    [self addSubview:self.noDataView];
    self.iconImage = [[UIImageView alloc]init];
    self.iconImage.image = [UIImage imageNamed:@"kg_searchEmpty_Icon"];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.noDataView addSubview:self.iconImage];
    [self.iconImage sizeToFit];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@302);
//        make.height.equalTo(@153);
        make.centerX.equalTo(_noDataView.mas_centerX);
        make.centerY.equalTo(_noDataView.mas_centerY);
    }];
    
    self.noDataLabel = [[UILabel alloc]init];
    [self.noDataView addSubview:self.noDataLabel];
    self.noDataLabel.text = @"当前暂无数据";
    self.noDataLabel.textColor = [UIColor colorWithHexString:@"#BFC6D2"];
    self.noDataLabel.font = [UIFont systemFontOfSize:12];
    self.noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_noDataView.mas_centerX);
        make.height.equalTo(@17);
        make.width.equalTo(@200);
        make.top.equalTo(self.iconImage.mas_bottom).offset(27);
    }];
}

- (void)showView {
    self.hidden = NO;
}

- (void)hideView {
    self.hidden = YES;
}


@end
