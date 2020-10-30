//
//  KG_LastestWarnTotalCell.m
//  Frame
//
//  Created by zhangran on 2020/9/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_LastestWarnTotalCell.h"

@interface KG_LastestWarnTotalCell () {
    
}

@property (nonatomic ,strong) UIView *centerView;



@end

@implementation KG_LastestWarnTotalCell

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
    self.centerView = [[UIView alloc]init];
    [self addSubview:self.centerView];
    self.centerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.equalTo(@313);
        make.right.equalTo(@(SCREEN_WIDTH));
    }];
    
    self.centerView.layer.cornerRadius = 6.f;
    self.centerView.layer.masksToBounds = YES;
    
    UIView *bgView = [[UIView alloc]init];
    [self.centerView addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left);
        make.top.equalTo(self.centerView.mas_top);
        make.height.equalTo(self.centerView.mas_height);
        make.right.equalTo(self.mas_right);
    }];
    
    UIView *shuView = [[UIView alloc]init];
    [bgView addSubview:shuView];
    shuView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(16);
        make.top.equalTo(bgView.mas_top).offset(21);
        make.width.equalTo(@4);
        make.height.equalTo(@15);
    }];
    shuView.layer.cornerRadius = 2.f;
    shuView.layer.masksToBounds = YES;
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [bgView addSubview:titleLabel];
    titleLabel.text = [NSString stringWithFormat:@"%@",@"最近告警统计"];
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.numberOfLines =1;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuView.mas_right).offset(5);
        make.width.equalTo(@220);
        make.height.equalTo(@30);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    

    UILabel *promptLabel = [[UILabel alloc]init];
    [bgView addSubview:promptLabel];
    promptLabel.text = [NSString stringWithFormat:@"%@",@"提示"];
    promptLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    promptLabel.font = [UIFont systemFontOfSize:12];
    promptLabel.numberOfLines =1;
    promptLabel.textAlignment = NSTextAlignmentLeft;
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-16);
        make.width.equalTo(@28);
        make.height.equalTo(@17);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    UIImageView *promptImage = [[UIImageView alloc]init];
    [bgView addSubview:promptImage];
    promptImage.backgroundColor = [UIColor colorWithHexString:@"#2B8EFF"];
    [promptImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(promptLabel.mas_left).offset(-2);
        make.width.equalTo(@13);
        make.height.equalTo(@7);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    
    
    UILabel *ciyaoLabel = [[UILabel alloc]init];
    [bgView addSubview:ciyaoLabel];
    ciyaoLabel.text = [NSString stringWithFormat:@"%@",@"次要"];
    ciyaoLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    ciyaoLabel.font = [UIFont systemFontOfSize:12];
    ciyaoLabel.numberOfLines =1;
    ciyaoLabel.textAlignment = NSTextAlignmentLeft;
    [ciyaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(promptImage.mas_left).offset(-8);
        make.width.equalTo(@28);
        make.height.equalTo(@17);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    UIImageView *ciyaoImage = [[UIImageView alloc]init];
    [bgView addSubview:ciyaoImage];
    ciyaoImage.backgroundColor = [UIColor colorWithHexString:@"#FDBE12"];
    [ciyaoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ciyaoLabel.mas_left).offset(-2);
        make.width.equalTo(@13);
        make.height.equalTo(@7);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    
    
    UILabel *importantLabel = [[UILabel alloc]init];
    [bgView addSubview:importantLabel];
    importantLabel.text = [NSString stringWithFormat:@"%@",@"重要"];
    importantLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    importantLabel.font = [UIFont systemFontOfSize:12];
    importantLabel.numberOfLines =1;
    importantLabel.textAlignment = NSTextAlignmentLeft;
    [importantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ciyaoImage.mas_left).offset(-8);
        make.width.equalTo(@28);
        make.height.equalTo(@17);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    UIImageView *importantImage = [[UIImageView alloc]init];
    [bgView addSubview:importantImage];
    importantImage.backgroundColor = [UIColor colorWithHexString:@"#FC7D0E"];
    [importantImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(importantLabel.mas_left).offset(-2);
        make.width.equalTo(@13);
        make.height.equalTo(@7);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    
    
    UILabel *jinjiLabel = [[UILabel alloc]init];
    [bgView addSubview:jinjiLabel];
    jinjiLabel.text = [NSString stringWithFormat:@"%@",@"紧急"];
    jinjiLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    jinjiLabel.font = [UIFont systemFontOfSize:12];
    jinjiLabel.numberOfLines =1;
    jinjiLabel.textAlignment = NSTextAlignmentLeft;
    [jinjiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(importantImage.mas_left).offset(-8);
        make.width.equalTo(@28);
        make.height.equalTo(@17);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    UIImageView *jinjiImage = [[UIImageView alloc]init];
    [bgView addSubview:jinjiImage];
    jinjiImage.backgroundColor = [UIColor colorWithHexString:@"#FC1F42"];
    [jinjiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(jinjiLabel.mas_left).offset(-2);
        make.width.equalTo(@13);
        make.height.equalTo(@7);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    
//    UIView *contentView = [UIView]
    
}
@end
