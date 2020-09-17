//
//  KG_ContactTopThirdView.h
//  Frame
//
//  Created by zhangran on 2020/9/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_AddressbookSecondModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_ContactTopThirdView : UIView

@property (nonatomic,strong) void(^searchMethod)();

@property (nonatomic,strong) KG_AddressbookSecondModel *model;

@property (nonatomic,copy) NSString *secTitle;


@property (nonatomic,copy) NSString *thirdTitle;
@end

NS_ASSUME_NONNULL_END
