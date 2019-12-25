//
//  ValueClassModel.h
//  Frame
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ValueClassModel : NSObject
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *operatorId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *code;
@property (nonatomic, copy)NSString *alias;
@property (nonatomic, copy)NSString *category;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *airport;
@property (nonatomic, copy)NSString *level;
@end

NS_ASSUME_NONNULL_END
