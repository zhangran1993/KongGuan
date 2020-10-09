//
//  KG_EquipmentHistoryDetailSecondCell.h
//  Frame
//
//  Created by zhangran on 2020/9/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_EquipmentHistoryDetailSecondCell : UITableViewCell



@property (nonatomic ,strong) NSDictionary *dataDic;

@property (nonatomic,strong)      UILabel         *titleLabel;

@property (nonatomic,strong)      UILabel         *detailLabel;

@property (nonatomic,strong)      UIImageView     *iconImage;

@property (nonatomic,strong)      UIView          *lineView;

@end

NS_ASSUME_NONNULL_END
