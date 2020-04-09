//
//  KG_NiControlCell.h
//  Frame
//
//  Created by zhangran on 2020/4/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_NiControlCell : UITableViewCell

@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * detailLabel;
@property (nonatomic,strong)UILabel * remarkLabel;

@property (strong, nonatomic)UIImageView *selectImageView;

@end

NS_ASSUME_NONNULL_END
