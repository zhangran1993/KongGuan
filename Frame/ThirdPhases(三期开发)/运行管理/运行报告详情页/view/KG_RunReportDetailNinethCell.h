//
//  KG_RunReportDetailNinethCell.h
//  Frame
//
//  Created by zhangran on 2020/6/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_RunReportDetailNinethCell : UITableViewCell
@property (nonatomic ,strong) UIButton *centerBtn;

@property (nonatomic ,strong) void(^buttonCLicked)();
@end

NS_ASSUME_NONNULL_END
