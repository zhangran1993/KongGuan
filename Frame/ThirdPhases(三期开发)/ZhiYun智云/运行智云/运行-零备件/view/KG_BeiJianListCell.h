//
//  KG_BeiJianListCell.h
//  Frame
//
//  Created by zhangran on 2020/7/30.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_BeiJianListCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;


@property (nonatomic,strong) NSDictionary *totalDic;

@property (nonatomic,strong) void (^didsel)(NSDictionary *dataDic,NSDictionary *totalDic);
@end

NS_ASSUME_NONNULL_END
