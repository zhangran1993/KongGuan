//
//  KG_ZhiTaiBottomNavigationView.h
//  Frame
//
//  Created by zhangran on 2021/2/25.
//  Copyright © 2021 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_ZhiTaiBottomNavigationView : UIView

@property(nonatomic, strong) NSArray *secArray;
@property (nonatomic,strong) NSString*titleString;

@property (nonatomic,strong) void(^clickToDetail)(NSDictionary *dataDic);
@property (nonatomic,strong) NSDictionary *currDic;
@property (nonatomic,assign) int currIndex;
@end

NS_ASSUME_NONNULL_END
