//
//  KG_DMEView.h
//  Frame
//
//  Created by zhangran on 2020/4/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_DMEView : UIView


@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) void(^clickToDetail)(NSDictionary *dataDic);
@end

NS_ASSUME_NONNULL_END
