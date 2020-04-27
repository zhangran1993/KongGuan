//
//  KG_RadarEquipCell.h
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_RadarEquipCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftIcon ;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *tempLabel;
@property (nonatomic, strong) UIImageView *tempImage;
@property (nonatomic, strong) UIImageView *zhexianIcon ;
@property (nonatomic, strong) UIImageView *starIcon ;

@property (nonatomic, strong) UIView *promptView;
@property (nonatomic, strong) UIImageView *promptBgImage ;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *promptBtn;

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UILabel *detailTitleLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@end

NS_ASSUME_NONNULL_END
