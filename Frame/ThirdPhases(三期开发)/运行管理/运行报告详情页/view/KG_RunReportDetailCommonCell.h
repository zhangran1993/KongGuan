//
//  KG_RunReportDetailCommonCell.h
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_RunReportDetailCommonCell : UITableViewCell


@property (nonatomic,copy) void(^textString)(NSString *textStr);


@property (nonatomic, strong) UITextView *textView;
@property (nonatomic ,copy) NSString *string;
@end

NS_ASSUME_NONNULL_END
