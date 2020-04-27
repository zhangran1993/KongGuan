//
//  KG_YiJianXunShiCell.h
//  Frame
//
//  Created by zhangran on 2020/4/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_YiJianXunShiCell : UITableViewCell


@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UIImageView *topLine;//52
@property (nonatomic, strong) UIImageView *centerLine;
@property (nonatomic, strong) UIImageView *bottomLine;//37
@property (nonatomic, strong) UILabel *leftTimeLabel;
@property (nonatomic, strong) UIImageView *leftIcon;







@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *roomLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIImageView *starImage;
@property (nonatomic, strong) UILabel *starLabel;

@property (nonatomic, strong) UIImageView *timeImage;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *personLabel;


@property (nonatomic, strong) UIButton *taskButton;
@end

NS_ASSUME_NONNULL_END
