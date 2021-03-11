//
//  KG_ZhiTaiBottomCell.m
//  Frame
//
//  Created by zhangran on 2020/4/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ZhiTaiBottomNavigationCell.h"

@interface KG_ZhiTaiBottomNavigationCell (){
    
}


@end

@implementation KG_ZhiTaiBottomNavigationCell

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
  
    self.leftImage = [UIImageView new];
    [self addSubview:self.leftImage];
  
//    self.leftImage.backgroundColor = [UIColor colorWithHexString:@"#95A8D7"];
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.width.height.equalTo(@22);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.leftLabel = [[UILabel alloc]init];
    [self addSubview:self.leftLabel];
    self.leftLabel.font = [UIFont systemFontOfSize:14];
    self.leftLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    self.leftLabel.textAlignment = NSTextAlignmentLeft;
    self.leftLabel.numberOfLines = 1;
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImage.mas_right).offset(12);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.leftImage.mas_centerY);
    }];
    
    self.statusImage = [[UIImageView alloc]init];
    [self addSubview:self.statusImage];
    self.statusImage.image = [UIImage imageNamed:@"level_normal"];
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftImage.mas_centerY);
        make.height.equalTo(@17);
        make.width.equalTo(@32);
        make.right.equalTo(self.mas_right).offset(-16-20);
    }];
    self.statusNumLabel = [[UILabel alloc]init];
    [self addSubview:self.statusNumLabel];
    self.statusNumLabel.layer.cornerRadius = 5.f;
    self.statusNumLabel.layer.masksToBounds = YES;
    self.statusNumLabel.text = @"1";
    self.statusNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.statusNumLabel.font = [UIFont systemFontOfSize:10];
    self.statusNumLabel.numberOfLines = 1;
    
    self.statusNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.statusNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusImage.mas_right).offset(-5);
        make.bottom.equalTo(self.statusImage.mas_top).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    UIImageView *rightImage = [[UIImageView alloc]init];
    rightImage.image = [UIImage imageNamed:@"right_iconImage"];
    [self addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-9);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"F6F7F9"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(70);
        make.right.equalTo(self.mas_right).offset(-32);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;

    self.leftLabel.text = safeString(dataDic[@"name"]);
    
    self.statusImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",dataDic[@"alarmLevel"]]]];
    self.statusNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",dataDic[@"alarmLevel"]]];
    self.statusNumLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"alarmNum"]];
    if([dataDic[@"alarmLevel"] intValue] ==0) {
        self.statusNumLabel.hidden = YES;
    }else {
        self.statusNumLabel.hidden = NO;
    }
    
    if([safeString(dataDic[@"category"]) isEqualToString:@"navigation"]
       ){
        if ([safeString(dataDic[@"name"]) containsString:@"DME"]||
            [safeString(dataDic[@"alias"]) containsString:@"导航-DME"] ||
            [safeString(dataDic[@"machine_name"]) containsString:@"导航DME"] ) {
            self.leftImage.image =  [UIImage imageNamed:@"导航DME"];
        }else if ([safeString(dataDic[@"name"]) containsString:@"DVOR"]||
                  [safeString(dataDic[@"alias"]) containsString:@"导航-DVOR"] ||
                  [safeString(dataDic[@"machine_name"]) containsString:@"导航DVOR"]) {
            self.leftImage.image =  [UIImage imageNamed:@"导航DVOR"];
        }
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
