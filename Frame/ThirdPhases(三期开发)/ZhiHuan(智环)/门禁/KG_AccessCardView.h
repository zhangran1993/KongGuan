//
//  KG_AccessCardView.h
//  Frame
//
//  Created by zhangran on 2020/6/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_AccessCardView : UIView
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic ,copy) void (^moreAction)();
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) NSArray *alarmArray;

@property (nonatomic ,copy) NSString *level;
@property (nonatomic ,copy) NSString *num;
@property (nonatomic ,copy) NSString *status;

@property (nonatomic ,copy) void (^gotoDetail)();
@end

NS_ASSUME_NONNULL_END
