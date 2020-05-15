//
//  KG_CommonDetailViewController.h
//  Frame
//
//  Created by zhangran on 2020/4/29.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_CommonDetailViewController : UIViewController



@property (assign, nonatomic) NSString* station_code;
@property (assign, nonatomic) NSString* station_name;
@property (assign, nonatomic) NSString* machine_name;
@property (assign, nonatomic) NSString* category;
@property (assign, nonatomic) NSString* engine_room_code;

//动态数组对象，存储图片
@property (retain, nonatomic) NSMutableArray *mList;
@end

NS_ASSUME_NONNULL_END
