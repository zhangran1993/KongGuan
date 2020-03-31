//
//  KG_ScrollListDetailModel.h
//  Frame
//
//  Created by zhangran on 2020/3/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_ScrollListDetailModel : NSObject

@property (nonatomic,copy)    NSString *enviromentDetails;
@property (nonatomic,strong)  NSDictionary *environmentStatus;
@property (nonatomic,copy)    NSString *equipmentDetails;
@property (nonatomic,strong)  NSDictionary *equipmentStatus;
@property (nonatomic,copy)    NSString *powerDetails;
@property (nonatomic,strong)  NSDictionary *powerStatus;
@property (nonatomic,copy)    NSString *roomList;
@property (nonatomic,copy)    NSString *securityDetails;
@property (nonatomic,strong)  NSDictionary *securityStatus;
@property (nonatomic,strong)  NSDictionary *station;
@property (nonatomic,strong)  NSString *weather;
@end


NS_ASSUME_NONNULL_END
