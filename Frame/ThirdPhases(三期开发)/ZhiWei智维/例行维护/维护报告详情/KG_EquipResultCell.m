//
//  KG_XunShiResultCell.m
//  Frame
//
//  Created by zhangran on 2020/5/13.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipResultCell.h"


@interface KG_EquipResultCell(){
    
    
}

@property (nonatomic, strong) UIButton * moreBtn;
@property (nonatomic, strong) UIView *moreView;
@end
@implementation KG_EquipResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        
        [self createUI];
    }
    
    return self;
}



- (void)createUI{
    self.moreView = [[UIView alloc]init];
    
    [self addSubview:self.moreView];
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@102);
    }];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.moreView addSubview:headView];
       
    UIImageView *shuImage = [[UIImageView alloc]init];
    [headView addSubview:shuImage];
    shuImage.image = [UIImage imageNamed:@"shu_image"];
    [shuImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@3);
        make.height.equalTo(@15);
        make.left.equalTo(headView.mas_left).offset(16);
        make.centerY.equalTo(headView.mas_centerY);
    }];
    
    UILabel *headTitle = [[UILabel alloc]initWithFrame:CGRectMake(32.5, 0, 200, 44)];
    [headView addSubview:headTitle];
    headTitle.text = @"设备情况";
    headTitle.textAlignment = NSTextAlignmentLeft;
    headTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    headTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    headTitle.numberOfLines = 1;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(16, 43.5, SCREEN_WIDTH - 32, 0.5)];
    lineView.backgroundColor  = [UIColor colorWithHexString:@"#EFF0F7"];
    [headView addSubview:lineView];
   
    self.moreBtn = [[UIButton alloc]init];
    [self.moreView addSubview:self.moreBtn];
    [self.moreBtn addTarget:self action:@selector(moreMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.moreBtn setImage:[UIImage imageNamed:@"blue_jiantou"] forState:UIControlStateNormal];
    [self.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    
    [self.moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0,130, 0, 0)];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.moreView.mas_centerX);
        make.bottom.equalTo(self.moreView.mas_bottom);
        make.width.equalTo(@200);
        make.height.equalTo(@(102 -44));
    }];
    
    
    
}

- (void)moreMethod:(UIButton *)button {
    if (self.moreAction) {
        self.moreAction();
    }
    
}


@end
