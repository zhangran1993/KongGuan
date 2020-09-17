//
//  KG_AddressbookSearchViewController.h
//  Frame
//
//  Created by zhangran on 2020/9/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_HistorySearchViewController : UIViewController

@property (nonatomic ,copy) NSString *searchId;


@property (nonatomic ,strong) void (^didselBlock)(NSString *nameID,NSString *name);

@end

NS_ASSUME_NONNULL_END
