//
//  KG_DutyManageCell.h
//  Frame
//
//  Created by zhangran on 2020/12/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_DutyManageCell : UITableViewCell

@property (nonatomic ,strong) NSDictionary *dataDic;


@property (nonatomic ,strong) UIView        *leftShuLineView;

@property (nonatomic ,strong) UIView        *bgView;

@property (nonatomic ,strong) UIView        *rightShuLineView;

@property (nonatomic ,strong) UIView        *topLineView;

@property (nonatomic ,strong) UIView        *centerShuLineView;

@property (nonatomic ,strong) UIView        *botLineView;

@property (nonatomic ,strong) UILabel       *leftTitleLabel;

@property (nonatomic ,strong) UILabel       *rightTitleLabel;

@end

NS_ASSUME_NONNULL_END
