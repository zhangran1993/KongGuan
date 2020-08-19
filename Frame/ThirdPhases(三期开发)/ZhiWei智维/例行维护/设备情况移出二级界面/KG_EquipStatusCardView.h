//
//  KG_EquipStatusCardView.h
//  Frame
//
//  Created by zhangran on 2020/8/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "KG_XunShiReportDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_EquipStatusCardView : UIView

@property (nonatomic ,strong) NSArray *listArray;
@property (strong, nonatomic) KG_XunShiReportDetailModel *dataModel;

@property (nonatomic ,strong) NSDictionary *dataDic;
@property (nonatomic,copy) void(^moreBlockMethod)(NSDictionary *dataDic);
@property (nonatomic ,strong) void (^saveSuccessBlock)();
@end

NS_ASSUME_NONNULL_END
