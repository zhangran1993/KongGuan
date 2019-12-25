//
//  CommonExtension
//  TenMinDemo
//
//  Created by Hibaysoft on 17/7/4.
//  Copyright (c) 2018年 Hibaysoft. All rights reserved.
//

@protocol ParentViewDelegate <NSObject>

- (void)ParentViewTitle:(NSString *)ParentViewTitle;

- (void)ParentViewTag:(NSInteger )tag;
@end

#import <Foundation/Foundation.h>
#import "FSTextView.h"

@interface CommonExtension : NSObject
+ (BOOL)isEmptyWithString:(NSString *)string;
+ (NSString *)returnWithString:(NSString *)string;
+(NSString *)convertToJsonData:(NSMutableArray *)dict;
+ (void)logout;
+ (void)showviewLoadView;
-(void)addTouchViewParent:(UIView *)ParentView;
-(void)addTouchViewParentTagClass:(UIView *)ParentView;
+(void)addLevelBtn:(UIButton *)btn level:(NSString *)level;
+ (void)addTViewParent:(UIView *)ParentView textView:(FSTextView *)textView text:(NSString*)text placeholder:(NSString *)placeholder maxLength:(int)maxLength;

+ (BOOL)isPureInt:(NSString *)string;
+(NSString *)getDateByTimesp:(double)date dateType:(NSString *)dateType;
+(void)showMessage:(NSString*)message;
/*
 *第二种方法，利用Emoji表情最终会被编码成Unicode，因此，
 *只要知道Emoji表情的Unicode编码的范围，
 *就可以判断用户是否输入了Emoji表情。
 */

+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (UIImage*)createImageWithColor: (UIColor*) color;
@property(nonatomic, strong)NSString *parentViewTitle;
@property(nonatomic, assign)NSInteger parentViewTag;
@property (nonatomic, weak)id<ParentViewDelegate>delegate;
+(int)isFirstLauch;
+ (float)heightForString:(NSString *)value fontSize:(UIFont*)fontSize andWidth:(float)width ;
@end
