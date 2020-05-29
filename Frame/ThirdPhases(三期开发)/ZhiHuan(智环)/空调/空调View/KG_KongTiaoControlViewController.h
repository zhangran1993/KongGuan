//
//  KG_KongTiaoControlViewController.h
//  Frame
//
//  Created by zhangran on 2020/5/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_KongTiaoControlViewController : UIViewController


@property (nonatomic,strong) void(^controlLog)();

@property (nonatomic ,strong)NSArray *dataArray;
@property (nonatomic ,strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
