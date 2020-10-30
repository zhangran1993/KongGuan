//
//  KG_CaseLibraryDetailReasonCell.h
//  Frame
//
//  Created by zhangran on 2020/10/15.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_CaseLibraryDetailReasonCell : UITableViewCell

@property (nonatomic,strong)      UILabel         *titleLabel;

@property (nonatomic,strong)      UILabel         *detailLabel;

@property (nonatomic,strong)      UIImageView     *iconImage;

@property (nonatomic,strong)      UIButton          *rightBtn;

@property (nonatomic,strong)      NSDictionary *dataDic;

@property (nonatomic,copy)        NSString *reasonStr;
@end

NS_ASSUME_NONNULL_END
