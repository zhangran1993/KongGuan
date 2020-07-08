//
//  KG_WeiHuCardAlertCell.h
//  Frame
//
//  Created by zhangran on 2020/7/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_WeiHuCardAlertCell : UICollectionViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSDictionary *detailDic;

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,strong) NSDictionary *selDic;
@property (nonatomic,strong) NSDictionary *selDetailDic;
@property (nonatomic,strong) void(^buttonBlockMethod)(NSDictionary *dataDic,NSDictionary *detailDic,NSInteger tag);
@end

NS_ASSUME_NONNULL_END
