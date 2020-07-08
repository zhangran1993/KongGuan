//
//  KG_AccessCardLogCell.h
//  Frame
//
//  Created by zhangran on 2020/6/24.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_AccessCardLogCell : UITableViewCell

@property (nonatomic,strong)   UILabel * timeLabel;
@property (nonatomic,strong)   UILabel * titleLabel;
@property (nonatomic,strong)   UILabel * detailLabel;
@property (nonatomic,strong)   UILabel * remarkLabel;

@property (strong, nonatomic)  UIImageView *selectImageView;

@property (strong, nonatomic) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
