//
//  UserManager.h
//  ylh-app-primary-ios
//
//  Created by 巨商汇 on 2018/9/19.
//  Copyright © 2018年 巨商汇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Single.h"

@interface UserManager : NSObject

interfaceSingle(UserManager)

/**  用户信息 */
@property (nonatomic, assign) BOOL loginSuccess;

@property(nonatomic, strong) NSDictionary *currentStationDic;

@property(nonatomic, strong) NSArray *stationList;

//执行负责人
@property(nonatomic, strong) NSArray *exeHeadArr;

//执行负责人
@property(nonatomic, strong) NSArray *executiveList;

//获取任务状态字典接口
@property(nonatomic, strong) NSArray *taskStatusArr;

@property (nonatomic, copy) NSString *userID;

@property(nonatomic, strong) NSArray *leaderNameArray;

//是否是在删除图片或者是上传图片  智修界面用到
@property (nonatomic, assign) BOOL isDeletePicture;
//智维当前点击的segment的是第几个
@property(nonatomic, assign) NSInteger  zhiweiSegmentCurIndex;


@property(nonatomic, assign) BOOL isChangeTask;


//智维获取详情  的 remarkDic
@property(nonatomic, strong) NSDictionary *remarkDic;

//智维获取详情  的 resultDic
@property(nonatomic, strong) NSDictionary *resultDic;
//门禁当前点击的segment的是第几个
@property(nonatomic, assign) NSInteger  accessSegmentCurIndex;
- (void)saveStationData:(NSDictionary *)dataD ;
    

@end
