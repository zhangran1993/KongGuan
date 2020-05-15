//
//  KG_ZhiXiuCell.m
//  Frame
//
//  Created by zhangran on 2020/5/14.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ZhiXiuCell.h"


@implementation KG_ZhiXiuCell

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
    
//
//    @property (nonatomic,strong) UILabel *roomLabel;
//
//    @property (nonatomic,strong) UILabel *timeLabel;
//
//    @property (nonatomic,strong) UIView *lineView;
//    @property (nonatomic,strong) UIImageView *iconImage;
//    @property (nonatomic,strong) UIImageView *gaojingImage;
//    @property (nonatomic,strong) UILabel *powLabel;
    
    self.roomLabel = [[UILabel alloc]init];
    [self addSubview:self.roomLabel];
    self.roomLabel.text = @"黄城导航台-电池间";
    self.roomLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.roomLabel.font = [UIFont systemFontOfSize:16];
    [self.roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(13);
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
        make.top.equalTo(self.roomLabel.mas_bottom);
        make.height.equalTo(@24);
        make.width.equalTo(@200);
    }];
       
    self.statusImage = [[UIImageView alloc]init];
    [self addSubview:self.statusImage];
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-18);
        make.width.equalTo(@38);
        make.height.equalTo(@20);
        make.top.equalTo(self.mas_top).offset(18);
    }];
    self.statusImage.image = [UIImage imageNamed:@"level_jinji"];
    
    
    self.confirmBtn = [[UIButton alloc]init];
    [self addSubview:self.confirmBtn];
    [self.confirmBtn setTitle:@"未确认" forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(buttonClock:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#F3F5F8"]];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(-16);
        make.width.equalTo(@58);
        make.height.equalTo(@28);
        make.bottom.equalTo(self.mas_bottom).offset(-25);
    }];
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-18);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.top.equalTo(self.mas_top).offset(18);
    }];
    self.gaojingImage.image = [UIImage imageNamed:@"gaojing_red"];
    
    self.gaojingImage = [[UIImageView alloc]init];
    [self addSubview:self.gaojingImage];
    [self.gaojingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-18);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.top.equalTo(self.mas_top).offset(18);
    }];
    self.gaojingImage.image = [UIImage imageNamed:@"gaojing_red"];
    
    
    self.powLabel = [[UILabel alloc]init];
    [self addSubview:self.powLabel];
    self.powLabel.text = @"导航DVOR";
    self.powLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.powLabel.font = [UIFont systemFontOfSize:12];
    [self.powLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.roomLabel.mas_bottom);
        make.height.equalTo(@24);
        make.width.equalTo(@200);
    }];
}
@end
