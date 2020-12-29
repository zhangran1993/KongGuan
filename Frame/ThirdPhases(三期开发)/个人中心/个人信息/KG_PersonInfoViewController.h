//
//  KG_PersonInfoViewController.h
//  Frame
//
//  Created by zhangran on 2020/12/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_PersonInfoViewController : UIViewController


@property (nonatomic,strong) void (^refreshData)();

@property (nonatomic,copy) NSString *stationStr;
@end

NS_ASSUME_NONNULL_END
