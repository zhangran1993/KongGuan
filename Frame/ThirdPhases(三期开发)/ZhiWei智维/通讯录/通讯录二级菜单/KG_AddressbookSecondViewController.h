//
//  KG_AddressbookSecondViewController.h
//  Frame
//
//  Created by zhangran on 2020/8/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_AddressbookSecondViewController : UIViewController

@property (nonatomic,copy) NSString *strID;

@property (nonatomic,copy) NSString *secondTitle;

@property (nonatomic ,strong) void (^sureBlockMethod)(NSString *nameID,NSString *nameStr);

@end

NS_ASSUME_NONNULL_END
