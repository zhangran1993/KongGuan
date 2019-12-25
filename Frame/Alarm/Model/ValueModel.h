//
//  ValueModel.h
//  Frame
//
//  Created by centling on 2018/12/5.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VenderModel.h"
#import "PersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ValueModel : NSObject

@property (nonatomic, strong) PersonModel *person;
@property (nonatomic, strong) VenderModel *vender;
@end

NS_ASSUME_NONNULL_END
