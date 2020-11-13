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

@property (nonatomic,strong) UIView *statusView;

@property (nonatomic,strong) UIButton *taskButton;

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
        make.top.equalTo(self.bgImage.mas_top).offset(14);
       
        make.height.equalTo(@26);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left).offset(16);
        make.top.equalTo(self.typeImage.mas_bottom).offset(7);
        make.right.equalTo(self.bgImage.mas_right).offset(-60);
       
    }];
    
  
    self.statusView = [[UIView alloc]init];
    [self addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left).offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(11);
        make.right.equalTo(self.bgImage.mas_right).offset(-15);
        make.height.equalTo(@12);
    }];
    
    
    
    
    self.timeImage = [[UIImageView alloc]init];
    self.timeImage.image = [UIImage imageNamed:@"station_timeIcon"];
    [self addSubview:self.timeImage];
    [self.timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left).offset(15);
        make.bottom.equalTo(self.mas_bottom).offset(-14);
        make.width.equalTo(@12);
        make.height.equalTo(@12);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.numberOfLines = 1;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeImage.mas_right).offset(4);
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
    
    self.taskButton = [[UIButton alloc]init];
    [self addSubview:self.taskButton];
    [self.taskButton setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    [self.taskButton setTitle:@"指派任务" forState:UIControlStateNormal];
    [self.taskButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.taskButton.layer.cornerRadius = 4.f;
    self.taskButton.layer.masksToBounds = YES;
    self.taskButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [self.taskButton addTarget:self action:@selector(taskButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.taskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImage.mas_right).offset(-16);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.width.equalTo(@70);
        make.height.equalTo(@24);
    }];
    
    
}

- (void)taskButtonMethod:(UIButton *)btn {
    if (self.getTask) {
        self.getTask(self.dic);
    }
    
}
///一键巡视oneTouchTour
////                    例行维护routineMaintenance
////                    特殊保障分为特殊维护specialSafeguard和特殊巡视specialTour
- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    self.timeLabel.text = [self timestampToTimeStr:safeString(dic[@"planStartTime"])];
    if([safeString(dic[@"typeCode"]) isEqualToString:@"oneTouchTour"]){
        
        if ([safeString(dic[@"taskName"]) containsString:@"现场巡视"]) {
            self.typeImage.image = [UIImage imageNamed:@"类型标签-现场巡视"];
        }else {
            self.typeImage.image = [UIImage imageNamed:@"类型标签-一键巡视"];
        }
        self.timeLabel.text = [self timestampToTimeStr:safeString(dic[@"patrolIntervalTime"])];
    }else if([safeString(dic[@"typeCode"]) isEqualToString:@"routineMaintenance"]){
        
        self.typeImage.image = [UIImage imageNamed:@"类型标签-例行维护"];
        self.timeLabel.text = [self timestampToTimeStr:safeString(dic[@"planStartTime"])];
    }else if([safeString(dic[@"typeCode"]) isEqualToString:@"specialSafeguard"]){
        
        self.typeImage.image = [UIImage imageNamed:@"类型标签-特殊保障"];
        self.timeLabel.text = [self timestampToTimeStr:safeString(dic[@"planStartTime"])];
    }else if([safeString(dic[@"typeCode"]) isEqualToString:@"specialTour"]){
        
        self.typeImage.image = [UIImage imageNamed:@"类型标签-特殊巡视"];
        self.timeLabel.text = [self timestampToTimeStr:safeString(dic[@"planStartTime"])];
    }
    
    self.titleLabel.text = safeString(dic[@"taskName"]);
    
    
    self.personLabel.text = [NSString stringWithFormat:@"执行负责人:%@",safeString(dic[@"leaderName"])];
    
    self.statusImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"状态标签-%@",[self getTaskStatus:safeString(dic[@"status"])]]];
    NSArray *biaoqianArr = dic[@"atcPatrolRoomList"];
    if (biaoqianArr.count  &&[safeString(dic[@"patrolCode"]) isEqualToString:@"fieldInspection"]) {
        self.statusView.hidden = NO;
        
       [self createSignView:biaoqianArr];
    }else {
//        self.statusView.hidden = YES;
    }
    
    if ([safeString(dic[@"status"]) isEqualToString:@"5"]) {
        self.taskButton.hidden = NO;
        self.personLabel.hidden = YES;
        [self.taskButton setTitle:@"领取任务" forState:UIControlStateNormal];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"role"]){
            NSArray *arr = [userDefaults objectForKey:@"role"];
            if (arr.count) {
                for (NSString *str in arr) {
                    if ([safeString(str) isEqualToString:@"领导"]) {
                        [self.taskButton setTitle:@"指派任务" forState:UIControlStateNormal];
                        NSLog(@"是个领导");
                        break;
                    }
                }
            }
        }
    }else if ([safeString(dic[@"status"]) isEqualToString:@"6"]) {
        self.taskButton.hidden = NO;
        self.personLabel.hidden = YES;
        [self.taskButton setTitle:@"指派任务" forState:UIControlStateNormal];
    }else {
        self.taskButton.hidden = YES;
        self.personLabel.hidden = NO;
    }


}

