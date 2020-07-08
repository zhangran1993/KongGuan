//
//  KG_SelPhotoCollectionViewCell.h
//  Frame
//
//  Created by zhangran on 2020/5/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_SelPhotoCollectionViewCell : UICollectionViewCell


@property (nonatomic, strong) UIButton *iconImage;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic ,strong) NSDictionary *dataDic;

@property (nonatomic ,strong) void(^closeMethod)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
