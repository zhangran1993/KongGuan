//
//  ContactsCell.m
//  Frame
//
//  Created by centling on 2018/12/5.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "ContactsCell.h"

@implementation ContactsCell

- (void)awakeFromNib {
    _telLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _telLabel.numberOfLines = 2;
    _nameLabel.font = FontSize(15);
    _telLabel.font = FontSize(15);
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_nameLabel release];
    [_telLabel release];
    [super dealloc];
}
@end
