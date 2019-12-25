//
//  EquipmentDetailsModel.h
//  Frame
//
//  Created by centling on 2018/12/3.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EquipmentDetailsModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger status;
@end

NS_ASSUME_NONNULL_END
