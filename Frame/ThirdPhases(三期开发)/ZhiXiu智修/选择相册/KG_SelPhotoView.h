//
//  KG_SelPhotoView.h
//  Frame
//
//  Created by zhangran on 2020/5/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_SelPhotoView : UIView
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) void(^closeMethod)(NSInteger index);
@property (nonatomic ,strong) void(^addMethod)();
@end

NS_ASSUME_NONNULL_END
