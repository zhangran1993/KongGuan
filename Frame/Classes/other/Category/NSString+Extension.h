//
//  NSString+Extension.h
//  HiSmartInternational
//
//  Created by Seas Cheng on 2018/1/4.
//  Copyright © 2018年 Hisense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)


- (BOOL)isNull;
- (BOOL)isEmpty;
- (BOOL)isEmail;
- (BOOL)isLocalizedEmail;
- (BOOL)contains:(NSString *)string;
- (BOOL)isOnlyLetterOrNumbersOrUnderlines;
- (BOOL)isContainsUppercaseAndLowercaseLetters;
- (BOOL)isOnlyLettersOrNumbers;

/**
 Return the height of fixed string
 **/
+ (CGRect)heightForString:(NSString *)str size:(CGSize)size font:(UIFont *)font;

/**
 NSString md5 decode and encode
 **/
+(NSString*)stringDecodingByMD5:(NSString*)str;
-(NSString*)md5DecodingString;
-(NSString*)md5StringFor16;
-(NSString*)filterSpace;


/**
 Trim blank characters (space and newline) in head and tail.
 */
- (NSString *)stringByTrim;

/**
 Get the current link wireless SSID
 */
+ (NSString *)SSID;


/**
 if the string contains emoji
 */
- (BOOL)isContainsEmoji ;

@end

NS_ASSUME_NONNULL_END
