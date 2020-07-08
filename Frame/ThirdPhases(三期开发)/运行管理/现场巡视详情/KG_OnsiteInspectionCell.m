//
//  KG_OnsiteInspectionCell.m
//  Frame
//
//  Created by zhangran on 2020/6/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_OnsiteInspectionCell.h"

@interface KG_OnsiteInspectionCell (){
    
}

@property (nonatomic,strong) UILabel *titleLabel ;

@property (nonatomic,strong) UILabel *detailLabel ;

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *statusLabel;

@property (nonatomic,strong) UILabel *timeLabel;
@end
@implementation KG_OnsiteInspectionCell

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
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.layer.cornerRadius = 6;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(3);
        make.bottom.equalTo(self.mas_bottom).offset(-3);
    }];
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
   
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right);
        make.top.equalTo(bgView.mas_top).offset(2);
        
        make.height.equalTo(@26);
    }];
    
    
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        make.right.equalTo(self.iconImage.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(7);
        make.height.equalTo(@20);
    }];
    
    
   
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.text = @"2020.04.28 17:00:23";
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(11);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        make.height.equalTo(@17);
    }];
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

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    self.titleLabel.text =safeString(dic[@"engineRoomName"]);
    self.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"状态标签-%@",[self getTaskStatus:safeString(dic[@"fingerPrintStatus"])]]];

    self.timeLabel.text = [NSString stringWithFormat:@"打卡时间:%@", [self timestampToTimeStr:safeString(dic[@"punchTime"])]];
    if (safeString(dic[@"punchTime"]).length == 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"打卡时间:-"];
    }
}


- (NSString *)getTaskStatus :(NSString *)status {
    NSString *ss = @"已完成";
    if ([status isEqualToString:@"0"]) {
        ss = @"待执行";
    }else if ([status isEqualToString:@"1"]) {
        ss = @"已完成";
    }else if ([status isEqualToString:@"2"]) {
        ss = @"逾期未完成";
    }else if ([status isEqualToString:@"3"]) {
        ss = @"逾期完成";
    }
    return ss;
    
}

@end
