//
//  ChooseStationCell.m
//  Frame
//
//  Created by hibayWill on 2018/3/16.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "ChooseStationCell.h"
#import "StationItems.h"
#import "UIColor+Extension.h"


@interface ChooseStationCell ()
@property (weak, nonatomic) IBOutlet UILabel *stationName;


@end
@implementation ChooseStationCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:kCellHighlightColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setStation:(StationItems *)station{
    _stationName.text = station.alias;
    _stationName.font = FontSize(16);
    _stationName.font = [UIFont my_font:16];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, FrameWidth(78), WIDTH_SCREEN, 1)];
    lineView.backgroundColor = BGColor;
    [self addSubview:lineView];
    /*
    _shop = shop;
    // 利用SDWebImage框架加载图片资源
    [self.litpic sd_setImageWithURL:[NSURL URLWithString:_shop.litpic]];
    
    // 设置标题
    self.titleLabel.text = alias;
    
    // 设置材料数据
    self.descLabel.text = [_shop.quantity stringByAppendingString:@"人点评"];
    
    RatingBar *ratingBar = [[RatingBar alloc] init];
    ratingBar.frame = CGRectMake(0, 4, 200, 25);
    [ratingBar setImageDeselected:@"star_gray" halfSelected:nil fullSelected:@"star_red" rating:[_shop.rate intValue]];
    [self.ratingView addSubview:ratingBar];
    ratingBar.isIndicator = YES;//指示器，就不能滑动了，只显示评分结果
    
    //
    */
}

@end

