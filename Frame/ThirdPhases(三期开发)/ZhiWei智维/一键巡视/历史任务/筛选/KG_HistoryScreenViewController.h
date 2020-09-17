//
//  KG_NewScreenViewController.h
//  Frame
//
//  Created by zhangran on 2020/8/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_HistoryScreenViewController : UIViewController

@property (nonatomic, copy) NSString             *roomStr;
@property (nonatomic, copy) NSString             *taskStr;
@property (nonatomic, copy) NSString             *taskStatusStr;
@property (nonatomic, copy) NSString             *equipTypeStr;
@property (nonatomic, copy) NSString             *alarmLevelStr;
@property (nonatomic, copy) NSString             *alarmStatusStr;
@property (nonatomic, copy) NSString             *startTime;
@property (nonatomic, copy) NSString             *endTime;
@property (nonatomic ,strong) void(^confirmBlockMethod)(NSString *taskStr,NSString *roomStr,NSString *taskStausStr, NSString *startTimeStr,NSString *endTimeStr,NSArray *roomArray);
@end

NS_ASSUME_NONNULL_END
