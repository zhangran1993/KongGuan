//
//  KG_StationFileDetailFirstCell.h
//  Frame
//
//  Created by zhangran on 2020/10/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_EquipmentHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_StationFileDetailFirstCell : UITableViewCell


@property (nonatomic ,strong) NSDictionary *dataDic ;


@property (nonatomic ,copy) NSString *healthStr ;

@property (nonatomic,strong) KG_EquipmentHistoryModel *dataModel;
@end

NS_ASSUME_NONNULL_END
