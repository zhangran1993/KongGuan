//
//  UIScrollView+EmptyDataSet.h
//  HiSmartInternational
//
//  Created by Seas Cheng on 2018/7/9.
//  Copyright © 2018年 Hisense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSIEmptyDataSetView.h"
@protocol EmptyDataSetDelegate <NSObject>
@optional

- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView;
- (nullable NSAttributedString *)tipsForEmptyDataSet:(UIScrollView *)scrollView;
//- (nullable NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView;
- (nullable NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;

@end


@interface UIScrollView (EmptyDataSet)
@property (nonatomic, readonly) HSIEmptyDataSetView *emptyDataSetView;
@property (nonatomic, weak, nullable) IBOutlet id <EmptyDataSetDelegate> emptyDataSetDelegate;

@end
