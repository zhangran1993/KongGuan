//
//  technicalManualListModel.h
//  Frame
//
//  Created by centling on 2018/12/4.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface technicalManualListModel : NSObject
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deleted;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *engineRoomCode;
@property (nonatomic, copy) NSString *equipmentCode;
@property (nonatomic, copy) NSString *equipmentName;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *lastUpdateTime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *operatorId;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *stationCode;
@property (nonatomic, copy) NSString *stationName;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *url;
@end

NS_ASSUME_NONNULL_END
