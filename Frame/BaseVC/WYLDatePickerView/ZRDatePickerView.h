//
//  WYLDatePickerView.h
//  ylh-app-primary-ios
//
//  Created by 巨商汇 on 2019/1/8.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    WYLDatePickerTypeYMDHMS,
    WYLDatePickerTypeYMDHM,
    WYLDatePickerTypeYMD,
    WYLDatePickerTypeYM,
    WYLDatePickerTypeY
} WYLDatePickerType;



@protocol WYLDatePickerViewDelegate <NSObject>

/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer;

/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate;

@end


@interface ZRDatePickerView : UIView


@property (copy, nonatomic) NSString *title;

/// 是否自动滑动 默认YES,用来控制是否可以选择过去的时间
@property (assign, nonatomic) BOOL isSlide;
/// 最小可选择年限
@property (nonatomic, assign) NSInteger minYear;
/// 最大可选择年限
@property (nonatomic, assign) NSInteger maxYear;
/// 是否禁止循环
@property (nonatomic, assign) BOOL isForbidCirculate;

/// 选中的时间， 默认是当前时间 2017-02-12 13:35
@property (copy, nonatomic) NSString *date;

/// 分钟间隔 默认5分钟
@property (assign, nonatomic) NSInteger minuteInterval;

/** 工具条背景颜色 */
@property(nonatomic , strong) UIColor *toolBackColor;
/** 完成按钮标题颜色 */
@property(nonatomic , strong) UIColor *saveTitleColor;
/** 取消按钮标题颜色 */
@property(nonatomic , strong) UIColor *cancleTitleColor;
/** 工具条标题颜色 */
@property(nonatomic , strong) UIColor *toolTitleColor;
/** 时间选择器背景颜色 */
@property(nonatomic , strong) UIColor *datePickerColor;

@property (weak, nonatomic) id <WYLDatePickerViewDelegate> delegate;


/** 构造方法 */
- (instancetype)initWithFrame:(CGRect)frame withDatePickerType:(WYLDatePickerType)datePickerType;

/**
 显示  必须调用
 */
- (void)show;


@end

NS_ASSUME_NONNULL_END
