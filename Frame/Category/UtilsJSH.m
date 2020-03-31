//
//  UtilsJSH.m
//  ylh-app-primary-ios
//
//  Created by 王文渊 on 2018/8/30.
//  Copyright © 2018年 巨商汇. All rights reserved.
//

#import "UtilsJSH.h"
static UtilsJSH *instance = nil;

@implementation UtilsJSH
+ (UtilsJSH *)standarInstance
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
      instance = [[UtilsJSH alloc] init];
      instance.netValid = YES;
    });
    return instance;
}
+ (NSString *)countNumAndChangeformat:(NSString *)num
{
    if ([num rangeOfString:@"."].location != NSNotFound) {
        NSString *losttotal = [NSString stringWithFormat:@"%.2f", [num doubleValue]]; //小数点后只保留两位
        NSArray *array = [losttotal componentsSeparatedByString:@"."];
        //小数点前:array[0]
        //小数点后:array[1]
        int count = 0;
        num = array[0];
        long long int a = num.longLongValue;
        while (a != 0) {
            count++;
            a /= 10;
        }
        NSMutableString *string = [NSMutableString stringWithString:num];
        NSMutableString *newstring = [NSMutableString string];
        while (count > 3) {
            count -= 3;
            NSRange rang = NSMakeRange(string.length - 3, 3);
            NSString *str = [string substringWithRange:rang];
            [newstring insertString:str atIndex:0];
            [newstring insertString:@"," atIndex:0];
            [string deleteCharactersInRange:rang];
        }
        [newstring insertString:string atIndex:0];
        NSMutableString *newString = [NSMutableString string];
        newString = [NSMutableString stringWithFormat:@"%@.%@", newstring, array[1]];
        return newString;
    }
    else {
        int count = 0;
        long long int a = num.longLongValue;
        while (a != 0) {
            count++;
            a /= 10;
        }
        NSMutableString *string = [NSMutableString stringWithString:num];
        NSMutableString *newstring = [NSMutableString string];
        while (count > 3) {
            count -= 3;
            NSRange rang = NSMakeRange(string.length - 3, 3);
            NSString *str = [string substringWithRange:rang];
            [newstring insertString:str atIndex:0];
            [newstring insertString:@"," atIndex:0];
            [string deleteCharactersInRange:rang];
        }
        [newstring insertString:string atIndex:0];
        [newstring appendFormat:@".00"];
        return newstring;
    }
}

+ (NSString *)countNumAndChangeformatNotDot:(NSString *)num
{
    if ([num rangeOfString:@"."].location != NSNotFound) {
        NSString *losttotal = [NSString stringWithFormat:@"%.2f", [num doubleValue]]; //小数点后只保留两位
        NSArray *array = [losttotal componentsSeparatedByString:@"."];
        //小数点前:array[0]
        //小数点后:array[1]
        int count = 0;
        num = array[0];
        long long int a = num.longLongValue;
        while (a != 0) {
            count++;
            a /= 10;
        }
        NSMutableString *string = [NSMutableString stringWithString:num];
        NSMutableString *newstring = [NSMutableString string];
        while (count > 3) {
            count -= 3;
            NSRange rang = NSMakeRange(string.length - 3, 3);
            NSString *str = [string substringWithRange:rang];
            [newstring insertString:str atIndex:0];
            [newstring insertString:@"," atIndex:0];
            [string deleteCharactersInRange:rang];
        }
        [newstring insertString:string atIndex:0];
        NSMutableString *newString = [NSMutableString string];
        newString = [NSMutableString stringWithFormat:@"%@.%@", newstring, array[1]];
        return newString;
    }
    else {
        int count = 0;
        long long int a = num.longLongValue;
        while (a != 0) {
            count++;
            a /= 10;
        }
        NSMutableString *string = [NSMutableString stringWithString:num];
        NSMutableString *newstring = [NSMutableString string];
        while (count > 3) {
            count -= 3;
            NSRange rang = NSMakeRange(string.length - 3, 3);
            NSString *str = [string substringWithRange:rang];
            [newstring insertString:str atIndex:0];
            [newstring insertString:@"," atIndex:0];
            [string deleteCharactersInRange:rang];
        }
        [newstring insertString:string atIndex:0];
        return newstring;
    }
}

//判断空字符串
+ (NSString *)isBlankString:(id)string
{
    if (string == nil || string == NULL) {

        return @"";
    }
    if ([string isKindOfClass:[NSNull class]]) {

        return @"";
    }

    if ([string isKindOfClass:[NSString class]]) {
        if ([string isEqualToString:@"<null>"]) {
            return @"";
        }
        if ([string isEqualToString:@"(null)"]) {
            return @"";
        }
        if ([string isEqualToString:@"null"]) {
            return @"";
        }
        if ([string isEqualToString:@"<nil>"]) {
            return @"";
        }
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([string length] == 0) {
            return @"";
        }
    }
    return string;
}
//yyyy-MM-dd HH:mm:ss
+ (NSString *)getDateStrWithDate:(NSTimeInterval)second andFormatter:(NSString *)formatter
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

//压缩图片
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context

    UIGraphicsBeginImageContext(newSize);

    // Tell the old image to draw in this new context, with the desired
    // new size

    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];


    // Get the new image from the context

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();


    // End the context

    UIGraphicsEndImageContext();


    // Return the new image.

    return newImage;
}
@end
