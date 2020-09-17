//
//  KG_ContactTopView.h
//  Frame
//
//  Created by zhangran on 2020/8/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_AddressbookModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_ContactTopView : UIView

@property (nonatomic,strong) void(^pushToNextPage)(NSInteger selSection,NSInteger selIndex);
@property (nonatomic,strong) KG_AddressbookModel *model;

@property (nonatomic,strong) void(^searchMethod)();
@end

NS_ASSUME_NONNULL_END
