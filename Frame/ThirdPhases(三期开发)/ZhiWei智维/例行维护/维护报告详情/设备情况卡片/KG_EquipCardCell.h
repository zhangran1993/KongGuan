//
//  KG_EquipCardCell.h
//  Frame
//
//  Created by zhangran on 2020/6/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_XunShiReportDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_EquipCardCell : UITableViewCell


@property (nonatomic ,strong) NSArray *listArray;
@property (strong, nonatomic) KG_XunShiReportDetailModel *dataModel;
@property (nonatomic ,strong) NSDictionary *curSelDic;
@property (nonatomic ,strong) NSDictionary *curSelDetialDic;

@property (nonatomic,copy) void(^moreBlockMethod)(NSDictionary *dataDic);
@end

NS_ASSUME_NONNULL_END
