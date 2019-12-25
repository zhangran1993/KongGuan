//
//  SearchView.h
//  Frame
//
//  Created by centling on 2018/12/3.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewDelegeat <NSObject>
//开始搜索
- (void)startSearch:(NSString *)searchFieldText;
- (void)searchTextFieldDidEndEditing:(NSString *)textFieldText;
@end

NS_ASSUME_NONNULL_BEGIN

@interface SearchView : UIView <UITextFieldDelegate>
@property (nonatomic, strong)UITextField *searchField;
@property (nonatomic, weak)id<SearchViewDelegeat>delegeat;
@property (nonatomic, strong)NSString *fieldPlaceholder;
@end

NS_ASSUME_NONNULL_END
