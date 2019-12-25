//
//  AlarmUserItems.h
//  Frame
//
//  Created by hibayWill on 2018/5/8.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmUserItems : NSObject

@property (copy, nonatomic) NSString*  userAccount;
@property (copy, nonatomic) NSString*  id;
/** 尾部标题 */
@property (copy, nonatomic) NSString*  name;
@property (copy, nonatomic) NSString*  type;
@property double  createDate;
@property bool hangupStatus;
@property double createTime;
@property double lastUpdateTime;

@property double operatorId;
@property (copy, nonatomic) NSString*  contactLevel;
@property (copy, nonatomic) NSString*  tel;
@property (copy, nonatomic) NSString*  email;
@property (copy, nonatomic) NSString*  remark;
@property (copy, nonatomic) NSString*  powerLevel;
@property (copy, nonatomic) NSString*  stationName;
@property (copy, nonatomic) NSString*  engineRoomName;
@property (copy, nonatomic) NSString*  engineRoomCode;
@property (copy, nonatomic) NSString*  equipmentName;
@property (copy, nonatomic) NSString*  equipmentCode;
@property (copy, nonatomic) NSString*  equipmentGroup;
@property (copy, nonatomic) NSString*  equipmentType;
@property (copy, nonatomic) NSString*  stationCode;
@property (copy, nonatomic) NSString*  tagName;
@property (copy, nonatomic) NSString*  measureTagName;
@property (copy, nonatomic) NSString*  measureTagCode;
@property (copy, nonatomic) NSString*  realTimeValueAlias;
@property  int  realTimeValue;
@property (copy, nonatomic) NSArray*  imgurls;


@end


