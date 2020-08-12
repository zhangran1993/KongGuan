//
//  KG_BeiJianThirdView.h
//  Frame
//
//  Created by zhangran on 2020/7/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_BeiJianThirdView : UIView

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,copy)   NSString *categoryString;

@property (nonatomic,strong) void (^saveBlockMethod)(NSString *str);

@property (nonatomic,copy)   NSString *descriptionStr;
@end

NS_ASSUME_NONNULL_END
