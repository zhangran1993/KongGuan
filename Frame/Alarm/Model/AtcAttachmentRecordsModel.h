//
//  AtcAttachmentRecordsModel.h
//  Frame
//
//  Created by centling on 2018/12/11.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AtcAttachmentRecordsModel : NSObject
@property (nonatomic, copy) NSString *attachmentCode;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deleted;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *lastUpdateTime;
@property (nonatomic, copy) NSString *operatorId;
@property (nonatomic, copy) NSString *participants;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) CGFloat textHeight;
@end

NS_ASSUME_NONNULL_END
