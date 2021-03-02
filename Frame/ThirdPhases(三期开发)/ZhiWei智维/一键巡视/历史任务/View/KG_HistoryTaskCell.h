//
//  KG_HistoryTaskCell.h
//  Frame
//
//  Created by zhangran on 2020/5/11.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_HistoryTaskCell : UITableViewCell
//状态image
@property (nonatomic,strong)   UIImageView     *statusImage;
@property (nonatomic, strong)  UIView          *rightView;
@property (nonatomic, strong)  UIImageView     *statusCconImage;
@property (nonatomic, strong)  UIImageView     *iconImage;
@property (nonatomic, strong)  UILabel         *roomLabel;
@property (nonatomic, strong)  UILabel         *statusLabel;
@property (nonatomic, strong)  UILabel         *detailLabel;

@property (nonatomic, strong)  UIImageView     *starImage;
@property (nonatomic, strong)  UILabel         *starLabel;

@property (nonatomic, strong)  UIImageView     *timeImage;
@property (nonatomic, strong)  UILabel         *timeLabel;

@property (nonatomic, strong)  UILabel         *personLabel;
@property (nonatomic, strong)  UIImageView     *typeImage;

@property (nonatomic, strong)  UIButton        *taskButton;

@property (nonatomic, strong)  NSDictionary    *dataDic;

@property (nonatomic, assign)  int             currIndex;

@property (nonatomic, copy)    void(^taskMethod)(NSDictionary *dic);

@property (nonatomic,strong)   UIView          *statusView;
@end

NS_ASSUME_NONNULL_END
