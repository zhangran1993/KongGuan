//
//  KG_EquipmentHistoryCell.m
//  Frame
//
//  Created by zhangran on 2020/9/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipmentHistoryCell.h"

@interface KG_EquipmentHistoryCell () {
    
}

@property (nonatomic ,strong)  UILabel         *titleLabel;

@property (nonatomic ,strong)  UILabel         *firstLabel;
@property (nonatomic ,strong)  UILabel         *firstTextLabel;

@property (nonatomic ,strong)  UILabel         *secondLabel;
@property (nonatomic ,strong)  UILabel         *secondTextLabel;

@property (nonatomic ,strong)  UILabel         *thirdLabel;
@property (nonatomic ,strong)  UIImageView     *thirdImageView;
@property (nonatomic ,strong)  UILabel         *rightNumLabel;
@property (nonatomic ,strong)  UIImageView     *iconImage;

@end

@implementation KG_EquipmentHistoryCell

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
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(17);
        make.width.equalTo(@148);
        make.height.equalTo(@105);
    }];
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.iconImage.mas_top).offset(3);
        make.height.equalTo(@20);
    }];
    
    
    self.firstLabel = [[UILabel alloc]init];
    [self addSubview:self.firstLabel];
    self.firstLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.firstLabel.font = [UIFont systemFontOfSize:14];
    self.firstLabel.textAlignment = NSTextAlignmentLeft;
    self.firstLabel.text = @"";
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.width.equalTo(@100);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.height.equalTo(@20);
    }];
    
    self.firstTextLabel = [[UILabel alloc]init];
    [self addSubview:self.firstTextLabel];
    self.firstTextLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.firstTextLabel.font = [UIFont systemFontOfSize:14];
    self.firstTextLabel.textAlignment = NSTextAlignmentRight;
    self.firstTextLabel.text = @"";
    [self.firstTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(@120);
        make.centerY.equalTo(self.firstLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    
    
    self.secondLabel = [[UILabel alloc]init];
    [self addSubview:self.secondLabel];
    self.secondLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.secondLabel.font =  [UIFont systemFontOfSize:14];
    self.secondLabel.textAlignment = NSTextAlignmentLeft;
    self.secondLabel.text = @"";
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.width.equalTo(@100);
        make.top.equalTo(self.firstLabel.mas_bottom).offset(8);
        make.height.equalTo(@20);
    }];
    
    self.secondTextLabel = [[UILabel alloc]init];
    [self addSubview:self.secondTextLabel];
    self.secondTextLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.secondTextLabel.font =  [UIFont systemFontOfSize:14];
    self.secondTextLabel.textAlignment = NSTextAlignmentRight;
    self.secondTextLabel.text = @"";
    [self.secondTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(@120);
        make.centerY.equalTo(self.secondLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    self.thirdLabel = [[UILabel alloc]init];
    [self addSubview:self.thirdLabel];
    self.thirdLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.thirdLabel.font =  [UIFont systemFontOfSize:14];
    self.thirdLabel.textAlignment = NSTextAlignmentLeft;
    self.thirdLabel.text = @"";
    [self.thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.width.equalTo(@100);
        make.top.equalTo(self.secondLabel.mas_bottom).offset(8);
        make.height.equalTo(@20);
    }];
    
    self.thirdImageView = [[UIImageView alloc]init];
    [self addSubview:self.thirdImageView];
    [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.equalTo(@32);
        make.centerY.equalTo(self.thirdLabel.mas_centerY);
        make.height.equalTo(@17);
    }];
    
    self.rightNumLabel = [[UILabel alloc]init];
    [self addSubview:self.rightNumLabel];
    self.rightNumLabel.layer.cornerRadius = 5.f;
    self.rightNumLabel.layer.masksToBounds = YES;
    self.rightNumLabel.text = @"1";
    self.rightNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.rightNumLabel.font = [UIFont systemFontOfSize:10];
    self.rightNumLabel.numberOfLines = 1;
    
    self.rightNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.rightNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thirdImageView.mas_right).offset(-5);
        make.bottom.equalTo(self.thirdImageView.mas_top).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic =dataDic;
    
    if ([self.selType isEqualToString:@"equipFile"]) {
        
        
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,_dataDic[@"picture"]]]  ];
        
        self.titleLabel.text = safeString(dataDic[@"name"]);
        
        self.firstTextLabel.text = safeString(dataDic[@"stationName"]);
        self.firstLabel.text = @"所属台站：";
        self.secondTextLabel.text = safeString(dataDic[@"type"]);
        self.secondLabel.text = @"设备类型：";
        self.thirdImageView.image = [UIImage imageNamed:[self getLevelImage:safeString(_dataDic[@"alarmStatus"])]];
        self.thirdLabel.text = @"设备状态：";
        self.rightNumLabel.text = safeString(_dataDic[@"alarmNum"]);
        self.rightNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",safeString(_dataDic[@"status"])]];
        if([safeString(_dataDic[@"alarmNum"]) floatValue] <=0) {
            self.rightNumLabel.hidden = YES;
        }
        
    }else {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,_dataDic[@"picture"]]]  ];
        
        self.titleLabel.text = safeString(dataDic[@"name"]);
        
        self.firstTextLabel.text = safeString(dataDic[@"alias"]);
        self.firstLabel.text = @"台站简称：";
        self.secondTextLabel.text = safeString(dataDic[@"categoryName"]);
        self.secondLabel.text = @"台站分类：";
        self.thirdImageView.image = [UIImage imageNamed:[self getLevelImage:safeString(_dataDic[@"status"])]];
        self.thirdLabel.text = @"台站状态：";
        self.rightNumLabel.text = safeString(_dataDic[@"alarmNum"]);
        
        
        
    }
    
   
    
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
    }
    
    //紧急
    return levelString;
}

- (void)setSelType:(NSString *)selType {
    _selType = selType;
    
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
@end
