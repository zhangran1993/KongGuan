//
//  KG_XunShiLogCell.h
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_XunShiLogCell : UITableViewCell


@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UILabel *nameTitle;
@property (nonatomic, strong) UILabel *detailTitle;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) NSDictionary *dic;
@end

NS_ASSUME_NONNULL_END
