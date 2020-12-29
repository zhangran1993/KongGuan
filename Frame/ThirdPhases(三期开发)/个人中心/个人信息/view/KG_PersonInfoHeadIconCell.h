//
//  KG_HeadIconCell.h
//  Frame
//
//  Created by zhangran on 2020/12/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_PersonInfoHeadIconCell : UITableViewCell

@property (nonatomic ,strong) void (^selHeadIcon)();



@property (nonatomic ,strong) UILabel          *titleLabel;

@property (nonatomic ,strong) UIButton         *bgBtn;

@property (nonatomic ,strong) UIImageView      *headImage;

@property (nonatomic ,strong) UIImageView      *rightImage;

@property (nonatomic ,strong) UIView           *lineView;

@end

NS_ASSUME_NONNULL_END
