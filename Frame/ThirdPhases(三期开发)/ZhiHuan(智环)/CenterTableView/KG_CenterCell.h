//
//  KG_CenterCell.h
//  Frame
//
//  Created by zhangran on 2020/4/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_CenterCell : UITableViewCell

//正常
@property (retain, nonatomic) IBOutlet UIImageView *levelImagee;
//名称
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
//左部分icon
@property (retain, nonatomic) IBOutlet UIImageView *iconImage;

@property (retain, nonatomic) IBOutlet UIImageView *rightArrowImage;

@property (retain, nonatomic) IBOutlet UIImageView *lineImage;
@property (retain, nonatomic) IBOutlet UILabel *redDotImage;

@property (retain, nonatomic) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
