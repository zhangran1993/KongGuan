//
//  AlarmListCell.h
//  Frame
//
//  Created by hibayWill on 2018/4/4.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RatingBar.h"

@class AlarmItems;
@interface AlarmListCell : UITableViewCell
/** 菜单模型 */
@property (copy, nonatomic) AlarmItems * AlarmItem;
@end

