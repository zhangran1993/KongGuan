//
//  KG_ZhiXiuModel.h
//  Frame
//
//  Created by zhangran on 2020/5/19.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_ZhiXiuModel : NSObject


@property (nonatomic ,copy) NSString *alarmDisplay ;
@property (nonatomic ,copy) NSString *alarmStatus ;
@property (nonatomic ,copy) NSString *alias;
@property (nonatomic ,copy) NSString *category;
@property (nonatomic ,copy) NSString *code;
@property (nonatomic ,copy) NSString *createTime;
@property (nonatomic ,copy) NSString *deleted;
@property (nonatomic ,copy) NSString *description;
@property (nonatomic ,strong) NSArray *equipmentGroupList;
@property (nonatomic ,strong) NSArray *equipmentList;
@property (nonatomic ,copy) NSString *id;
@property (nonatomic ,copy) NSString *lastUpdateTime;
@property (nonatomic ,copy) NSString *level;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *operatorId;
@property (nonatomic ,copy) NSString *order;
@property (nonatomic ,copy) NSString *picture;
@property (nonatomic ,copy) NSString *stationCode;
@property (nonatomic ,copy) NSString *xCoordinate ;
@property (nonatomic ,copy) NSString *yCoordinate;



@end

NS_ASSUME_NONNULL_END
