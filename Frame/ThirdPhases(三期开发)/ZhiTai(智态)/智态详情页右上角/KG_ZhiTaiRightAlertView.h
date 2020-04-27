//
//  KG_ZhiTaiRightAlertView.h
//  Frame
//
//  Created by zhangran on 2020/4/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_ZhiTaiRightAlertView : UIView

@property (nonatomic ,copy) void(^didsel)(NSDictionary *selDic);


@property (nonatomic ,strong) NSMutableArray *dataArray;
@end

NS_ASSUME_NONNULL_END
