//
//  UserManager.m
//  ylh-app-primary-ios
//
//  Created by 巨商汇 on 2018/9/19.
//  Copyright © 2018年 巨商汇. All rights reserved.
//

#import "UserManager.h"


@interface UserManager()

@end
@implementation UserManager

implementationSingle(UserManager)

- (void)saveStationData:(NSDictionary *)dataD {
       
    
    [UserManager shareUserManager].currentStationDic = dataD;
  
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataD forKey:@"station"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   
    
}
@end
