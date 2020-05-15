//
//  KG_LiXingWeiHuCell.m
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_TeShuBaoZhangCell.h"

@implementation KG_TeShuBaoZhangCell

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
    self.rightView = [[UIView alloc]init];
    self.rightView.layer.cornerRadius = 10;
    self.rightView.layer.masksToBounds = YES;
    self.rightView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-16);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    
    self.iconImage = [[UIImageView alloc]init];
    [self.rightView addSubview:self.iconImage];
    self.iconImage.layer.cornerRadius = 3.f;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#95A8D7"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightView.mas_left).offset(16);
        make.top.equalTo(self.rightView.mas_top).offset(19);
        make.width.height.equalTo(@6);
    }];
    
    self.roomLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.roomLabel];
    self.roomLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.roomLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.roomLabel.textAlignment = NSTextAlignmentLeft;
    self.roomLabel.numberOfLines = 1;
    self.roomLabel.text = @"雷达机房";
    [self.roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(8);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.iconImage.mas_centerY);
    }];
    
    
    self.statusLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.statusLabel];
    self.statusLabel.text = @"进行中";
    self.statusLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.statusLabel.textAlignment = NSTextAlignmentLeft;
    self.statusLabel.numberOfLines = 1;
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightView.mas_right).offset(-16);
        make.width.lessThanOrEqualTo(@100);
        make.centerY.equalTo(self.iconImage.mas_centerY);
    }];
    
    
    self.detailLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.detailLabel];
    self.detailLabel.text = @"电池间蓄电池2#设备故障";
    self.detailLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.numberOfLines = 1;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_left);
        make.right.equalTo(self.rightView.mas_right).offset(-20);
        make.top.equalTo(self.iconImage.mas_bottom).offset(12);
        make.height.equalTo(@14);
    }];
    
    self.starImage = [[UIImageView alloc]init];
    [self.rightView addSubview:self.starImage];
    self.starImage.image = [UIImage imageNamed:@"yellow_staricon"];
    [self.starImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_left);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(9.5);
        make.width.height.equalTo(@12);
    }];
    self.starLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.starLabel];
    self.starLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.starLabel.textColor = [UIColor colorWithHexString:@"#FFB428"];
    self.starLabel.textAlignment = NSTextAlignmentLeft;
    self.starLabel.numberOfLines = 1;
    self.starLabel.text = @"20#电池内阻";
    [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starImage.mas_right).offset(6);
        make.right.equalTo(self.rightView.mas_right).offset(-20);
        make.centerY.equalTo(self.starImage.mas_centerY);
        make.height.equalTo(@14);
    }];
    self.timeImage = [[UIImageView alloc]init];
    [self.rightView addSubview:self.timeImage];
    self.timeImage.image = [UIImage imageNamed:@"calendar_icon"];
    [self.timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_left);
        make.bottom.equalTo(self.rightView.mas_bottom).offset(-16);
        make.width.height.equalTo(@12);
    }];
    self.timeLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.timeLabel];
    self.timeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.text = @"2020.01.12 09:00";
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starImage.mas_right).offset(6);
        make.right.equalTo(self.rightView.mas_right).offset(-20);
        make.centerY.equalTo(self.timeImage.mas_centerY);
        make.height.equalTo(@14);
    }];
    self.personLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.personLabel];
    self.personLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.personLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.personLabel.textAlignment = NSTextAlignmentRight;
    self.personLabel.numberOfLines = 1;
    self.personLabel.text = @"执行负责人：王雪";
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.right.equalTo(self.rightView.mas_right).offset(-20);
        make.centerY.equalTo(self.timeImage.mas_centerY);
        make.height.equalTo(@14);
    }];
    
    self.taskButton = [[UIButton alloc]init];
    [self.rightView addSubview:self.taskButton];
    [self.taskButton setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    [self.taskButton setTitle:@"指派任务" forState:UIControlStateNormal];
    [self.taskButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.taskButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [self.taskButton addTarget:self action:@selector(taskButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.taskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightView.mas_right).offset(-16);
        make.centerY.equalTo(self.rightView.mas_centerY);
        make.width.equalTo(@70);
        make.height.equalTo(@24);
    }];
}
- (void)taskButtonMethod:(UIButton *)button {
    if ([button.titleLabel.text isEqualToString:@"指派任务"]) {
        
    }else {
        //领取
        if(self.taskMethod){
            self.taskMethod(self.dataDic);
        }
    }
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.roomLabel.text = safeString(dataDic[@"engineRoomName"]);
    self.statusLabel.text = [self getTaskStatus:safeString(dataDic[@"status"])];
    self.statusLabel.textColor = [self getTaskColor:safeString(dataDic[@"status"])];
    
    self.detailLabel.text = safeString(dataDic[@"taskName"]);
    self.timeLabel.text = [self timestampToTimeStr:safeString(dataDic[@"createTime"])];
    self.personLabel.text = [NSString stringWithFormat:@"执行负责人:%@",safeString(dataDic[@"leaderName"])];
    if([safeString(dataDic[@"status"]) isEqualToString:@"5"]){
        
        [self.taskButton setTitle:@"领取任务" forState:UIControlStateNormal];
        self.taskButton.hidden = NO;
    }else if([safeString(dataDic[@"status"]) isEqualToString:@"6"]){
        
        [self.taskButton setTitle:@"指派任务" forState:UIControlStateNormal];
        self.taskButton.hidden = NO;
    }else {
        self.taskButton.hidden = YES;
    }
    NSArray *biaoqianArr = dataDic[@"atcSpecialTagList"];
    if (biaoqianArr.count) {
        NSMutableString *s = [NSMutableString string];
        for (NSDictionary *dic in biaoqianArr) {
            [s appendString:dic[@"specialTagName"]];
        }
        self.starLabel.text = safeString(s);
        [self.starLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@14);
        }];
        [self.starImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@12);
        }];
    }else {
        [self.starLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.starImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
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


- (UIColor *)getTaskColor :(NSString *)status {
    UIColor *ss = [UIColor colorWithHexString:@"#24252A"];
    if ([status isEqualToString:@"0"]) {
        ss = [UIColor colorWithHexString:@"#24252A"];;
    }else if ([status isEqualToString:@"1"]) {
        ss = [UIColor colorWithHexString:@"#004EC4"];;
    }else if ([status isEqualToString:@"0"]) {
        ss = [UIColor colorWithHexString:@"#03C3B6"];;
    }else if ([status isEqualToString:@"3"]) {
        ss = [UIColor colorWithHexString:@"#FB394C"];;
    }else if ([status isEqualToString:@"4"]) {
        ss = [UIColor colorWithHexString:@"#03C3B6"];;
    }else if ([status isEqualToString:@"5"]) {
        ss = [UIColor colorWithHexString:@"#95A8D7"];;
    }else if ([status isEqualToString:@"6"]) {
        ss = [UIColor colorWithHexString:@"#95A8D7"];;
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
