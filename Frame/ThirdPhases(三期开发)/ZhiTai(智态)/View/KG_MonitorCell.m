//
//  KG_MonitorCell.m
//  Frame
//
//  Created by zhangran on 2020/4/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_MonitorCell.h"

@implementation KG_MonitorCell

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
  
    _bgView = [[UIView alloc]init];
    [self.contentView addSubview:_bgView];
    _bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@98);
        make.height.equalTo(@26);
        make.top.equalTo(self.mas_top);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 1;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@98);
        make.height.equalTo(@26);
        make.top.equalTo(self.mas_top);
    }];
    
    
}
@end
