//
//  PersonalPatrolItems.h
//  Frame
//
//  Created by hibayWill on 2018/3/19.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalPatrolItems : NSObject

/** 头部标题 */
@property (copy, nonatomic) NSString*  name;
/** 尾部标题 */
@property (copy, nonatomic) NSString*  type;
@property (copy, nonatomic) NSString*  post;
@property (copy, nonatomic) NSString*  address;
@property (copy, nonatomic) NSString*  status;
@property (copy, nonatomic) NSString*  desc;
@property (copy, nonatomic) NSString*  createdate;
@property (copy, nonatomic) NSString*  position;
@property (copy, nonatomic) NSString*  faceurl;

@property  int  id;
@property  int  pid;


@end
