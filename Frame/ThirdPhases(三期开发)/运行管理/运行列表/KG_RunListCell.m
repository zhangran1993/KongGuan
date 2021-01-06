//
//  KG_RunReportCell.m
//  Frame
//
//  Created by zhangran on 2020/5/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunListCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_RunListCell (){
    
    
}

@property (nonatomic,strong) UILabel *titleLabel ;

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *statusLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation KG_RunListCell

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
    bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    bgView.layer.cornerRadius = 5.f;
    bgView.layer.masksToBounds = YES;
    
    
    self.titleLabel = [[UILabel alloc]init];
    [bgView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"黄城导航台2020.02.02-2020";
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(16);
        make.right.equalTo(bgView.mas_right).offset(-16);
        make.top.equalTo(bgView.mas_top).offset(13);
        
    }];
    self.iconImage = [[UIImageView alloc]init];
    [bgView addSubview:self.iconImage];
    self.iconImage.layer.cornerRadius =11.f;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.image = [UIImage imageNamed:@"head_blueIcon"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.height.width.equalTo(@22);
    }];
       
       
    self.statusLabel = [[UILabel alloc]init];
    [bgView addSubview:self.statusLabel];
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
    [bgView addSubview:self.timeLabel];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.font = [UIFont my_font:12];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.text = @"2020.04.28 17:00:23";
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.right.equalTo(bgView.mas_right).offset(-16);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@24);
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleLabel.text = safeString(dataDic[@"title"]);
    
    self.statusLabel.text = [NSString stringWithFormat:@"%@ %@",safeString(dataDic[@"submitterName"]),safeString(dataDic[@"postName"])];
    
    self.timeLabel.text = [self timestampToTimeStr:safeString(dataDic[@"createTime"])];
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
