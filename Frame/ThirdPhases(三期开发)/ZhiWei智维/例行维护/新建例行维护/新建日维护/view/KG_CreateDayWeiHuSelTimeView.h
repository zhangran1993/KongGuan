//
//  KG_CreateDayWeiHuSelTimeView.h
//  Frame
//
//  Created by zhangran on 2020/9/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_CreateDayWeiHuSelTimeView : UIView

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) void(^cancelBlockMethod)();
@property (nonatomic,strong) void(^saveBlockMethod)(NSString *timeStr);

@end

NS_ASSUME_NONNULL_END
