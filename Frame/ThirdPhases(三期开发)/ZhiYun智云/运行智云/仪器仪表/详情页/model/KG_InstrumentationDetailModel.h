//
//  KG_InstrumentationDetailModel.h
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_InstrumentationDetailModel : NSObject


@property (nonatomic ,copy) NSString *batch;

@property (nonatomic ,copy) NSString *code;

@property (nonatomic ,copy) NSString *componentNumber;

@property (nonatomic ,copy) NSString *createTime;

@property (nonatomic ,copy) NSString *cycle;

@property (nonatomic ,copy) NSString *deleted;

@property (nonatomic ,copy) NSString *description;

@property (nonatomic ,strong) NSArray *fileList;

@property (nonatomic ,copy) NSString *id;

@property (nonatomic ,copy) NSString *introduce;

@property (nonatomic ,copy) NSString *lastUpdateTime;

@property (nonatomic ,copy) NSString *manufactor;

@property (nonatomic ,copy) NSString *model;

@property (nonatomic ,copy) NSString *name;

@property (nonatomic ,copy) NSString *operatorId;

@property (nonatomic ,copy) NSString *picture;

@property (nonatomic ,copy) NSString *productTime;

@property (nonatomic ,strong) NSArray *recordList;

@property (nonatomic ,copy) NSString *serialNumber;

@property (nonatomic ,copy) NSString *status;

@property (nonatomic ,copy) NSString *stockLocation;

@property (nonatomic ,copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
