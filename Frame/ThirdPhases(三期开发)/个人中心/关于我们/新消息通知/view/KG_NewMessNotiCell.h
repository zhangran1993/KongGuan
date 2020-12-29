//
//  KG_NewMessNotiCell.h
//  Frame
//
//  Created by zhangran on 2020/12/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_NewMessNotiCell : UITableViewCell

@property (nonatomic ,strong) UIImageView        *iconImage;

@property (nonatomic ,strong) UILabel            *titleLabel;

@property (nonatomic ,strong) UILabel            *detailLabel;

@property (nonatomic ,strong) UISwitch           *swh;

@property (nonatomic ,strong) UIView             *lineView;

@property (nonatomic ,copy)   NSString           *str;


@property (nonatomic ,assign)  NSInteger         indexPath;


@property (nonatomic ,strong) void (^switchOnBlock)(BOOL switchOn,NSInteger indexRow);

@end

NS_ASSUME_NONNULL_END

