//
//  KG_SelPhotoAddCell.h
//  Frame
//
//  Created by zhangran on 2020/5/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_SelPhotoAddCell : UICollectionViewCell


@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic ,strong) NSDictionary *dataDic;

@property (nonatomic ,strong) void(^addMethod)();
@end

NS_ASSUME_NONNULL_END
