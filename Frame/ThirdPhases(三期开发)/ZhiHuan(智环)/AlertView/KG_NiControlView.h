//
//  KG_NiControlView.h
//  Frame
//
//  Created by zhangran on 2020/4/8.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_NiControlView : UIView
@property (nonatomic,copy) void(^textString)(NSString *textStr);
@property (nonatomic,copy) void(^textFieldString)(NSString *textFieldStr);

@property (nonatomic,copy) void(^confirmMethod)();
@property (nonatomic,copy) void(^hideKeyBoard)();
@end

NS_ASSUME_NONNULL_END
