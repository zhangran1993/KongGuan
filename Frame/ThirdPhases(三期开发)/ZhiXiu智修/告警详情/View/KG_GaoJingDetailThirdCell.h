//
//  KG_GaoJingDetailThirdCell.h
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_GaoJingDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_GaoJingDetailThirdCell : UITableViewCell
@property (nonatomic,strong) KG_GaoJingDetailModel *model;

@property (nonatomic,strong) void (^pushToNextStep)(NSString *titleStr,KG_GaoJingDetailModel *model);

@property (nonatomic,strong) void (^changeStatus)(NSString *titleStr);
@end

NS_ASSUME_NONNULL_END
