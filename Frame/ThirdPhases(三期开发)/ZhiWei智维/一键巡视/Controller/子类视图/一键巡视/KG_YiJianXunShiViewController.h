//
//  KG_YiJianXunShiViewController.h
//  Frame
//
//  Created by zhangran on 2020/4/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_YiJianXunShiViewController : UIViewController


@property (nonatomic,copy)void (^didsel )(NSDictionary *dataDic,NSString *statusType);

@property (nonatomic,copy)void (^addMethod )(NSString *statusType);


@end

NS_ASSUME_NONNULL_END
