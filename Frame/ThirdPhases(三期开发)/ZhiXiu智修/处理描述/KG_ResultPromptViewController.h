//
//  KG_ResultPromptViewController.h
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_GaoJingDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KG_ResultPromptViewController : UIViewController
@property (nonatomic,strong) KG_GaoJingDetailModel *model;


@property (nonatomic,copy) void(^textString)(NSString *textStr);


@end

NS_ASSUME_NONNULL_END


