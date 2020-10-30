//
//  KG_FaultEventRecordCell.h
//  Frame
//
//  Created by zhangran on 2020/10/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_FaultEventRecordCell : UITableViewCell


@property (nonatomic, strong)  UIImageView    *iconImage;

@property (nonatomic, strong)  UILabel        *titleLabel;

@property (nonatomic, strong)  UILabel        *detailLabel;

@property (nonatomic, strong)  UIView         *lineView;


@property (nonatomic,strong) NSDictionary  *dataDic ;

@end

NS_ASSUME_NONNULL_END
