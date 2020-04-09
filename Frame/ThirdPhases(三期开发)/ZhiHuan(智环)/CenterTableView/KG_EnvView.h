//
//  KG_EnvView.h
//  Frame
//
//  Created by zhangran on 2020/4/7.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_EnvView : UIView

@property(nonatomic, strong) NSArray *envArray;

@property (nonatomic ,copy) void(^didsel)(NSString *typeString,NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
