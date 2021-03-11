//
//  KG_RunMangerFifthCell.m
//  Frame
//
//  Created by zhangran on 2020/6/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunMangerFifthCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_RunMangerFifthCell (){
    
}
@property (nonatomic, strong)  UIView    *zhihuiyunView;

@end

@implementation KG_RunMangerFifthCell

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
    [self setUpzhihuiyunView];
}
//智慧云view
- (void)setUpzhihuiyunView {
    
    self.zhihuiyunView =  [[UIView alloc]init];
    [self addSubview:self.zhihuiyunView];
    //    zhihuiyun_gotoImage
    [self.zhihuiyunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top).offset(1);
        make.height.equalTo(@94);
    }];
    
    UIImageView *bgImage = [[UIImageView alloc]init];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.zhihuiyunView addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zhihuiyunView.mas_left);
        make.right.equalTo(self.zhihuiyunView.mas_right);
        make.top.equalTo(self.zhihuiyunView.mas_top);
        make.bottom.equalTo(self.zhihuiyunView.mas_bottom);
    }];
    bgImage.image = [UIImage imageNamed:@"zhihuiyun_bgImage"];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.zhihuiyunView addSubview:titleLabel];
    titleLabel.text = @"智慧云";
    titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightHeavy];
    titleLabel.font = [UIFont my_font:20];
    titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImage.mas_left).offset(24);
        make.top.equalTo(bgImage.mas_top).offset(19);
        make.width.equalTo(@100);
        make.height.equalTo(@28);
    }];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    [self.zhihuiyunView addSubview:detailLabel];
    detailLabel.text = @"零备件/技术资料/巡视维护记录";
    detailLabel.font = [UIFont systemFontOfSize:14];
    detailLabel.font = [UIFont my_font:14];
    detailLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImage.mas_left).offset(24);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.width.equalTo(@250);
        make.height.equalTo(@28);
    }];
    
    UIButton *goToZhiYunBtn = [[UIButton alloc]init];
    [self.zhihuiyunView addSubview:goToZhiYunBtn];
    [goToZhiYunBtn setImage:[UIImage imageNamed:@"zhihuiyun_gotoImage"] forState:UIControlStateNormal];
    [goToZhiYunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.zhihuiyunView.mas_right).offset(-15);
        make.width.height.equalTo(@64);
        make.centerY.equalTo(self.zhihuiyunView.mas_centerY);
    }];
    [goToZhiYunBtn addTarget:self action:@selector(goToZhiHuiYunMethod) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)goToZhiHuiYunMethod {
    if(self.gotuYunBlockMethod){
        self.gotuYunBlockMethod();
    }
}


@end
