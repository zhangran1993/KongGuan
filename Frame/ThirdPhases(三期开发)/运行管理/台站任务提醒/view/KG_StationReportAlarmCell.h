//
//  KG_StationReportAlarmCell.h
//  Frame
//
//  Created by zhangran on 2020/6/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_StationReportAlarmCell : UITableViewCell

@property (nonatomic, strong) void(^getTask)(NSDictionary *dataDic);
@property (nonatomic, strong) NSDictionary *dic;

@end

NS_ASSUME_NONNULL_END
