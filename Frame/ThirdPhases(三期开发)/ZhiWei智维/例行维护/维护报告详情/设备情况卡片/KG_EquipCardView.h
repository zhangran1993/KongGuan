//
//  KG_EquipCardView.h
//  Frame
//
//  Created by zhangran on 2020/6/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_EquipCardView : UIView

@property (nonatomic ,strong) NSArray *dataArray;

@property (nonatomic ,strong) NSDictionary *dataDic;

@property (nonatomic ,copy) NSString *taskStatus;

@property (nonatomic ,assign) int cardTotalNum;
@property (nonatomic ,assign) int cardCurrNum;
@property (nonatomic,copy) void(^moreBlockMethod)(NSDictionary *dataDic);
@end

NS_ASSUME_NONNULL_END
