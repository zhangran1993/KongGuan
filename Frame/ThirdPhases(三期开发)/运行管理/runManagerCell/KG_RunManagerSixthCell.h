//
//  KG_RunManagerSixthCell.h
//  Frame
//
//  Created by zhangran on 2021/2/20.
//  Copyright © 2021 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_RunManagerDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_RunManagerSixthCell : UITableViewCell

@property (nonatomic, strong) void (^createReportBlockMethod)();

@property (nonatomic, strong) void (^runReportBlockMethod)();

@property (nonatomic, strong) void (^jiaobanBlockMethod)();

@property (nonatomic, strong) void (^jiebanBlockMethod)();
@property (nonatomic, strong) void (^gotoDetailBlockMethod)(NSDictionary *dic);

@property (nonatomic, strong)  KG_RunManagerDetailModel *detailModel;
@end

NS_ASSUME_NONNULL_END
