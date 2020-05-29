//
//  KG_GaoJingDetailSecondCell.m
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_GaoJingDetailSecondCell.h"

@implementation KG_GaoJingDetailSecondCell

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
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.text = @"智慧助手";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(13);
        make.width.equalTo(@120);
        make.height.equalTo(@22);
    }];
    
    UIButton *videoBtn = [[UIButton alloc]init];
    [self addSubview:videoBtn];
    [videoBtn setImage:[UIImage imageNamed:@"zhixiu_VideoImage"] forState:UIControlStateNormal];
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.height.equalTo(@44);
    }];
    [videoBtn addTarget:self action:@selector(videoMethod:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *veideoLabel = [[UILabel alloc]init];
    [self addSubview:veideoLabel];
    veideoLabel.text = @"实时视频";
    veideoLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    veideoLabel.textAlignment = NSTextAlignmentCenter;
    veideoLabel.font = [UIFont systemFontOfSize:12];
    [veideoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(videoBtn.mas_centerX);
        make.top.equalTo(videoBtn.mas_bottom).offset(8);
        make.width.equalTo(@60);
        make.height.equalTo(@22);
    }];
    
    UIButton *yunBtn = [[UIButton alloc]init];
    [self addSubview:yunBtn];
    [yunBtn setImage:[UIImage imageNamed:@"zhixiu_ZhiHuiYun"] forState:UIControlStateNormal];
    [yunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(videoBtn.mas_right).offset(30);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.height.equalTo(@44);
    }];
    [yunBtn addTarget:self action:@selector(resultMethod:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *yunLabel = [[UILabel alloc]init];
    [self addSubview:yunLabel];
    yunLabel.text = @"智慧云";
    yunLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    yunLabel.textAlignment = NSTextAlignmentCenter;
    yunLabel.font = [UIFont systemFontOfSize:12];
    [yunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(yunBtn.mas_centerX);
        make.top.equalTo(yunBtn.mas_bottom).offset(8);
        make.width.equalTo(@60);
        make.height.equalTo(@22);
    }];
    
    UIButton *tongGaoBtn = [[UIButton alloc]init];
    [self addSubview:tongGaoBtn];
    [tongGaoBtn setImage:[UIImage imageNamed:@"zhixiu_GuZhangeImage"] forState:UIControlStateNormal];
    [tongGaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yunBtn.mas_right).offset(30);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.height.equalTo(@44);
    }];
    [tongGaoBtn addTarget:self action:@selector(tongGaoMethod:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *tongGaoLabel = [[UILabel alloc]init];
    [self addSubview:tongGaoLabel];
    tongGaoLabel.text = @"故障通告";
    tongGaoLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    tongGaoLabel.textAlignment = NSTextAlignmentCenter;
    tongGaoLabel.font = [UIFont systemFontOfSize:12];
    [tongGaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tongGaoBtn.mas_centerX);
        make.top.equalTo(videoBtn.mas_bottom).offset(8);
        make.width.equalTo(@60);
        make.height.equalTo(@22);
    }];
    
    UIButton *huizhenBtn = [[UIButton alloc]init];
    [self addSubview:huizhenBtn];
    [huizhenBtn setImage:[UIImage imageNamed:@"zhixiu_HuiZhenImage"] forState:UIControlStateNormal];
    [huizhenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tongGaoBtn.mas_right).offset(30);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.height.equalTo(@44);
    }];
    [huizhenBtn addTarget:self action:@selector(huizhenMethod:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *huizhenLabel = [[UILabel alloc]init];
    [self addSubview:huizhenLabel];
    huizhenLabel.text = @"远程会诊";
    huizhenLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    huizhenLabel.textAlignment = NSTextAlignmentCenter;
    huizhenLabel.font = [UIFont systemFontOfSize:12];
    [huizhenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(huizhenBtn.mas_centerX);
        make.top.equalTo(huizhenBtn.mas_bottom).offset(8);
        make.width.equalTo(@60);
        make.height.equalTo(@22);
    }];
    
}

- (void)videoMethod:(UIButton *)button {
    
    if (self.clickToVideo) {
        self.clickToVideo();
    }
    
    
}
- (void)resultMethod:(UIButton *)button {
    
    if (self.clickToYun) {
        self.clickToYun();
    }
    
}
- (void)tongGaoMethod:(UIButton *)button {
    
    
    if (self.clickToGuZhang) {
        self.clickToGuZhang();
    }
}

- (void)huizhenMethod:(UIButton *)button {
    
    if (self.clickToHuiZhen) {
        self.clickToHuiZhen();
    }
    
}

@end
