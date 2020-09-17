//
//  KG_CreateDayWeiHuCell.h
//  Frame
//
//  Created by zhangran on 2020/9/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_CreateDayWeiHuCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *lineImage;

@property (nonatomic, strong) UIImageView *rightImage;

@property (nonatomic, copy) NSString *roomStr;

@property (nonatomic, copy) NSString *selRoomStr;
@end

NS_ASSUME_NONNULL_END
