//
//  UserManager.h
//  ylh-app-primary-ios
//
//  Created by 巨商汇 on 2018/9/19.
//  Copyright © 2018年 巨商汇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Single.h"

@interface UserManager : NSObject

interfaceSingle(UserManager)

/**  用户信息 */
@property (nonatomic, assign) BOOL loginSuccess;

@property(nonatomic, strong) NSDictionary *currentStationDic;

@property(nonatomic, strong) NSArray *stationList;
@end
