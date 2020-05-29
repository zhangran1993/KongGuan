//
//  KG_ProgressLeftCell.h
//  Frame
//
//  Created by zhangran on 2020/5/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_ProgressLeftCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIImageView *circleImage;


@property (nonatomic,strong) UIImageView *lineImage;

@property (nonatomic,strong) NSDictionary *dic;

@end

NS_ASSUME_NONNULL_END
