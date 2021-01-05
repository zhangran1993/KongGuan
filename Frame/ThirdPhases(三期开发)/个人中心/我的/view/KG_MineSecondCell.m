//
//  KG_MineSecondCell.m
//  Frame
//
//  Created by zhangran on 2020/12/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_MineSecondCell.h"

@interface  KG_MineSecondCell () {
    
    
}


@end

@implementation KG_MineSecondCell

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

    UIView *shuView = [[UIView alloc]init];
    [self addSubview:shuView];
    shuView.layer.cornerRadius = 2.f;
    shuView.layer.masksToBounds = YES;
    shuView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.equalTo(@4);
        make.height.equalTo(@14);
        make.top.equalTo(self.mas_top).offset(17);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.text = @"数据中心";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font =[UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.font =[UIFont my_font:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuView.mas_right).offset(8);
        make.centerY.equalTo(shuView.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@22);
    }];
    
    UIButton *rightButton = [[UIButton alloc]init];
    [self addSubview:rightButton];
    [rightButton setImage:[UIImage imageNamed:@"center_rightImage"] forState:UIControlStateNormal];\
    [rightButton addTarget:self action:@selector(buttonCLicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.right.equalTo(self.mas_right).offset(-11);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    UIButton *guzhangBtn = [[UIButton alloc]init];
    [self addSubview:guzhangBtn];
    [guzhangBtn setImage:[UIImage imageNamed:@"guzhang_tongji"] forState:UIControlStateNormal];
    [guzhangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(38);
        make.top.equalTo(self.mas_top).offset(51);
        make.width.height.equalTo(@60);
    }];
    
    [guzhangBtn addTarget:self action:@selector(buttonCLicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *guzhangLabel = [[UILabel alloc]init];
    [self addSubview:guzhangLabel];
    guzhangLabel.text = @"故障统计";
    guzhangLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    guzhangLabel.numberOfLines = 1;
    guzhangLabel.textAlignment = NSTextAlignmentCenter;
    guzhangLabel.font = [UIFont systemFontOfSize:14];
    guzhangLabel.font =[UIFont my_font:14];
    [guzhangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(guzhangBtn.mas_centerX);
        make.top.equalTo(guzhangBtn.mas_bottom).offset(4);
        make.height.equalTo(@22);
        make.width.equalTo(@80);
    }];
    
    UIButton *beijianBtn = [[UIButton alloc]init];
    [self addSubview:beijianBtn];
    [beijianBtn setImage:[UIImage imageNamed:@"beijian_tongji"] forState:UIControlStateNormal];
    [beijianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(51);
        make.width.height.equalTo(@60);
    }];
    [beijianBtn addTarget:self action:@selector(buttonCLicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *beijianLabel = [[UILabel alloc]init];
    [self addSubview:beijianLabel];
    beijianLabel.text = @"备件统计";
    beijianLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    beijianLabel.numberOfLines = 1;
    beijianLabel.textAlignment = NSTextAlignmentCenter;
    beijianLabel.font = [UIFont systemFontOfSize:14];
    beijianLabel.font =[UIFont my_font:14];
    [beijianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(beijianBtn.mas_centerX);
        make.top.equalTo(beijianBtn.mas_bottom).offset(4);
        make.height.equalTo(@22);
        make.width.equalTo(@80);
    }];
    
    UIButton *levelBtn = [[UIButton alloc]init];
    [self addSubview:levelBtn];
    [levelBtn setImage:[UIImage imageNamed:@"level_tongji"] forState:UIControlStateNormal];
    [levelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-40);
        make.top.equalTo(self.mas_top).offset(51);
        make.width.height.equalTo(@60);
    }];
    [levelBtn addTarget:self action:@selector(buttonCLicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *levelLabel = [[UILabel alloc]init];
    [self addSubview:levelLabel];
    levelLabel.text = @"等级统计";
    levelLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    levelLabel.numberOfLines = 1;
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.font = [UIFont systemFontOfSize:14];
    levelLabel.font =[UIFont my_font:14];
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(levelBtn.mas_centerX);
        make.top.equalTo(levelBtn.mas_bottom).offset(4);
        make.height.equalTo(@22);
        make.width.equalTo(@80);
    }];
    
}

- (void)buttonCLicked :(UIButton *)btn {
    
    if (self.pushToDataManager) {
        self.pushToDataManager();
    }
}
@end
