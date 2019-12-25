//
//  ValueWeatherStationMoel.h
//  Frame
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StationItems.h"
NS_ASSUME_NONNULL_BEGIN

@interface ValueWeatherStationMoel : NSObject

@property (nonatomic, strong)StationItems *weatherStation;
@property (nonatomic, strong)StationItems *faultStation;
@property (nonatomic, strong)StationItems *anotherStation;
@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSMutableArray<StationItems *>  *stationList;
@property (nonatomic, strong)NSString *name;

@end

NS_ASSUME_NONNULL_END