- (void)createSignView :(NSArray *)array{
    [self.statusView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat witdth = 0;
    CGFloat orX = 0;
    for (int i =0; i<array.count; i++) {
        CGRect fontRect = [safeString(array[i][@"engineRoomName"]) boundingRectWithSize:CGSizeMake(MAXFLOAT,12) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
        
       
        witdth = fontRect.size.width ;
        UIImageView *detailImage = [[UIImageView alloc]initWithFrame:CGRectMake(orX, 0, 12, 12)];
        if ([safeString(array[i][@"fingerPrintStatus"]) isEqualToString:@"0"])  {
            detailImage.image = [UIImage imageNamed:@"gray_qizi"];
        }else if ([safeString(array[i][@"fingerPrintStatus"]) isEqualToString:@"1"])  {
            detailImage.image = [UIImage imageNamed:@"lv_qizi"];
        }else {
            detailImage.image = [UIImage imageNamed:@"red_qizi"];
        }
        [self.statusView addSubview:detailImage];
        
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(12 +orX, 0,witdth, 12)];
        detailLabel.text = safeString(array[i][@"engineRoomName"]);
        [self.statusView addSubview:detailLabel];
        if ([safeString(array[i][@"fingerPrintStatus"]) isEqualToString:@"0"])  {
            detailLabel.textColor = [UIColor colorWithHexString:@"#D0CFCF"];
        }else if ([safeString(array[i][@"fingerPrintStatus"]) isEqualToString:@"1"])  {
            detailLabel.textColor = [UIColor colorWithHexString:@"#03C3B6"];
        }else {
            detailLabel.textColor = [UIColor colorWithHexString:@"#FB3957"];
        }
        detailLabel.font = [UIFont systemFontOfSize:12];
        detailLabel.numberOfLines = 1;
        orX += fontRect.size.width+12 ;
    }
    
   
   
    
 
   
}

- (NSString *)getTaskStatus :(NSString *)status {
    NSString *ss = @"已完成";
    if ([status isEqualToString:@"0"]) {
        ss = @"待执行";
    }else if ([status isEqualToString:@"1"]) {
        ss = @"进行中";
    }else if ([status isEqualToString:@"2"]) {
        ss = @"已完成";
    }else if ([status isEqualToString:@"3"]) {
        ss = @"逾期未完成";
    }else if ([status isEqualToString:@"4"]) {
        ss = @"逾期完成";
    }else if ([status isEqualToString:@"5"]) {
        ss = @"待领取";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"role"]){
            NSArray *arr = [userDefaults objectForKey:@"role"];
            if (arr.count) {
                for (NSString *str in arr) {
                    if ([safeString(str) isEqualToString:@"领导"]) {
                        ss = @"待领取";
                        NSLog(@"是个领导");
                        break;
                    }
                }
            }
        }
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
    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd HH:mm"] stringFromDate:date];
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
