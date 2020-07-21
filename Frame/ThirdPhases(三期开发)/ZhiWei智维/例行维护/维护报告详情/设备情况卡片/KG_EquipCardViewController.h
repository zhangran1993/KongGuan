//
//  KG_EquipCardViewController.h
//  Frame
//
//  Created by zhangran on 2020/6/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_XunShiReportDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_EquipCardViewController : UIViewController

@property (nonatomic ,strong) NSArray *listArray;
@property (strong, nonatomic) KG_XunShiReportDetailModel *dataModel;

@property (nonatomic ,strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
