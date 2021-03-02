//
//  KG_CreateReportAlertView.h
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_RunManagerDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_CreateReportAlertView : UIView

@property (nonatomic ,strong) void(^selTimeBlockMethod)(NSInteger tag);
@property (nonatomic ,strong) void(^confirmBlockMethod)(handoverPositionInfoModel *dataDic,NSString *endTime);
@property (nonatomic ,strong) void(^changeTimeBlockMethod)(handoverPositionInfoModel *dataDic,NSString *endTime);
- (instancetype)initWithCondition:(KG_RunManagerDetailModel *)condition;
@end


NS_ASSUME_NONNULL_END
