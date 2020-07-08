//
//  KG_XunShiReportDetailModel.h
//  Frame
//
//  Created by zhangran on 2020/4/24.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface taskDetail : NSObject
@property (nonatomic ,copy)   NSString *infoId;
@property (nonatomic ,copy)   NSString *levelCode;
@property (nonatomic ,copy)   NSString *parentId;
@property (nonatomic ,copy)   NSString *measureTagCode;
@property (nonatomic ,copy)   NSArray *childrens;
@property (nonatomic ,copy)   NSString *measureTagName;
@property (nonatomic ,copy)   NSString *title;
@property (nonatomic ,copy)   NSString *type;
@property (nonatomic ,copy)   NSString *value;
@property (nonatomic ,copy)   NSString *selectType;
@property (nonatomic ,copy)   NSString *systemCategory;


@property (nonatomic ,copy)   NSString *equipmentCode;
@property (nonatomic ,copy)   NSString *equipmentName;
@property (nonatomic ,copy)   NSString *unit;
@property (nonatomic ,copy)   NSString *unit1;
@property (nonatomic ,copy)   NSString *eChartsY;
@property (nonatomic ,copy)   NSString *atcSpecialTag;
@property (nonatomic ,copy)   NSString *eChartsX;
@property (nonatomic ,copy)   NSString *echarts;
@property (nonatomic ,copy)   NSString *operationalGuidelines;

@property (nonatomic ,copy)   NSString *engineRoomCode;
@property (nonatomic ,copy)   NSString *engineRoomName;
@property (nonatomic ,copy)   NSString *stationCode;
@property (nonatomic ,copy)   NSString *stationName;
@property (nonatomic ,copy)   NSString *measureValueAlias;
@property (nonatomic ,copy)   NSString *alarmContent;
@property (nonatomic ,copy)   NSString *annotation;
@property (nonatomic ,copy)   NSString *remark;
@property (nonatomic ,copy)   NSString *levelMax;

  
@property (nonatomic ,copy)   NSString *parent;
@property (nonatomic ,copy)   NSString *special;
@property (nonatomic ,copy)   NSString *children;
@property (nonatomic ,copy)   NSString *cardDisplay;
@property (nonatomic ,copy)   NSString *tendency;
@property (nonatomic ,copy)   NSString *inputEnd;
@property (nonatomic ,strong) NSDictionary  *systemAndEquipmentInfo;
           
@end

@interface KG_XunShiReportDetailModel : NSObject

@property (nonatomic ,copy)NSString * taskRange;

@property (nonatomic ,copy)   NSString * showFullTime;
@property (nonatomic ,copy)   NSString * taskDescription;
@property (nonatomic ,copy)   NSString * patrolName;
@property (nonatomic ,copy)   NSString * taskName;

@property (nonatomic ,copy)   NSString * taskLastUpdateTime;
@property (nonatomic ,copy)   NSString * taskId;
@property (nonatomic ,copy)   NSString * taskStatus;
@property (nonatomic ,copy)   NSString * taskTime;
@property (nonatomic ,strong) NSArray  * workPersonName;
@property (nonatomic ,strong) NSArray  *label;
@property (nonatomic ,strong) NSArray  <taskDetail *> *task;
@end

NS_ASSUME_NONNULL_END
