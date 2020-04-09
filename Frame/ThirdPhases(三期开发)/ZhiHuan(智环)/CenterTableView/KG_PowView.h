//
//  KG_PowView.h
//  Frame
//
//  Created by zhangran on 2020/4/7.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_PowView : UIView
@property(nonatomic, strong) NSArray *powArray;

@property (nonatomic ,copy) void(^didsel)(NSString *typeString,NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
