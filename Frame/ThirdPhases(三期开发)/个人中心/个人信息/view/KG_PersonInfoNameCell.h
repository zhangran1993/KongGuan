//
//  KG_PersonInfoNameCell.h
//  Frame
//
//  Created by zhangran on 2020/12/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_PersonInfoNameCell : UITableViewCell


@property (nonatomic,strong)  NSDictionary     *dataDic;

@property (nonatomic ,strong) UILabel          *titleLabel;

@property (nonatomic ,strong) UILabel          *detailLabel;

@property (nonatomic ,strong) UIView           *lineView;

@end

NS_ASSUME_NONNULL_END
