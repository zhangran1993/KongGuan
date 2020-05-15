//
//  RS_ConditionSearchModel.h
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/7/1.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import "RS_JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 筛选页分组样式
 - RS_ConditionSearchSectionTypeNormal: 普通样式
 - RS_ConditionSearchSectionTypeAdjustText: 适应文字宽且左对齐
 - RS_ConditionSearchSectionTypeInterval: 选择区间(价格/时间)
 - RS_ConditionSearchSectionTypeSelect: 跳转二级页面选择
 */
typedef NS_ENUM(NSInteger,RS_ConditionSearchSectionType) {
    RS_ConditionSearchSectionTypeNormal = 0,
    RS_ConditionSearchSectionTypeAdjustText,
    RS_ConditionSearchSectionTypeInterval,
    RS_ConditionSearchSectionTypeToSecondView
};

@protocol RS_ConditionSearchItemModel;

@interface RS_ConditionSearchItemModel : RS_JSONModel

/** 选项名称 */
@property (nonatomic, copy) NSString *itemName;
/** cell宽 */
@property (nonatomic, assign) CGFloat width;
/** cell高 */
@property (nonatomic, assign) CGFloat height;
/** cell选中状态 */
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end

@interface RS_ConditionSearchModel : RS_JSONModel

#pragma mark - 构造筛选数据源时需设置的参数
/** 分组名称 */
@property (nonatomic, copy) NSString *sectionName;
/** 分组样式 default is RS_ConditionSearchSectionTypeNormal */
@property (nonatomic, strong) NSNumber *sectionType;
/** 选项 */
@property (nonatomic, strong) NSMutableArray<RS_ConditionSearchItemModel> *itemArrM;
/** 是否允许多选 default is @(YES) */
@property (nonatomic, strong, getter=isAllowMutiSelect) NSNumber *allowMutiSelect;
/** 是否允许收起 default is @(YES) */
@property (nonatomic, strong, getter=isAllowPackUp) NSNumber *allowPackUp;
/** 是否已收起 default is @(NO) */
@property (nonatomic, strong, getter=isPackUp) NSNumber *packUp;
/** 收起后保留的行数 default is @(2) */
@property (nonatomic, strong) NSNumber *rowForPackUp;
/** 起始区间(如最低价、开始时间,非区间样式无需设置,下同) */
@property (nonatomic, copy) NSString *intervalStart;
/** 结束区间(如最高价、结束时间) */
@property (nonatomic, copy) NSString *intervalEnd;
/** 区间值是否为输入(价格为输入，时间一般为选择) default is @(YES) */
@property (nonatomic, strong) NSNumber *intervalIsInput;

#pragma mark - 页面属性
/** 分组的cell高度 */
@property (nonatomic, assign) CGFloat height;
/** 选项的行数 */
@property (nonatomic, assign) NSInteger row;

/**
 计算各分组高度height、行数row及选项宽度
 */
- (void)calculateSize;

@end

NS_ASSUME_NONNULL_END
