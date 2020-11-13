//
//  KG_SparePartsStatisticsCollectionViewCell.h
//  Frame
//
//  Created by zhangran on 2020/11/13.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_SparePartsStatisticsCollectionViewCell : UICollectionViewCell


@property (nonatomic ,strong) UILabel      *titleLabel;

@property (nonatomic ,strong) NSDictionary *dataDic;


@property (nonatomic ,strong) NSDictionary *currSelDic;

@end

NS_ASSUME_NONNULL_END
