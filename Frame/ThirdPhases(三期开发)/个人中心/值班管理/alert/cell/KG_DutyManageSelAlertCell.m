//
//  KG_DutyManageSelAlertCell.m
//  Frame
//
//  Created by zhangran on 2021/1/27.
//  Copyright © 2021 hibaysoft. All rights reserved.
//

#import "KG_DutyManageSelAlertCell.h"

@interface KG_DutyManageSelAlertCell (){
    
}

@property (nonatomic,strong) UIView                *centerView;

@property (nonatomic,strong) UIImageView           *selBtn;

@property (nonatomic,strong) UILabel               *titleLabel;

@property (nonatomic,strong) UIImageView           *timeImage;

@property (nonatomic,strong) UILabel               *timeLabel;

@property (nonatomic,strong) UILabel               *personLabel;


@end

@implementation KG_DutyManageSelAlertCell

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
    
    self.centerView = [[UIView alloc]init];
    self.centerView.layer.cornerRadius = 4;
    self.centerView.layer.masksToBounds = YES;
    [self addSubview:self.centerView];
    self.centerView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.titleLabel sizeToFit];
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(38);
        make.right.equalTo(self.centerView.mas_right).offset(-8);
        make.top.equalTo(self.centerView.mas_top).offset(12);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    self.selBtn = [[UIImageView alloc]init];
    [self.selBtn setImage:[UIImage imageNamed:@"kg_dutymanageunSelImage"]];
    [self addSubview:self.selBtn];
    [self.selBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(8);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.timeImage = [[UIImageView alloc]init];
    [self addSubview:self.timeImage];
    self.timeImage.image = [UIImage imageNamed:@"kg_dutymanTimeIcon"];
    [self.timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@12);
        make.bottom.equalTo(self.centerView.mas_bottom).offset(-13);
        make.left.equalTo(self.centerView.mas_left).offset(38);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.font = [UIFont my_font:12];
    [self.timeLabel sizeToFit];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeImage.mas_right).offset(6);
        make.height.equalTo(@17);
        make.centerY.equalTo(self.timeImage.mas_centerY);
        
    }];
    
    self.personLabel  = [[UILabel alloc]init];
    [self addSubview:self.personLabel];
    self.personLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.personLabel.font = [UIFont systemFontOfSize:12];
    self.personLabel.font = [UIFont my_font:12];
    self.personLabel.textAlignment = NSTextAlignmentRight;
    
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right).offset(-8);
        make.height.equalTo(@17);
        make.centerY.equalTo(self.timeImage.mas_centerY);
    }];
    
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.timeLabel.text = [self timestampToTimeStr:safeString(dataDic[@"patrolIntervalTime"])] ;
    self.personLabel.text = [NSString stringWithFormat:@"负责人:%@",safeString(dataDic[@"leaderName"])];
    self.titleLabel.text = safeString(dataDic[@"taskName"]);
}
//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY.MM.dd HH:mm"] stringFromDate:date];
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

- (void)setModel:(KG_DutyManageSelModel *)model {
    _model = model;
    
    if([safeString(model.typeCode) isEqualToString:@"oneTouchTour"] ||
       [safeString(model.typeCode) isEqualToString:@"fieldInspection"]) {
        
        self.timeLabel.text = [self timestampToTimeStr:safeString(model.patrolIntervalTime)];
    
    }else if([safeString(model.typeCode) isEqualToString:@"routineMaintenance"] ) {
        
        self.timeLabel.text = [self timestampToTimeStr:safeString(model.planStartTime)];
    
    }else if([safeString(model.typeCode) isEqualToString:@"specialSafeguard"]
             ||[safeString(model.typeCode) isEqualToString:@"specialTour"]) {
       
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[self timestampToTimeStr:safeString(model.planStartTime)],[self timestampToTimeStr:safeString(model.planFinishTime)]];
    }
    
    self.personLabel.text = [NSString stringWithFormat:@"负责人:%@",safeString(model.leaderName)];
    if(safeString(model.leaderName).length == 0) {
        
        self.personLabel.text = @"";
    }
    self.titleLabel.text = safeString(model.taskName);
    
    BOOL issel = model.isSelect;
    if(issel) {
        [self.selBtn setImage:[UIImage imageNamed:@"kg_dutymanageSelImage"]];
    }else {
        
        [self.selBtn setImage:[UIImage imageNamed:@"kg_dutymanageunSelImage"]];
    }
}
@end



