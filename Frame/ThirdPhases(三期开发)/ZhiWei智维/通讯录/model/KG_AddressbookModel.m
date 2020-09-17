//
//  KG_AddressbookModel.m
//  Frame
//
//  Created by zhangran on 2020/9/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_AddressbookModel.h"

@implementation orgInfo

@end

@implementation contacts

@end


@implementation KG_AddressbookModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"contacts" : [contacts class],
             @"orgInfo" : [orgInfo class]
             
    };
}
@end
