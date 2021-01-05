//
//  KG_MineFirstCell.m
//  Frame
//
//  Created by zhangran on 2020/12/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_MineFirstCell.h"

@interface KG_MineFirstCell () {
    
    
}

@property (nonatomic, strong)   UIImageView       *bgImage;

@property (nonatomic, strong)   UIImageView       *iconImage;

@property (nonatomic, strong)   UIButton          *rightButton;

@property (nonatomic, strong)   UILabel           *titleLabel;

@property (nonatomic, strong)   UILabel           *detailLabel;

@property (nonatomic, strong)   UILabel           *positionLabel;

@property (nonatomic, strong)   UIView            *circleView;

@property (nonatomic, strong)   UIView            *bgView;

@property (nonatomic, strong)   UIView            *shuView;
 
@property (nonatomic, strong)   UIButton          *staRightBtn;

@end


@implementation KG_MineFirstCell

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
    
    self.bgImage = [[UIImageView alloc]init];
    [self addSubview:self.bgImage];
    self.bgImage.image = [UIImage imageNamed:@"center_bg_image"];
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@180);
    }];
    
    

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSArray * positions = [userDefaults objectForKey:@"role"];
    NSString *position = @"";
    if(![positions  isEqual: @[]] ){
        position = positions[0];
        for (int i = 1; i < positions.count; i++) {
            position = [NSString stringWithFormat:@"%@、%@",position,positions[i]];
        }
        //position = [userDefaults objectForKey:@"role"][0];
    }
    
    
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(self.mas_top).offset(66);
        make.height.width.equalTo(@74);
    }];
    
    self.iconImage.layer.cornerRadius = 74/2;
    self.iconImage.layer.masksToBounds = YES;
    
    
    if([userDefaults objectForKey:@"icon"]){
        NSString *iconString = [userDefaults objectForKey:@"icon"];
      
        
        
        if([iconString isEqualToString:@"head_blueIcon"]) {
            self.iconImage.image = [UIImage imageNamed:@"head_icon"];
        }else {
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString: [WebNewHost stringByAppendingString:[userDefaults objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"head_icon"]];
        }
    }else {
        
        self.iconImage.image = [UIImage imageNamed:@"head_icon"];
    }
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    self.titleLabel.font =[UIFont my_font:20 ];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(16);
        make.top.equalTo(self.iconImage.mas_top).offset(6);
        make.height.equalTo(@28);
        make.width.equalTo(@120);
    }];
    
    self.titleLabel.text = name;
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.font = [UIFont my_font:14];
    [self.detailLabel sizeToFit];

    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.lessThanOrEqualTo(@(SCREEN_WIDTH - 108-29));
