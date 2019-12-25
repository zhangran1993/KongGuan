//
//  XDMultTableView.h
//  XDMultTableView
//
//  Created by 蔡欣东 on 2016/7/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TechnicalManualTableViewCell.h"
@protocol XDMultTableViewDelegate,XDMultTableViewDatasource;

//typedef UITableViewCell XDMultTableViewCell;

typedef UITableViewRowAnimation XDMultTableViewRowAnimation;

typedef NS_ENUM(NSInteger, XDMultTableViewCellEditingStyle) {
    XDMultTableViewCellEditingStyleNone,
    XDMultTableViewCellEditingStyleDelete,
    XDMultTableViewCellEditingStyleInsert
};

//视图滚动监听
@protocol RollDelegate <NSObject>
- (void)tableViewRequestData;
- (void)startRoll;
@end
@interface XDMultTableView : UIView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>


@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, assign, readwrite) id<XDMultTableViewDatasource> datasource;

@property (nonatomic, assign, readwrite) id<XDMultTableViewDelegate> delegate;
@property (nonatomic, weak)id <RollDelegate>rollDelegate;

/**
 若为YES，则点开一行，其他行关闭,默认为YES
 */
@property (nonatomic, assign, readwrite) BOOL autoAdjustOpenAndClose;

/**
 预先打开的行数组
 */
@property (nonatomic, copy, readwrite) NSArray *openSectionArray;

@property (nonatomic, strong, readwrite) UIView *tableViewHeader;


/**
 结束刷新
 */
- (void)endOfRequest;

/**
 *  刷新数据源
 */
- (void)reloadData;


/**
 *  Cell重用机制（一）
 *
 *  @param identifier Cell标识
 *
 *  @return Cell
 */
- (TechnicalManualTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

/**
 *  Cell重用机制（二）
 *
 *  @param identifier Cell标识
 *  @param indexPath indexPath
 *
 *  @return Cell
 */
- (TechnicalManualTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/**
 *  注册cell（一）
 *
 *  @param nib nib
 *  @param identifier identifier
 */
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier ;

/**
 *  注册cell（二）
 *
 *  @param cellClass cellClass
 *  @param identifier identifier
 */
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

/**
 *  删除cell
 *
 *  @param indexPaths indexPaths
 *  @param animation animation
 */
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;

@end

/**
 *  数据源
 */
@protocol XDMultTableViewDatasource <NSObject>

@required

/**
 *  每个section的行数
 *
 *  @param mTableView mTableView
 *  @param section section
 *
 *  @return 每个section的行数
 */
- (NSInteger)mTableView:(XDMultTableView *)mTableView numberOfRowsInSection:(NSInteger)section;

/**
 *  Cell显示
 *
 *  @param mTableView mTableView
 *  @param indexPath indexPath
 *
 *  @return Cell
 */
- (TechnicalManualTableViewCell *)mTableView:(XDMultTableView *)mTableView
               cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 *  section的数量
 *
 *  @param mTableView mTableView
 *
 *  @return section的数量 section
 */
- (NSInteger)numberOfSectionsInTableView:(XDMultTableView *)mTableView;              // Default is 1

/**
 *  头部的title
 *
 *  @param  mTableView tableView
 *  @param section   section
 *
 *  @return
 */
-(NSString *)mTableView:(XDMultTableView *)mTableView titleForHeaderInSection:(NSInteger)section;

//Edit

/**
 *  cell是否可以编辑
 *
 *  @param mTableView mTableView
 *  @param indexPath indexPath
 */
- (BOOL)mTableView:(XDMultTableView *)mTableView canEditRowAtIndexPath:(NSIndexPath  *)indexPath;

/**
 *  cell编辑后回调
 *
 *  @param tableView tableView
 *  @param editingStyle editingStyle
 *  @param indexPath indexPath
 */
- (void)mTableView:(XDMultTableView *)tableView commitEditingStyle:(XDMultTableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

/**
 *  代理
 */
@protocol XDMultTableViewDelegate <NSObject>

@optional
/**
 *  每个Cell的高度
 *
 *  @param mTableView
 *  @param indexPath
 *
 *  @return 每个Cell的高度
 */
- (CGFloat)mTableView:(XDMultTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  每个section的高度
 *
 *  @param mTableView mTableView
 *  @param section section
 *
 *  @return 每个section的高度
 */
- (CGFloat)mTableView:(XDMultTableView *)mTableView heightForHeaderInSection:(NSInteger)section;

/**
 *  section View
 *
 *  @param mTableView mTableView
 *  @param section section
 *
 *  @return section View
 */
- (UIView *)mTableView:(XDMultTableView *)mTableView viewForHeaderInSection:(NSInteger)section;

/**
 *  即将打开指定列表回调
 *
 *  @param mTableView mTableView
 *  @param section section
 */
- (void)mTableView:(XDMultTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section;

/**
 *
 *  即将关闭列表回调
 *  @param mTableView mTableView
 *  @param section section
 */
- (void)mTableView:(XDMultTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section;

/**
 *  点击Cell回调
 *
 *  @param mTableView mTableView
 *  @param indexPath indexPath
 */
- (void)mTableView:(XDMultTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//Edit

/**
 *
 *  设置cell的编辑类型
 *  @param mTableView mTableView
 *  @param indexPath indexPath
 *
 *  @return
 */
- (XDMultTableViewCellEditingStyle)mTableView:(XDMultTableView *)mTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  设置cell编辑状态之删除的文本
 *
 *  @param mTableView mTableView
 *  @param indexPath indexPath
 
 *  @return
 */
- (NSString *)mTableView:(XDMultTableView *)mTableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;



/**
 *  ...易拓展出你想要的tableview的功能，写法可以参照上面的定义
 */

@end

