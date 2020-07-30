//
//  KG_SelectCardTypeView.h
//  Frame
//
//  Created by zhangran on 2020/7/24.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_SelectCardTypeView : UIView

@property (nonatomic, strong) void(^didselTextBlock)(NSDictionary *str);

@property (nonatomic, strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
