//
//  KG_AddressbookSearchCell.h
//  Frame
//
//  Created by zhangran on 2020/9/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_InstrumentationSearchCell : UITableViewCell

@property (nonatomic,strong) UIView         *rightView;

@property (nonatomic, strong) UILabel       *titleLabel;

@property (nonatomic, strong) UILabel       *detailLabel;

@property (nonatomic, strong) NSDictionary  *dataDic;


@property (nonatomic, copy) NSString  *seachStr;
@end

NS_ASSUME_NONNULL_END
