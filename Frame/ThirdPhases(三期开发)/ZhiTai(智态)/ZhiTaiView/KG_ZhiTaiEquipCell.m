//
//  KG_ZhiTaiEquipCell.m
//  Frame
//
//  Created by zhangran on 2020/4/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ZhiTaiEquipCell.h"

@implementation KG_ZhiTaiEquipCell

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
        self.contentView.backgroundColor = self.backgroundColor;
        
        [self createUI];
    }
    
    return self;
}



- (void)createUI{
    
    
    self.leftLabel = [[UILabel alloc]init];
    [self addSubview:self.leftLabel];
    self.leftLabel.text = @"Thales雷达";
    self.leftLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.leftLabel.font = [UIFont systemFontOfSize:14];
    self.leftLabel.font = [UIFont my_font:14];
    self.leftLabel.numberOfLines = 2;
    [self.leftLabel sizeToFit];
    self.leftLabel.textAlignment = NSTextAlignmentLeft;
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.centerY.equalTo(self.mas_centerY);
        make.width.lessThanOrEqualTo(@110);
       
    }];
    
    
    self.leftImage = [[UIImageView alloc]init];
    self.leftImage.image = [UIImage imageNamed:@"level_prompt"];
    [self addSubview:self.leftImage];
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftLabel.mas_centerY);
        make.left.equalTo(self.leftLabel.mas_right).offset(4);
        make.width.equalTo(@30);
        make.height.equalTo(@17);
    }];
    
    self.leftNumLabel = [[UILabel alloc]init];
    [self addSubview:self.leftNumLabel];
    self.leftNumLabel.layer.cornerRadius = 5.f;
    self.leftNumLabel.layer.masksToBounds = YES;
    self.leftNumLabel.text = @"1";
    self.leftNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.leftNumLabel.font = [UIFont systemFontOfSize:10];
    self.leftNumLabel.numberOfLines = 1;
    
    self.leftNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.leftNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImage.mas_right).offset(-5);
        make.bottom.equalTo(self.leftImage.mas_top).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    
    
    
    self.rightLabel = [[UILabel alloc]init];
    [self addSubview:self.rightLabel];
    self.rightLabel.text = @"Thales雷达";
    self.rightLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    self.rightLabel.font = [UIFont my_font:14];
    self.rightLabel.numberOfLines = 2;
    [self.rightLabel sizeToFit];
    self.rightLabel.textAlignment = NSTextAlignmentLeft;
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImage.mas_right).offset(30);
        make.centerY.equalTo(self.mas_centerY);
        make.width.lessThanOrEqualTo(@110);
       
    }];
    
    
    self.rightImage = [[UIImageView alloc]init];
    self.rightImage.image = [UIImage imageNamed:@"level_prompt"];
    [self addSubview:self.rightImage];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightLabel.mas_centerY);
        make.left.equalTo(self.rightLabel.mas_right).offset(4);
        make.width.equalTo(@30);
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
        make.left.equalTo(self.rightImage.mas_right).offset(-5);
        make.bottom.equalTo(self.rightImage.mas_top).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    self.rightLabel.hidden = YES;
    self.rightImage.hidden = YES;
    self.rightNumLabel.hidden = YES;
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.leftLabel.text = safeString(dataDic[@"name"]);
    
    self.leftImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",dataDic[@"alarmLevel"]]]];
    self.leftNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",dataDic[@"alarmLevel"]]];
    self.leftNumLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"alarmNum"]];
    if([dataDic[@"alarmNum"] intValue] ==0) {
           self.leftNumLabel.hidden = YES;
       }else {
           self.leftNumLabel.hidden = NO;
       }
}
- (void)setDetailDic:(NSDictionary *)detailDic{
    _detailDic = detailDic;
    if (detailDic.count) {
        self.rightLabel.hidden = NO;
        self.rightImage.hidden = NO;
        self.rightNumLabel.hidden = NO;
        
    }else {
        self.rightLabel.hidden = YES;
        self.rightImage.hidden = YES;
        self.rightNumLabel.hidden = YES;
    }
    self.rightLabel.text = safeString(detailDic[@"name"]);
    self.rightImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",detailDic[@"alarmLevel"]]]];
    self.rightNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",detailDic[@"alarmLevel"]]];
    self.rightNumLabel.text = [NSString stringWithFormat:@"%@",detailDic[@"alarmNum"]];
    if([detailDic[@"alarmNum"] intValue] ==0) {
        self.rightNumLabel.hidden = YES;
    }else {
        self.rightNumLabel.hidden = NO;
    }
    
}

- (UIColor *)getTextColor:(NSString *)level {
    UIColor *textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    if ([level isEqualToString:@"0"]) {
        textColor = [UIColor colorWithHexString:@"FFFFFF"];
    }else if ([level isEqualToString:@"4"]) {
        textColor = [UIColor colorWithHexString:@"2986F1"];
    }else if ([level isEqualToString:@"3"]) {
        textColor = [UIColor colorWithHexString:@"FFA800"];
    }else if ([level isEqualToString:@"2"]) {
        textColor = [UIColor colorWithHexString:@"FC7D0E"];
    }else if ([level isEqualToString:@"1"]) {
        textColor = [UIColor colorWithHexString:@"F62546"];
    }
    
    //紧急
    return textColor;
}

- (NSString *)getLevelImage:(NSString *)level {
    NSString *levelString = @"level_normal";
    
    if ([level isEqualToString:@"0"]) {
        levelString = @"level_normal";
    }else if ([level isEqualToString:@"4"]) {
        levelString = @"level_prompt";
    }else if ([level isEqualToString:@"3"]) {
        levelString = @"level_ciyao";
    }else if ([level isEqualToString:@"2"]) {
        levelString = @"level_important";
    }else if ([level isEqualToString:@"1"]) {
        levelString = @"level_jinji";
    }
    
    //紧急
    return levelString;
}
@end
