//
//  KG_KongTiaoViewController.h
//  Frame
//
//  Created by zhangran on 2020/4/15.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationScrollViewController.h"

@interface KG_KongTiaoViewController : StationScrollViewController
//滚动视图对象
@property (retain, nonatomic) UIScrollView *scrollView;
//视图中小圆点，对应视图的页码
@property (retain, nonatomic) UIPageControl *pageControl;
//动态数组对象，存储图片
@property (retain, nonatomic) NSMutableArray *mList;

@property (assign, nonatomic) NSString* station_code;
@property (assign, nonatomic) NSString* station_name;
@property (assign, nonatomic) NSString* machine_name;
@property (assign, nonatomic) NSString* category;
@property (assign, nonatomic) NSString* engine_room_code;
@end
