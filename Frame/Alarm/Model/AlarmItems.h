//
//  AlarmItems.h
//  Frame
//
//  Created by hibayWill on 2018/4/4.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmItems : NSObject

@property (copy, nonatomic) NSString*  name;
@property (copy, nonatomic) NSString*  id;
/** 尾部标题 */
@property (copy, nonatomic) NSString*  type;
@property (copy, nonatomic) NSString*  position;
@property double  createTime;
@property bool hangupStatus;
@property (copy, nonatomic) NSString*  status;
@property (copy, nonatomic) NSString*  desc;
@property (copy, nonatomic) NSString*  machine;
@property (strong, nonatomic) NSString*  level;
@property (copy, nonatomic) NSString*  power;
@property (copy, nonatomic) NSString*  content;

@property (copy, nonatomic) NSString*  powerLevel;
@property (copy, nonatomic) NSString*  stationName;
@property (copy, nonatomic) NSString*  engineRoomName;
@property (copy, nonatomic) NSString*  equipmentName;
@property (copy, nonatomic) NSString*  equipmentType;
@property (copy, nonatomic) NSString*  measureTagName;
@property (copy, nonatomic) NSString*  measureTagCode;
@property (copy, nonatomic) NSString*  realTimeValueAlias;
@property (copy, nonatomic) NSArray*  imgurls;
@property (copy, nonatomic) NSString*  code;
@property (copy, nonatomic) NSString*  category;
@property (copy, nonatomic) NSString*  num;
@property (copy, nonatomic) NSString*  model;
@property (copy, nonatomic) NSString*  userName;

/*
"id":"fc3e5147788d41988e3d7de4f5800d88",//告警id                     "createTime":1523522599000,//创建时间                     "lastUpdateTime":null,                     "operatorId":null,                     "description":null,                     "deleted":false,                     "stationName":"荣城",//台站名称                     "engineRoomName":"安防机房",//机房名称                     "equipmentName":"安防设备",//设备名称                     "equipmentType":"－－",//设备类型                     "measureTagName":"红外2",//测点名称                     "measureTagCode":"HB-ACC-A100-2",//测点编码                     "content":"",                     "level":"1",//告警等级                     "status":"unconfirmed",//告警状态                     "type":"switchOff",//告警类型（开关量，模拟量）                     "realTimeValue":0,//告警实时值（暂时不用）                     "realTimeValueAlias":"0",//告警实时值                     "hangupStatus":false,//告警挂起标识                     "isRead":null,                     "atcAlarmHandleRecordList":null 
 */

@property  int  tid;


@end

