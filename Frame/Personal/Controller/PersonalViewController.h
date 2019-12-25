//
//  PersonalViewController.h
//  Frame
//
//  Created by hibayWill on 2018/3/16.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "BasicViewController.h"
typedef void (^TypeDidClick) (NSInteger type,Class targetClass);
@interface PersonalViewController : BasicViewController
@property(nonatomic,copy)TypeDidClick typeClick;
//(, nonatomic) NSInteger * tablerow;/**< 第几个 */

@end

