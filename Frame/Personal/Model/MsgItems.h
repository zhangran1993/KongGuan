//
//  MsgItems.h
//  Frame
//
//  Created by hibayWill on 2018/3/31.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgItems : NSObject

@property double createTime;//时间
@property (copy, nonatomic) NSString*   id;
@property (copy, nonatomic) NSString*  engineRoomName;//机房
@property (copy, nonatomic) NSString*  equipmentName;//机器
@property (copy, nonatomic) NSString*  measureTagName;//测点
@property (copy, nonatomic) NSString*  stationName;//台站
@property (copy, nonatomic) NSString*  realTimeValueAlias;//测知
@property (copy, nonatomic) NSString*  level;//等级
@property (copy, nonatomic) NSString*  content;//等级

@property  int  isRead;




/** 头部标题 */
@property (copy, nonatomic) NSString*  name;
/** 尾部标题 */
@property (copy, nonatomic) NSString*  type;
@property (copy, nonatomic) NSString*  title;
@property int  status;
@property (copy, nonatomic) NSString*  desc;
@property (copy, nonatomic) NSString*  createdate;
@property (copy, nonatomic) NSString*  body;
@property (copy, nonatomic) NSString*  sendtime;
@property (copy, nonatomic) NSString*  message;
@property (copy, nonatomic) NSString*  faceurl;
@property (copy, nonatomic) NSArray*  imgurls;


@property int  LabelHeight;


@property  int  vid;


@end
