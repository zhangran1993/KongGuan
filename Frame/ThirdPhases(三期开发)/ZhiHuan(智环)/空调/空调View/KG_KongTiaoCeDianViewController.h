//
//  KG_KongTiaoCeDianViewController.h
//  Frame
//
//  Created by zhangran on 2020/5/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_KongTiaoCeDianViewController : UIViewController

@property (nonatomic ,strong)NSArray *dataArray;
@property (nonatomic ,copy) void (^moreAction)(NSDictionary *dataDic);

@property (nonatomic ,strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
