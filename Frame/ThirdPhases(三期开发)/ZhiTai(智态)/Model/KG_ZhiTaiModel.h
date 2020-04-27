//
//  KG_ZhiTaiModel.h
//  Frame
//
//  Created by zhangran on 2020/4/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface stationInfoDetail : NSObject
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString *airport;
@property (nonatomic, copy) NSString *alarmDisplay;
@property (nonatomic, copy) NSString *alarmStatus;
@property (nonatomic, copy) NSString *alias;
@property (nonatomic, copy) NSString *altitude;
@property (nonatomic, copy) NSString *atcEngineRoomList;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *clearanceRequirement;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *competentUnit;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deleted;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *environmentInformation;
@property (nonatomic, copy) NSString *equipmentGroupList;
@property (nonatomic, copy) NSString *equipmentList;
@property (nonatomic, copy) NSString *humidity;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *lastUpdateTime;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *lightningProtectionConfiguration;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nearField;
@property (nonatomic, copy) NSString *operatorId;
@property (nonatomic, copy) NSString *order;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *powerSupply;
@property (nonatomic, copy) NSString *productionDate;
@property (nonatomic, copy) NSString *protectionDistance;
@property (nonatomic, copy) NSString *serviceRadius;
@property (nonatomic, copy) NSString *sysStatus;
@property (nonatomic, copy) NSString *temperature;
@property (nonatomic, copy) NSString *useStatus;

@end

@interface KG_ZhiTaiModel : NSObject

@property (nonatomic, strong) NSArray *mainEquipmentDetails;

@property (nonatomic, strong) NSArray *roomDetails;
@property (nonatomic, strong) stationInfoDetail *stationInfo;
@end

NS_ASSUME_NONNULL_END
