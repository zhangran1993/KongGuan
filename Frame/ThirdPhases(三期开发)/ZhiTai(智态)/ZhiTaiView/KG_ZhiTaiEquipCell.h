//
//  KG_ZhiTaiEquipCell.h
//  Frame
//
//  Created by zhangran on 2020/4/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_ZhiTaiEquipCell : UITableViewCell

@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UILabel *leftNumLabel;
@property (nonatomic,strong) UIImageView *leftImage;

@property (nonatomic,strong) UIImageView *rightImage;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UILabel *rightNumLabel;

@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,strong) NSDictionary *detailDic;
@end

NS_ASSUME_NONNULL_END
