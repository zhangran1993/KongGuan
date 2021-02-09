//
//  KG_LiXingWeiHuCell.h
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_LiXingWeiHuCell : UITableViewCell

@property (nonatomic, strong) UIView              *rightView;
@property (nonatomic, strong) UIImageView         *iconImage;
@property (nonatomic, strong) UILabel             *roomLabel;
@property (nonatomic, strong) UILabel             *statusLabel;
@property (nonatomic, strong) UILabel             *detailLabel;

@property (nonatomic, strong) UIImageView         *starImage;
@property (nonatomic, strong) UILabel             *starLabel;

@property (nonatomic, strong) UIImageView         *timeImage;
@property (nonatomic, strong) UILabel             *timeLabel;
 
@property (nonatomic, strong) UILabel             *personLabel;

@property (nonatomic, strong) UIImageView         *statusImage ;
@property (nonatomic, strong) UIButton            *taskButton;

@property (nonatomic, strong) NSDictionary        *dataDic;

@property (nonatomic, copy) void(^taskMethod)(NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
