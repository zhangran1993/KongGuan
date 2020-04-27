//
//  KG_MachineDetailModel.h
//  Frame
//
//  Created by zhangran on 2020/4/14.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface equipmentDetailsModel : NSObject

@property(strong,nonatomic ) NSDictionary *equipment;

@property(strong,nonatomic ) NSDictionary *equipmentTagsTrend;

@property(strong,nonatomic ) NSArray *equipmentAlarmInfo;
@property(strong,nonatomic ) NSArray *equipmentWarningInfo;

@property(copy,nonatomic ) NSString  *level;
@property(copy,nonatomic ) NSString  *num ;
@property(copy,nonatomic ) NSString  *status ;

@end
@interface KG_MachineDetailModel : NSObject

@property(strong,nonatomic ) NSDictionary *totalDetail;

@property(strong,nonatomic ) NSArray <equipmentDetailsModel*> *equipmentDetails;


@end

NS_ASSUME_NONNULL_END
