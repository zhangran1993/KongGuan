//
//  KG_GetLogCell.m
//  Frame
//
//  Created by zhangran on 2020/6/15.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_GetLogCell.h"

@interface KG_GetLogCell (){
    
}
@property (nonatomic,strong) UIImageView *iconImage;


@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *timeLabel;
@end

@implementation KG_GetLogCell

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
        self.contentView.backgroundColor = self.backgroundColor;
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@"kg_logIcon"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@16);
        make.left.equalTo(self.mas_left).offset(14);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"张建杰创建了任务";
    self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.titleLabel.numberOfLines = 1;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(8.5);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@24);
    }];
    
  
    
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    self.timeLabel.text = @"2019.07.10 09:00";
    [self.timeLabel sizeToFit];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.timeLabel.numberOfLines = 1;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-16);
        
        make.height.equalTo(@20);
    }];
    
}

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@",safeString(dic[@"operatorName"]),safeString(dic[@"content"])];
    
    self.timeLabel.text = [self timestampToTimeStr:safeString(dic[@"lastUpdateTime"])];
    
    
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
