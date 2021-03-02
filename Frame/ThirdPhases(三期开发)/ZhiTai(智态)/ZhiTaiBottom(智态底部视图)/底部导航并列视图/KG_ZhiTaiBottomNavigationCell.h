//
//  KG_ZhiTaiBottomNavigationCell.h
//  Frame
//
//  Created by zhangran on 2021/2/25.
//  Copyright © 2021 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_ZhiTaiBottomNavigationCell : UITableViewCell


@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UIImageView *leftImage;


@property (nonatomic,strong) UILabel *statusNumLabel;
@property (nonatomic,strong) UIImageView *statusImage;
@property (nonatomic,strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
