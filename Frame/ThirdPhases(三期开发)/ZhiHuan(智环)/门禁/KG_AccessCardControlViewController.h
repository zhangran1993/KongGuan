//
//  KG_AccessCardControlViewController.h
//  Frame
//
//  Created by zhangran on 2020/6/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_AccessCardControlViewController : UIViewController

@property (nonatomic,strong) void(^controlLog)(NSDictionary *dataDic);

@property (nonatomic ,strong)NSArray *dataArray;
@property (nonatomic ,strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
