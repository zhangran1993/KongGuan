//
//  KG_InstrumentDetailContentFourthCell.h
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_InstrumentDetailContentFourthCell : UICollectionViewCell

@property (nonatomic,strong)      UIImageView     *contentImage;

@property (nonatomic,strong)      UIImageView     *iconImage;

@property (nonatomic,strong)      UILabel         *titleLabel;

@property (nonatomic,strong)      UILabel         *numLabel;

@property (nonatomic,strong)      UILabel         *totalNumLabel;

@property (nonatomic,strong)      NSDictionary    *dataDic;

@end

NS_ASSUME_NONNULL_END
