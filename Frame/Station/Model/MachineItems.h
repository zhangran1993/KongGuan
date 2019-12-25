//
//  MachineItems.h
//  Frame
//
//  Created by hibayWill on 2018/3/30.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface MachineItems : NSObject

/** 头部标题 */
@property (copy, nonatomic) NSString*  name;
@property (copy, nonatomic) NSString*  num;
@property (copy, nonatomic) NSString*  topLimit;
@property (copy, nonatomic) NSString*  bottomLimit;
@property (copy, nonatomic) NSString*  unit;
@property  bool  alarmStatus;
@property  bool  emphasis;
@property (copy, nonatomic) NSString *  tagValue;
@property (copy, nonatomic) NSString *  category;

@property  int  vid;
/** 尾部标题 */
@property (copy, nonatomic) NSString*  type;
@property (copy, nonatomic) NSString*  title;
@property (copy, nonatomic) NSString*  status;
@property (copy, nonatomic) NSString*  desc;
@property (copy, nonatomic) NSString*  body;
@property (copy, nonatomic) NSString*  sendtime;
@property (copy, nonatomic) NSString*  message;
@property (copy, nonatomic) NSString*  faceurl;
@property (copy, nonatomic) NSArray*  imgurls;


@property  int  id;
@property  int  tid;


@end
