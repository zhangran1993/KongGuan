//
//  KG_DutyManageSelModel.h
//  Frame
//
//  Created by zhangran on 2021/1/28.
//  Copyright © 2021 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_DutyManageSelModel : NSObject


@property (nonatomic,strong)   NSArray    *atcPatrolLabelList;

@property (nonatomic,strong)   NSArray    *atcPatrolMediaList;

@property (nonatomic,strong)   NSArray    *atcPatrolRoomList;
@property (nonatomic,strong)   NSArray    *atcPatrolWorkList;
@property (nonatomic,strong)   NSArray    *atcSpecialTagList;

@property (nonatomic,copy)     NSString   *createTime;



@property (nonatomic,copy)     NSString   *deleted;
@property (nonatomic,copy)     NSString   *description;
@property (nonatomic,copy)     NSString   *engineRoomName;
@property (nonatomic,copy)     NSString   *equipmentCode;
@property (nonatomic,copy)     NSString   *equipmentTypeCode;
@property (nonatomic,copy)     NSString   *fileUrl;
@property (nonatomic,copy)     NSString   *id;
@property (nonatomic,copy)     NSString   *inspectCompany;
@property (nonatomic,copy)     NSString   *inspectInterval;
@property (nonatomic,copy)     NSString   *inspectResult;
@property (nonatomic,copy)     NSString   *lastUpdateTime;
@property (nonatomic,copy)     NSString   *leaderName;
@property (nonatomic,copy)     NSString   *operatorId;
@property (nonatomic,copy)     NSString   *patrolCode;
@property (nonatomic,copy)     NSString   *patrolId;
@property (nonatomic,copy)     NSString   *patrolIntervalTime;
@property (nonatomic,copy)     NSString   *patrolName;
@property (nonatomic,copy)     NSString   *patrolTime;
@property (nonatomic,copy)     NSString   *patrolTimeDetail;
@property (nonatomic,copy)     NSString   *planFinishTime;


@property (nonatomic,copy)     NSString   *planStartTime;
@property (nonatomic,copy)     NSString   *remark;
@property (nonatomic,copy)     NSString   *result;
@property (nonatomic,copy)     NSString   *specialCode;
@property (nonatomic,copy)     NSString   *specialName;

@property (nonatomic,copy)     NSString   *stationCode;
@property (nonatomic,copy)     NSString   *stationName;
@property (nonatomic,copy)     NSString   *status;
@property (nonatomic,copy)     NSString   *statusName;
@property (nonatomic,copy)     NSString   *tagStringList;

@property (nonatomic,copy)     NSString   *taskName;
@property (nonatomic,copy)     NSString   *taskType;
@property (nonatomic,copy)     NSString   *typeCode;
@property (nonatomic,copy)     NSString   *typeName;


@property (nonatomic,assign)   BOOL       isSelect;
@end

NS_ASSUME_NONNULL_END
