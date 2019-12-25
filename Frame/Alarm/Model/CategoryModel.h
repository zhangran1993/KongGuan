//
//  CategoryModel.h
//  Frame
//
//  Created by centling on 2018/12/4.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "technicalManualListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CategoryModel : NSObject
@property (nonatomic, copy) NSString *category;
@property (nonatomic, strong)technicalManualListModel *technicalManualList;
@end

NS_ASSUME_NONNULL_END
