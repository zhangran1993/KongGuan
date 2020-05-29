//
//  KG_RunReportCell.m
//  Frame
//
//  Created by zhangran on 2020/5/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunReportCell.h"

@interface KG_RunReportCell (){
    
    
}

@property (nonatomic,strong) UILabel *titleLabel ;

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *statusLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation KG_RunReportCell

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
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"黄城导航台2020.02.02-2020";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top).offset(13);
        make.height.equalTo(@24);
    }];
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    self.iconImage.layer.cornerRadius =11.f;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#2B8EFF"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.height.width.equalTo(@22);
    }];
       
       
    self.statusLabel = [[UILabel alloc]init];
    [self addSubview:self.statusLabel];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.statusLabel.font = [UIFont systemFontOfSize:12];
    self.statusLabel.textAlignment = NSTextAlignmentLeft;
    self.statusLabel.text = @"技术主任张树剑";
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.left.equalTo(self.iconImage.mas_right).offset(4);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@24);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.text = @"2020.04.28 17:00:23";
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.right.equalTo(self.mas_right).offset(-16);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@24);
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
}
@end
