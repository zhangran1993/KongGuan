//
//  KG_ZhiXiuCell.m
//  Frame
//
//  Created by zhangran on 2020/5/14.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_GaoJingDetailFirstCell.h"

@interface KG_GaoJingDetailFirstCell (){
    
    
}

@property (nonatomic ,strong) UIButton *confirmStatusBtn;

@property (nonatomic ,strong) UIButton *hangUpStautsBtn;

@property (nonatomic ,strong) UIButton *liftStatusBtn;
@end

@implementation KG_GaoJingDetailFirstCell

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
    
    self.roomLabel = [[UILabel alloc]init];
    [self addSubview:self.roomLabel];
    self.roomLabel.text = @"黄城导航台-电池间";
    self.roomLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.roomLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [self.roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@27);
        make.width.equalTo(@200);
    }];
    
    
    
    self.statusImage = [[UIImageView alloc]init];
    [self addSubview:self.statusImage];
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-18);
        make.width.equalTo(@38);
        make.height.equalTo(@20);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    self.statusImage.image = [UIImage imageNamed:@"level_jinji"];
    
    
    UIView *lineImage = [[UIView alloc]init];
    [self addSubview:lineImage];
    lineImage.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.roomLabel.mas_bottom).offset(11);
        make.height.equalTo(@1);
    }];
    
    
    self.confirmBtn = [[UIButton alloc]init];
    [self addSubview:self.confirmBtn];
    [self.confirmBtn setTitle:@"未确认" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor colorWithHexString:@"#AABBCD"] forState:UIControlStateNormal];
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.masksToBounds = YES;
    [self.confirmBtn addTarget:self action:@selector(buttonClock:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#F3F5F8"]];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.width.equalTo(@58);
        make.height.equalTo(@28);
        make.top.equalTo(lineImage.mas_bottom).offset(25);
    }];
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@1);
        make.top.equalTo(self.confirmBtn.mas_bottom).offset(20);
    }];
    
    self.iconImage = [[UIImageView alloc]init];
    self.iconImage.image = [UIImage imageNamed:@"gaojing_red"];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.top.equalTo(lineImage.mas_bottom).offset(12);
    }];
    
    self.powLabel = [[UILabel alloc]init];
    [self addSubview:self.powLabel];
    self.powLabel.text = @"电池组2#";
    self.powLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.powLabel.font = [UIFont systemFontOfSize:12];
    [self.powLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(14);
        make.top.equalTo(lineImage.mas_bottom).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@200);
    }];
    self.gaojingImage.image = [UIImage imageNamed:@"gaojing_red"];
    self.gaojingImage = [[UIImageView alloc]init];
    [self addSubview:self.gaojingImage];
    [self.gaojingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.top.equalTo(self.iconImage.mas_bottom).offset(8);
    }];
    self.gaojingImage.image = [UIImage imageNamed:@"gaojing_red"];
    
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.text = @"电池组2#";
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.detailLabel.font = [UIFont systemFontOfSize:12];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gaojingImage.mas_right).offset(14);
        make.top.equalTo(self.powLabel.mas_bottom).offset(8);
        make.height.equalTo(@24);
        make.width.equalTo(@200);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    self.timeLabel.text = @"2019.12.24 06:37";
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.height.equalTo(@21);
        make.width.equalTo(@150);
    }];
    
    self.hangUpStautsBtn = [[UIButton alloc]init];
    [self addSubview:self.hangUpStautsBtn];
    [self.hangUpStautsBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    [self.hangUpStautsBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.hangUpStautsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.hangUpStautsBtn.layer.cornerRadius = 4;
    self.hangUpStautsBtn.layer.masksToBounds = YES;
   
    [self.hangUpStautsBtn setTitle:@"挂起" forState:UIControlStateNormal];
    [self.hangUpStautsBtn addTarget:self action:@selector(hangMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.hangUpStautsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-22);
        make.width.equalTo(@60);
        make.height.equalTo(@28);
        make.bottom.equalTo(self.mas_bottom).offset(-11);
    }];
    
    
    
    self.liftStatusBtn = [[UIButton alloc]init];
    [self addSubview:self.liftStatusBtn];
    [self.liftStatusBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    [self.liftStatusBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.liftStatusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.liftStatusBtn.layer.cornerRadius = 4;
    self.liftStatusBtn.layer.masksToBounds = YES;
    [self.liftStatusBtn addTarget:self action:@selector(liftMethod:) forControlEvents:UIControlEventTouchUpInside];
   
    [self.liftStatusBtn setTitle:@"解除" forState:UIControlStateNormal];
    [self.liftStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.hangUpStautsBtn.mas_left).offset(-10);
        make.width.equalTo(@60);
        make.height.equalTo(@28);
        make.bottom.equalTo(self.mas_bottom).offset(-11);
    }];
    
    
    self.confirmStatusBtn = [[UIButton alloc]init];
    [self addSubview:self.confirmStatusBtn];
    [self.confirmStatusBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    [self.confirmStatusBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.confirmStatusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.confirmStatusBtn.layer.cornerRadius = 4;
    self.confirmStatusBtn.layer.masksToBounds = YES;
    [self.confirmStatusBtn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
  
    [self.confirmStatusBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.confirmStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.liftStatusBtn.mas_left).offset(-10);
        make.width.equalTo(@60);
        make.height.equalTo(@28);
        make.bottom.equalTo(self.mas_bottom).offset(-11);
    }];
    
}


- (void)setModel:(KG_GaoJingDetailModel *)model {
    _model = model;
    NSDictionary *dic = model.info;
    self.roomLabel.text = [NSString stringWithFormat:@"%@-%@",safeString(dic[@"stationName"]),safeString(dic[@"engineRoomName"])];
   self.timeLabel.text = [self timestampToTimeStr:safeString(dic[@"happenTime"])];
   self.statusImage.image = [UIImage imageNamed:[self getLevelImage:safeString(dic[@"level"])]];
 
    NSString *sta = @"未确认";
    if ([safeString(dic[@"status"]) isEqualToString:@"unconfirmed"]) {
        sta = @"未确认";
    }else if ([safeString(dic[@"status"]) isEqualToString:@"confirmed"]) {
        sta = @"已确认";
    }else if ([safeString(dic[@"status"]) isEqualToString:@"removed"]) {
        sta = @"已解除";
    }else if ([safeString(dic[@"status"]) isEqualToString:@"hangUp"]) {
        sta = @"已挂起";
    }else if ([safeString(dic[@"status"]) isEqualToString:@"completed"]) {
        sta = @"已解决";
    }
    
   [self.confirmBtn setTitle:sta forState:UIControlStateNormal];
   self.powLabel.text = safeString(dic[@"equipmentName"]);
    self.iconImage.image = [UIImage imageNamed: [CommonExtension getDeviceIcon:safeString(dic[@"equipmentCategory"])]];
    
   self.detailLabel.text = safeString(dic[@"name"]);
    
    if ([dic[@"hangupStatus"] boolValue]) {
        [self.hangUpStautsBtn setTitle:@"解除挂起" forState:UIControlStateNormal];
        [self.confirmBtn setTitle:@"已挂起" forState:UIControlStateNormal];
        
    }else {
        [self.hangUpStautsBtn setTitle:@"挂起" forState:UIControlStateNormal];
        
    }
    if([sta isEqualToString:@"已确认"]){
        [self.confirmStatusBtn setTitle:@"确认" forState:UIControlStateNormal];
        [self.confirmStatusBtn setTitleColor:[UIColor colorWithHexString:@"#AABBCD"] forState:UIControlStateNormal];
        self.confirmStatusBtn.userInteractionEnabled = NO;
        [self.confirmStatusBtn setBackgroundColor:[UIColor colorWithHexString:@"#F3F5F8"]];
    }else if([sta isEqualToString:@"未确认"]){
        [self.confirmStatusBtn setTitle:@"确认" forState:UIControlStateNormal];
        self.confirmStatusBtn.userInteractionEnabled = YES;
        [self.confirmStatusBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
        [self.confirmStatusBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }
    
}

- (void)buttonClock:(UIButton *)button {
    
    
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
- (NSString *)getLevelImage:(NSString *)level {
    NSString *levelString = @"level_normal";
    
    if ([level isEqualToString:@"正常"]) {
        levelString = @"level_normal";
    }else if ([level isEqualToString:@"提示"]) {
        levelString = @"level_prompt";
    }else if ([level isEqualToString:@"次要"]) {
        levelString = @"level_ciyao";
    }else if ([level isEqualToString:@"重要"]) {
        levelString = @"level_important";
    }else if ([level isEqualToString:@"紧急"]) {
        levelString = @"level_jinji";
    }
    
    //紧急
    return levelString;
}
- (void)hangMethod:(UIButton *)btn {
    
    if (self.hangupMethod) {
        self.hangupMethod();
    }
}

- (void)liftMethod:(UIButton *)btn {
    
    if (self.removeMethod) {
        self.removeMethod();
    }
}

- (void)confirmMethod:(UIButton *)btn {
    if (self.confirmMethod) {
        self.confirmMethod();
    }
    
}

@end
