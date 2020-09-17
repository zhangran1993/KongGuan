//
//  KG_AddressbookThirdModel.m
//  Frame
//
//  Created by zhangran on 2020/9/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_AddressbookThirdModel.h"

@implementation thirdorgInfo

@end

@implementation thirdcontacts

@end


@implementation KG_AddressbookThirdModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"contacts" : [thirdcontacts class],
             @"orgInfo" : [thirdorgInfo class]
    };
}
@end
