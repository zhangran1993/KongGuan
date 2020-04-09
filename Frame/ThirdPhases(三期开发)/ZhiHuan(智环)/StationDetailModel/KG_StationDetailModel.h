//
//  KG_StationDetailModel.h
//  Frame
//
//  Created by zhangran on 2020/4/7.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_StationDetailModel : NSObject

@property (nonatomic ,strong) NSArray *roomList;
@property (nonatomic ,strong) NSDictionary *weather;


@property (nonatomic ,strong) NSDictionary *environmentStatus;
@property (nonatomic ,strong) NSDictionary *powerStatus;
@property (nonatomic ,strong) NSDictionary *equipmentStatus;
@property (nonatomic ,strong) NSDictionary *securityStatus;


@property (nonatomic ,strong) NSDictionary *station;

@property (nonatomic ,strong) NSArray *enviromentDetails;
@property (nonatomic ,strong) NSArray *powerDetails;
@property (nonatomic ,strong) NSArray *equipmentDetails;
@property (nonatomic ,strong) NSArray *securityDetails;
@end

NS_ASSUME_NONNULL_END
