//
//  PatrolHistoryCell.h
//  Frame
//
//  Created by hibayWill on 2018/3/27.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RatingBar.h"

@class Patroltems;

@interface PatrolHistoryCell : UITableViewCell

/** 菜单模型 */
@property (copy, nonatomic) Patroltems * Patroltem;

@end
