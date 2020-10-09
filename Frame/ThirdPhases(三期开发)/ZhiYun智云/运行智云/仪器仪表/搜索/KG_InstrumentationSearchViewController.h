//
//  KG_InstrumentationSearchViewController.h
//  Frame
//
//  Created by zhangran on 2020/9/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_InstrumentationSearchViewController : UIViewController
@property (nonatomic ,copy) NSString *searchId;


@property (nonatomic ,strong) void (^didselBlock)(NSString *nameID,NSString *name);
@end

NS_ASSUME_NONNULL_END
