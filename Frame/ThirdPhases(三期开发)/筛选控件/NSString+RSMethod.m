//
//  NSString+RSMethod.m
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/3/1.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import "NSString+RSMethod.h"

@implementation NSString (RSMethod)

+ (NSMutableAttributedString *)attributedPlaceholder:(NSString *)string
                                               color:(UIColor *)color
                                                font:(UIFont *)font
{

    NSMutableAttributedString *placeholderStr = [[NSMutableAttributedString alloc] initWithString:string];
    [placeholderStr addAttribute:NSForegroundColorAttributeName
                           value:color
                           range:NSMakeRange(0, string.length)];
    [placeholderStr addAttribute:NSFontAttributeName
                           value:font
                           range:NSMakeRange(0, string.length)];
    return placeholderStr;
}

+ (NSString *)errorMessage:(NSDictionary *)dic
{

    if (!isSafeDictionary(dic)) {
        return @"访问出错";
    }

    NSString *errorMessage = @"";
    if (isSafeDictionary(dic[@"data"])) {
        errorMessage = safeString(dic[@"data"][@"resultMsg"]);
    }
    if (!errorMessage.length || [errorMessage isEqualToString:@"<null>"]) {
        errorMessage = @"访问出错";
    }
    return errorMessage;
}

+ (CGSize)sizeForString:(NSString *)value font:(UIFont *)font width:(float)width height:(float)height
{

    if (![value isKindOfClass:NSString.class]) {
        return CGSizeMake(0, 0);
    }
    if (!value.length) {
        return CGSizeMake(0, 0);
    };

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:value];
    NSRange range = NSMakeRange(0, attrStr.length);
    [attrStr addAttribute:NSFontAttributeName value:font range:range];
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    CGSize size = CGSizeMake(width ?: MAXFLOAT, height ?: MAXFLOAT);
    CGSize sizeToFit = [value boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:dic
                                           context:nil]
                           .size;
    return sizeToFit;
}

+ (NSString *)transformDateStringWithUnixTimestamp:(NSString *)time format:(NSString *)format
{

    if (!format.length) {
        format = @"YYYY-MM-dd HH:mm:ss";
    }
    if (safeString(time).length == 0) {
        return @"-";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];

    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue] / 1000];
    NSString *endDateStr = [formatter stringFromDate:endDate];

    return endDateStr;
}

+ (NSString *)rs_safeString:(NSString *)str
{

    if ([str isKindOfClass:NSString.class]) {
        return str.length ? str : @"";
    }
    else if ([str isKindOfClass:NSNumber.class]) {
        return [NSString stringWithFormat:@"%@", str];
    }
    else {
        return @"";
    }
}

+ (NSString *)twoDecimalPlaces:(NSString *)num
{

    num = safeString(num);

    if (!num.length) {
        return @"";
    }

    NSString *n = [NSString stringWithFormat:@"%.2lf", num.doubleValue];
    return n;
}

+ (NSString *)dateStringWithTimeIntervalSinceNow:(NSTimeInterval)interval
{

    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger year;
    NSInteger month;
    NSInteger day;
    [calendar getEra:nil year:&year month:&month day:&day fromDate:date];
    NSString *dateStr = [NSString stringWithFormat:@"%li-%02li-%02li", year, month, day];

    return dateStr;
}

