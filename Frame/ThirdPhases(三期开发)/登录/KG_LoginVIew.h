//
//  KG_LoginVIew.h
//  Frame
//
//  Created by zhangran on 2020/5/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_LoginVIew : UIView

@property (nonatomic,strong) void (^stationClick)();

@property (nonatomic,strong) void (^runClick)();

@end

NS_ASSUME_NONNULL_END
