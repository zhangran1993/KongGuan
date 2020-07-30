//
//  KG_PowerOnView.h
//  Frame
//
//  Created by zhangran on 2020/4/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_PowerOnView : UIView
@property (nonatomic,copy) void(^textString)(NSString *textStr);
@property (nonatomic,copy) void(^textFieldString)(NSString *textFieldStr);


@property (nonatomic,copy) void(^hideKeyBoard)();


@property (nonatomic,copy) void(^confirmBlockMethod)();

@property (nonatomic,copy) NSString *switchStatus;
@end

NS_ASSUME_NONNULL_END
