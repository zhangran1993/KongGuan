//
//  PersonModel.h
//  Frame
//
//  Created by centling on 2018/12/5.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TelModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PersonModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) TelModel *value;
@end

NS_ASSUME_NONNULL_END
