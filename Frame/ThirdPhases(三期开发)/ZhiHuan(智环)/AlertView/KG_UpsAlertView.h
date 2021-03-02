//
//  KG_UpsAlertView.h
//  Frame
//
//  Created by zhangran on 2020/4/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_UpsAlertView : UIView

@property (nonatomic ,copy) void(^didsel)(NSDictionary *selDic);


@property (nonatomic ,strong) NSMutableArray *dataArray;


@property (nonatomic ,assign) BOOL  isFromZhiTai;
@end

NS_ASSUME_NONNULL_END
