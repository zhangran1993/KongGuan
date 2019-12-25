//
//  customTableView.h
//  Frame
//
//  Created by centling on 2018/12/7.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol customTableViewDelegate <NSObject>
- (void)customTableViewClickCell:(NSString *)text;
@end

@interface customTableView : UIView
@property (nonatomic, weak)id<customTableViewDelegate>delegate;
@property (nonatomic, strong) NSArray *customManufactureArray;
/**
 初始化列表
 */
- (void)InitializationListView:(NSArray*)customManufactureArray;
//弹框显示
-(void)show;
//隐藏
-(void)hide;
@end

NS_ASSUME_NONNULL_END
