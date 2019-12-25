//
//  SparePartTableViewCell.h
//  Frame
//
//  Created by centling on 2018/12/11.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SparePartListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SparePartTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *sparePartName;
@property (retain, nonatomic) IBOutlet UILabel *numLabel;
@property (retain, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong)SparePartListModel *sparePartListModel;
@end

NS_ASSUME_NONNULL_END
