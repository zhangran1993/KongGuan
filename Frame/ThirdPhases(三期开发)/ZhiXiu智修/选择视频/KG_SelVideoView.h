//
//  KG_SelVideoView.h
//  Frame
//
//  Created by zhangran on 2020/5/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_SelVideoView : UIView
@property (nonatomic ,strong) NSMutableArray *videoArray;
@property (nonatomic ,strong) void(^closeVideoMethod)(NSInteger index);
@property (nonatomic ,strong) void(^addVideoMethod)();
@property (nonatomic ,strong) void(^playVideoMethod)(NSString *dataDic);
@end

NS_ASSUME_NONNULL_END