+ (NSString *)random_32_String
{

    NSString *string = [[NSString alloc] init];
    for (int i = 0; i < 32; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }
        else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

/*
 *  判断用户输入的商品编码是否符合规范，符合规范的密码要求：
 1. 长度???
 2. 编码允许输入的字符0123456789ABCDEFGHJKLMNPQRSTUVWXYZ
 */
+ (BOOL)judgeBarCodeLegal:(NSString *)barCode
{

    BOOL result = NO;

    NSString *regex = @"^[0123456789ABCDEFGHJKLMNPQRSTUVWXYZ]{1,16}";
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [predict evaluateWithObject:barCode];
    return result;
}

+ (NSString *)transformFileExpandedNameToMp4:(NSString *)fileName
{

    if (![fileName containsString:@"."]) {
        return [fileName stringByAppendingString:@".mp4"];
    }

    if ([fileName hasSuffix:@".mp4"]) {
        return fileName;
    }

    NSMutableArray *fileNameArrM = [[fileName componentsSeparatedByString:@"."] mutableCopy];
    [fileNameArrM removeLastObject];

    NSString *name = @"";
    for (NSString *str in fileNameArrM) {
        name = [name stringByAppendingString:str];
        name = [name stringByAppendingString:@"."];
    }
    name = [name stringByAppendingString:@"mp4"];
    return name;
}

+ (BOOL)isPureInt:(NSString *)string
{

    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (NSString *)removeNull:(NSString *)string {
    
    string = safeString(string);
    
    if ([string isEqualToString:@"<null>"] ||
        [string isEqualToString:@"(null)"] ||
        [string isEqualToString:@"null"]) {
        return @"";
    }
    
    return string;
}

+ (NSDictionary *)dateScaleWithType:(RSDateType)type weekFirstDayIsMonday:(BOOL)ret {
    
    // 今天
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger currentYear; NSInteger currentMonth; NSInteger currentWeek; NSInteger currentDay;
    [calendar getEra:nil year:&currentYear month:&currentMonth day:&currentDay fromDate:today];
    [calendar getEra:nil yearForWeekOfYear:nil weekOfYear:nil weekday:&currentWeek
            fromDate:today];
    NSString *todayStr = [NSString stringWithFormat:@"%li-%02li-%02li",currentYear,currentMonth,currentDay];
    if (ret) {
        currentWeek--;
    }
    
    // 昨天
    NSTimeInterval yesterdayInterval = -24 * 3600;
    NSString *yesterDay = [NSString dateStringWithTimeIntervalSinceNow:yesterdayInterval];
    
    // 本周第一天
    NSTimeInterval currentWeekFirstDayInterval = - (currentWeek - 1) * 24 * 3600;
    NSString *currentWeekFirstDay = [NSString dateStringWithTimeIntervalSinceNow:currentWeekFirstDayInterval];
    
    // 上周第一天
    NSTimeInterval lastWeekFirstDayInterval = - ((currentWeek - 1) + 7) * 24 * 3600;
    NSString *lastWeekFirstDay = [NSString dateStringWithTimeIntervalSinceNow:lastWeekFirstDayInterval];
    
    // 上周最后一天
    NSTimeInterval lastWeekLastDayInterval = - currentWeek * 24 * 3600;
    NSString *lastWeekLastDay = [NSString dateStringWithTimeIntervalSinceNow:lastWeekLastDayInterval];
    
    // 本月第一天
    NSString *currentMonthFirstDay = [NSString stringWithFormat:@"%li-%02li-01",currentYear,currentMonth];
    
    // 上月第一天
    NSInteger lastMonthYear = currentMonth == 1 ? currentYear - 1 : currentYear;
    NSInteger lastMonth = currentMonth == 1 ? 12 : currentMonth - 1;
    NSString *lastMonthFirstDay = [NSString stringWithFormat:@"%li-%02li-01",lastMonthYear,lastMonth];
    
    // 上月最后一天
    NSTimeInterval lastMonthLastDayInterval = - currentDay * 24 * 3600;
    NSString *lastMonthLastDay = [NSString dateStringWithTimeIntervalSinceNow:lastMonthLastDayInterval];
    
    NSString *beginDateStr = @"";
    NSString *endDateStr = @"";
    switch (type) {
        case RSDateTypeToday:
            beginDateStr = todayStr;
            endDateStr = todayStr;
            break;
        case RSDateTypeYesterday:
            beginDateStr = yesterDay;
            endDateStr = yesterDay;
            break;
        case RSDateTypeCurrentWeek:
            beginDateStr = currentWeekFirstDay;
            endDateStr = todayStr;
            break;
        case RSDateTypeLastWeek:
            beginDateStr = lastWeekFirstDay;
            endDateStr = lastWeekLastDay;
            break;
        case RSDateTypeCurrentMonth:
            beginDateStr = currentMonthFirstDay;
            endDateStr = todayStr;
            break;
        case RSDateTypeLastMonth:
            beginDateStr = lastMonthFirstDay;
            endDateStr = lastMonthLastDay;
            break;
        case RSDateTypeCurrentYear:
            beginDateStr = [NSString stringWithFormat:@"%li-01-01",currentYear];
            endDateStr = [NSString stringWithFormat:@"%li-12-31",currentYear];
            break;
        case RSDateTypeSevenDays:
            beginDateStr = [NSString dateStringWithTimeIntervalSinceNow:-7 * 24 * 3600];
            endDateStr = todayStr;
            break;
        case RSDateTypeFifteenDays:
            beginDateStr = [NSString dateStringWithTimeIntervalSinceNow:-15 * 24 * 3600];
            endDateStr = todayStr;
            break;
        case RSDateTypeThirtyDays:
            beginDateStr = [NSString dateStringWithTimeIntervalSinceNow:-30 * 24 * 3600];
            endDateStr = todayStr;
            break;
        default:
            return nil;
    }
    
    return @{@"startDate":safeString(beginDateStr),
             @"endDate":safeString(endDateStr)};
}

@end
