//
//  KG_XunShiTopView.h
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_XunShiReportDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_XunShiTopView : UIView

@property (nonatomic,strong) KG_XunShiReportDetailModel *model;
@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,copy) void (^shouqiMethod)();
@property (nonatomic,copy) void (^zhankaiMethod)();
@end

NS_ASSUME_NONNULL_END

