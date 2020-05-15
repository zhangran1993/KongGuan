//
//  RS_ConditionSearchCell.m
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/7/1.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import "RS_ConditionSearchCell.h"

@interface RS_ConditionSearchCell ()

@property (nonatomic, strong) UIButton *itemButton;

@end

@implementation RS_ConditionSearchCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    _itemButton = [UIButton new];
    [self.contentView addSubview:_itemButton];
    _itemButton.frame = CGRectMake(5, 7.5, self.width - 10, 25);
    _itemButton.userInteractionEnabled = NO;
    
    [_itemButton setTitleColor:LCColor(@"#555555") forState:UIControlStateNormal];
    [_itemButton setTitleColor:LCColor(@"#EA3425") forState:UIControlStateSelected];
    _itemButton.titleLabel.font = Font(13);
    _itemButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _itemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 13);
    
    _itemButton.clipsToBounds = YES;
    _itemButton.layer.cornerRadius = 3;
    _itemButton.backgroundColor = LCColor(@"#F2F2F2");
    
    [_itemButton setBackgroundImage:[UIImage stretchImage:IMAGE(@"rs_condition_search_rectangle_conrim") left:10 top:10] forState:UIControlStateSelected];
}

- (void)setModel:(RS_ConditionSearchItemModel *)model {
    
    _model = model;
    
    _itemButton.frame = CGRectMake(5, 5, model.width - 10, 30);
    [_itemButton setTitle:model.itemName forState:UIControlStateNormal];
    _itemButton.selected = model.isSelected;
}


@end
