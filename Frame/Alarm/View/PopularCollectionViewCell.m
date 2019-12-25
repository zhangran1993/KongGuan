//
//  PopularCollectionViewCell.m
//  Frame
//
//  Created by centling on 2018/12/5.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PopularCollectionViewCell.h"
#import "UIColor+Extension.h"
@implementation PopularCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexString:@"ECECEC"].CGColor;
    self.layer.cornerRadius = 5;
    self.searchLabel.font = FontSize(15);
}

- (void)setModel:(PopularModel *)model {
    _model = model;
    _searchLabel.text = model.name;
    if (model.Checked) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"348BF1"];
        _searchLabel.textColor = [UIColor whiteColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.searchLabel.textColor = [UIColor colorWithHexString:@"5C5D56"];
    }
    //[_searchLabel sizeToFit];
}

- (void)dealloc {
    [_searchLabel release];
    [super dealloc];
}
@end
