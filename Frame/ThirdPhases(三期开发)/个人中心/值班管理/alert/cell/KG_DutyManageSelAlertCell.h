//
//  KG_DutyManageSelAlertCell.h
//  Frame
//
//  Created by zhangran on 2021/1/27.
//  Copyright © 2021 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_DutyManageSelModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_DutyManageSelAlertCell : UITableViewCell

@property (nonatomic ,strong) NSDictionary *dataDic ;


@property (nonatomic ,strong) KG_DutyManageSelModel  *model;
@end

NS_ASSUME_NONNULL_END
