//
//  Patroltems.h
//  Frame
//
//  Created by hibayWill on 2018/3/29.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Patroltems : NSObject


@property double createTime;
@property double lastUpdateTime;
@property double patrolTime;

@property (copy, nonatomic) NSString*  id;
@property (copy, nonatomic) NSString*  patrolName;
@property (copy, nonatomic) NSString*  firstTitle;
@property (copy, nonatomic) NSString*  result;
@property (copy, nonatomic) NSString*  stationCode;
@property (copy, nonatomic) NSString*  stationName;
@property (copy, nonatomic) NSString*  status;
@property (copy, nonatomic) NSString*  typeCode;
@property (copy, nonatomic) NSString*  typeName;


@property (copy, nonatomic) NSString*  operatorId;
@property (copy, nonatomic) NSString*  patrolCode;
@property (copy, nonatomic) NSString*  tagValue;
@property (copy, nonatomic) NSString*  title;
@property (copy, nonatomic) NSString*  type;
@property (copy, nonatomic) NSString*  value;



@property (copy, nonatomic) NSString*  address;
@property (copy, nonatomic) NSString*  airport;
@property (copy, nonatomic) NSString*  alias;
@property (copy, nonatomic) NSString*  code;
@property (copy, nonatomic) NSString*  desc;

@property (copy, nonatomic) NSString*  picture;


/** 头部标题 */
@property (copy, nonatomic) NSString*  name;
/** 尾部标题 */
@property (copy, nonatomic) NSString*  post;
@property (copy, nonatomic) NSString*  body;
@property (copy, nonatomic) NSString*  sendtime;
@property (copy, nonatomic) NSString*  message;
@property (copy, nonatomic) NSString*  faceurl;
@property (copy, nonatomic) NSArray*  imgurls;
@property (copy, nonatomic) NSString*  specialName;
@property (copy, nonatomic) NSString*  specialCode;

@property  int  tid;
@property  int  cellHeight;
@property  int  labelHeight;

@end
