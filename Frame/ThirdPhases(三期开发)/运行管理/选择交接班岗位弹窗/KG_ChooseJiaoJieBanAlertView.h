//
//  KG_ChooseJiaoJieBanAlertView.h
//  Frame
//
//  Created by zhangran on 2020/6/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_RunManagerDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_ChooseJiaoJieBanAlertView : UIView

@property (nonatomic,copy)    void(^textString)(NSString *textStr);

@property (nonatomic,copy)    void(^textFieldString)(NSString *textFieldStr);

@property (nonatomic ,strong) void(^confirmBlockMethod)(succeedPositionInfoModel *dataDic);

- (instancetype)initWithCondition:(KG_RunManagerDetailModel *)condition;
@end

NS_ASSUME_NONNULL_END
