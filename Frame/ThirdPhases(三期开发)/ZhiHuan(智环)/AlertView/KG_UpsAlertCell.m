//
//  KG_UpsAlertCell.m
//  Frame
//
//  Created by zhangran on 2020/4/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_UpsAlertCell.h"

@interface KG_UpsAlertCell ()

@end
@implementation KG_UpsAlertCell

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
  
    _selectImageView = [UIImageView new];
    [self.contentView addSubview:_selectImageView];
    _selectImageView.layer.cornerRadius = 3.f;
    _selectImageView.layer.masksToBounds = YES;
    _selectImageView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.width.height.equalTo(@6);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_selectImageView.mas_right).offset(7);
        make.height.equalTo(self.mas_height);
        make.right.equalTo(self.mas_right).offset(-5);
        make.centerY.equalTo(_selectImageView.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.width.equalTo(@133);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

@end
