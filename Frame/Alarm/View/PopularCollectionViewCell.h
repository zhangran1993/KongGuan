//
//  PopularCollectionViewCell.h
//  Frame
//
//  Created by centling on 2018/12/5.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopularModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PopularCollectionViewCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UILabel *searchLabel;
@property (nonatomic, strong)PopularModel *model;
@end

NS_ASSUME_NONNULL_END
