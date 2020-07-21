//
//  KG_KongTiaoControlView.h
//  Frame
//
//  Created by zhangran on 2020/5/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_KongTiaoControlView : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic ,copy) void (^moreAction)();
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) NSArray *alarmArray;

@property (nonatomic ,copy) NSString *level;
@property (nonatomic ,copy) NSString *num;
@property (nonatomic ,copy) NSString *status;
@end

NS_ASSUME_NONNULL_END
