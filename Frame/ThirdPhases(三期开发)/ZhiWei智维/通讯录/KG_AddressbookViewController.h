//
//  KG_AddressbookViewController.h
//  Frame
//
//  Created by zhangran on 2020/8/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_AddressbookViewController : UIViewController

@property (nonatomic ,strong) void (^sureBlockMethod)(NSString *nameID,NSString *nameStr);

@property (nonatomic ,copy) NSString *selPersonId;

@end

NS_ASSUME_NONNULL_END
