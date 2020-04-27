//
//  KG_JifangView.h
//  Frame
//
//  Created by zhangran on 2020/4/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_JifangView : UIView
@property(nonatomic, strong) NSArray *powArray;

@property(nonatomic, copy)void (^didsel)(NSString *str);


@property (nonatomic, assign) int selIndex;

@property(nonatomic, strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
