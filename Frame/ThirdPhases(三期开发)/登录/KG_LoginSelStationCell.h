//
//  KG_LoginSelStationCell.h
//  Frame
//
//  Created by zhangran on 2020/5/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_LoginSelStaionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_LoginSelStationCell : UITableViewCell


@property (nonatomic ,strong) KG_LoginSelStaionModel *model;

@property (nonatomic ,strong) stationListModel *detailModel;


@property (nonatomic ,strong) void (^selectedMethod)(stationListModel *detailModel);



@property (nonatomic ,strong) UILabel * titleLabel;

@property (nonatomic ,strong) UIImageView * selImageView;

@property (nonatomic ,strong) UIImageView * bgImageView;

@property (nonatomic ,strong) UIView * lineView;

@property (nonatomic ,strong) UIButton * selBtn;
@end

NS_ASSUME_NONNULL_END
