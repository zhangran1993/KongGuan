//
//  KG_AddressbookModel.h
//  Frame
//
//  Created by zhangran on 2020/9/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface contacts : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *userAccount;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *enabled;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *companyId;
@property (nonatomic,copy) NSString *deptId;
@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,copy) NSString *orgId;
@property (nonatomic,copy) NSString *orgName;
@property (nonatomic,copy) NSString *lastLoginDate;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *contactLevel;
@property (nonatomic,copy) NSString *hang;
@property (nonatomic,copy) NSString *expert;
@property (nonatomic,copy) NSString *role;
@property (nonatomic,copy) NSString *station;
@property (nonatomic,copy) NSString *specificStationCode;
@property (nonatomic,copy) NSString *userSource;
@property (nonatomic,copy) NSString *areaCode;
@property (nonatomic,copy) NSString *leader;
@property (nonatomic,copy) NSString *sync;

@end

@interface orgInfo : NSObject

@property (nonatomic,copy) NSString *orgName;
@property (nonatomic,copy) NSString *userSize;
@property (nonatomic,strong) NSArray *subOrgInfo;
@property (nonatomic,copy) NSString *orgId;

@end

@interface KG_AddressbookModel : NSObject



@property (nonatomic,strong) NSArray <orgInfo *>*orgInfo;

@property (nonatomic,strong) NSArray <contacts *>*contacts;
@end

NS_ASSUME_NONNULL_END
