//
//  KG_CaseLibraryDetailModel.h
//  Frame
//
//  Created by zhangran on 2020/10/15.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_CaseLibraryDetailModel : NSObject

@property (nonatomic ,copy) NSString *id   ;

@property (nonatomic ,copy) NSString *createTime   ;

@property (nonatomic ,copy) NSString *operatorId   ;

@property (nonatomic ,copy) NSString *lastUpdateTime   ;

@property (nonatomic ,copy) NSString *description   ;

@property (nonatomic ,copy) NSString *deleted   ;

@property (nonatomic ,copy) NSString *name   ;

@property (nonatomic ,copy) NSString *type   ;

@property (nonatomic ,copy) NSString *typeName   ;

@property (nonatomic ,copy) NSString *equipmentCategory   ;


@property (nonatomic ,copy) NSString *equipmentCategoryName   ;

@property (nonatomic ,copy) NSString *grade   ;

@property (nonatomic ,copy) NSString *picture   ;//图片的URL地址

@property (nonatomic ,copy) NSString *reason   ; //可能原因分析

@property (nonatomic ,strong) NSArray *caseLabelList   ;//设备标签

@property (nonatomic ,strong) NSArray *caseModelList   ; //适用型号

@property (nonatomic ,strong) NSArray *referenceFileList;//参考文件列表

@property (nonatomic ,strong) NSArray *handleMethodList;


@end

NS_ASSUME_NONNULL_END
