//
//  KG_BeiJianLvLiCell.m
//  Frame
//
//  Created by zhangran on 2020/8/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianLvLiCell.h"

@interface KG_BeiJianLvLiCell (){
    
}

@property (nonatomic,strong) UILabel        *leftTitleLabel;

@property (nonatomic,strong) UILabel        *rightTitleLabel;

@property (nonatomic,strong) UILabel        *rightDetailLabel;

@property (nonatomic,strong) UIImageView    *iconImage;

@property (nonatomic,strong) UIView         *lineView;

@end

@implementation KG_BeiJianLvLiCell

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
   
    self.leftTitleLabel = [[UILabel alloc]init];
    self.leftTitleLabel.text = @"";
    [self addSubview:self.leftTitleLabel];
    
    self.leftTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.leftTitleLabel.textAlignment = NSTextAlignmentRight;
    self.leftTitleLabel.numberOfLines = 1;
    self.leftTitleLabel.font = [UIFont systemFontOfSize:14];
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@27);
        make.left.equalTo(self.mas_left).offset(16);
        make.width.equalTo(@120);
    }];
    
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@"proCircleImage"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@17);
        make.centerY.equalTo(self.leftTitleLabel.mas_centerY);
        make.left.equalTo(self.leftTitleLabel.mas_right).offset(6);
        
    }];
    self.line = [[UIView alloc]init];
    [self addSubview:self.line];
    self.line.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImage.mas_centerX);
        make.width.equalTo(@1);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.iconImage.mas_top);
    }];
    
    
    self.rightTitleLabel = [[UILabel alloc]init];
    self.rightTitleLabel.text = @"";
    self.rightTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.rightTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.rightTitleLabel.numberOfLines = 1;
    self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.rightTitleLabel];
    [self.rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@27);
        make.left.equalTo(self.iconImage.mas_right).offset(12);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    
    self.rightDetailLabel = [[UILabel alloc]init];
    self.rightDetailLabel.text = @"";
    self.rightDetailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.rightDetailLabel.textAlignment = NSTextAlignmentLeft;
    self.rightDetailLabel.numberOfLines = 0;
    self.rightDetailLabel.font = [UIFont systemFontOfSize:14];
    [self.rightDetailLabel sizeToFit];
    [self addSubview:self.rightDetailLabel];
    [self.rightDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightTitleLabel.mas_bottom);
        
        make.left.equalTo(self.iconImage.mas_right).offset(12);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImage.mas_centerX);
        make.width.equalTo(@1);
        make.top.equalTo(self.iconImage.mas_bottom).offset(0);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    self.botImage = [[UIImageView alloc]init];
    [self addSubview:self.botImage];
    self.botImage.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    self.botImage.layer.cornerRadius = 3.f;
    self.botImage.layer.masksToBounds = YES;
    [self.botImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImage.mas_centerX);
        make.height.width.equalTo(@6);
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.rightTitleLabel.text = safeString(dataDic[@"participants"]);
    
    self.rightDetailLabel.text = safeString(dataDic[@"content"]);
    
    self.leftTitleLabel.text = [self timestampToTimeStr:safeString(dataDic[@"time"])];
    
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
