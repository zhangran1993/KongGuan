//
//  KG_XunShiHandleView.h
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_XunShiHandleView : UIView

@property (nonatomic ,copy) void(^didsel)(NSDictionary *selDic);

@property (nonatomic ,strong) NSArray *dataArray;

@end

NS_ASSUME_NONNULL_END
