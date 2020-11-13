//
//  KG_RunLingBeiJianSearchViewController.h
//  Frame
//
//  Created by zhangran on 2020/11/11.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_GaoJingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_RunLingBeiJianSearchViewController : UIViewController


@property (nonatomic ,copy) NSString *searchId;

@property (nonatomic ,strong) KG_GaoJingModel *model;

@property (nonatomic ,copy) NSString *fromType;

@property (nonatomic ,strong) void (^didselBlock)(NSString *nameID,NSString *name);

@property (nonatomic,strong) NSDictionary *totalDic;


@property (nonatomic,strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
