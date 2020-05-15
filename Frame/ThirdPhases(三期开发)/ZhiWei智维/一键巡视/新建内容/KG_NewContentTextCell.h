//
//  KG_NewContentTextCell.h
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_NewContentTextCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UILabel *promptLabel;

@property (nonatomic,copy) void(^textString)(NSString *textStr,NSInteger tag);



@property (nonatomic,copy) void(^hideKeyBoard)();


@end

NS_ASSUME_NONNULL_END
