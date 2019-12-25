//
//  CurriculumVitaeModel.h
//  Frame
//
//  Created by centling on 2018/12/11.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtcAttachmentRecordsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CurriculumVitaeModel : NSObject
@property (nonatomic, strong) AtcAttachmentRecordsModel *atcAttachmentRecords;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deleted;
@property (nonatomic, copy) NSString *engineRoomCode;
@property (nonatomic, copy) NSString *equipmentCode;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *keeper;
@property (nonatomic, copy) NSString *lastUpdateTime;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *operatorId;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *stationCode;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *storageLocation;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign)CGFloat textHeight;
@end

NS_ASSUME_NONNULL_END
