//
//  PatrolRemindCell.h
//  Frame
//
//  Created by hibayWill on 2018/3/27.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StationItems;

@interface PatrolRemindCell : UITableViewCell

/** 菜单模型 */
@property (copy, nonatomic) StationItems * StationItem;
-(float)getCellHeight:(StationItems *)StationItem;
@end
