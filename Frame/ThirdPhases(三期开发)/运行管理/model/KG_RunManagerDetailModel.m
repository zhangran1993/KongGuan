//
//  KG_RunManagerDetailModel.m
//  Frame
//
//  Created by zhangran on 2021/2/19.
//  Copyright © 2021 hibaysoft. All rights reserved.
//

#import "KG_RunManagerDetailModel.h"

@implementation succeedPositionInfoModel


@end

@implementation handoverPositionInfoModel


@end

@implementation KG_RunManagerDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"succeedPositionInfo" : [succeedPositionInfoModel class],
             @"handoverPositionInfo" : [handoverPositionInfoModel class]
    };
}

@end
