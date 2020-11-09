//
//  KG_EquipmentHistoryScreenViewController.h
//  Frame
//
//  Created by zhangran on 2020/10/30.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_EquipmentHistoryScreenViewController : UIViewController

@property (nonatomic, copy)    NSString             *selStr;

@property (nonatomic, strong)  NSArray              *selArray;

@property (nonatomic ,strong) void(^confirmBlockMethod)(NSString *selStr,NSArray *dataArray);
@end

NS_ASSUME_NONNULL_END
