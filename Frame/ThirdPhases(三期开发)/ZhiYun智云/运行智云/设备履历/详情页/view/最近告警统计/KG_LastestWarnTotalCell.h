//
//  KG_LastestWarnTotalCell.h
//  Frame
//
//  Created by zhangran on 2020/9/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_EquipmentHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_LastestWarnTotalCell : UITableViewCell


@property (nonatomic ,strong) NSArray *listArray ;

@property (nonatomic ,strong) NSDictionary *dataDic ;

@property (nonatomic,strong) KG_EquipmentHistoryModel *dataModel;
@end

NS_ASSUME_NONNULL_END
