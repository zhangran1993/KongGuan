//
//  KG_CommonGaojingView.h
//  Frame
//
//  Created by zhangran on 2020/5/6.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_CommonGaojingView : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic ,copy) void (^moreAction)();
@property (nonatomic, strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
