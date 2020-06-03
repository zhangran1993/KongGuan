//
//  KG_StationReportAlarmCell.m
//  Frame
//
//  Created by zhangran on 2020/6/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_StationReportAlarmCell.h"

@interface KG_StationReportAlarmCell (){
    
}
@property (nonatomic,strong) UIImageView *bgImage;

@property (nonatomic,strong) UILabel *titleLabel;
//巡视类型图片
@property (nonatomic,strong) UIImageView *typeImage;
//状态image
@property (nonatomic,strong) UIImageView *statusImage;
//小绿旗image
@property (nonatomic,strong) UIImageView *detailImage;
@property (nonatomic,strong) UILabel *detailLabel;

//timeimage
@property (nonatomic,strong) UIImageView *timeImage;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *personLabel;

@end

@implementation KG_StationReportAlarmCell

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
    
    self.bgImage = [[UIImageView alloc]init];
    [self addSubview:self.bgImage];
    self.bgImage.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.bgImage.layer.cornerRadius = 10;
    self.bgImage.layer.shadowColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:245/255.0 alpha:1.0].CGColor;
    self.bgImage.layer.shadowOffset = CGSizeMake(0,2);
    self.bgImage.layer.shadowOpacity = 1;
    self.bgImage.layer.shadowRadius = 2;
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    self.typeImage  = [[UIImageView alloc]init];
    self.typeImage.image = [UIImage imageNamed:@"类型标签-例行维护"];
    [self addSubview:self.typeImage];
    [self.typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left).offset(15);
        make.top.equalTo(self.bgImage.mas_top).offset(16);
        make.width.equalTo(@63);
        make.height.equalTo(@18);
    }];
    
    
    self.statusImage  = [[UIImageView alloc]init];
    [self.statusImage sizeToFit];
    self.statusImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.statusImage];
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImage.mas_right);
        make.top.equalTo(self.bgImage.mas_top).offset(16);
       
        make.height.equalTo(@22);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.numberOfLines = 1;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left).offset(16);
        make.top.equalTo(self.typeImage.mas_bottom).offset(7);
        make.width.equalTo(@200);
        make.height.equalTo(@22);
    }];
    
    self.detailImage = [[UIImageView alloc]init];
    [self addSubview:self.detailImage];
    [self.detailImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left).offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(11);
        make.width.equalTo(@12);
        make.height.equalTo(@12);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#03C3B6"];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.numberOfLines = 1;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailImage.mas_right).offset(4);
        make.top.equalTo(self.typeImage.mas_bottom).offset(7);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    
    self.timeImage = [[UIImageView alloc]init];
    self.timeImage.image = [UIImage imageNamed:@"station_timeIcon"];
    [self addSubview:self.timeImage];
    [self.timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left).offset(15);
        make.top.equalTo(self.detailImage.mas_bottom).offset(13);
        make.width.equalTo(@12);
        make.height.equalTo(@12);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.numberOfLines = 1;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailImage.mas_right).offset(4);
        make.centerY.equalTo(self.timeImage.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    
    self.personLabel = [[UILabel alloc]init];
    [self addSubview:self.personLabel];
    self.personLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.personLabel.font = [UIFont systemFontOfSize:12];
    self.personLabel.textAlignment = NSTextAlignmentRight;
    self.personLabel.numberOfLines = 1;
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImage.mas_right).offset(-16);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@17);
    }];
    
    
    
    
}
///一键巡视oneTouchTour
////                    例行维护routineMaintenance
////                    特殊保障分为特殊维护specialSafeguard和特殊巡视specialTour
- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    
    if([safeString(dic[@"typeCode"]) isEqualToString:@"oneTouchTour"]){
        
        if ([safeString(dic[@"taskName"]) containsString:@"现场巡视"]) {
            self.typeImage.image = [UIImage imageNamed:@"类型标签-现场巡视"];
        }else {
            self.typeImage.image = [UIImage imageNamed:@"类型标签-一键巡视"];
        }
    }else if([safeString(dic[@"typeCode"]) isEqualToString:@"routineMaintenance"]){
        
        self.typeImage.image = [UIImage imageNamed:@"类型标签-例行维护"];
    }else if([safeString(dic[@"typeCode"]) isEqualToString:@"specialSafeguard"]){
        
        self.typeImage.image = [UIImage imageNamed:@"类型标签-特殊保障"];
    }else if([safeString(dic[@"typeCode"]) isEqualToString:@"specialTour"]){
        
        self.typeImage.image = [UIImage imageNamed:@"类型标签-特殊巡视"];
    }
    
    self.titleLabel.text = safeString(dic[@"taskName"]);
    self.timeLabel.text = [self timestampToTimeStr:safeString(dic[@"createTime"])];
    
    self.personLabel.text = [NSString stringWithFormat:@"执行负责人:%@",safeString(dic[@"leaderName"])];
    
    self.statusImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"状态标签-%@",[self getTaskStatus:safeString(dic[@"status"])]]];
}

- (NSString *)getTaskStatus :(NSString *)status {
    NSString *ss = @"已完成";
    if ([status isEqualToString:@"0"]) {
        ss = @"待执行";
    }else if ([status isEqualToString:@"1"]) {
        ss = @"进行中";
    }else if ([status isEqualToString:@"0"]) {
        ss = @"已完成";
    }else if ([status isEqualToString:@"3"]) {
        ss = @"逾期未完成";
    }else if ([status isEqualToString:@"4"]) {
        ss = @"逾期完成";
    }else if ([status isEqualToString:@"5"]) {
        ss = @"待领取";
    }else if ([status isEqualToString:@"6"]) {
        ss = @"待指派";
    }
    return ss;
    
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
@end
