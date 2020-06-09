//
//  KG_RunManagerFirstCell.h
//  Frame
//
//  Created by zhangran on 2020/6/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_RunManagerFirstCell : UITableViewCell

@property (nonatomic, strong)  NSArray    *stationTaskInfoArr;//台站任务提醒

@property (nonatomic, strong) void(^watchTotal)();
@end

NS_ASSUME_NONNULL_END
