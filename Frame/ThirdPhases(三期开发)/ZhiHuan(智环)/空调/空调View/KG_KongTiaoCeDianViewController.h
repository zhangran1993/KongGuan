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
@property (nonatomic ,strong)NSArray *alarmArray;
@property (nonatomic ,strong)NSArray *dataArray;
@property (nonatomic ,copy) void (^moreAction)(NSDictionary *dataDic);

@property (nonatomic ,strong) NSDictionary *dataDic;

@property (nonatomic ,strong) UIImageView *leftIcon;

@property (nonatomic ,strong) UILabel *leftTitle;

@property (nonatomic ,strong) NSString *leftStr;

@property (nonatomic ,strong) NSString *leftIconStr;
@end

NS_ASSUME_NONNULL_END
