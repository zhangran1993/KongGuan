//
//  KG_InstrumentationDetailCell.m
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_StationFileDetailFirstCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_StationFileDetailFirstCell (){
    
}

@property (nonatomic ,strong)     UIView          *centerView;

@property (nonatomic ,strong)     UIView          *bgView;

@property (nonatomic,strong)      UIImageView     *iconImage;

@property (nonatomic,strong)      UILabel         *titleLabel;


@property (nonatomic,strong)      UILabel         *nameLabel;//台站简称


@property (nonatomic,strong)      UILabel         *nameTextLabel;//台站简称

@property (nonatomic,strong)      UILabel         *typeLabel;//台站分类

@property (nonatomic,strong)      UILabel         *typeTextLabel;

@property (nonatomic,strong)      UILabel         *statusLabel;//台站状态

@property (nonatomic,strong)      UILabel         *statusTextLabel;

@property (nonatomic,strong)      UILabel         *healthLabel;//健康指数

@property (nonatomic,strong)      UILabel         *healthTextLabel;
 
@property (nonatomic,strong)      UIImageView     *statusImage;

@property (nonatomic,strong)      UILabel         *statusNumLabel;

@end

@implementation KG_StationFileDetailFirstCell

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
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self addSubview:topImage1];
    [topImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(NAVIGATIONBAR_HEIGHT +44));
        make.top.equalTo(self.mas_top);
    }];
    
    
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 208)];
    [self addSubview:topImage];
    topImage.backgroundColor  =[UIColor colorWithHexString:@"#F6F7F9"];
    topImage.image = [UIImage imageNamed:@"kg_shebeilvli_BgImaage"];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(208));
        make.top.equalTo(self.mas_top);
    }];
    self.centerView = [[UIView alloc]init];
    self.centerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top).offset( NAVIGATIONBAR_HEIGHT + 5);
        make.height.equalTo(@165);
    }];
    self.centerView.layer.cornerRadius = 10.f;
    self.centerView.layer.masksToBounds = YES;
    self.centerView.layer.shadowOffset = CGSizeMake(0,2);
    self.centerView.layer.shadowOpacity = 1;
    self.centerView.layer.shadowRadius = 2;
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"无线电综合测试仪";
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont my_font:16];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.top.equalTo(self.centerView.mas_top);
        make.height.equalTo(@48);
    }];
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#F3F7FC"];
    [self.centerView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.width.equalTo(@134);
        make.height.equalTo(@94);
    }];
    self.bgView.layer.cornerRadius = 6.f;
    self.bgView.layer.masksToBounds = YES;
   

    self.iconImage = [[UIImageView alloc]init];
    [self.bgView addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@""];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left);
        make.top.equalTo(self.bgView.mas_top);
        make.right.equalTo(self.bgView.mas_right);
        make.bottom.equalTo(self.bgView.mas_bottom);
    }];
    
    
       self.nameLabel = [[UILabel alloc]init];
       [self.centerView addSubview:self.nameLabel];
       self.nameLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
       self.nameLabel.font = [UIFont systemFontOfSize:14];
       self.nameLabel.textAlignment = NSTextAlignmentLeft;
       self.nameLabel.text = @"台站简称:";
       self.nameLabel.numberOfLines = 1;
       self.nameLabel.font = [UIFont my_font:14];
       [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.bgView.mas_right).offset(8);
           make.width.equalTo(@80);
           make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
           make.height.equalTo(@20);
       }];
       
       self.nameTextLabel = [[UILabel alloc]init];
       [self.centerView addSubview:self.nameTextLabel];
       self.nameTextLabel.textColor = [UIColor colorWithHexString:@"#626470"];
       self.nameTextLabel.font = [UIFont systemFontOfSize:14];
       self.nameTextLabel.font = [UIFont my_font:14];
       self.nameTextLabel.textAlignment = NSTextAlignmentRight;
       self.nameTextLabel.text = @"";
       self.nameTextLabel.numberOfLines = 1;
       [self.nameTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(self.centerView.mas_right).offset(-15);
           make.width.equalTo(@200);
           make.centerY.equalTo(self.nameLabel.mas_centerY);
           make.height.equalTo(@20);
       }];
       
    
    
    
    
    self.typeLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.typeLabel];
    self.typeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.typeLabel.font = [UIFont systemFontOfSize:14];
    self.typeLabel.font = [UIFont my_font:14];
    self.typeLabel.textAlignment = NSTextAlignmentLeft;
    self.typeLabel.text = @"台站分类:";
    self.typeLabel.numberOfLines = 1;
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_right).offset(10);
        make.width.equalTo(@80);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
        make.height.equalTo(@20);
    }];
    
    self.typeTextLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.typeTextLabel];
    self.typeTextLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.typeTextLabel.font = [UIFont systemFontOfSize:14];
    self.typeTextLabel.font = [UIFont my_font:14];
    self.typeTextLabel.textAlignment = NSTextAlignmentRight;
    self.typeTextLabel.text = @"";
    self.typeTextLabel.numberOfLines = 1;
    [self.typeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.typeLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    
    self.statusLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.statusLabel];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.font = [UIFont my_font:14];
    self.statusLabel.textAlignment = NSTextAlignmentLeft;
    self.statusLabel.text = @"台站状态:";
    self.statusLabel.numberOfLines = 1;
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_right).offset(8);
        make.width.equalTo(@80);
        make.top.equalTo(self.typeLabel.mas_bottom).offset(4);
        make.height.equalTo(@20);
    }];
    
    self.statusImage = [[UIImageView alloc]init];
    [self.centerView addSubview:self.statusImage];
    self.statusImage.image = [UIImage imageNamed:@"level_normal"];
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusLabel.mas_centerY);
        make.height.equalTo(@17);
        make.width.equalTo(@32);
        make.right.equalTo(self.centerView.mas_right).offset(-16);
    }];
    self.statusNumLabel = [[UILabel alloc]init];
    [self addSubview:self.statusNumLabel];
    self.statusNumLabel.layer.cornerRadius = 5.f;
    self.statusNumLabel.layer.masksToBounds = YES;
    self.statusNumLabel.text = @"1";
    self.statusNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.statusNumLabel.font = [UIFont systemFontOfSize:10];
    self.statusNumLabel.font = [UIFont my_font:10];
    self.statusNumLabel.numberOfLines = 1;
    
    self.statusNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.statusNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusImage.mas_right).offset(-5);
        make.bottom.equalTo(self.statusImage.mas_top).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    
    self.healthLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.healthLabel];
    self.healthLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.healthLabel.font = [UIFont systemFontOfSize:14];
    self.healthLabel.font = [UIFont my_font:14];
    self.healthLabel.textAlignment = NSTextAlignmentLeft;
    self.healthLabel.text = @"健康指数:";
    self.healthLabel.numberOfLines = 1;
    [self.healthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_right).offset(8);
        make.width.equalTo(@80);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(4);
        make.height.equalTo(@20);
    }];
    
    self.healthTextLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.healthTextLabel];
    self.healthTextLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.healthTextLabel.font = [UIFont systemFontOfSize:14];
    self.healthTextLabel.font = [UIFont my_font:14];
    self.healthTextLabel.textAlignment = NSTextAlignmentRight;
    self.healthTextLabel.text = @"良好";
    self.healthTextLabel.numberOfLines = 1;
    [self.healthTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.width.equalTo(@80);
        make.centerY.equalTo(self.healthLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
  
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleLabel.text = safeString(dataDic[@"name"]);
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,safeString(dataDic[@"picture"])]]];
    
    self.typeTextLabel.text = safeString(dataDic[@"stationName"]);
    
    self.typeTextLabel.text = safeString(dataDic[@"categoryName"]);
    
    self.statusImage.image = [UIImage imageNamed:[self getLevelImage:safeString(_dataDic[@"status"])]];
   
    self.statusNumLabel.text = safeString(_dataDic[@"alarmNum"]);
    self.statusNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",safeString(_dataDic[@"status"])]];
    if([safeString(_dataDic[@"alarmNum"]) floatValue] <=0) {
        self.statusNumLabel.hidden = YES;
    }
    
}

