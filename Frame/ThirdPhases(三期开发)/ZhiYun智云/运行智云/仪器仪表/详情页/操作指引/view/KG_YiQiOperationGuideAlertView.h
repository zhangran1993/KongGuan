//
//  KG_YiQiOperationGuideAlertView.h
//  Frame
//
//  Created by zhangran on 2020/9/24.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_YiQiOperationGuideAlertView : UIView

- (instancetype)initWithDataArray:(NSArray *)dataArray;

@property (nonatomic,strong) void(^selTypeStr)(NSString *typeStr,NSString *nameStr);

@end

NS_ASSUME_NONNULL_END
