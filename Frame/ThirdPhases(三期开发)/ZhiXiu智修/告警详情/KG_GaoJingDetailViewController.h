//
//  KG_GaoJingDetailViewController.h
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_GaoJingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_GaoJingDetailViewController : UIViewController

@property (nonatomic,strong) KG_GaoJingModel *model;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) void (^refreshData)();


@end

NS_ASSUME_NONNULL_END
