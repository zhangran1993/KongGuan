//
//  KG_XunShiRoomCell.m
//  Frame
//
//  Created by zhangran on 2020/4/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CreateMonthWeiHuCell.h"

@implementation KG_CreateMonthWeiHuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = self.backgroundColor;
        [self createUI];
    }
    return self;
}

- (void)createUI {
   
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(33);
        make.right.equalTo(self.mas_right).offset(-80);
        make.height.equalTo(self.mas_height);
    }];
    
    
    self.lineImage = [[UIImageView alloc]init];
    [self addSubview:self.lineImage];
    self.lineImage.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [self.lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(16);
        make.height.equalTo(@0.5);
        make.right.equalTo(self.mas_right).offset(-16);
    }];
    
    self.rightImage = [[UIImageView alloc]init];
    [self addSubview:self.rightImage];
    self.rightImage.image = [UIImage imageNamed:@"duigou_image"];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@14);
        make.width.equalTo(@16);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
}

- (void)setSelRoomStr:(NSString *)selRoomStr {
    _selRoomStr = selRoomStr;
    
}

- (void)setRoomStr:(NSString *)roomStr {
    _roomStr = roomStr;
    if ([self.selRoomStr isEqualToString:roomStr]) {
        self.rightImage.image = [UIImage imageNamed:@"duigou_sel"];
    }else {
        self.rightImage.image = [UIImage imageNamed:@"duigou_image"];
    }
}
@end
