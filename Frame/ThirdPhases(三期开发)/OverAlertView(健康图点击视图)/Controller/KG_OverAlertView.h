//
//  KG_OverAlertView.h
//  Frame
//
//  Created by zhangran on 2020/3/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_OverAlertView : UIView

@property (nonatomic ,copy) void(^didsel)(NSString *selString);

@end

NS_ASSUME_NONNULL_END
