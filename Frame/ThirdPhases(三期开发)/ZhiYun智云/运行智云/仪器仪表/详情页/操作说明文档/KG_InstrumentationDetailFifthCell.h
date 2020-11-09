//
//  KG_InstrumentationDetailFifthCell.h
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_InstrumentationDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_InstrumentationDetailFifthCell : UITableViewCell

@property (nonatomic,strong) KG_InstrumentationDetailModel *dataModel;

@property (nonatomic,strong) void (^changeShouQiBlock)(BOOL shouqi);


@property (nonatomic,strong) void(^pushToNextStep)(NSDictionary *dataDic);
@end

NS_ASSUME_NONNULL_END
