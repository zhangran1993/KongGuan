//
//  KG_NiTaiTuNoDataView.h
//  Frame
//
//  Created by zhangran on 2020/7/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_NiTaiTuNoDataView : UIView
@property(nonatomic, strong) NSArray *envArray;

@property(nonatomic, strong) NSDictionary *dmeDic;


@property(nonatomic, strong) NSDictionary *dvorDic;
@property (nonatomic ,copy) void(^didsel)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
