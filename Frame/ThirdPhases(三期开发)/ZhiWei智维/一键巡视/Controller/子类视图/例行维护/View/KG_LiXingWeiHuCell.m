//
//  KG_LiXingWeiHuCell.m
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_LiXingWeiHuCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_LiXingWeiHuCell(){
    
}

@property (nonatomic,strong) UIView *statusView;
@end

@implementation KG_LiXingWeiHuCell

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
    self.roomLabel.font = [UIFont systemFontOfSize:12];
    self.roomLabel.font = [UIFont my_Pingfont:12];
    self.roomLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.roomLabel.textAlignment = NSTextAlignmentLeft;
    self.roomLabel.numberOfLines = 2;
    self.roomLabel.text = @"雷达机房";
    [self.roomLabel sizeToFit];
    [self.roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(8);
        make.right.equalTo(self.rightView.mas_right).offset(-60);
        make.centerY.equalTo(self.iconImage.mas_centerY);
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
       
    
    self.statusLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.statusLabel];
    self.statusLabel.text = @"";
    self.statusLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.statusLabel.font = [UIFont my_Pingfont:12];
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
    self.detailLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.detailLabel.font = [UIFont my_Pingfont:16];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.numberOfLines = 2;
    [self.detailLabel sizeToFit];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_left);
        make.right.equalTo(self.rightView.mas_right).offset(-20);
        make.top.equalTo(self.roomLabel.mas_bottom).offset(12);
        
    }];
    
//    self.starImage = [[UIImageView alloc]init];
//    [self.rightView addSubview:self.starImage];
//    self.starImage.image = [UIImage imageNamed:@"yellow_staricon"];
//    [self.starImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconImage.mas_left);
//        make.top.equalTo(self.detailLabel.mas_bottom).offset(9.5);
//        make.width.height.equalTo(@12);
//    }];
//    self.starLabel = [[UILabel alloc]init];
//    [self.rightView addSubview:self.starLabel];
//    self.starLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
//    self.starLabel.textColor = [UIColor colorWithHexString:@"#FFB428"];
//    self.starLabel.textAlignment = NSTextAlignmentLeft;
//    self.starLabel.numberOfLines = 1;
//    self.starLabel.text = @"20#电池内阻";
//    [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.starImage.mas_right).offset(6);
//        make.right.equalTo(self.rightView.mas_right).offset(-20);
//        make.centerY.equalTo(self.starImage.mas_centerY);
//        make.height.equalTo(@14);
//    }];
    
    self.statusView = [[UIView alloc]init];
    [self addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightView.mas_left).offset(15);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(11);
        make.right.equalTo(self.rightView.mas_right).offset(-86);
        make.height.equalTo(@12);
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
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.font = [UIFont my_Pingfont:12];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.text = @"2020.01.12 09:00";
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeImage.mas_right).offset(6);
        make.right.equalTo(self.rightView.mas_right).offset(-86);
        make.centerY.equalTo(self.timeImage.mas_centerY);
        make.height.equalTo(@14);
    }];
    self.personLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.personLabel];
    self.personLabel.font = [UIFont systemFontOfSize:12];
    self.personLabel.font = [UIFont my_Pingfont:12];
    self.personLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.personLabel.textAlignment = NSTextAlignmentRight;
    self.personLabel.numberOfLines = 2;
    [self.personLabel sizeToFit];
    self.personLabel.text = @"执行负责人：王雪";
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.right.equalTo(self.rightView.mas_right).offset(-20);
        make.centerY.equalTo(self.timeImage.mas_centerY);
        
    }];
    
//    UIButton *taskBgBtn =[[UIButton alloc]init];
//    [self.rightView addSubview:taskBgBtn];
//    [taskBgBtn setTitle:@"" forState:UIControlStateNormal];
//    [taskBgBtn addTarget:self action:@selector(taskButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [taskBgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.rightView.mas_right);
//        make.bottom.equalTo(self.rightView.mas_bottom);
//        make.width.equalTo(@120);
//        make.height.equalTo(@100);
//    }];
    
    
    self.taskButton = [[UIButton alloc]init];
    [self.rightView addSubview:self.taskButton];
    [self.taskButton setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    [self.taskButton setTitle:@"指派任务" forState:UIControlStateNormal];
    [self.taskButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.taskButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.taskButton.layer.cornerRadius = 4.f;
    self.taskButton.layer.masksToBounds = YES;
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
    self.statusLabel.textColor = [self getTaskColor:safeString(dataDic[@"status"])];
    self.statusImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"状态标签-%@",[self getTaskStatus:safeString(dataDic[@"status"])]]];
    self.detailLabel.text = safeString(dataDic[@"taskName"]);
    
    if ([safeString(dataDic[@"patrolCode"]) isEqualToString:@"weekSafeguard"]
        ||[safeString(dataDic[@"patrolCode"]) isEqualToString:@"daySafeguard"]
        ||[safeString(dataDic[@"patrolCode"]) isEqualToString:@"monthSafeguard"]) {
        self.timeLabel.text = [self timestampToTimeStr:safeString(dataDic[@"planStartTime"])];
    }else if ([safeString(dataDic[@"patrolCode"]) isEqualToString:@"yearSafeguard"] ||
              [safeString(dataDic[@"patrolCode"]) isEqualToString:@"quarterSafeguard"]){
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[self timestampToTimeStr:safeString(dataDic[@"planStartTime"])],[self timestampToTimeStr:safeString(dataDic[@"planFinishTime"])]];
    }else {
        self.timeLabel.text = [self timestampToTimeStr:safeString(dataDic[@"planStartTime"])];
    }
    
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
    self.statusView.hidden = YES;
    NSArray *biaoqianArr = self.dataDic[@"atcPatrolRoomList"];
    if (biaoqianArr.count &&[safeString(self.dataDic[@"patrolCode"]) isEqualToString:@"fieldInspection"]) {
        self.statusView.hidden = NO;
        
        [self createSignView:biaoqianArr];
    }else {
        //        self.statusView.hidden = YES;
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
    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd"] stringFromDate:date];
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



@end
