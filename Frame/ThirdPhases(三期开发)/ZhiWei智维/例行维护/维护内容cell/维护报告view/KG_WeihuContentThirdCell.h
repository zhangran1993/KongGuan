//
//  KG_RadarEquipCell.h
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_WeihuContentThirdCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftIcon ;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *tempLabel;
@property (nonatomic, strong) UIImageView *zhexianIcon ;
@property (nonatomic, strong) UIImageView *starIcon ;

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UILabel *detailTitleLabel;
@property (nonatomic, strong) UILabel *detailTextTitleLabel;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIButton *specialStarBtn;
@property (nonatomic, strong) UIButton *promptBtn;
@property (nonatomic,strong) void(^specialData)(NSDictionary *dataDic);
@end

NS_ASSUME_NONNULL_END
