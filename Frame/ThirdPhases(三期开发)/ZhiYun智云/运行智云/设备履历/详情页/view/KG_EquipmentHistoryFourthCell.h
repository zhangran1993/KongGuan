//
//  KG_InstrumentationDetailFifthCell.h
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_EquipmentHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_EquipmentHistoryFourthCell : UITableViewCell

@property (nonatomic,strong) KG_EquipmentHistoryModel *dataModel;

@property (nonatomic,strong) void (^changeShouQiBlock)(BOOL shouqi);

@property (nonatomic,assign) NSInteger currSection;
@end

NS_ASSUME_NONNULL_END
