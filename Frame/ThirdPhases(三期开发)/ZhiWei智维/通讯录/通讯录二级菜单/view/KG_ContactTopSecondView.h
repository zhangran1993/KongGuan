//
//  KG_ContactTopSecondView.h
//  Frame
//
//  Created by zhangran on 2020/8/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_AddressbookSecondModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_ContactTopSecondView : UIView
@property (nonatomic,strong) void(^pushToNextPage)(NSInteger selSection,NSInteger selIndex);
@property (nonatomic,strong) KG_AddressbookSecondModel *model;

@property (nonatomic,strong) void(^searchMethod)();

@property (nonatomic,copy) NSString *secTitle;
@end

NS_ASSUME_NONNULL_END
