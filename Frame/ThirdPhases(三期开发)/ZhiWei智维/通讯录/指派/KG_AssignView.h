//
//  KG_AssignView.h
//  Frame
//
//  Created by zhangran on 2020/9/8.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_AssignView : UIView

@property (nonatomic ,strong) void(^confirmBlockMethod)(NSDictionary *dataDic,NSString *name,NSString *nameID);

@property (nonatomic ,strong) void(^selContactBlockMethod)();

@property (nonatomic ,strong) NSDictionary *dataDic;

@property (nonatomic ,copy) NSString *name;

@property (nonatomic ,copy) NSString *nameID;
@end

NS_ASSUME_NONNULL_END
