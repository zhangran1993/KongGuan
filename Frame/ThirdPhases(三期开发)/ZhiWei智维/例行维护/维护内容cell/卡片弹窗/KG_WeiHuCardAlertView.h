//
//  KG_WeiHuCardAlertView.h
//  Frame
//
//  Created by zhangran on 2020/7/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_WeiHuCardAlertView : UIView

@property (nonatomic ,strong) void(^confirmBlockMethod)(NSDictionary *dataDic);
@property (nonatomic,strong) void(^buttonBlockMethod)(NSDictionary *dataDic,NSDictionary *detailDic);
@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,strong) NSDictionary *curSelDic;
@property (nonatomic ,strong) NSDictionary *curSelDetailDic;
@end

NS_ASSUME_NONNULL_END
