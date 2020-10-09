//
//  KG_SpecilaCanShuSignView.h
//  Frame
//
//  Created by zhangran on 2020/9/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_SpecilaCanShuSignView : UIView

@property (nonatomic,strong) void (^saveBlockMethod)(NSString *str);
@end

NS_ASSUME_NONNULL_END
