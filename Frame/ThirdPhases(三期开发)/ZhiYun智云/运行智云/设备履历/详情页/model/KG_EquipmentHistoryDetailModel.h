//
//  KG_EquipmentHistoryDetailModel.h
//  Frame
//
//  Created by zhangran on 2020/10/13.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_EquipmentHistoryDetailModel : NSObject

//设备故障事件
@property (nonatomic ,strong) NSArray * equipmentFailureList;

//设备告警记录
@property (nonatomic ,strong) NSArray * equipmentWarnRecordList;
//设备调整记录
@property (nonatomic ,strong) NSArray * equipmentAdjustList;
//技术资料
@property (nonatomic ,strong) NSArray * technicalInformationList;
//巡视
@property (nonatomic ,strong) NSArray * xunShiList;
//维护
@property (nonatomic ,strong) NSArray * weiHuList;
//特殊保障
@property (nonatomic ,strong) NSArray * specialGuaranteeList;

//备件统计
@property (nonatomic ,strong) NSArray * sparePartsStatistics;

//最后告警统计
@property (nonatomic ,strong) NSDictionary * lastestWarnDic;

//备件统计
@property (nonatomic ,strong) NSDictionary * sparePartsStatisticsDic;

@end

NS_ASSUME_NONNULL_END
