//
//  SparePartTableViewCell.m
//  Frame
//
//  Created by centling on 2018/12/11.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "SparePartTableViewCell.h"
#import "UIColor+Extension.h"
@implementation SparePartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"F0F6FA"];
    self.sparePartName.textColor = [UIColor colorWithHexString:@"252525"];
    self.sparePartName.font = FontSize(16);
    self.numLabel.textColor = [UIColor colorWithHexString:@"555756"];
    self.numLabel.font = FontSize(16);
}


-(void)setSparePartListModel:(SparePartListModel *)sparePartListModel {
    _sparePartListModel = sparePartListModel;
    NSLog(@"aaaaaaaaa%@:::%@",sparePartListModel.category,sparePartListModel.num);
    self.sparePartName.text = sparePartListModel.category;
    self.numLabel.text = sparePartListModel.num;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:kCellHighlightColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}


- (void)dealloc {
    [_sparePartName release];
    [_numLabel release];
    [_lineView release];
    [super dealloc];
}
@end
