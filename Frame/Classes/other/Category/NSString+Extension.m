//
//  NSString+Extension.m
//  HiSmartInternational
//
//  Created by Seas Cheng on 2018/1/4.
//  Copyright © 2018年 Hisense. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation NSString (Extension)

- (BOOL)isNull {
    if(self == nil || [self isKindOfClass:[NSNull class]] || [self isEmpty]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEmpty {
    return [[self trimWhitespace] isEqualToString:@""];
}

- (BOOL)isEmail {
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isLocalizedEmail {
    NSString *stricterFilterString = @"^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w+)+)$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [emailTest evaluateWithObject:[self filterSpace]];
}

- (BOOL)contains:(NSString *)string {
    if (string) {
        NSRange range = [self rangeOfString:string];
        return (range.location != NSNotFound);
    }else {
        return NO;
    }
}

//只由字母数字下划线组成
- (BOOL)isOnlyLetterOrNumbersOrUnderlines {
    NSString *nicknameRegex = @"^[A-Za-z0-9_ ]+$";
    NSPredicate *nicknamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [nicknamePredicate evaluateWithObject:self];
}
//必须包含大小写字母/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*$/  ----  (?=.*\d)  包含一个数字
- (BOOL)isContainsUppercaseAndLowercaseLetters {
    NSString *passwordRegex = @"^(?=.*[a-z])(?=.*[A-Z]).*$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passWordPredicate evaluateWithObject:self];
}
//只由字母数字组成
- (BOOL)isOnlyLettersOrNumbers {
    NSString *nicknameRegex = @"^[A-Za-z0-9]+$";
    NSPredicate *nicknamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [nicknamePredicate evaluateWithObject:self];
}
//过滤空格
-(NSString*)filterSpace{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+(CGRect)heightForString:(NSString*)str size:(CGSize)size font:(UIFont*)font{
    return [NSString heightForString:str size:size font:font lines:0];
}

+(CGRect)heightForString:(NSString*)str size:(CGSize)size font:(UIFont*)font lines:(NSInteger)lines{
    if (str.isNull) {
        return CGRectMake(0, 0, 0, 0);
    }
    static UILabel *lbtext;
    if (lbtext==nil) {
        lbtext    = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    }else{
        lbtext.frame=CGRectMake(0, 0, size.width, size.height);
    }
    lbtext.font=font;
    lbtext.text=str;
    lbtext.numberOfLines=lines;
    CGRect rect= [lbtext textRectForBounds:lbtext.frame limitedToNumberOfLines:lines];
    if(rect.size.height<0)
        rect.size.height=0;
    if (rect.size.width<0) {
        rect.size.width=0;
    }
    return rect;
}


+ (NSString* )stringDecodingByMD5:(NSString*)str{
    const char * cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString* )md5DecodingString{
    return [NSString stringDecodingByMD5:self];
}

-(NSString*)md5StringFor16{
    NSString *md5Str = [NSString stringDecodingByMD5:self];
    if (md5Str) {
        return [md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return nil;
}


- (NSString *)stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}


#pragma mark -

- (NSString *)trimWhitespace {
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


+ (NSString *)SSID {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"];
    return ssid;
}

- (BOOL)isContainsEmoji
{
    NSUInteger len = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (len < 3) {  // 大于2个字符需要验证Emoji(有些Emoji仅三个字符)
        return NO;
    }
    
    // 仅考虑字节长度为3的字符,大于此范围的全部做Emoji处理
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    Byte *bts = (Byte *)[data bytes];
    Byte bt;
    short v;
    for (NSUInteger i = 0; i < len; i++) {
        bt = bts[i];
        
        if ((bt | 0x7F) == 0x7F) {  // 0xxxxxxx  ASIIC编码
            continue;
        }
        if ((bt | 0x1F) == 0xDF) {  // 110xxxxx  两个字节的字符
            i += 1;
            continue;
        }
        if ((bt | 0x0F) == 0xEF) {  // 1110xxxx  三个字节的字符(重点过滤项目)
            // 计算Unicode下标
            v = bt & 0x0F;
            v = v << 6;
            v |= bts[i + 1] & 0x3F;
            v = v << 6;
            v |= bts[i + 2] & 0x3F;
            
            //            NSLog(@"%02X%02X", (Byte)(v >> 8), (Byte)(v & 0xFF));
            
            if ([self emojiInSoftBankUnicode:v] || [self emojiInUnicode:v]) {
                return YES;
            }
            
            i += 2;
            continue;
        }
        if ((bt | 0x3F) == 0xBF) {  // 10xxxxxx  10开头,为数据字节,直接过滤
            continue;
        }
        
        return YES;                 // 不是以上情况的字符全部超过三个字节,做Emoji处理
    }
    
    return NO;
}

- (BOOL)emojiInSoftBankUnicode:(short)code
{
    return ((code >> 8) >= 0xE0 && (code >> 8) <= 0xE5 && (Byte)(code & 0xFF) < 0x60);
}

- (BOOL)emojiInUnicode:(short)code
{
    if (code == 0x0023
        || code == 0x002A
        || (code >= 0x0030 && code <= 0x0039)
        || code == 0x00A9
        || code == 0x00AE
        || code == 0x203C
        || code == 0x2049
        || code == 0x2122
        || code == 0x2139
        || (code >= 0x2194 && code <= 0x2199)
        || code == 0x21A9 || code == 0x21AA
        || code == 0x231A || code == 0x231B
        || code == 0x2328
        || code == 0x23CF
        || (code >= 0x23E9 && code <= 0x23F3)
        || (code >= 0x23F8 && code <= 0x23FA)
        || code == 0x24C2
        || code == 0x25AA || code == 0x25AB
        || code == 0x25B6
        || code == 0x25C0
        || (code >= 0x25FB && code <= 0x25FE)
        || (code >= 0x2600 && code <= 0x2604)
        || code == 0x260E
        || code == 0x2611
        || code == 0x2614 || code == 0x2615
        || code == 0x2618
        || code == 0x261D
        || code == 0x2620
        || code == 0x2622 || code == 0x2623
        || code == 0x2626
        || code == 0x262A
        || code == 0x262E || code == 0x262F
        || (code >= 0x2638 && code <= 0x263A)
        || (code >= 0x2648 && code <= 0x2653)
        || code == 0x2660
        || code == 0x2663
        || code == 0x2665 || code == 0x2666
        || code == 0x2668
        || code == 0x267B
        || code == 0x267F
        || (code >= 0x2692 && code <= 0x2694)
        || code == 0x2696 || code == 0x2697
        || code == 0x2699
        || code == 0x269B || code == 0x269C
        || code == 0x26A0 || code == 0x26A1
        || code == 0x26AA || code == 0x26AB
        || code == 0x26B0 || code == 0x26B1
        || code == 0x26BD || code == 0x26BE
        || code == 0x26C4 || code == 0x26C5
        || code == 0x26C8
        || code == 0x26CE
        || code == 0x26CF
        || code == 0x26D1
        || code == 0x26D3 || code == 0x26D4
        || code == 0x26E9 || code == 0x26EA
        || (code >= 0x26F0 && code <= 0x26F5)
        || (code >= 0x26F7 && code <= 0x26FA)
        || code == 0x26FD
        || code == 0x2702
        || code == 0x2705
        || (code >= 0x2708 && code <= 0x270D)
        || code == 0x270F
        || code == 0x2712
        || code == 0x2714
        || code == 0x2716
        || code == 0x271D
        || code == 0x2721
        || code == 0x2728
        || code == 0x2733 || code == 0x2734
        || code == 0x2744
        || code == 0x2747
        || code == 0x274C
        || code == 0x274E
        || (code >= 0x2753 && code <= 0x2755)
        || code == 0x2757
        || code == 0x2763 || code == 0x2764
        || (code >= 0x2795 && code <= 0x2797)
        || code == 0x27A1
        || code == 0x27B0
        || code == 0x27BF
        || code == 0x2934 || code == 0x2935
        || (code >= 0x2B05 && code <= 0x2B07)
        || code == 0x2B1B || code == 0x2B1C
        || code == 0x2B50
        || code == 0x2B55
        || code == 0x3030
        || code == 0x303D
        || code == 0x3297
        || code == 0x3299
        // 第二段
        || code == 0x23F0) {
        return YES;
    }
    return NO;
}

@end
