//
//  KG_RunReportDetailViewController.h
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_RunReportDetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, copy) NSString * pushType;


@property (nonatomic, copy) NSString * endTime;
@end

NS_ASSUME_NONNULL_END