- (void)setDataModel:(KG_EquipmentHistoryModel *)dataModel {
    _dataModel = dataModel;
    
    self.titleLabel.text = safeString(dataModel.name);
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,safeString(dataModel.picture)]]];
    self.nameTextLabel.text = safeString(dataModel.model);
    
    self.typeTextLabel.text = safeString(dataModel.model);
    
    self.healthTextLabel.text = safeString(dataModel.code);
    
//
//    NSString *status = safeString(dataModel.status);
//
//    if ([status isEqualToString:@"depositAndDeposit"]) {
//        self.statusTextLabel.text = @"库存中" ;
//    }else if ([status isEqualToString:@"alreadyOutOfStore"]) {
//        self.statusTextLabel.text = @"已出库" ;
//    }

    
}


- (NSString *)getLevelImage:(NSString *)level {
    NSString *levelString = @"正常";
    
    if ([level isEqualToString:@"正常"]) {
        levelString = @"level_normal";
    }else if ([level isEqualToString:@"提示"]) {
        levelString = @"level_prompt";
    }else if ([level isEqualToString:@"次要"]) {
        levelString = @"level_ciyao";
    }else if ([level isEqualToString:@"重要"]) {
        levelString = @"level_important";
    }else if ([level isEqualToString:@"紧急"]) {
        levelString = @"level_jinji";
    }else if ([level isEqualToString:@"预警"]) {
        levelString = @" level_yujing";
    }
    
    //紧急
    return levelString;
}


- (UIColor *)getTextColor:(NSString *)level {
    UIColor *textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    if ([level isEqualToString:@"正常"]) {
        textColor = [UIColor colorWithHexString:@"FFFFFF"];
    }else if ([level isEqualToString:@"提示"]) {
        textColor = [UIColor colorWithHexString:@"2986F1"];
    }else if ([level isEqualToString:@"次要"]) {
        textColor = [UIColor colorWithHexString:@"FFA800"];
    }else if ([level isEqualToString:@"重要"]) {
        textColor = [UIColor colorWithHexString:@"FC7D0E"];
    }else if ([level isEqualToString:@"紧急"]) {
        textColor = [UIColor colorWithHexString:@"F62546"];
    }
    
    //紧急
    return textColor;
}

- (void)setHealthStr:(NSString *)healthStr {
    _healthStr = healthStr;
    self.healthTextLabel.text = healthStr;
}
@end
