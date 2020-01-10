//
//  WarnTableViewCell.h
//  Frame
//
//  Created by An An on 2019/11/1.
//  Copyright © 2019 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StationItems;
@interface WarnTableViewCell : UITableViewCell
/** 菜单模型 */
@property (copy, nonatomic) StationItems * StationItem;

@property (copy, nonatomic)  NSString *String;

@property (assign, nonatomic)  NSInteger currentRow;
@end

