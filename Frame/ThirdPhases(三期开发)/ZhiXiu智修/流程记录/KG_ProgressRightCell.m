//
//  KG_ProgressRightCell.m
//  Frame
//
//  Created by zhangran on 2020/5/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ProgressRightCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"

#import "FMFontManager.h"
#import "ChangeFontManager.h"
@implementation KG_ProgressRightCell
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
        make.left.equalTo(self.mas_left).offset((SCREEN_WIDTH -19)/2);
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
    
    self.titleLabel = [[UILabel alloc]init];
     [self addSubview:self.titleLabel];
     self.titleLabel.text = @"应急处理 张三";
     self.titleLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
     self.titleLabel.font = [UIFont systemFontOfSize:14];
     self.titleLabel.font = [UIFont my_font:14];
     self.titleLabel.numberOfLines = 2;
     [self.titleLabel sizeToFit];
     self.titleLabel.textAlignment = NSTextAlignmentLeft;
     [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.mas_top);
         make.left.equalTo(self.circleImage.mas_right).offset(6);
         make.height.mas_greaterThanOrEqualTo(@20);
         make.width.equalTo(@150);
     }];
    
  
        
     [self addSubview:self.titleLabel];
    
    
     self.timeLabel = [[UILabel alloc]init];
     [self addSubview:self.timeLabel];
     self.timeLabel.text = @"2020.02.03 19:00:56";
     self.timeLabel.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
     self.timeLabel.font = [UIFont systemFontOfSize:12];
     self.timeLabel.font = [UIFont my_font:12];
     self.timeLabel.numberOfLines = 1;
     self.timeLabel.textAlignment = NSTextAlignmentLeft;
     [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
         make.left.equalTo(self.titleLabel.mas_left);
         make.height.equalTo(@20);
         make.width.equalTo(@150);
     }];
     
     [self addSubview:self.timeLabel];

     
    
}
- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",safeString(dic[@"content"]),safeString(dic[@"userName"])];
    
    self.timeLabel.text = [self timestampToTimeStr:safeString(dic[@"createTime"])];
    
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
