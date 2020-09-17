//
//  KG_XunShiSelTimeView.h
//  Frame
//
//  Created by zhangran on 2020/9/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_XunShiSelTimeView : UIView

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) void(^cancelBlockMethod)();
@property (nonatomic,strong) void(^saveBlockMethod)(NSString *timeStr);
@end

NS_ASSUME_NONNULL_END
