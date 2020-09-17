//
//  KG_NewScreenCell.h
//  Frame
//
//  Created by zhangran on 2020/8/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_HistoryScreenCell : UICollectionViewCell

@property (nonatomic ,strong) NSDictionary *dataDic;

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) NSDictionary *roomDic;

@property (nonatomic, copy) NSString *str;


@property(nonatomic , copy) NSString *roomStr;
//设备类型
@property(nonatomic , copy) NSString *equipTypeStr;
//告警等级
@property(nonatomic , copy) NSString *alarmLevelStr;
//告警状态
@property(nonatomic , copy) NSString *alarmStatusStr;

//任务类型
@property (nonatomic, copy) NSString *taskTotalStr;

@property (nonatomic, copy) NSString *taskStr;

//任务状态
@property (nonatomic, copy) NSString *taskStatusTotalStr;

@property (nonatomic, copy) NSString *taskStatusStr;

@end

NS_ASSUME_NONNULL_END
