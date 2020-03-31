//
//  FrameScrollList.h
//  Frame
//
//  Created by zhangran on 2020/3/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrameScrollList : UIView

@property(nonatomic,copy) void(^sliderDown)(BOOL isSliderDown);

@property(nonatomic,copy) NSString *refreshData;

@property (nonatomic, copy) void (^watchVideo)(NSString *stationCode,NSString *stationName);
@end

NS_ASSUME_NONNULL_END
