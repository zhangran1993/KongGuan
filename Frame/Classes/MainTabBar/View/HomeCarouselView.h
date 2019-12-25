//
//  HomeCarouselView.h
//  RHYM
//
//  Created by shmily on 2018/2/5.
//  Copyright © 2018年 HuaZhengInfo. All rights reserved.
//


@protocol HomeCarouselViewDelegate <NSObject>
@optional
- (void)HomeCarouselViewDelegateClickAtIndex:(NSInteger)index;
@end
#import <UIKit/UIKit.h>

@interface HomeCarouselView : UIView
@property (nonatomic,weak) IBOutlet  UIWebView *homeLight;
//data
@property(nonatomic,strong) NSArray * dataArr;

@property (nonatomic,weak) id <HomeCarouselViewDelegate>delegate;
@end
