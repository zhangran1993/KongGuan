//
//  StationMachineDetailMoreController.h
//  Frame
//
//  Created by zhangran on 2020/1/7.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StationMachineDetailMoreController : UIViewController


@property (strong, nonatomic) NSDictionary * machineDetail;
@property (copy, nonatomic) NSString * naviTitleString;

@property (strong, nonatomic) NSArray *alarmArray;
@end


NS_ASSUME_NONNULL_END