//        make.right.equalTo(self.mas_right).offset(-29);
    }];
    
 
    self.detailLabel.text = position;
    
    
    
    self.positionLabel = [[UILabel alloc]init];
    [self addSubview:self.positionLabel];
    self.positionLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.positionLabel.textAlignment = NSTextAlignmentLeft;
    self.positionLabel.font = [UIFont systemFontOfSize:14];
    self.positionLabel.font =[UIFont my_font:14];
    [self.positionLabel sizeToFit];
    
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(16);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.lessThanOrEqualTo(@(SCREEN_WIDTH - 108-29));
        //        make.right.equalTo(self.mas_right).offset(-29);
    }];
    self.positionLabel.text = position;
    
    
    
    
    
    
    self.staRightBtn = [[UIButton alloc]init];
    [self addSubview:self.staRightBtn];
    [self.staRightBtn setImage:[UIImage imageNamed:@"center_rightImage"] forState:UIControlStateNormal];
    [self.staRightBtn addTarget:self action:@selector(stationClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.staRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailLabel.mas_right).offset(5);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.detailLabel.mas_centerY);
    }];
    
    self.circleView = [[UIView alloc]init];
    [self addSubview:self.circleView];
    self.circleView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.circleView.layer.cornerRadius = 10;
    self.circleView.layer.masksToBounds = YES;
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImage.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@30);
    }];
    
    
    UIView *shuView = [[UIView alloc]init];
    [self addSubview:shuView];
    shuView.layer.cornerRadius = 2.f;
    shuView.layer.masksToBounds = YES;
    shuView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.equalTo(@4);
        make.height.equalTo(@14);
        make.top.equalTo(self.bgImage.mas_bottom).offset(3);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.text = @"消息中心";
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
    
    UIButton *bgBtn = [[UIButton alloc]init];
    [self addSubview:bgBtn];
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.bgImage.mas_bottom).offset(-10);
    }];
    [bgBtn addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [[UIButton alloc]init];
    [self addSubview:rightButton];
    [rightButton setImage:[UIImage imageNamed:@"center_rightImage"] forState:UIControlStateNormal];\
    [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.right.equalTo(self.mas_right).offset(-11);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    
    UIButton *guzhangBtn = [[UIButton alloc]init];
    [self addSubview:guzhangBtn];
    [guzhangBtn setImage:[UIImage imageNamed:@"center_yujing_image"] forState:UIControlStateNormal];
    [guzhangBtn addTarget:self action:@selector(yujingButtonCLicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [guzhangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(38);
        make.top.equalTo(self.bgImage.mas_bottom).offset(51+3-10);
        make.width.height.equalTo(@60);
    }];
    
    UILabel *guzhangLabel = [[UILabel alloc]init];
    [self addSubview:guzhangLabel];
    guzhangLabel.text = @"预警消息";
    guzhangLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    guzhangLabel.numberOfLines = 1;
    guzhangLabel.textAlignment = NSTextAlignmentCenter;
    guzhangLabel.font = [UIFont systemFontOfSize:14];
    guzhangLabel.font = [UIFont my_font:14];
    [guzhangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(guzhangBtn.mas_centerX);
        make.top.equalTo(guzhangBtn.mas_bottom).offset(4);
        make.height.equalTo(@22);
        make.width.equalTo(@80);
    }];
    
    UIButton *beijianBtn = [[UIButton alloc]init];
    [self addSubview:beijianBtn];
    [beijianBtn setImage:[UIImage imageNamed:@"center_gaojing_image"] forState:UIControlStateNormal];
    [beijianBtn addTarget:self action:@selector(gaojingButtonCLicked:) forControlEvents:UIControlEventTouchUpInside];
    [beijianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.bgImage.mas_bottom).offset(51+3-10);
        make.width.height.equalTo(@60);
    }];
    
    UILabel *beijianLabel = [[UILabel alloc]init];
    [self addSubview:beijianLabel];
    beijianLabel.text = @"告警消息";
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
    [levelBtn addTarget:self action:@selector(gonggaoButtonCLicked:) forControlEvents:UIControlEventTouchUpInside];
    [levelBtn setImage:[UIImage imageNamed:@"center_gonggao_image"] forState:UIControlStateNormal];
    [levelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-40);
        make.top.equalTo(self.bgImage.mas_bottom).offset(51+3-10);
        make.width.height.equalTo(@60);
    }];
    
    UILabel *levelLabel = [[UILabel alloc]init];
    [self addSubview:levelLabel];
    levelLabel.text = @"公告消息";
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

- (void)rightButtonClicked :(UIButton *)btn {
    
    if (self.pushToNextStep) {
        self.pushToNextStep(@"消息中心");
    }
}

//所属台站点击
- (void)stationClickMethod:(UIButton *)button {
    
    if(self.pushToPesonalMessPage){
        self.pushToPesonalMessPage();
    }
    
    
}

//公告点击
- (void)gonggaoButtonCLicked:(UIButton *)button {
    
    
    if (self.pushToNextStep) {
           self.pushToNextStep(@"公告消息");
       }
}

//告警消息点击
- (void)gaojingButtonCLicked:(UIButton *)button {
    
    if (self.pushToNextStep) {
           self.pushToNextStep(@"告警消息");
       }
    
}

//预警消息点击
- (void)yujingButtonCLicked:(UIButton *)button {
    
    if (self.pushToNextStep) {
           self.pushToNextStep(@"预警消息");
       }
    
}

- (void)setStaStr:(NSString *)staStr {
    _staStr = staStr;
    self.detailLabel.text = safeString(staStr);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"icon"]){
        //            NSString *iconString = [userDefaults objectForKey:@"icon"];
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString: [WebNewHost stringByAppendingString:[userDefaults objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"head_icon"]];
    }else {
        
        self.iconImage.image = [UIImage imageNamed:@"head_icon"];
    }
    
}
@end
