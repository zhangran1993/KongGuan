//
//  KG_BeiJianDetailThirdCell.h
//  Frame
//
//  Created by zhangran on 2020/8/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_BeiJianDetailThirdCell : UITableViewCell
@property (nonatomic ,strong) NSDictionary *dataDic;

@property (nonatomic ,copy)   NSString *categoryString;

@property (nonatomic,strong) void (^saveBlockMethod)(NSString *str);

@property (nonatomic ,copy)   NSString *descriptionStr;
@end

NS_ASSUME_NONNULL_END
