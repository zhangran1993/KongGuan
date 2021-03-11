//
//  KG_NiControlCell.m
//  Frame
//
//  Created by zhangran on 2020/4/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SearchCell.h"

@implementation KG_SearchCell

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
        
        self.contentView.backgroundColor = self.backgroundColor;
        [self createUI];
    }
    
    return self;
}



- (void)createUI{
    self.contentBgView = [[UIView alloc]init];
    [self addSubview:self.contentBgView];
    
    self.contentBgView.layer.shadowOffset = CGSizeMake(0,0);
    self.contentBgView.layer.shadowOpacity = 1;
    self.contentBgView.layer.shadowRadius = 3;
    self.contentBgView.layer.cornerRadius = 10;
    self.contentBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.contentBgView.layer.shadowColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:0.3].CGColor;
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self.contentBgView addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.text = @"荣成雷达站日常巡视";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentBgView.mas_left).offset(16.5);
        make.right.equalTo(self.contentBgView.mas_right).offset(-12);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.equalTo(@13.5);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.font = [UIFont systemFontOfSize:12];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.text = @"电池间-20号电阻异常";
    self.detailLabel.numberOfLines = 1;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(-36);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@11.5);
    }];
    
    
    
    
    _selectImageView = [UIImageView new];
    [self.contentBgView addSubview:_selectImageView];
    _selectImageView.image = [UIImage imageNamed:@"calendar_icon"];
    [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentBgView.mas_left).offset(16.5);
        make.width.height.equalTo(@10);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(10);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self.contentBgView addSubview:self.timeLabel];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.text = @"2020.03.02 10:20:42";
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_selectImageView.mas_right).offset(7);
        make.width.height.equalTo(@200);
        make.centerY.equalTo(_selectImageView.mas_centerY);
        make.height.equalTo(@12.5);
    }];
    
    
    
    self.personLabel = [[UILabel alloc]init];
    [self.contentBgView addSubview:self.personLabel];
    self.personLabel.font = [UIFont systemFontOfSize:14];
    self.personLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.personLabel.textAlignment = NSTextAlignmentRight;
    self.personLabel.numberOfLines = 1;
    self.personLabel.text = @"执行负责人:";
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentBgView.mas_right).offset(-11.5);
        make.width.height.equalTo(@200);
        make.centerY.equalTo(_selectImageView.mas_centerY);
        make.height.equalTo(@11.5);
    }];
    
}

@end
