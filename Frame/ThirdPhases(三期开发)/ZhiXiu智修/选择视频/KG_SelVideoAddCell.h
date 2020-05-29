//
//  KG_SelVideoAddCell.h
//  Frame
//
//  Created by zhangran on 2020/5/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_SelVideoAddCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic ,strong) NSDictionary *dataDic;

@property (nonatomic ,strong) void(^addVideoMethod)();
@end

NS_ASSUME_NONNULL_END
