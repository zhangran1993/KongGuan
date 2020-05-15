//
//  KG_NewContentCell.h
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_NewContentCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *selBtn;

@property (nonatomic,strong) UIImageView *rightImage;


@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,copy) void(^hideKeyBoard)();
@end

NS_ASSUME_NONNULL_END
