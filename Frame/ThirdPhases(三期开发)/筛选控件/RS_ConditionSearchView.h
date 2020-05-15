//
//  RS_ConditionSearchView.h
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/7/1.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RS_ConditionSearchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RS_ConditionSearchView : UIView

/** 筛选条件数据源 */
@property (nonatomic, copy) NSArray *conditionDataArr;
/** 点击确定的回调数据 */
@property (nonatomic, copy) NSArray *resultArray;
/** 回调，根据不同类型返回index、区间值、二级页面选项值 */
@property (nonatomic, copy) void (^didSelectItemHandler)(NSArray<NSArray *> *resultArr);

/**
 初始化方法
 
 @param conditionDataArr 筛选条件数据源，参考下方构造示例
 */
- (instancetype)initWithCondition:(NSArray *)conditionDataArr;

/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)hide;

@end

/**
 筛选条件数据源conditionDataArr构造示例
 
 @param sectionName 每个筛选分组的标题
 @param sectionType 筛选类型(参考枚举RS_ConditionSearchSectionType)
 @param allowMutiSelect 是否允许多选，默认@(YES)
 @param allowPackUp 是否允许收起，默认@(YES)
 @param itemArrM 普通样式时:筛选选项
                 区间样式时:起止区间的提示语
 @param intervalStart   区间起始值(非区间样式无需设置)
 @param intervalEnd     区间结束值(非区间样式无需设置)
 @param intervalIsInput 区间是输入或选择，默认@(YES)为输入(非区间样式无需设置)
 @param 其他参数含义参考RS_ConditionSearchModel.h
 
self.conditionDataArr =
@[@{@"sectionName":@"收支类型",
    @"sectionType":@(RS_ConditionSearchSectionTypeNormal),
    @"allowMutiSelect":@(YES),
    @"allowPackUp":@(YES),
    @"itemArrM":
        @[@{@"itemName":@"充值"},
          @{@"itemName":@"订单付款"},
          @{@"itemName":@"扣款"},
          @{@"itemName":@"收款冲红"}]},
  @{@"sectionName":@"资金账户",
    @"sectionType":@(RS_ConditionSearchSectionTypeAdjustText),
    @"allowMutiSelect":@(YES),
    @"allowPackUp":@(YES),
    @"itemArrM":
        @[@{@"itemName":@"帐户名称超过二十个字符就省略帐户名称超过名称省略"},
          @{@"itemName":@"订电热水器电热水器"},
          @{@"itemName":@"太阳能热水器"},
          @{@"itemName":@"太阳能热水器2"}]},
  @{@"sectionName":@"时间区间",
    @"sectionType":@(RS_ConditionSearchSectionTypeInterval),
    @"allowMutiSelect":@(NO),
    @"allowPackUp":@(NO),
    @"intervalStart":@"",
    @"intervalEnd":@"",
    @"intervalIsInput":@(NO),
    @"itemArrM":
        @[@{@"itemName":@"开始时间"},
          @{@"itemName":@"结束时间"}]}];
*/

NS_ASSUME_NONNULL_END
