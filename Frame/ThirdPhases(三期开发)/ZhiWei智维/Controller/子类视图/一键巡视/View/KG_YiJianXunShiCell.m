//
//  KG_YiJianXunShiCell.m
//  Frame
//
//  Created by zhangran on 2020/4/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_YiJianXunShiCell.h"

@implementation KG_YiJianXunShiCell

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
    
    self.leftView = [[UIView alloc]init];
    [self addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@52);
        make.bottom.equalTo(self.mas_bottom);
    }];
    

    
    
    
    self.leftTimeLabel = [[UILabel alloc]init];
    [self.leftView addSubview:self.leftTimeLabel];
    self.leftTimeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.leftTimeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.leftTimeLabel.textAlignment = NSTextAlignmentRight;
    self.leftTimeLabel.numberOfLines = 1;
    self.leftTimeLabel.text = @"07:00";
    [self.leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@45);
        make.right.equalTo(self.leftView.mas_right).offset(-5.5);
        make.top.equalTo(self.leftView.mas_top).offset(40);
        make.height.equalTo(@10);
    }];
    
    
    self.leftIcon = [[UIImageView alloc]init];
    [self.leftView addSubview:self.leftIcon];
    self.leftIcon.image = [UIImage imageNamed:@"time_greenIcon"];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftView.mas_right).offset(-14.5);
        make.top.equalTo(self.leftTimeLabel.mas_bottom).offset(4.5);
        make.width.equalTo(@12);
        make.height.equalTo(@12);
    }];
    
    self.topLine = [[UIImageView alloc]init];
    [self.leftView addSubview:self.topLine];
    self.topLine.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftIcon.mas_centerX);
        make.top.equalTo(self.leftView.mas_top);
        make.width.equalTo(@1);
        make.bottom.equalTo(self.leftTimeLabel.mas_top).offset(-5);
    }];
    
   
    self.bottomLine = [[UIImageView alloc]init];
    [self.leftView addSubview:self.bottomLine];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftIcon.mas_centerX);
        make.top.equalTo(self.leftIcon.mas_bottom).offset(5);
        make.width.equalTo(@1);
        make.bottom.equalTo(self.leftView.mas_bottom);
    }];
    
//    self.centerLine = [[UIImageView alloc]init];
//    [self.leftView addSubview:self.centerLine];
//    self.centerLine.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
//    [self.centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.leftIcon.mas_centerX);
//        make.top.equalTo(self.topLine.mas_bottom);
//        make.width.equalTo(@1);
//        make.bottom.equalTo(self.bottomLine.mas_top);
//    }];
//
    
    self.rightView = [[UIView alloc]init];
    self.rightView.layer.cornerRadius = 10;
    self.rightView.layer.masksToBounds = YES;
    self.rightView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right);
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-16);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
   
    self.iconImage = [[UIImageView alloc]init];
    [self.rightView addSubview:self.iconImage];
    self.iconImage.layer.cornerRadius = 3.f;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#95A8D7"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightView.mas_left).offset(16);
        make.top.equalTo(self.rightView.mas_top).offset(19);
        make.width.height.equalTo(@6);
    }];
    
    self.roomLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.roomLabel];
    self.roomLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.roomLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.roomLabel.textAlignment = NSTextAlignmentLeft;
    self.roomLabel.numberOfLines = 1;
    self.roomLabel.text = @"雷达机房";
    [self.roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(8);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.iconImage.mas_centerY);
    }];
    
    
    self.statusLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.statusLabel];
    self.statusLabel.text = @"进行中";
    self.statusLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.statusLabel.textAlignment = NSTextAlignmentLeft;
    self.statusLabel.numberOfLines = 1;
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightView.mas_right).offset(-16);
        make.width.lessThanOrEqualTo(@100);
        make.centerY.equalTo(self.iconImage.mas_centerY);
    }];
    
    
    self.detailLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.detailLabel];
    self.detailLabel.text = @"电池间蓄电池2#设备故障";
    self.detailLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.numberOfLines = 1;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_left);
        make.right.equalTo(self.rightView.mas_right).offset(-20);
        make.top.equalTo(self.iconImage.mas_bottom).offset(12);
        make.height.equalTo(@14);
    }];
    
    self.starImage = [[UIImageView alloc]init];
    [self.rightView addSubview:self.starImage];
    self.starImage.image = [UIImage imageNamed:@"yellow_staricon"];
    [self.starImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_left);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(9.5);
        make.width.height.equalTo(@12);
    }];
    self.starLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.starLabel];
    self.starLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.starLabel.textColor = [UIColor colorWithHexString:@"#FFB428"];
    self.starLabel.textAlignment = NSTextAlignmentLeft;
    self.starLabel.numberOfLines = 1;
    self.starLabel.text = @"20#电池内阻";
    [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starImage.mas_right).offset(6);
        make.right.equalTo(self.rightView.mas_right).offset(-20);
        make.centerY.equalTo(self.starImage.mas_centerY);
        make.height.equalTo(@14);
    }];
    self.timeImage = [[UIImageView alloc]init];
    [self.rightView addSubview:self.timeImage];
    self.timeImage.image = [UIImage imageNamed:@"yellow_staricon"];
    [self.timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_left);
        make.top.equalTo(self.starImage.mas_bottom).offset(9);
        make.width.height.equalTo(@12);
    }];
    self.timeLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.timeLabel];
    self.timeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.text = @"2020.01.12 09:00";
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starImage.mas_right).offset(6);
        make.right.equalTo(self.rightView.mas_right).offset(-20);
        make.centerY.equalTo(self.timeImage.mas_centerY);
        make.height.equalTo(@14);
    }];
    
    self.personLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.personLabel];
    self.personLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.personLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.personLabel.textAlignment = NSTextAlignmentRight;
    self.personLabel.numberOfLines = 1;
    self.personLabel.text = @"执行负责人：王雪";
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.right.equalTo(self.rightView.mas_right).offset(-20);
        make.centerY.equalTo(self.timeImage.mas_centerY);
        make.height.equalTo(@14);
    }];
    
    self.taskButton = [[UIButton alloc]init];
    [self.rightView addSubview:self.taskButton];
    [self.taskButton setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    [self.taskButton setTitle:@"指派任务" forState:UIControlStateNormal];
    [self.taskButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.taskButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [self.taskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightView.mas_right).offset(-16);
        make.centerY.equalTo(self.rightView.mas_centerY);
        make.width.equalTo(@70);
        make.height.equalTo(@24);
    }];
}
@end
