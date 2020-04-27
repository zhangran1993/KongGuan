//
//  KG_JifangCell.m
//  Frame
//
//  Created by zhangran on 2020/4/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_JifangCell.h"

@implementation KG_JifangCell

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
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(self.mas_height);
    }];
    
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
    self.lineView.layer.cornerRadius = 2.f;
    self.lineView.layer.masksToBounds = YES;
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#2B67E8"];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@4);
        make.width.equalTo(@18);
        make.centerX.equalTo(self.mas_centerX);
    }];
}
@end
