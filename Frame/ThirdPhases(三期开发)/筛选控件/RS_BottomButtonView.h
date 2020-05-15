//
//  RS_BottomButtonView.h
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/5/30.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,RS_BottomButtonType) {
    RS_BottomButtonTypeLeft = 0,
    RS_BottomButtonTypeRight
};

@interface RS_BottomButtonView : UIView

@property (nonatomic, copy) void (^didClickButton)(RS_BottomButtonType type);

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)itemArr;

@end

NS_ASSUME_NONNULL_END
