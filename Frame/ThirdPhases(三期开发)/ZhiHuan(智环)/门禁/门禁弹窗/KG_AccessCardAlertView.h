//
//  KG_AccessCardAlertView.h
//  Frame
//
//  Created by zhangran on 2020/6/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_AccessCardAlertView : UIView

@property (nonatomic,copy) void(^textString)(NSString *textStr);
@property (nonatomic,copy) void(^textFieldString)(NSString *textFieldStr);


@property (nonatomic,copy) void(^hideKeyBoard)();

@property (nonatomic,strong) void (^confirmMehtod)(NSString *passStirng);
@end

NS_ASSUME_NONNULL_END
