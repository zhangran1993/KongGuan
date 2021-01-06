//
//  KG_RunReportDetailJiaoJieBanCell.m
//  Frame
//
//  Created by zhangran on 2020/6/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunReportDetailJiaoJieBanCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_RunReportDetailJiaoJieBanCell (){
    
}

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *leftTitle;
@property (nonatomic,strong) UILabel *leftTime;

@property (nonatomic,strong) UILabel *rightTitle;
@property (nonatomic,strong) UILabel *rightTime;
@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) UIView *rightView;
@end

@implementation KG_RunReportDetailJiaoJieBanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    
    self.titleLabel.text = [NSString stringWithFormat:@"交接班岗位:%@",[CommonExtension getWorkType:safeString(dic[@"post"])]];
    self.leftTitle.text = safeString(dic[@"handoverName"]);
    
    self.rightTitle.text = safeString(dic[@"successorName"]);
    
    self.leftTime.text = [self timestampToTimeStr:safeString(dic[@"handoverTime"])];
    
    self.rightTime.text = [self timestampToTimeStr:safeString(dic[@"acceptTime"])];
    
   
    if (safeString(dic[@"handoverName"]).length == 0) {
        self.leftView.hidden = YES;
    }
    
    if (safeString(dic[@"successorName"]).length == 0) {
        self.rightView.hidden = YES;
    }
    
    
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
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(7);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    
    UIImageView *centerImage = [[UIImageView alloc]init];
    [self addSubview:centerImage];
    centerImage.image = [UIImage imageNamed:@"jiaojiebanjiantou"];
    
    
    self.leftView = [[UIView alloc]init];
    [self addSubview:self.leftView];
    int viewWidth =( SCREEN_WIDTH -32 -38 )/2;
    self.leftView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.equalTo(@(viewWidth));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
        make.height.equalTo(@40);
    }];
    self.leftView.layer.cornerRadius = 4;
    self.leftView.layer.masksToBounds = YES;
    UIImageView *leftIcon = [[UIImageView alloc]init];
    [self.leftView addSubview:leftIcon];
    leftIcon.image = [UIImage imageNamed:@"head_blueIcon"];
    leftIcon.layer.cornerRadius =11.f;
    leftIcon.layer.masksToBounds = YES;
    [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.left.equalTo(self.leftView.mas_left).offset(12);
        make.centerY.equalTo(self.leftView.mas_centerY);
    }];
    self.leftTitle = [[UILabel alloc]init];
    [self.leftView addSubview:self.leftTitle];
    self.leftTitle.text = @"张树剑告";
    self.leftTitle.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.leftTitle.font = [UIFont systemFontOfSize:12];
    self.leftTitle.font = [UIFont my_font:12];
    [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIcon.mas_right).offset(9);
        make.top.equalTo(self.leftView.mas_top).offset(5);
        make.right.equalTo(self.leftView.mas_right);
        make.height.equalTo(@17);
    }];
    self.leftTime = [[UILabel alloc]init];
    [self.leftView addSubview:self.leftTime];
    self.leftTime.text = @"2020.05.07 08:00:23";
    self.leftTime.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.leftTime.font = [UIFont systemFontOfSize:10];
    self.leftTime.font = [UIFont my_font:10];
    [self.leftTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIcon.mas_right).offset(9);
        make.top.equalTo(self.leftTitle.mas_bottom);
        make.right.equalTo(self.leftView.mas_right);
        make.height.equalTo(@14);
    }];
    
    
    self.rightView = [[UIView alloc]init];
    [self addSubview:self.rightView];
    self.rightView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.width.equalTo(@(viewWidth));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
        make.height.equalTo(@40);
    }];
    
    self.rightView.layer.cornerRadius = 4;
    self.rightView.layer.masksToBounds = YES;
    UIImageView *rightIcon = [[UIImageView alloc]init];
    [self.rightView addSubview:rightIcon];
    rightIcon.image = [UIImage imageNamed:@"head_blueIcon"];
    rightIcon.layer.cornerRadius =11.f;
    rightIcon.layer.masksToBounds = YES;
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.left.equalTo(self.rightView.mas_left).offset(12);
        make.centerY.equalTo(self.rightView.mas_centerY);
    }];
    self.rightTitle = [[UILabel alloc]init];
    [self.rightView addSubview:self.rightTitle];
    self.rightTitle.text = @"张树剑告";
    self.rightTitle.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.rightTitle.font = [UIFont systemFontOfSize:12];
    self.rightTitle.font = [UIFont my_font:12];
    [self.rightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightIcon.mas_right).offset(9);
        make.top.equalTo(self.rightView.mas_top).offset(5);
        make.right.equalTo(self.rightView.mas_right);
        make.height.equalTo(@17);
    }];
    self.rightTime = [[UILabel alloc]init];
    [self.rightView addSubview:self.rightTime];
    self.rightTime.text = @"2020.05.07 08:00:23";
    self.rightTime.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.rightTime.font = [UIFont systemFontOfSize:10];
    self.rightTime.font = [UIFont my_font:10];
    [self.rightTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightIcon.mas_right).offset(9);
        make.top.equalTo(self.rightTitle.mas_bottom);
        make.right.equalTo(self.rightView.mas_right);
        make.height.equalTo(@14);
    }];
    
    [centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@14);
        make.centerY.equalTo(self.leftView.mas_centerY);
        make.left.equalTo(self.leftView.mas_right).offset(11);
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
@end
