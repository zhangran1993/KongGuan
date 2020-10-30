//
//  KG_StationFileWarnRecordCell.h
//  Frame
//
//  Created by zhangran on 2020/10/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "KG_EquipmentHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_StationFileWarnRecordCell : UITableViewCell

@property (nonatomic,strong) KG_EquipmentHistoryModel *dataModel;

@property (nonatomic,strong) void (^changeShouQiBlock)(BOOL shouqi);

@property (nonatomic,assign) NSInteger currSection;

@property (nonatomic,strong) NSDictionary *dataDic;


@property (nonatomic,strong)      NSArray         *listArray;

@property (nonatomic,strong)   void (^moreMethodBlock)( NSString *titleStr);

@property (nonatomic,strong) void (^pushToNextStep)( NSString *titleStr,NSDictionary *dataDic);

@end

NS_ASSUME_NONNULL_END
