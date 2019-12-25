//
//  MediaModel.h
//  Frame
//
//  Created by Apple on 2018/12/17.
//  Copyright © 2018 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaModel : NSObject

@property (copy, nonatomic) NSString*  id;
@property (copy, nonatomic) NSString*  operatorId;
@property (copy, nonatomic) NSString*  patrolRecodeId;
//@property double * createTime;
//@property double * lastUpdateTime;
@property (copy, nonatomic) NSString*  url;

@end

NS_ASSUME_NONNULL_END
