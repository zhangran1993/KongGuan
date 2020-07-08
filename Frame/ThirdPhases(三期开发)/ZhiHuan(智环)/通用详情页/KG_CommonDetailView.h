//
//  KG_CommonDetailView.h
//  Frame
//
//  Created by zhangran on 2020/4/29.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_CommonDetailView : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic ,copy) void (^moreAction)();
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) NSArray *alarmArray;

@property (nonatomic ,copy) void (^gotoDetail)();
@property (nonatomic ,copy) NSString *machineName;
@end

NS_ASSUME_NONNULL_END
