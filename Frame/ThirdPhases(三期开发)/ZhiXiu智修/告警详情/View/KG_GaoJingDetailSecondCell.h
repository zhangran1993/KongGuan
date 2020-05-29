//
//  KG_GaoJingDetailSecondCell.h
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_GaoJingDetailSecondCell : UITableViewCell


@property (nonatomic,strong) void(^didsel)(NSString *buttonString);

@property (nonatomic,strong) void(^clickToVideo)();

@property (nonatomic,strong) void(^clickToYun)();

@property (nonatomic,strong) void(^clickToGuZhang)();
@property (nonatomic,strong) void(^clickToHuiZhen)();
@end

NS_ASSUME_NONNULL_END
