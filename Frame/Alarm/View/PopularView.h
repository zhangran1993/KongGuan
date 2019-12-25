//
//  PopularView.h
//  Frame
//
//  Created by centling on 2018/12/5.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PopularViewDelegate <NSObject>
- (void)clickCell:(NSString *)text isBool:(BOOL)isBool index:(NSIndexPath *)index modelArray:(NSArray *)modelArray;
@end

@interface PopularView : UIView
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, weak)id<PopularViewDelegate>delegate;
- (void)refresh;
@end

NS_ASSUME_NONNULL_END
