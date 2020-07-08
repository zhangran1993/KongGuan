//
//  KG_RunReportDetailSeventhCell.h
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_RunReportDeatilModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_RunReportDetailSeventhCell : UITableViewCell
@property (nonatomic ,strong) KG_RunReportDeatilModel *model;

@property (nonatomic ,copy) NSString *pushType;
@property (nonatomic,copy) void(^textString)(NSString *textStr);
@end

NS_ASSUME_NONNULL_END
