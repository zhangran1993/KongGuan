//
//  CustomTableViewCell.m
//  Frame
//
//  Created by centling on 2018/12/7.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_nameLabel release];
    [super dealloc];
}
@end
