//
//  KG_XunShiResultCell.h
//  Frame
//
//  Created by zhangran on 2020/5/13.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KG_XunShiReportDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_XunShiResultCell : UITableViewCell

@property (nonatomic, strong) void (^textStringChangeBlock)( NSString *taskDescription);
@property (nonatomic, strong) NSString *taskDescription;
@end

NS_ASSUME_NONNULL_END
