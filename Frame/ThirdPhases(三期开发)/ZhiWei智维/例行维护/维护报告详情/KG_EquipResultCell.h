//
//  KG_EquipResultCell.h
//  Frame
//
//  Created by zhangran on 2020/6/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_EquipResultCell : UITableViewCell

@property (nonatomic ,copy) void (^moreAction)();

@end

NS_ASSUME_NONNULL_END
