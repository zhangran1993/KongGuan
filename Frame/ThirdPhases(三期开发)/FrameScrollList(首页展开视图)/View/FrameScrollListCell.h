//
//  FrameScrollListCell.h
//  Frame
//
//  Created by zhangran on 2020/3/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrameScrollListCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dataDic;

@property (retain, nonatomic) IBOutlet UIButton *watchVideoButton;
@end

NS_ASSUME_NONNULL_END
