//
//  KG_ZhiTaiBottomView.h
//  Frame
//
//  Created by zhangran on 2020/4/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_ZhiTaiBottomView : UIView
@property(nonatomic, strong) NSArray *secArray;
@property (nonatomic,strong) NSString*titleString;

@property (nonatomic,strong) void(^clickToDetail)(NSDictionary *dataDic);
@property (nonatomic,strong) NSDictionary *currDic;
@property (nonatomic,assign) int currIndex;
@end

NS_ASSUME_NONNULL_END
