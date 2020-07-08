//
//  KG_AccessCardInputPassAlertView.h
//  Frame
//
//  Created by zhangran on 2020/6/24.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_AccessCardInputPassAlertView : UIView

@property (nonatomic,strong) void (^confirmMehtod)(NSString *passStirng);
@end

NS_ASSUME_NONNULL_END
