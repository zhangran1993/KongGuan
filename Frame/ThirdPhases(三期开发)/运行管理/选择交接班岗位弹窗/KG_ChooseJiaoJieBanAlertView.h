//
//  KG_ChooseJiaoJieBanAlertView.h
//  Frame
//
//  Created by zhangran on 2020/6/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_ChooseJiaoJieBanAlertView : UIView
@property (nonatomic,copy) void(^textString)(NSString *textStr);
@property (nonatomic,copy) void(^textFieldString)(NSString *textFieldStr);

@property (nonatomic ,strong) void(^confirmBlockMethod)(NSDictionary *dataDic);
- (instancetype)initWithCondition:(NSDictionary *)condition;
@end

NS_ASSUME_NONNULL_END
