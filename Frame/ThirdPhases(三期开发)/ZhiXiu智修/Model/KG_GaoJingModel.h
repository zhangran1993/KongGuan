//
//  KG_GaoJingModel.h
//  Frame
//
//  Created by zhangran on 2020/5/19.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_GaoJingModel : NSObject


@property (nonatomic ,copy) NSString *alarmCode;
@property (nonatomic ,copy) NSString *category;
@property (nonatomic ,copy) NSString *checked ;
@property (nonatomic ,copy) NSString *controlInfluence;
@property (nonatomic ,copy) NSString *createTime;
@property (nonatomic ,copy) NSString *deleted;
@property (nonatomic ,copy) NSString *description ;
@property (nonatomic ,copy) NSString *deviceSeverity ;
@property (nonatomic ,copy) NSString *engineRoomCode;
@property (nonatomic ,copy) NSString *engineRoomName;
@property (nonatomic ,copy) NSString *equipmentCategory;
@property (nonatomic ,copy) NSString *equipmentCode ;
@property (nonatomic ,copy) NSString *equipmentGroup;
@property (nonatomic ,copy) NSString *equipmentName;
@property (nonatomic ,copy) NSString *eventReason;
@property (nonatomic ,copy) NSString *eventReasonList;
@property (nonatomic ,copy) NSString *eventType;
@property (nonatomic ,copy) NSString *faultInfo;
@property (nonatomic ,copy) NSString *faultInfoCode;
@property (nonatomic ,copy) NSString *hangupStatus;
@property (nonatomic ,copy) NSString *happenTime;
@property (nonatomic ,copy) NSString *id;
@property (nonatomic ,strong) NSArray *imageList;
@property (nonatomic ,strong) NSArray *labelsList;
@property (nonatomic ,copy) NSString *lastUpdateTime;
@property (nonatomic ,copy) NSString *level;
@property (nonatomic ,copy) NSString *manualType;
@property (nonatomic ,copy) NSString *measureTagCode;
@property (nonatomic ,copy) NSString *measureTagName ;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *operatorId;
@property (nonatomic ,copy) NSString *realTimeValue;
@property (nonatomic ,copy) NSString *realTimeValueAlias;
@property (nonatomic ,copy) NSString *recordDescription ;
@property (nonatomic ,copy) NSString *recordStatus;
@property (nonatomic ,copy) NSString *stationCode;
@property (nonatomic ,copy) NSString *stationName;
@property (nonatomic ,copy) NSString *status;
@property (nonatomic ,copy) NSString *systemEquipmentCode;
@property (nonatomic ,copy) NSString *systemEquipmentName;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *unit ;
@property (nonatomic ,strong) NSArray *videosList;

       
        
@end

NS_ASSUME_NONNULL_END
