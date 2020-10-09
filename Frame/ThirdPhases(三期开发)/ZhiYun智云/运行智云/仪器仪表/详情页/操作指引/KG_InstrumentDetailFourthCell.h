//
//  KG_InstrumentDetailFourthCell.h
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_InstrumentationDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_InstrumentDetailFourthCell : UITableViewCell

@property (nonatomic,strong) KG_InstrumentationDetailModel *dataModel;

@property (nonatomic,strong) NSArray *listArray;

@property (nonatomic,copy) NSString *guideTypeStr;
@property (nonatomic,copy) NSString *guideNameStr;
@property (nonatomic,strong) void (^selGudieListBlock)();

@property (nonatomic,strong) void (^pushToDetailBlock)(NSDictionary *dataDic);
@end

NS_ASSUME_NONNULL_END
