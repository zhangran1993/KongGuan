//
//  FrameScrollListCell.h
//  Frame
//
//  Created by zhangran on 2020/3/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrameBottomCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *iconImage;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
//第一个
@property (retain, nonatomic) IBOutlet UILabel *firstTitleLabel;

@property (retain, nonatomic) IBOutlet UILabel *firstNumLabel;
@property (retain, nonatomic) IBOutlet UIImageView *firstStatusLabel;
//第二个
@property (retain, nonatomic) IBOutlet UILabel *secondTitleLabel;

@property (retain, nonatomic) IBOutlet UILabel *secondNumLabel;
@property (retain, nonatomic) IBOutlet UIImageView *secondStatusLabel;
//第三个
@property (retain, nonatomic) IBOutlet UILabel *thirdTitleLabel;

@property (retain, nonatomic) IBOutlet UILabel *thirdNumLabel;
@property (retain, nonatomic) IBOutlet UIImageView *thirdStatusLabel;
//第四个
@property (retain, nonatomic) IBOutlet UILabel *fourthTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *fourthNumLabel;

@property (retain, nonatomic) IBOutlet UIImageView *fourthStatusLabel;


@property (retain, nonatomic) IBOutlet UIButton *watchVideoButton;

@property (nonatomic, strong) NSDictionary *dataDic;


@end

NS_ASSUME_NONNULL_END
