//
//  KG_TeShuBaoZhangViewController.h
//  Frame
//
//  Created by zhangran on 2020/4/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_TeShuBaoZhangViewController : UIViewController

@property (nonatomic,copy)void (^didsel )(NSDictionary *dataDic,NSString *statusType);

@property (nonatomic,copy)void (^addMethod )(NSString *statusType);
@end

NS_ASSUME_NONNULL_END
