//
//  CCZTrotingAttribute.h
//  CCZAngelWalker
//
//  Created by centling on 2018/12/7.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface CCZTrotingAttribute : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong, nullable) NSAttributedString *attribute;
/**
 * 这个属性可以为每一个attribute设置一个标识，如id
 */
@property (nonatomic, copy, nullable) NSDictionary *userinfo;
@end
NS_ASSUME_NONNULL_END
