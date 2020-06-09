//
//  KG_RunManagerSecondCell.h
//  Frame
//
//  Created by zhangran on 2020/6/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_RunManagerSecondCell : UITableViewCell
@property (nonatomic, strong)  NSArray    *reportListArr;//维护

@property (nonatomic, strong) void (^weihuBlockMethod)();

@end

NS_ASSUME_NONNULL_END
