//
//  RS_ConditionSearchTableViewCell.h
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/7/1.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RS_ConditionSearchModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,RS_ConditionSearchIntervalType) {
    RS_ConditionSearchIntervalTypeStart = 0,
    RS_ConditionSearchIntervalTypeEnd
};

@interface RS_ConditionSearchTableViewCell : UITableViewCell

@property (nonatomic, strong) RS_ConditionSearchModel *model;
@property (nonatomic, copy) void (^intervalTextFieldEditingChanged)(NSString *text, RS_ConditionSearchIntervalType type);
@property (nonatomic, copy) void (^intervalTextFieldClick)(RS_ConditionSearchIntervalType type);

@end

NS_ASSUME_NONNULL_END
