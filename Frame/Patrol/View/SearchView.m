//
//  SearchView.m
//  Frame
//
//  Created by centling on 2018/12/3.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "SearchView.h"
#import "UIView+LX_Frame.h"
#import "FrameBaseRequest.h"
#import "UIColor+Extension.h"
#import "NSString+Extension.h"
@implementation SearchView
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)setFieldPlaceholder:(NSString *)fieldPlaceholder {
    _fieldPlaceholder = fieldPlaceholder;
    self.searchField.placeholder = fieldPlaceholder;
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(20, 7, WIDTH_SCREEN - 40, 40)];
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = [UIColor colorWithHexString:@"ECECEC"].CGColor;
    backView.layer.cornerRadius = backView.lx_height/2;
    [self addSubview:backView];

    self.searchField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, backView.lx_width - 40, backView.lx_height)];
    self.searchField.placeholder = @"可以对巡查结果进行查询";
    self.searchField.font = FontSize(15);
    self.searchField.textColor = [UIColor blackColor];
    self.searchField.delegate = self;
    self.searchField.returnKeyType = UIReturnKeySearch;
    [self.searchField addTarget:self action:@selector(searchFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    self.searchField.leftView = leftView;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    [backView addSubview:self.searchField];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchField.frame), 0, 30, backView.lx_height)];
    [searchButton setImage:[UIImage imageNamed:@"alarm_search"] forState:UIControlStateNormal];
    searchButton.imageView.contentMode = 1;
    [searchButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:searchButton];
    
}



- (void)searchFieldDidBeginEditing:(UITextField *)textField{
    if ([textField.text isContainsEmoji]) {
        NSString *text = textField.text;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
        NSString *modifiedString = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@""];
        textField.text = modifiedString;
    }
    if ([self.delegeat respondsToSelector:@selector(searchTextFieldDidEndEditing:)]) {
        [self.delegeat searchTextFieldDidEndEditing:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchField resignFirstResponder];
    int isNull = isNull(self.searchField.text);
    if(isNull==0){
        [FrameBaseRequest showMessage:@"请输入搜索内容"];
        return YES;
    }
    if ([self.delegeat respondsToSelector:@selector(startSearch:)]) {
        [self.delegeat startSearch:self.searchField.text];
    }
    return YES;
}

- (void)searchClick {
    [self.searchField resignFirstResponder];
    if ([self.delegeat respondsToSelector:@selector(startSearch:)]) {
        [self.delegeat startSearch:self.searchField.text];
    }
}
@end
