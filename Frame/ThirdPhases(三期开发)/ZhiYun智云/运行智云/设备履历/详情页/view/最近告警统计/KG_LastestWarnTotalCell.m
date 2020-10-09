//
//  KG_LastestWarnTotalCell.m
//  Frame
//
//  Created by zhangran on 2020/9/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_LastestWarnTotalCell.h"

@implementation KG_LastestWarnTotalCell

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
    
}
@end
