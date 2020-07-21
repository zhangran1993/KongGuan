//
//  KG_XunShiResultView.h
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_XunShiResultView : UIView

@property (nonatomic, strong) NSString *taskDescription;

@property (nonatomic, strong) void (^textStringChangeBlock)( NSString *taskDescription);
@end

NS_ASSUME_NONNULL_END
