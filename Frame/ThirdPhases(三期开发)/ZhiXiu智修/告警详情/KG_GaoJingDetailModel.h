//
//  KG_GaoJingDetailModel.h
//  Frame
//
//  Created by zhangran on 2020/5/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_GaoJingDetailModel : NSObject

@property (nonatomic ,strong) NSMutableArray *videos;

@property (nonatomic ,strong) NSMutableArray *labels;
@property (nonatomic ,strong) NSDictionary *announce;
@property (nonatomic ,strong) NSMutableArray *image;
@property (nonatomic ,strong) NSMutableArray *shooting;
@property (nonatomic ,strong) NSMutableArray *log;
@property (nonatomic ,strong) NSDictionary *emergency;
@property (nonatomic ,strong) NSDictionary *info;
@end

NS_ASSUME_NONNULL_END
