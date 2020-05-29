//
//  KG_GaoJingDetailFirstCell.h
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.

#import <UIKit/UIKit.h>
#import "KG_GaoJingDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_GaoJingDetailFirstCell : UITableViewCell

@property (nonatomic,strong) UILabel *roomLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UIImageView *gaojingImage;
@property (nonatomic,strong) UILabel *powLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIImageView *statusImage;

@property (nonatomic,strong) UIButton *confirmBtn;

@property (nonatomic,strong) KG_GaoJingDetailModel *model;

@property (nonatomic,copy) NSString *showLeftSrcollView;

@property (nonatomic,strong) NSDictionary *infoDic;

@property (nonatomic,strong) void(^confirmMethod)();

@property (nonatomic,strong) void(^removeMethod)();

@property (nonatomic,strong) void(^hangupMethod)();
@end

NS_ASSUME_NONNULL_END
