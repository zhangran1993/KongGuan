//
//  KG_NoDataPromptView.h
//  Frame
//
//  Created by zhangran on 2020/11/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_NoDataPromptView : UIView

@property (nonatomic, strong)      UILabel *noDataLabel;

@property (nonatomic, strong)      UIImageView *iconImage;

 
@property (nonatomic, strong)       UIView       *noDataView;


- (void)showView;

- (void)hideView;


@end

NS_ASSUME_NONNULL_END
