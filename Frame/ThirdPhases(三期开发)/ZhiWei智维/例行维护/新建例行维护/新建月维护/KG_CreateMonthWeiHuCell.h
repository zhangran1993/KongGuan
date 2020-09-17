//
//  KG_CreateMonthWeiHuCell.h
//  Frame
//
//  Created by zhangran on 2020/9/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_CreateMonthWeiHuCell : UITableViewCell


@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *lineImage;

@property (nonatomic, strong) UIImageView *rightImage;

@property (nonatomic, copy) NSString *roomStr;

@property (nonatomic, copy) NSString *selRoomStr;

@end

NS_ASSUME_NONNULL_END
