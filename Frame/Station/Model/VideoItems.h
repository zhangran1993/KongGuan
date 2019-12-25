//
//  VideoItems.h
//  Frame
//
//  Created by hibayWill on 2018/3/30.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoItems : NSObject

/** 头部标题 */
@property (copy, nonatomic) NSString*  name;
@property (copy, nonatomic) NSString*  roomName;
@property (copy, nonatomic) NSString*  account;
@property (copy, nonatomic) NSString*  lipic;
@property (copy, nonatomic) NSString*  ip;
@property (copy, nonatomic) NSString*  password;
@property (copy, nonatomic) NSString*  port;
@property  int channelId;
@property  int  vid;



/** 尾部标题 */
@property (copy, nonatomic) NSString*  type;
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
