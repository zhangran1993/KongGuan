//
//  KG_XunShiLastDetailCell.h
//  Frame
//
//  Created by zhangran on 2020/11/19.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_XunShiLastDetailCell : UITableViewCell


@property (nonatomic, strong) NSDictionary          *dataDic;

//特殊参数标记block传值
@property (nonatomic, strong) void(^specialData)(NSDictionary *dataDic);

@end

NS_ASSUME_NONNULL_END
