//
//  KG_LoginSelStationCell.m
//  Frame
//
//  Created by zhangran on 2020/5/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_LoginSelStationCell.h"

@interface KG_LoginSelStationCell (){
    
}

@end

@implementation KG_LoginSelStationCell

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
        self.contentView.backgroundColor = self.backgroundColor;
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    
    self.bgImageView = [[UIImageView alloc]init];
    [self addSubview:self.bgImageView];
    self.bgImageView.backgroundColor = [UIColor colorWithHexString:@"#FAFBFB"];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@40);
        make.right.equalTo(self.mas_right);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"薛家岛导航台";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@40);
        make.width.equalTo(@200);
    }];
    
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
        make.right.equalTo(self.mas_right).offset(-24);
    }];
    self.selImageView = [[UIImageView alloc]init];
    [self addSubview:self.selImageView];
    [self.selImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@16);
        make.height.equalTo(@13);
        make.right.equalTo(self.mas_right).offset(-28);
        make.top.equalTo(self.mas_top).offset(10);
    }];
    self.selImageView.image = [UIImage imageNamed:@"radio_unsel"];
    
    self.selBtn = [[UIButton alloc]init];
    [self addSubview:self.selBtn];
    [self.selBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@100);
    }];
    [self.selBtn setTitle:@"" forState:UIControlStateNormal];
    [self.selBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.selBtn addTarget:self action:@selector(selMethod:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selMethod:(UIButton *)button {
  
    if (self.selectedMethod) {
        self.selectedMethod(self.detailModel);
    }
}

- (void)setDetailModel:(stationListModel *)detailModel {
    _detailModel = detailModel;
    
    self.titleLabel.text = safeString(detailModel.stationName);
    if (detailModel.isSelected ) {
        self.selImageView.image  = [UIImage imageNamed:@"radio_sel"];
    }else {
        self.selImageView.image  = [UIImage imageNamed:@"radio_unsel"];
        
    }
    
}
@end
