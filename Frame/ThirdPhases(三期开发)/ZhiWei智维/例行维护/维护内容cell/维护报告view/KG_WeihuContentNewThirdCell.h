//
//  KG_WeihuContentNewThirdCell.h
//  Frame
//
//  Created by zhangran on 2020/11/24.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_WeihuContentNewThirdCell : UITableViewCell


@property (nonatomic, strong) NSDictionary          *dataDic;

//特殊参数标记block传值
@property (nonatomic, strong) void(^specialData)(NSDictionary *dataDic);
@end

NS_ASSUME_NONNULL_END
