//
//  KG_XunShiLogCell.m
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiLogCell.h"

@implementation KG_XunShiLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    //    @property (nonatomic, strong) UIImageView *headImage;
    //
    //    @property (nonatomic, strong) UILabel *nameTitle;
    //    @property (nonatomic, strong) UILabel *detailTitle;
    //    @property (nonatomic, strong) UILabel *timeLabel;
    
    
    self.headImage = [[UIImageView alloc]init];
    [self addSubview:self.headImage];
   
    self.headImage.image = [UIImage imageNamed:@""];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(16);
        make.width.height.equalTo(@48);
    }];
    
  
   
    
    self.nameTitle = [[UILabel alloc]init];
    [self addSubview:self.nameTitle];
    self.nameTitle.text = @"李建";
    self.nameTitle.textColor = [UIColor colorWithHexString:@"#626470"];
    self.nameTitle.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.nameTitle.numberOfLines = 1;
    self.nameTitle.textAlignment = NSTextAlignmentLeft;
    [self.nameTitle  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(21.5);
        make.left.equalTo(self.headImage.mas_right).offset(12);
        make.height.equalTo(@13);
        make.width.equalTo(@120);
    }];
    
    self.detailTitle = [[UILabel alloc]init];
    [self addSubview:self.detailTitle];
    self.detailTitle.text = @"注意重拉相关进程后的各项";
    self.detailTitle.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.detailTitle.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.detailTitle.numberOfLines = 1;
    self.detailTitle.textAlignment = NSTextAlignmentLeft;
    [self.detailTitle  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTitle.mas_bottom).offset(8.5);
        make.left.equalTo(self.headImage.mas_right).offset(12);
        make.height.equalTo(@13.5);
        make.width.equalTo(@180);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    self.timeLabel.text = @"注意重拉相关进程后的各项";
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.timeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.timeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameTitle.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@9.5);
        make.width.equalTo(@180);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)setDic:(NSDictionary *)dic {
    _dic =dic;
    self.timeLabel.text = [self timestampToTimeStr:safeString(dic[@"createTime"])];
    
    self.nameTitle.text = safeString(dic[@"operatorName"]);
    self.detailTitle.text= safeString(dic[@"content"]);
    [self.headImage sd_setImageWithURL:@"" placeholderImage:[UIImage imageNamed:@"head_blueIcon"]];
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
