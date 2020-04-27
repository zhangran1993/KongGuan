//
//  KG_CenterCell.m
//  Frame
//
//  Created by zhangran on 2020/4/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CenterCell.h"

@implementation KG_CenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.redDotImage.layer.cornerRadius = 5.f;
    self.redDotImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_lineImage release];
    [_rightArrowImage release];
    [_levelImagee release];
    [_titleLabel release];
    [_iconImage release];
    [_redDotImage release];
    [super dealloc];
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSString *code = safeString(dataDic[@"name"]);
    self.iconImage.image = [UIImage imageNamed:@"UPS"];
    if([code isEqualToString:@"UPS"]){
        self.iconImage.image = [UIImage imageNamed:@"device_UPS"];
    }else if([code isEqualToString:@"水浸"]){
        self.iconImage.image = [UIImage imageNamed:@"device_shuijin"];
    }else if([code isEqualToString:@"烟感"]){
        self.iconImage.image = [UIImage imageNamed:@"device_yangan"];
    }else if([code isEqualToString:@"空调"]){
        self.iconImage.image = [UIImage imageNamed:@"device_kongtiao"];
    }else if([code isEqualToString:@"蓄电池"]){
        self.iconImage.image = [UIImage imageNamed:@"device_xudianchi"];
    }else if([code isEqualToString:@"柴油发电机"]){
        self.iconImage.image = [UIImage imageNamed:@"device_chaiyou"];
    }else if([code isEqualToString:@"电量仪"]){
        self.iconImage.image = [UIImage imageNamed:@"device_dianliangyi"];
    }else if([code isEqualToString:@"空开"]){
        self.iconImage.image = [UIImage imageNamed:@"device_kongtiao"];
    }else if([code isEqualToString:@"电子围栏"]){
        self.iconImage.image = [UIImage imageNamed:@"device_zhalan"];
    }else if([code isEqualToString:@"门禁"]){
        self.iconImage.image = [UIImage imageNamed:@"device_menjin"];
    }else if([code isEqualToString:@"视频监测"]){
        self.iconImage.image = [UIImage imageNamed:@"device_video"];
    }else if([code isEqualToString:@"温湿度"]){
        self.iconImage.image = [UIImage imageNamed:@"device_wenshidu"];
    }else {
        self.iconImage.image = [UIImage imageNamed:@"device_UPS"];
    }
    
    if (isSafeDictionary(dataDic)) {
        if([dataDic[@"status"] isEqualToString:@"0"]){
            self.levelImagee.image = [UIImage imageNamed:@"level_normal"];
        }else if([dataDic[@"status"] isEqualToString:@"3"]){
            self.levelImagee.image = [UIImage imageNamed:@"level_normal"];
        }else if([dataDic[@"status"] isEqualToString:@"1"]){
            self.levelImagee.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",dataDic[@"level"]]]];
            self.redDotImage.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",dataDic[@"level"]]];
            self.redDotImage.text = [NSString stringWithFormat:@"%@",dataDic[@"num"]];
            
        }else{
            self.levelImagee.image = [UIImage imageNamed:@"level_normal"];
        }
        if ([dataDic[@"num"] intValue] == 0) {
            self.redDotImage.hidden = YES;
        }else {
            self.redDotImage.hidden =NO;
        }
    }
    self.titleLabel.text = safeString(dataDic[@"name"]);
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

- (NSString *)changeIconImage:(NSString *)icon {
    NSString *iconImage = @"level_normal";
    return iconImage;
}
@end
