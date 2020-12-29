//
//  KG_MineFirstCell.h
//  Frame
//
//  Created by zhangran on 2020/12/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_MineFirstCell : UITableViewCell


@property (nonatomic ,strong) void (^pushToNextStep)( NSString *title);

@property (nonatomic ,strong) void (^pushToPesonalMessPage)();


@property (nonatomic ,copy)   NSString   *staStr;
@end

NS_ASSUME_NONNULL_END
