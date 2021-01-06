//
//  KG_RunReportDetailFirstCell.m
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunReportDetailFirstCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_RunReportDetailFirstCell ()

@property (nonatomic,strong) UILabel      *titleLabel ;

@property (nonatomic,strong) UILabel      *detailLabel ;

@property (nonatomic,strong) UIImageView  *iconImage;

@property (nonatomic,strong) UILabel      *statusLabel;

@property (nonatomic,strong) UILabel      *timeLabel;

@end

@implementation KG_RunReportDetailFirstCell

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
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"黄城导航台2020.02.02-2020\n11111";
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(13);
        make.height.equalTo(@48);
    }];
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    self.iconImage.layer.cornerRadius =11.f;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.image = [UIImage imageNamed:@"head_blueIcon"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9);
        make.height.width.equalTo(@22);
    }];
    
    self.statusLabel = [[UILabel alloc]init];
    [self addSubview:self.statusLabel];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.statusLabel.font = [UIFont systemFontOfSize:12];
    self.statusLabel.font = [UIFont my_font:12];
    self.statusLabel.textAlignment = NSTextAlignmentLeft;
    self.statusLabel.text = @"技术主任张树剑";
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.left.equalTo(self.iconImage.mas_right).offset(4);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@24);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.font = [UIFont my_font:12];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.text = @"2020.04.28 17:00:23";
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.right.equalTo(self.mas_right).offset(-16);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@24);
    }];
}

- (void)setModel:(KG_RunReportDeatilModel *)model {
    _model = model;
    
    NSDictionary *dic = model.info;
    
    self.titleLabel.text = safeString(dic[@"title"]);
    
    self.statusLabel.text = [NSString stringWithFormat:@"%@ %@",safeString(dic[@"submitterName"]),safeString(dic[@"postName"])];
    
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
