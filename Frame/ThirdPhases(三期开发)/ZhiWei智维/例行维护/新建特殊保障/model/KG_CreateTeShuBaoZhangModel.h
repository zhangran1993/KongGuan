//
//  KG_CreateTeShuBaoZhangModel.h
//  Frame
//
//  Created by zhangran on 2020/9/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_CreateTeShuBaoZhangModel : NSObject


@property (nonatomic ,copy) NSString *taskTitle;      //任务名称

@property (nonatomic ,copy) NSString *taskType;       //任务类型

@property (nonatomic ,copy) NSString *xunshiStation;  //巡视台站

@property (nonatomic ,copy) NSString *xunshiRoom;     //巡视机房

@property (nonatomic ,assign) NSInteger xunshiSelIndex;

@property (nonatomic ,copy) NSString *xunshiRoomCode;     //巡视机房

@property (nonatomic ,copy) NSString *xunshiRoomID;     //巡视机房ID

@property (nonatomic ,copy) NSString *selTime;        //时间选择

@property (nonatomic ,copy) NSString *realPersonName;     //执行负责人

@property (nonatomic ,copy) NSString *realPersonID;     //执行负责人


@property (nonatomic ,copy) NSString *reportTaskTypeCode;     //任务类型 特殊保障
@property (nonatomic ,copy) NSString *reportTaskTypeName;     //任务类型 特殊保障
@end

NS_ASSUME_NONNULL_END
