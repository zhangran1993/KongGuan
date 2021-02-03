//
//  KG_SecondFloorViewController.h
//  Frame
//
//  Created by zhangran on 2020/4/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_StationDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_SecondFloorViewController : UIViewController
@property (strong, nonatomic) KG_StationDetailModel *dataModel;
@property (copy, nonatomic)  NSString *idStr;
@property (copy, nonatomic)  NSString *codeStr;
@property (strong, nonatomic) void (^BackToLastPage)();
@end

NS_ASSUME_NONNULL_END
