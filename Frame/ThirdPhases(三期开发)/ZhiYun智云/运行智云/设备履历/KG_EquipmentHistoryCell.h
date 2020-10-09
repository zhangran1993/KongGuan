//
//  KG_EquipmentHistoryCell.h
//  Frame
//
//  Created by zhangran on 2020/9/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_EquipmentHistoryCell : UITableViewCell

@property (nonatomic ,strong) NSDictionary    *dataDic;


@property (nonatomic ,copy)   NSString        *selType;
@end

NS_ASSUME_NONNULL_END
