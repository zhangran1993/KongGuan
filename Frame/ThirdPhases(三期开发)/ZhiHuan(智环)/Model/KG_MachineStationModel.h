//
//  KG_MachineStationModel.h
//  Frame
//
//  Created by zhangran on 2020/4/13.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_MachineStationModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *operatorId;

@property (nonatomic, copy) NSString *lastUpdateTime;

@property (nonatomic, copy) NSString *description;

@property (nonatomic, copy) NSString *deleted;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *equipmentCode;
@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *unit;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *parameter;

@property (nonatomic, copy) NSString *alarmDisplay;

@property (nonatomic, copy) NSString *hidden;

@property (nonatomic, copy) NSString *emphasis;


@property (nonatomic, copy) NSString *alarmStatus;
@property (nonatomic, copy) NSString *stationCode;

@property (nonatomic, copy) NSString *picShow;

@property (nonatomic, copy) NSString *equipmentModel;

@property (nonatomic, copy) NSString *valueAlias;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *alarmLevel;
@property (nonatomic, copy) NSString *realTimeDataList;


@end

NS_ASSUME_NONNULL_END
