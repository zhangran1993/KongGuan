//
//  KG_NiControlCell.m
//  Frame
//
//  Created by zhangran on 2020/4/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NiControlCell.h"

@implementation KG_NiControlCell

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
  
    self.selectImageView = [[UIImageView alloc]init];
    [self addSubview:self.selectImageView];
    self.selectImageView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    self.selectImageView.layer.cornerRadius = 4.f;
    self.selectImageView.layer.masksToBounds = YES;
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.height.equalTo(@8);
        make.top.equalTo(self.mas_top).offset(18);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.text = @"2020.03.02 10:20:42";
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectImageView.mas_right).offset(8);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.selectImageView.mas_centerY);
        make.height.equalTo(@27);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.text = @"张三对1#空调遥控器（OAO-485）进行了：";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectImageView.mas_right).offset(8);
        make.right.equalTo(self.mas_right).offset(-36);
        make.top.equalTo(self.timeLabel.mas_bottom);
        make.height.equalTo(@27);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#FF9E00"];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.text = @"开关设置模式-OFF-操作失败";
    self.detailLabel.numberOfLines = 1;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectImageView.mas_right).offset(8);
        make.right.equalTo(self.mas_right).offset(-36);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.equalTo(@27);
    }];
    
    self.remarkLabel = [[UILabel alloc]init];
    [self addSubview:self.remarkLabel];
    self.remarkLabel.font = [UIFont systemFontOfSize:12];
    self.remarkLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.remarkLabel.textAlignment = NSTextAlignmentLeft;
    self.remarkLabel.text = @"操作备注：我对1#空调遥控器（OAO-485）进行了，我对1# 空调遥控器（OAO-485）进行了关闭操作";
    self.remarkLabel.numberOfLines = 2;
    [self.remarkLabel sizeToFit];
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectImageView.mas_right).offset(8);
        make.right.equalTo(self.mas_right).offset(-36);
        make.top.equalTo(self.detailLabel.mas_bottom);
        
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(32);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.timeLabel.text = [self timestampToTimeStr:safeString(dataDic[@"time"])];
    self.titleLabel.text = [NSString stringWithFormat:@"%@对%@进行了:",safeString(dataDic[@"operatorName"]),safeString(dataDic[@"equipmentName"])];
    self.detailLabel.text = safeString(dataDic[@"content"]);
    if(safeString(dataDic[@"description"]).length == 0){
        self.remarkLabel.text = [NSString stringWithFormat:@"操作备注:%@",@"无"];
        
    }else {
        self.remarkLabel.text = [NSString stringWithFormat:@"操作备注:%@",safeString(dataDic[@"description"])];
        
    }
    
    
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
