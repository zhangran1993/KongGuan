//
//  DIYNoDataView.h
//  Frame
//
//  Created by centling on 2018/12/18.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DIYNoDataViewDelegate <NSObject>
- (void)DIYNoDataViewButtonClcik;
@end


NS_ASSUME_NONNULL_BEGIN

@interface DIYNoDataView : UIView

@property (nonatomic, strong) UIImageView *noDataImage;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak)id<DIYNoDataViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
