//
//  KG_RunPromptCell.m
//  Frame
//
//  Created by zhangran on 2020/6/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunPromptCell.h"

@interface KG_RunPromptCell (){
    
}
@property (nonatomic,strong) UIImageView *bgImage;

@property (nonatomic,strong) UILabel *titleLabel;

//状态image
@property (nonatomic,strong) UIImageView *statusImage;

@property (nonatomic,strong) UILabel *detailLabel;


@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *personLabel;

@end

@implementation KG_RunPromptCell

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
    
    self.bgImage = [[UIImageView alloc]init];
    [self addSubview:self.bgImage];
    self.bgImage.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.bgImage.layer.cornerRadius = 10;
    self.bgImage.layer.shadowColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:245/255.0 alpha:1.0].CGColor;
    self.bgImage.layer.shadowOffset = CGSizeMake(0,2);
    self.bgImage.layer.shadowOpacity = 1;
    self.bgImage.layer.shadowRadius = 2;
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
 
    
    self.statusImage  = [[UIImageView alloc]init];
    
    self.statusImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.statusImage];
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImage.mas_right);
        make.top.equalTo(self.bgImage.mas_top);
        make.width.height.equalTo(@48);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.numberOfLines = 1;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left).offset(16);
        make.top.equalTo(self.bgImage.mas_top).offset(13);
        make.width.equalTo(@200);
        make.height.equalTo(@22);
    }];
    
    
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.text = @"afdnjsdfsdasvdkajfsvnkafdnjsdfsdasvdkajfsvnkjlafdnjsdfsdasvdkajfsvnkjlafdnjsdfsdasvdkajfsvnkjlafdnjsdfsdasvdkajfsvnkjlafdnjsdfsdasvdkajfsvnkjlafdnjsdfsdasvdkajfsvnkjlafdnjsdfsdasvdkajfsvnkjljls";
    [self.detailLabel sizeToFit];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left).offset(17);
        make.right.equalTo(self.bgImage.mas_right).offset(-16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9);
        
       
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left);
        make.right.equalTo(self.bgImage.mas_right);
        make.height.equalTo(@0.5);
        //        make.bottom.equalTo(self.timeLabel.mas_top).offset(-11);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(14);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImage.mas_right).offset(-16);
        make.top.equalTo(lineView.mas_bottom).offset(11 );
        make.width.equalTo(@200);
        make.height.equalTo(@17);
    }];
    
    self.personLabel = [[UILabel alloc]init];
    [self addSubview:self.personLabel];
    self.personLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.personLabel.font = [UIFont systemFontOfSize:12];
    self.personLabel.textAlignment = NSTextAlignmentLeft;
    self.personLabel.numberOfLines = 1;
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left).offset(16);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@17);
    }];
   
   
    
    
}

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    self.titleLabel.text = safeString(dic[@"title"]);
    self.detailLabel.text = safeString(dic[@"content"]);
    
    self.timeLabel.text = [self timestampToTimeStr:safeString(dic[@"issuedTime"])] ;
    self.personLabel.text = [NSString stringWithFormat:@"发布人:%@",safeString(dic[@"issuedNmae"])];
    if ([dic[@"tipsStatus"] boolValue]) {
        self.statusImage.image = [UIImage imageNamed:@"run_startImage"];
    }else {
        self.statusImage.image = [UIImage imageNamed:@"run_closeImage"];
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

