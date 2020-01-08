//
//  CommonBaseViewController.h
//  ylh-app-change
//
//  Created by 巨商汇 on 2019/6/12.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonBaseViewController : BaseVC
/**
 设置标题
 */
@property (nonatomic, copy) NSString * navigationTitle;

/**  标题栏 */
@property (nonatomic, strong) UILabel * titleLabel;
/** 标题栏字体大小 */
@property(nonatomic , assign) CGFloat titleFont;
/** 标题栏字体颜色 */
@property(nonatomic , copy) NSString *titleColor;
/**  是否隐藏返回按钮 */
@property (nonatomic, assign) BOOL isHiddenLeftBtn;
/**  是否隐藏底部分割线 */
@property (nonatomic, assign) BOOL isHiddenBottomLine;
/**
 返回按钮点击
 */
- (void) backButtonClick;
@end

NS_ASSUME_NONNULL_END
