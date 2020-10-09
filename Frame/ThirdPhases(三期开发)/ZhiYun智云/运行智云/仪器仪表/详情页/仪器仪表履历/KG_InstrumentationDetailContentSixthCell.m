//
//  KG_ProgressLeftCell.m
//  Frame
//
//  Created by zhangran on 2020/5/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_InstrumentationDetailContentSixthCell.h"


@implementation KG_InstrumentationDetailContentSixthCell
//
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
    
    
    self.circleImage = [[UIImageView alloc]init];
    self.circleImage.image = [UIImage imageNamed:@"proCircleImage"];
    [self addSubview:self.circleImage];
    [self.circleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(150);
        make.width.equalTo(@19);
        make.height.equalTo(@19);
        make.top.equalTo(self.mas_top);
    }];
    
    self.lineImage = [[UIImageView alloc]init];
    [self addSubview:self.lineImage];
    self.lineImage.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [self.lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleImage.mas_centerX);
        make.width.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.circleImage.mas_bottom);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    self.timeLabel.text = @"2020.02.03 19:00:56";
    self.timeLabel.textColor = [UIColor colorWithHexString:@"24252A"];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.numberOfLines = 3;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.circleImage.mas_centerY);
        make.right.equalTo(self.circleImage.mas_left).offset(-9);
        make.height.mas_greaterThanOrEqualTo(@27);
        make.left.equalTo(self.mas_left).offset(16);
    }];
    
  
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"应急处理 张三";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.left.equalTo(self.circleImage.mas_right).offset(12);
        make.height.mas_greaterThanOrEqualTo(@27);
        make.width.equalTo(@250);
    }];
    
    
   self.personLabel = [[UILabel alloc]init];
   [self addSubview:self.personLabel];
   self.personLabel.text = @"应急处理 张三";
   self.personLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
   self.personLabel.font = [UIFont systemFontOfSize:12];
   self.personLabel.numberOfLines = 1;
   [self.personLabel sizeToFit];
   self.personLabel.textAlignment = NSTextAlignmentLeft;
   [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.timeLabel.mas_bottom);
       make.left.equalTo(self.titleLabel.mas_left);
       make.height.mas_greaterThanOrEqualTo(@27);
       make.width.equalTo(@250);
   }];
    
    
    self.contentLabel = [[UILabel alloc]init];
    [self addSubview:self.contentLabel];
    self.contentLabel.text = @"应急处理 张三";
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.numberOfLines = 2;
    [self.contentLabel sizeToFit];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.personLabel.mas_bottom);
        make.left.equalTo(self.titleLabel.mas_left);
        make.height.mas_greaterThanOrEqualTo(@27);
        make.width.equalTo(@250);
    }];
  
    
}

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",safeString(dic[@"name"])];
    
    self.timeLabel.text = [self timestampToTimeStr:safeString(dic[@"createTime"])];
    if (safeString(dic[@"createTime"]).length ==0) {
        self.timeLabel.text = @"";
    }
    self.personLabel.text = [NSString stringWithFormat:@"负责人:%@",safeString(dic[@"person"])];
    
    self.contentLabel.text = [NSString stringWithFormat:@"内容:%@",safeString(dic[@"content"])];
    
    
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
@end
