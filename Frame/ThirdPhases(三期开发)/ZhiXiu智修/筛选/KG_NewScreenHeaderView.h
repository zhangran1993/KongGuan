//
//  KG_NewScreenHeaderView.h
//  Frame
//
//  Created by zhangran on 2020/8/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_NewScreenHeaderView : UICollectionReusableView


@property  (nonatomic ,strong) UIButton *rightBtn;

@property  (nonatomic ,strong) UILabel *titleLabel;

@property  (nonatomic ,strong) UILabel *promptLabel;

@property  (nonatomic ,strong) UIImageView *rightImage;
@end

NS_ASSUME_NONNULL_END
