//
//  KG_ZhiXiuCell.m
//  Frame
//
//  Created by zhangran on 2020/5/14.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ZhiXiuCell.h"
#import "KG_LeftScrollPromptView.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_ZhiXiuCell (){
    
    
}

@property (nonatomic,strong) KG_LeftScrollPromptView  *promptView;

@end

@implementation KG_ZhiXiuCell

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
    
    self.roomLabel = [[UILabel alloc]init];
    [self addSubview:self.roomLabel];
    self.roomLabel.text = @"黄城导航台-电池间";
    self.roomLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.roomLabel.font = [UIFont systemFontOfSize:16];
    self.roomLabel.font = [UIFont my_font:16];
    [self.roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(13);
        make.height.equalTo(@24);
        make.right.equalTo(self.mas_right).offset(-67);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    self.timeLabel.text = @"2019.12.24 06:37";
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.font = [UIFont my_font:12];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.roomLabel.mas_bottom);
        make.height.equalTo(@24);
        make.width.equalTo(@200);
    }];
       
    self.statusImage = [[UIImageView alloc]init];
    [self addSubview:self.statusImage];
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-18);
        make.width.equalTo(@38);
        make.height.equalTo(@20);
        make.top.equalTo(self.mas_top).offset(18);
    }];
    self.statusImage.image = [UIImage imageNamed:@"level_jinji"];
    
    
    self.confirmBtn = [[UIButton alloc]init];
    [self addSubview:self.confirmBtn];
    [self.confirmBtn setTitle:@"未确认" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor colorWithHexString:@"#AABBCD"] forState:UIControlStateNormal];
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.masksToBounds = YES;
    [self.confirmBtn addTarget:self action:@selector(buttonClock:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#F3F5F8"]];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.width.equalTo(@58);
        make.height.equalTo(@28);
        make.bottom.equalTo(self.mas_bottom).offset(-25);
    }];
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@1);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(8);
    }];
    
    self.iconImage = [[UIImageView alloc]init];
    self.iconImage.image = [UIImage imageNamed:@"gaojing_red"];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.top.equalTo(lineView.mas_bottom).offset(12);
    }];
    
    self.powLabel = [[UILabel alloc]init];
    [self addSubview:self.powLabel];
    self.powLabel.text = @"电池组2#";
    self.powLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.powLabel.font = [UIFont systemFontOfSize:14];
    self.powLabel.font = [UIFont my_font:14];
    [self.powLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(14);
        make.top.equalTo(lineView.mas_bottom).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@200);
    }];
    self.gaojingImage.image = [UIImage imageNamed:@"gaojing_red"];
    self.gaojingImage = [[UIImageView alloc]init];
    [self addSubview:self.gaojingImage];
    [self.gaojingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.top.equalTo(self.iconImage.mas_bottom).offset(8);
    }];
    self.gaojingImage.image = [UIImage imageNamed:@"gaojing_red"];
    
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.text = @"电池组2#";
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.font = [UIFont my_font:14];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gaojingImage.mas_right).offset(14);
        make.top.equalTo(self.powLabel.mas_bottom).offset(8);
        make.height.equalTo(@24);
        make.right.equalTo(self.mas_right).offset(-80);
    }];
    
    self.promptView = [[KG_LeftScrollPromptView alloc]init];
    [self addSubview:self.promptView];
    self.promptView.hidden = YES;
    [self.promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}


- (void)setModel:(KG_GaoJingModel *)model {
    _model = model;
    
    self.roomLabel.text = [NSString stringWithFormat:@"%@-%@",safeString(model.stationName),safeString(model.engineRoomName)];
    self.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-蓝",[CommonExtension getDeviceIcon:safeString(model.equipmentCategory)]]];
    
    if([safeString(model.equipmentCategory) isEqualToString:@"navigation"]){
        if ([safeString(model.equipmentName) isEqualToString:@"导航DME"]) {
            self.iconImage.image =  [UIImage imageNamed:@"导航DME"];
        }else if ([safeString(model.equipmentName) isEqualToString:@"导航DVOR"]) {
            self.iconImage.image =  [UIImage imageNamed:@"导航DVOR"];
        }
     }
    
    self.timeLabel.text = [self timestampToTimeStr:safeString(model.happenTime)];
    
    
    self.statusImage.image = [UIImage imageNamed:[self getLevelImage:safeString(model.level)]];
    self.gaojingImage.image = [UIImage imageNamed:[self getGaoJingImage:safeString(model.level)]];
    [self.confirmBtn setTitle:safeString(model.status) forState:UIControlStateNormal];
    
    self.powLabel.text = safeString(model.equipmentName);
    
    self.detailLabel.text = safeString(model.name);
}

- (void)buttonClock:(UIButton *)button {
    
    
}
- (NSString *)getGaoJingImage:(NSString *)level {
    NSString *levelString = @"level_normal";
    
    if ([level isEqualToString:@"正常"]) {
        levelString = @"gaojing_red";
    }else if ([level isEqualToString:@"提示"]) {
        levelString = @"gaojing_prompt";
    }else if ([level isEqualToString:@"次要"]) {
        levelString = @"gaojing_ciyao";
    }else if ([level isEqualToString:@"重要"]) {
        levelString = @"gaojing_important";
    }else if ([level isEqualToString:@"紧急"]) {
        levelString = @"gaojing_red";
    }
    //紧急
    return levelString;
}


//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd HH:mm:ss"] stringFromDate:date];
    //    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd"] stringFromDate:date];
    return timeStr;
    
}
- (NSDateFormatter *)dateFormatWith:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];//@"YYYY-MM-dd HH:mm:ss"
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    return formatter;
}
- (NSString *)getLevelImage:(NSString *)level {
    NSString *levelString = @"level_normal";
    
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

- (void)setShowLeftSrcollView:(NSString *)showLeftSrcollView {
    if ([showLeftSrcollView isEqualToString:@"1"]) {
        self.promptView.hidden = NO;
    }else {
        self.promptView.hidden = YES;
    }
    
}
@end
