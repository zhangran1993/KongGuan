//
//  RS_BottomButtonView.m
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/5/30.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import "RS_BottomButtonView.h"

@interface RS_BottomButtonView ()

@property (nonatomic, copy) NSArray *itemArr;

@end

@implementation RS_BottomButtonView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)itemArr {
    
    CGFloat height = IS_FULL_SCREEN ? 79 : 45;
    if (self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height)]) {
        _itemArr = itemArr;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    for (int i = 0; i < _itemArr.count; ++i) {
        UIButton *button = [UIButton new];
        [self addSubview:button];
        button.sd_layout.xIs(SCREEN_WIDTH / 2.0 * i).yIs(0).widthIs(SCREEN_WIDTH / 2.0).heightIs(self.height);
        [button setTitle:_itemArr[i] forState:UIControlStateNormal];
        [button setTitleColor:i ? [UIColor whiteColor] : LCColor(@"#46BE89") forState:UIControlStateNormal];
        button.titleLabel.font = FontBold(16);
        button.backgroundColor = i ? LCColor(@"#46BE89") : [UIColor whiteColor];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (IS_FULL_SCREEN) {
            button.titleEdgeInsets = UIEdgeInsetsMake(-17, 0, 0, 0);
        }
        if (i) {
            _rightButton = button;
        } else {
            _leftButton = button;
        }
    }
}

- (void)buttonAction:(UIButton *)button {
    
    if (self.didClickButton) {
        self.didClickButton(button.tag - 10);
    }
}

@end
