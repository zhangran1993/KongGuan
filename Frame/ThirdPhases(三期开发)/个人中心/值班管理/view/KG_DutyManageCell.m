//
//  KG_DutyManageCell.m
//  Frame
//
//  Created by zhangran on 2020/12/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_DutyManageCell.h"

@interface KG_DutyManageCell () {
    
}


@end

@implementation KG_DutyManageCell

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
    
    self.bgView =  [[UIView alloc]init];
    [self addSubview:self.bgView];
//    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#E7ECF6"];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(self.mas_height);
    }];
    
    self.leftShuLineView = [[UIView alloc]init];
    [self addSubview:self.leftShuLineView];
    self.leftShuLineView.backgroundColor = [UIColor colorWithHexString:@"#E7ECF6"];
    [self.leftShuLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@1);
        make.height.equalTo(@37);
    }];
    
    self.rightShuLineView = [[UIView alloc]init];
    [self addSubview:self.rightShuLineView];
    self.rightShuLineView.backgroundColor = [UIColor colorWithHexString:@"#E7ECF6"];
    [self.rightShuLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@1);
        make.height.equalTo(self.mas_height);
    }];
    
    
    self.topLineView = [[UIView alloc]init];
    [self addSubview:self.topLineView];
    self.topLineView.backgroundColor = [UIColor colorWithHexString:@"#E7ECF6"];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.mas_top).offset(0);
    }];
    
    self.botLineView = [[UIView alloc]init];
    [self addSubview:self.botLineView];
    self.botLineView.backgroundColor = [UIColor colorWithHexString:@"#E7ECF6"];
    [self.botLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    self.botLineView.hidden = YES;
    
    self.centerShuLineView = [[UIView alloc]init];
    [self addSubview:self.centerShuLineView];
    self.centerShuLineView.backgroundColor = [UIColor colorWithHexString:@"#E7ECF6"];
    [self.centerShuLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    self.leftTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.leftTitleLabel];
    self.leftTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.leftTitleLabel.font = [UIFont systemFontOfSize:14];
    self.leftTitleLabel.font = [UIFont my_font:14];
    self.leftTitleLabel.numberOfLines = 1;
    self.leftTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16 +18);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(@((SCREEN_WIDTH -32)/2));
    }];
    
    self.rightTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.rightTitleLabel];
    self.rightTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
    self.rightTitleLabel.font = [UIFont my_font:14];
    self.rightTitleLabel.numberOfLines = 1;
    self.rightTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(@((SCREEN_WIDTH -32)/2));
    }];
    self.changeDutyButton = [[UIButton alloc]init];
    [self addSubview:self.changeDutyButton];
    [self.changeDutyButton setImage:[UIImage imageNamed:@"kg_changeDuty"] forState:UIControlStateNormal];
    [self.changeDutyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@17);
        make.right.equalTo(self.mas_right).offset(-46);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.changeDutyButton.hidden = YES;
    [self.changeDutyButton addTarget:self action:@selector(changeDuty:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.leftTitleLabel.text = safeString(dataDic[@"post"]);
    
    self.rightTitleLabel.text = safeString(dataDic[@"name"]);
    
}

- (void)changeDuty:(UIButton *)button {
    
    if (self.ischangeDutyBlock) {
        self.ischangeDutyBlock(self.dataDic);
    }
}
@end
