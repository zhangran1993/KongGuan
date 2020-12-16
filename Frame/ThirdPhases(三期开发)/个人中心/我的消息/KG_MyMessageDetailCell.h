//
//  KG_MyMessageDetailCell.h
//  Frame
//
//  Created by zhangran on 2020/12/15.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_MyMessageDetailCell : UITableViewCell

@property (nonatomic ,strong) UILabel         *timeLabel;

@property (nonatomic ,strong) UIView          *centerView;

@property (nonatomic ,strong) UIImageView     *iconImage;

@property (nonatomic ,strong) UILabel         *titleLabel;

@property (nonatomic ,strong) UIView          *lineView;

@property (nonatomic ,strong) UILabel         *detailLabel;

@property (nonatomic ,strong) UIImageView     *rightImage;

@property (nonatomic ,strong) NSDictionary    *dataDic;

@end

NS_ASSUME_NONNULL_END
