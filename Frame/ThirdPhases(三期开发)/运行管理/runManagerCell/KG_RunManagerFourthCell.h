//
//  KG_RunManagerFourthCell.h
//  Frame
//
//  Created by zhangran on 2020/6/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_RunManagerFourthCell : UITableViewCell
@property (nonatomic, strong)  NSArray    *jiaojiebanListArr;

@property (nonatomic, strong) void (^jiaojiebanBlockMethod)();
@end

NS_ASSUME_NONNULL_END
