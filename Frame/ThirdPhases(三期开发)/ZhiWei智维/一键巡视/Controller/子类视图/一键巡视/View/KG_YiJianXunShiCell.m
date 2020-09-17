//
//  KG_YiJianXunShiCell.m
//  Frame
//
//  Created by zhangran on 2020/4/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_YiJianXunShiCell.h"

@interface KG_YiJianXunShiCell(){
    
}

@property (nonatomic,strong) UIView     *statusView;

@property (nonatomic,strong) UIView     *specialView;

@property (nonatomic,strong) UILabel    *specialLabel;
@end
@implementation KG_YiJianXunShiCell

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
    
    self.leftView = [[UIView alloc]init];
    [self addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@52);
        make.bottom.equalTo(self.mas_bottom);
    }];
    

    
    
    
    self.leftTimeLabel = [[UILabel alloc]init];
    [self.leftView addSubview:self.leftTimeLabel];
    self.leftTimeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.leftTimeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.leftTimeLabel.textAlignment = NSTextAlignmentRight;
    self.leftTimeLabel.numberOfLines = 1;
    self.leftTimeLabel.text = @"07:00";
    [self.leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@45);
        make.right.equalTo(self.leftView.mas_right).offset(-5.5);
        make.top.equalTo(self.leftView.mas_top).offset(40);
        make.height.equalTo(@10);
    }];
    
    
    self.leftIcon = [[UIImageView alloc]init];
    [self.leftView addSubview:self.leftIcon];
    self.leftIcon.image = [UIImage imageNamed:@"time_greenIcon"];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftView.mas_right).offset(-14.5);
        make.top.equalTo(self.leftTimeLabel.mas_bottom).offset(4.5);
        make.width.equalTo(@12);
        make.height.equalTo(@12);
    }];
    
    self.topLine = [[UIImageView alloc]init];
    [self.leftView addSubview:self.topLine];
    self.topLine.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftIcon.mas_centerX);
        make.top.equalTo(self.leftView.mas_top);
        make.width.equalTo(@1);
        make.bottom.equalTo(self.leftTimeLabel.mas_top).offset(-5);
    }];
    
   
    self.bottomLine = [[UIImageView alloc]init];
    [self.leftView addSubview:self.bottomLine];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftIcon.mas_centerX);
        make.top.equalTo(self.leftIcon.mas_bottom).offset(5);
        make.width.equalTo(@1);
        make.bottom.equalTo(self.leftView.mas_bottom);
    }];
    
    self.centerLine = [[UIImageView alloc]init];
    self.centerLine.hidden = YES;
    [self.leftView addSubview:self.centerLine];
    self.centerLine.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftIcon.mas_centerX);
        make.top.equalTo(self.topLine.mas_bottom);
        make.width.equalTo(@1);
        make.bottom.equalTo(self.bottomLine.mas_top);
    }];

    
    self.rightView = [[UIView alloc]init];
    self.rightView.layer.cornerRadius = 10;
    self.rightView.layer.masksToBounds = YES;
    self.rightView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right);
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
    
   
    
    
    self.statusImage  = [[UIImageView alloc]init];
    [self.statusImage sizeToFit];
    self.statusImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.statusImage];
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightView.mas_right);
        make.top.equalTo(self.rightView.mas_top).offset(14);
        
        make.height.equalTo(@26);
    }];
    
    self.roomLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.roomLabel];
    self.roomLabel.font = [UIFont systemFontOfSize:12];
    self.roomLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.roomLabel.textAlignment = NSTextAlignmentLeft;
    self.roomLabel.numberOfLines = 2;
    self.roomLabel.text = @"雷达机房";
    [self.roomLabel sizeToFit];
    [self.roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(8);
        make.right.equalTo(self.rightView.mas_right).offset(-90);
        make.centerY.equalTo(self.iconImage.mas_centerY);
    }];
    
    self.statusLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.statusLabel];
    self.statusLabel.text = @"";
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
    self.detailLabel.numberOfLines = 2;
    [self.detailLabel sizeToFit];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_left);
        make.right.equalTo(self.rightView.mas_right).offset(-20);
        make.top.equalTo(self.roomLabel.mas_bottom).offset(12);
        
    }];
    
    
    self.statusView = [[UIView alloc]init];
    [self addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightView.mas_left).offset(15);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(11);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.height.equalTo(@12);
    }];
    
    
    self.specialView = [[UIView alloc]init];
    [self addSubview:self.specialView];
    self.specialView.hidden = YES;
    [self.specialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightView.mas_left).offset(15);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(11);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.height.equalTo(@12);
    }];
    
