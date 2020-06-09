//
//  KG_RunManagerThirdCell.h
//  Frame
//
//  Created by zhangran on 2020/6/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_RunManagerThirdCell : UITableViewCell

@property (nonatomic, strong)  NSArray    *stationRunReportArr;//台站运行报告arr

@property (nonatomic, strong)  NSDictionary *jiaoJieBanInfo;

@property (nonatomic, strong) void (^runReportBlockMethod)();

@property (nonatomic, strong) void (^jiaobanBlockMethod)();

@property (nonatomic, strong) void (^jiebanBlockMethod)();
@property (nonatomic, strong) void (^createReportBlockMethod)();
@property (nonatomic, strong) void (^gotoDetailBlockMethod)(NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
