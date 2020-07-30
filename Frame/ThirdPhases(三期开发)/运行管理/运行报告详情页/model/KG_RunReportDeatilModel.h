//
//  KG_RunReportDeatilModel.h
//  Frame
//
//  Created by zhangran on 2020/6/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_RunReportDeatilModel : NSObject

@property (nonatomic ,strong) NSDictionary    *info;

@property (nonatomic ,strong) NSArray         *changeShifts;

@property (nonatomic ,strong) NSArray         *runPrompt;

@property (nonatomic ,strong) NSArray         *autoAlarm;

@property (nonatomic ,strong) NSArray         *manualAlarm;

@property (nonatomic ,strong) NSArray         *changeManagement;

@property (nonatomic ,strong) NSArray         *otherAlarm;

@end

NS_ASSUME_NONNULL_END
