//
//  ContactManufacturerView.h
//  Frame
//
//  Created by centling on 2018/12/5.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactManufacturerView : UIView

@property (nonatomic, strong) NSArray *contactManufactureArray;
/**
初始化列表
 */
- (void)InitializationListView;
//弹框显示
-(void)show;
//隐藏
-(void)hide;

@end

NS_ASSUME_NONNULL_END
