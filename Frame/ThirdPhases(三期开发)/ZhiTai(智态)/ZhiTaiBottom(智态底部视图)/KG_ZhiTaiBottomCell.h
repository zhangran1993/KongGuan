//
//  KG_ZhiTaiBottomCell.h
//  Frame
//
//  Created by zhangran on 2020/4/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_ZhiTaiBottomCell : UITableViewCell


@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UIImageView *leftImage;


@property (nonatomic,strong) UILabel *statusNumLabel;
@property (nonatomic,strong) UIImageView *statusImage;
@property (nonatomic,strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
