//
//  KG_GaoJingFourthCell.h
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_GaoJingFourthCell : UITableViewCell
@property(nonatomic ,strong) NSMutableArray *dataArray;

@property(nonatomic ,strong) NSMutableArray *videoArray;
@property (nonatomic ,strong) void(^addMethod)();

@property (nonatomic ,strong) void(^closeMethod)(NSInteger index);
@property (nonatomic ,strong) void(^addVideoMethod)();

@property (nonatomic ,strong) void(^closeVideoMethod)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