//    UIImageView *specialImage = [[UIImageView alloc]init];
//    [self.specialView addSubview:specialImage];
//    specialImage.image = [UIImage imageNamed:@"yellow_staricon"];
//    [specialImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.specialView.mas_left).offset(16);
//        make.centerY.equalTo(self.specialView.mas_centerY);
//        make.width.equalTo(@12);
//        make.height.equalTo(@12);
//    }];
//
//
//    self.specialLabel = [[UILabel alloc]init];
//    [self.specialView addSubview:self.specialLabel];
//    self.specialLabel.textColor = [UIColor colorWithHexString:@"#FFB428"];
//    self.specialLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
//    self.specialLabel.numberOfLines = 1;
//    [self.specialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(specialImage.mas_right).offset(6.5);
//        make.centerY.equalTo(self.specialView.mas_centerY);
//        make.width.equalTo(@200);
//        make.height.equalTo(self.specialView.mas_height);
//    }];
    
    
    
 
    self.timeImage = [[UIImageView alloc]init];
    self.timeImage.image = [UIImage imageNamed:@"station_timeIcon"];
    [self addSubview:self.timeImage];
    [self.timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightView.mas_left).offset(15);
        make.bottom.equalTo(self.mas_bottom).offset(-16);
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
        make.right.equalTo(self.rightView.mas_right).offset(-16);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@17);
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
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.width.equalTo(@70);
        make.height.equalTo(@24);
    }];
}

- (void)taskButtonMethod:(UIButton *)button {
    
    if ([button.titleLabel.text isEqualToString:@"指派任务"]) {
        //领取任务
        if(self.taskMethod){
            self.taskMethod(self.dataDic);
        }
    }else {
        //领取任务
        //领取任务
        if(self.taskMethod){
            self.taskMethod(self.dataDic);
        }
    }
}
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.roomLabel.text = safeString(dataDic[@"engineRoomName"]);
    self.statusLabel.text = @"";
    self.statusImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"状态标签-%@",[self getTaskStatus:safeString(dataDic[@"status"])]]]; 
    self.statusLabel.textColor = [self getTaskColor:safeString(dataDic[@"status"])];
    
    self.detailLabel.text = safeString(dataDic[@"taskName"]);
    self.timeLabel.text = [self timestampToTimeStr:safeString(dataDic[@"patrolIntervalTime"])];
    self.personLabel.text = [NSString stringWithFormat:@"执行负责人:%@",safeString(dataDic[@"leaderName"])];
    if([safeString(dataDic[@"status"]) isEqualToString:@"5"]){
        
        [self.taskButton setTitle:@"领取任务" forState:UIControlStateNormal];
        self.taskButton.hidden = NO;
        self.personLabel.hidden = YES;
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
    }else if([safeString(dataDic[@"status"]) isEqualToString:@"6"]){
        
        [self.taskButton setTitle:@"指派任务" forState:UIControlStateNormal];
        self.taskButton.hidden = NO;
        self.personLabel.hidden = YES;
    }else {
        self.taskButton.hidden = YES;
        self.personLabel.hidden = NO;
    }
 
    
    NSArray *biaoqianArr = self.dataDic[@"atcPatrolRoomList"];
    if (biaoqianArr.count &&[safeString(self.dataDic[@"patrolCode"]) isEqualToString:@"fieldInspection"]) {
        self.statusView.hidden = NO;
        
        [self createSignView:biaoqianArr];
    }else {
        self.specialView.hidden = NO;
        NSArray *specArr = self.dataDic[@"atcSpecialTagList"];
        if (specArr.count ) {
            
            [self createSpecialView:specArr];
        }
            
        
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
                        ss = @"待指派";
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

- (void)createSpecialView :(NSArray *)array{
    [self.specialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat witdth = 0;
    CGFloat orX = 0;
    for (int i =0; i<array.count; i++) {
        CGRect fontRect = [safeString(array[i][@"specialTagName"]) boundingRectWithSize:CGSizeMake(MAXFLOAT,12) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
        
       
        witdth = fontRect.size.width ;
        UIImageView *detailImage = [[UIImageView alloc]initWithFrame:CGRectMake(orX, 0, 12, 12)];
      
        detailImage.image = [UIImage imageNamed:@"yellow_staricon"];
      
        [self.specialView addSubview:detailImage];
        
       
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(12 +orX, 0,witdth, 12)];
        detailLabel.textColor = [UIColor colorWithHexString:@"#FFB428"];
        detailLabel.text = safeString(array[i][@"specialTagName"]);
        [self.specialView addSubview:detailLabel];

        detailLabel.font = [UIFont systemFontOfSize:12];
        detailLabel.numberOfLines = 1;
        orX += fontRect.size.width+12 ;
    }
    
   
   
}
@end
