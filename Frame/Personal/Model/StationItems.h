//
//  StationItems.h
//  Frame
//
//  Created by hibayWill on 2018/3/16.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationItems : NSObject

/** 头部标题 */
@property (copy, nonatomic) NSString*  address;
@property (copy, nonatomic) NSString*  airport;
@property (copy, nonatomic) NSString*  airPort;
@property (copy, nonatomic) NSString*  alarmDisplay;
@property (copy, nonatomic) NSString*  alias;
@property (copy, nonatomic) NSString*  category;
@property (copy, nonatomic) NSString*  code;
@property (copy, nonatomic) NSString*  stationCode;
@property (copy, nonatomic) NSString*  specialCode;
@property (copy, nonatomic) NSString*  name;
@property (copy, nonatomic) NSString*  stationName;
@property (copy, nonatomic) NSString*  level;
@property (strong, nonatomic) NSArray*  content;
@property (copy, nonatomic) NSString*  warningId;
@property (copy, nonatomic) NSString* alarmStatus;
@property (copy, nonatomic) NSString* type;
@property (copy, nonatomic) NSArray*  environmentStatus;
@property (copy, nonatomic) NSArray*  powerStatus;
@property (copy, nonatomic) NSArray*  equipmentStatus;

@property (copy, nonatomic) NSString*  points;
@property int  num;
@property int  LabelHeight;
@property int  realTimeValue;
@property double  time;

@property long  createTime;
@property (copy, nonatomic) NSString*  desc;
@property (copy, nonatomic) NSString*  id;
@property (copy, nonatomic) NSString*  lastUpdateTime;
@property (copy, nonatomic) NSString*  PatrolTime;
@property (copy, nonatomic) NSString*  latitude;
@property (copy, nonatomic) NSString*  longitude;
@property (copy, nonatomic) NSString*  nearField;
@property (copy, nonatomic) NSString*  operatorId;
@property (copy, nonatomic) NSString*  picture;
@property (copy, nonatomic) NSString*  status;
@property (copy, nonatomic) NSString*  NowStatus;
@property (copy, nonatomic) NSString*  AirConditionNum;
@property (copy, nonatomic) NSArray*  airTagList;
@property (copy, nonatomic) NSString*  value;
@property (copy, nonatomic) NSString*  grade;
- (StationItems *)initWithDetailDic:(NSDictionary *)dic;

@end
