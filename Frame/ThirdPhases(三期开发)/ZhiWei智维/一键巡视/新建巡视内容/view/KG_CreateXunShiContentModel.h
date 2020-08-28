//
//  KG_CreateXunShiContentModel.h
//  Frame
//
//  Created by zhangran on 2020/8/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_CreateXunShiContentModel : NSObject

@property (nonatomic ,copy) NSString *taskTitle;      //任务名称

@property (nonatomic ,copy) NSString *taskType;       //任务类型

@property (nonatomic ,copy) NSString *xunshiStation;  //巡视台站

@property (nonatomic ,copy) NSString *xunshiRoom;     //巡视机房

@property (nonatomic ,copy) NSString *selTime;        //时间选择

@property (nonatomic ,copy) NSString *realPerson;     //执行负责人



@end

NS_ASSUME_NONNULL_END
