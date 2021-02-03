//
//  KG_DutyManageSelAlertView.h
//  Frame
//
//  Created by zhangran on 2021/1/27.
//  Copyright © 2021 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_DutyManageSelAlertView : UIView

- (instancetype)initWithDataDictionary:(NSDictionary *)dic;

@property (nonatomic,strong) void (^cancelMethod)();


@property (nonatomic,strong) void (^confirmMethod)(NSDictionary *dataDic);


@property (nonatomic,strong) void (^selContact)(NSArray *array);

@property (nonatomic,copy) NSString    *oldPostName;

@end

NS_ASSUME_NONNULL_END
