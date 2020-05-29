//
//  KG_LoginSelStaionModel.h
//  Frame
//
//  Created by zhangran on 2020/5/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface stationListModel : NSObject

@property (nonatomic,copy) NSString *stationName;

@property (nonatomic,copy) NSString *stationCode;

@property (nonatomic,assign) BOOL isSelected;

@end



@interface KG_LoginSelStaionModel : NSObject

@property (nonatomic,copy) NSString *categoryCode;

@property (nonatomic,copy) NSString *categoryName;

@property (nonatomic,strong) NSArray <stationListModel *>*stationList;


@property (nonatomic,assign)  BOOL isShouQi;
@end

NS_ASSUME_NONNULL_END
