//
//  KG_EmergencyTreatmentSecondCell.h
//  Frame
//
//  Created by zhangran on 2020/10/29.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_EmergencyTreatmentSecondCell : UITableViewCell


@property (nonatomic, strong) NSArray         *secondTopArray;


@property (nonatomic, strong) NSArray         *secondBotArray;

@property (nonatomic, strong) NSDictionary    *secondTopDic;

@property (nonatomic, strong) NSDictionary    *secondBotDic;


@property (nonatomic, strong) void (^pushToNextStep)(NSDictionary *dataDic,NSDictionary *totalDic);

@end

NS_ASSUME_NONNULL_END
