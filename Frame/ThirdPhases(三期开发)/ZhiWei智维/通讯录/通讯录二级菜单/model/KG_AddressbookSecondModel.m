//
//  KG_AddressbookModel.m
//  Frame
//
//  Created by zhangran on 2020/9/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_AddressbookSecondModel.h"

@implementation secorgInfo

@end

@implementation seccontacts

@end


@implementation KG_AddressbookSecondModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"contacts" : [seccontacts class],
             @"orgInfo" : [secorgInfo class]
             
    };
}
@end
